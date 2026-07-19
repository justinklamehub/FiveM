-- Verifies that selection authority is resolved from the active FULL session.
local policy = dofile('resources/[cnr]/cnr_characters/shared/character_policy.lua')

local function load_service(repository, memory_session)
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment.require = function(name)
        if name == 'shared.character_policy' then
            return policy
        end
        if name == 'server.repositories.character_repository' then
            return repository
        end
        error('unexpected module: ' .. name)
    end
    environment.exports = {
        cnr_sessions = {
            get_session_for_source = function()
                return memory_session
            end,
        },
        cnr_core = {
            get_server_instance_id = function()
                return 'service-test'
            end,
            create_error_result = function(_, code, key, details, correlation_id)
                return {
                    ok = false,
                    error = {
                        code = code,
                        message_key = key,
                        safe_details = details,
                        correlation_id = correlation_id,
                    },
                }
            end,
            create_success_result = function(_, data, correlation_id)
                return { ok = true, data = data, correlation_id = correlation_id }
            end,
        },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_characters/server/services/character_service.lua',
            't',
            environment
        )
    )
    return chunk()
end

local selection = {
    character_uuid = '0190b7a0-2000-7000-8000-000000000001',
    request_id = 'selection-1',
    operation_uuid = '0190b7a0-2000-7000-8000-000000000002',
    contract_version = 1,
}

describe('character selection service authority', function()
    it('rejects a missing or inactive session', function()
        local missing_service = load_service({
            session_for_source = function()
                return nil
            end,
        }, nil)
        local missing = missing_service.select_character(12, selection, 'correlation-1')
        assert.is_false(missing.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', missing.error.code)

        local inactive_repository = {
            session_for_source = function()
                return {
                    session_uuid = 'session-1',
                    account_uuid = 'account-1',
                    account_id = 1,
                    session_id = 2,
                    account_status = 'ACTIVE',
                    access_state = 'LIMITED',
                }
            end,
        }
        local inactive_service = load_service(
            inactive_repository,
            { session_uuid = 'session-1', account_uuid = 'account-1' }
        )
        local inactive = inactive_service.select_character(12, selection, 'correlation-2')
        assert.is_false(inactive.ok)
        assert.are.equal('PRECONDITION_FAILED', inactive.error.code)
    end)

    it('rejects a foreign character UUID without accepting account authority', function()
        local repository = {
            session_for_source = function()
                return {
                    session_uuid = 'session-1',
                    account_uuid = 'account-1',
                    account_id = 1,
                    session_id = 2,
                    account_status = 'ACTIVE',
                    access_state = 'FULL',
                }
            end,
            selection_payload_hash = function()
                return { payload_sha256 = string.rep('a', 64) }
            end,
            find_selection_operation = function()
                return nil
            end,
            binding_for_session = function()
                return nil
            end,
            find_owned = function()
                return nil
            end,
        }
        local service =
            load_service(repository, { session_uuid = 'session-1', account_uuid = 'account-1' })
        local result = service.select_character(12, selection, 'correlation-3')
        assert.is_false(result.ok)
        assert.are.equal('NOT_FOUND', result.error.code)
    end)

    it('derives lifecycle destinations from server-owned character and binding state', function()
        local function session()
            return {
                session_uuid = 'session-1',
                account_uuid = 'account-1',
                account_id = 1,
                session_id = 2,
                account_status = 'ACTIVE',
                access_state = 'FULL',
            }
        end
        local memory = { session_uuid = 'session-1', account_uuid = 'account-1' }

        local creation = load_service({
            session_for_source = session,
            binding_for_session = function()
                return nil
            end,
            list = function()
                return {}
            end,
        }, memory).lifecycle_snapshot(12, 'correlation-creation')
        assert.are.equal('CHARACTER_CREATION_REQUIRED', creation.data.phase)

        local selection = load_service({
            session_for_source = session,
            binding_for_session = function()
                return nil
            end,
            list = function()
                return { { status = 'ACTIVE' } }
            end,
        }, memory).lifecycle_snapshot(12, 'correlation-selection')
        assert.are.equal('CHARACTER_SELECTION_REQUIRED', selection.data.phase)

        for spawn_state, expected in pairs({
            APPEARANCE_REQUIRED = 'APPEARANCE_REQUIRED',
            PENDING = 'SPAWN_PENDING',
            SPAWNED = 'READY',
        }) do
            local result = load_service({
                session_for_source = session,
                binding_for_session = function()
                    return { binding_status = 'ACTIVE', spawn_state = spawn_state }
                end,
            }, memory).lifecycle_snapshot(12, 'correlation-binding')
            assert.are.equal(expected, result.data.phase)
        end
    end)

    it('exports only a source-bound spawned character and active State ID', function()
        local function session()
            return {
                session_uuid = 'session-1',
                account_uuid = 'account-1',
                account_id = 1,
                session_id = 2,
                account_status = 'ACTIVE',
                access_state = 'FULL',
            }
        end
        local memory = { session_uuid = 'session-1', account_uuid = 'account-1' }
        local pending = load_service({
            session_for_source = session,
            binding_for_session = function()
                return {
                    binding_status = 'ACTIVE',
                    spawn_state = 'PENDING',
                    status = 'ACTIVE',
                }
            end,
        }, memory).active_character_for_source(12, 'correlation-pending')
        assert.is_false(pending.ok)
        assert.are.equal('CHARACTER_REQUIRED', pending.error.code)

        local spawned = load_service({
            session_for_source = session,
            binding_for_session = function()
                return {
                    binding_status = 'ACTIVE',
                    binding_uuid = 'binding-1',
                    spawn_state = 'SPAWNED',
                    status = 'ACTIVE',
                    character_id = 5,
                    character_uuid = 'character-1',
                }
            end,
            state_document = function()
                return { document_uuid = 'document-1' }
            end,
        }, memory).active_character_for_source(12, 'correlation-spawned')
        assert.is_true(spawned.ok)
        assert.are.same({
            character_uuid = 'character-1',
            binding_uuid = 'binding-1',
            state_document_uuid = 'document-1',
        }, spawned.data)
    end)
end)
