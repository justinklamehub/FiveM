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
        local missing_service = load_service({}, nil)
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
end)
