-- Verifies security and idempotency branches with injected repositories and FiveM exports.
local policy = dofile('resources/[cnr]/cnr_registration/shared/registration_policy.lua')

local function load_service(repository, memory_session)
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment.require = function(name)
        if name == 'shared.registration_policy' then
            return policy
        end
        if name == 'server.repositories.registration_repository' then
            return repository
        end
        error('unexpected module: ' .. name)
    end
    local function error_result(_, code, key, details, correlation_id)
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
    environment.exports = {
        cnr_core = {
            create_error_result = error_result,
            create_success_result = function(_, data, correlation_id)
                return { ok = true, data = data, correlation_id = correlation_id }
            end,
            get_server_instance_id = function()
                return 'test-instance'
            end,
        },
        cnr_sessions = {
            get_session_for_source = function()
                return memory_session
            end,
        },
        cnr_logs = {
            log = function() end,
        },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_registration/server/services/registration_service.lua',
            't',
            environment
        )
    )
    return chunk()
end

describe('registration service security', function()
    it('rejects a source without an active in-memory session before database access', function()
        local service = load_service({}, nil)
        local result = service.status(42, 'correlation-1')
        assert.is_false(result.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', result.error.code)
    end)

    it('rejects a database session that does not match the source-owned session', function()
        local repository = {
            session_for_source = function()
                return { session_uuid = 'other-session', account_uuid = 'account-1' }
            end,
        }
        local service =
            load_service(repository, { session_uuid = 'session-1', account_uuid = 'account-1' })
        local result = service.status(42, 'correlation-2')
        assert.is_false(result.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', result.error.code)
    end)

    it('rejects stale rulesets without attempting a transaction', function()
        local committed = false
        local repository = {
            session_for_source = function()
                return {
                    session_uuid = 'session-1',
                    account_uuid = 'account-1',
                    account_status = 'PENDING_REGISTRATION',
                    access_state = 'ONBOARDING',
                }
            end,
            payload_hash = function()
                return { payload_sha256 = 'hash-1' }
            end,
            find_operation = function()
                return nil
            end,
            current_ruleset = function()
                return { public_uuid = '0190b7a0-0000-7000-8000-000000000099', version = 2 }
            end,
            commit_registration = function()
                committed = true
            end,
        }
        local service =
            load_service(repository, { session_uuid = 'session-1', account_uuid = 'account-1' })
        local result = service.submit(42, {
            ruleset_uuid = '0190b7a0-0000-7000-8000-000000000001',
            ruleset_version = 1,
            acceptance = true,
            locale = 'de',
            request_id = 'request-1',
            operation_uuid = '0190b7a0-0000-7000-8000-000000000002',
            contract_version = 1,
        }, 'correlation-3')
        assert.is_false(result.ok)
        assert.are.equal('PRECONDITION_FAILED', result.error.code)
        assert.is_false(committed)
    end)

    it('returns an identical stored operation and conflicts on changed semantic content', function()
        local stored_hash = 'same-hash'
        local repository = {
            session_for_source = function()
                return { session_uuid = 'session-1', account_uuid = 'account-1' }
            end,
            payload_hash = function()
                return { payload_sha256 = stored_hash }
            end,
            find_operation = function()
                return {
                    account_uuid = 'account-1',
                    payload_sha256 = 'same-hash',
                    operation_uuid = 'operation-1',
                    result_account_status = 'ACTIVE',
                    result_access_state = 'FULL',
                }
            end,
        }
        local memory = { session_uuid = 'session-1', account_uuid = 'account-1' }
        local service = load_service(repository, memory)
        local payload = {
            ruleset_uuid = '0190b7a0-0000-7000-8000-000000000001',
            ruleset_version = 1,
            acceptance = true,
            locale = 'de',
            request_id = 'request-1',
            operation_uuid = '0190b7a0-0000-7000-8000-000000000002',
            contract_version = 1,
        }
        local repeated = service.submit(42, payload, 'correlation-4')
        assert.is_true(repeated.ok)
        assert.is_true(repeated.data.repeated)

        stored_hash = 'changed-hash'
        local conflict_service = load_service(repository, memory)
        local conflict = conflict_service.submit(42, payload, 'correlation-5')
        assert.is_false(conflict.ok)
        assert.are.equal('CONFLICT', conflict.error.code)
    end)
end)
