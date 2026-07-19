-- Verifies that inventory authority is resolved from the FULL session and spawned character.
local policy = dofile('resources/[cnr]/cnr_inventory/shared/inventory_policy.lua')

local function error_result(code, key, details, correlation_id)
    return {
        ok = false,
        error = {
            code = code,
            message_key = key,
            safe_details = details,
            correlation_id = correlation_id,
        },
    }
end

local function load_service(repository, session, character_result)
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment.require = function(name)
        if name == 'shared.inventory_policy' then
            return policy
        end
        if name == 'server.repositories.inventory_repository' then
            return repository
        end
        error('unexpected module: ' .. name)
    end
    environment.GetConvarInt = function(_, default)
        return default
    end
    environment.exports = {
        cnr_sessions = {
            get_session_for_source = function()
                return session
            end,
        },
        cnr_characters = {
            active_character_for_source = function()
                return character_result
            end,
        },
        cnr_core = {
            create_uuid_v7 = function()
                return '0190b7a0-6000-7000-8000-000000000099'
            end,
            create_error_result = function(_, code, key, details, correlation_id)
                return error_result(code, key, details, correlation_id)
            end,
            create_success_result = function(_, data, correlation_id)
                return { ok = true, data = data, correlation_id = correlation_id }
            end,
        },
        cnr_logs = {
            audit = function() end,
        },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_inventory/server/services/inventory_service.lua',
            't',
            environment
        )
    )
    return chunk()
end

local read = { request_id = 'inventory-read-1', contract_version = 1 }
local transfer = {
    source_inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
    target_inventory_uuid = '0190b7a0-6000-7000-8000-000000000011',
    source_slot = 1,
    quantity = 1,
    request_id = 'inventory-transfer-1',
    operation_uuid = '0190b7a0-6000-7000-8000-000000000012',
    contract_version = 1,
}

describe('inventory service authority', function()
    it('rejects missing and LIMITED sessions before database access', function()
        local missing = load_service({}, nil, nil).snapshot(12, read, 'correlation-missing')
        assert.is_false(missing.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', missing.error.code)

        local limited = load_service({}, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'LIMITED',
        }, nil).snapshot(12, read, 'correlation-limited')
        assert.is_false(limited.ok)
        assert.are.equal('PRECONDITION_FAILED', limited.error.code)
    end)

    it('requires the character resource to resolve a spawned character', function()
        local result = load_service({}, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, error_result(
            'CHARACTER_REQUIRED',
            'character.required',
            {},
            'character-correlation'
        )).snapshot(12, read, 'correlation-character')
        assert.is_false(result.ok)
        assert.are.equal('CHARACTER_REQUIRED', result.error.code)
    end)

    it('rejects inventory UUIDs not owned by the source-bound character', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('a', 64) }
            end,
            transaction = function()
                return nil
            end,
            find_owned = function()
                return nil
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).transfer(12, transfer, 'correlation-foreign')
        assert.is_false(result.ok)
        assert.are.equal('NOT_FOUND', result.error.code)
    end)
end)
