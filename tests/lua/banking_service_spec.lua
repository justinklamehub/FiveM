local policy = dofile('resources/[cnr]/cnr_banking/shared/banking_policy.lua')

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
        if name == 'shared.banking_policy' then
            return policy
        end
        if name == 'server.repositories.banking_repository' then
            return repository
        end
        error('unexpected module: ' .. name)
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
                return '0190b7a0-7000-7000-8000-000000000099'
            end,
            create_error_result = function(_, code, key, details, correlation_id)
                return error_result(code, key, details, correlation_id)
            end,
            create_success_result = function(_, data, correlation_id)
                return { ok = true, data = data, correlation_id = correlation_id }
            end,
        },
        cnr_logs = { audit = function() end },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_banking/server/services/banking_service.lua',
            't',
            environment
        )
    )
    return chunk()
end

local request = { request_id = 'banking-read-1', contract_version = 1 }
local full_session = {
    account_uuid = 'account-1',
    session_uuid = 'session-1',
    access_state = 'FULL',
}
local active_character = {
    ok = true,
    data = { character_uuid = 'character-1', binding_uuid = 'binding-1' },
}

describe('banking service authority', function()
    it('rejects missing and LIMITED sessions before ledger access', function()
        local missing = load_service({}, nil, nil).snapshot(12, request, 'missing')
        assert.is_false(missing.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', missing.error.code)

        local limited = load_service({}, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'LIMITED',
        }, nil).snapshot(12, request, 'limited')
        assert.is_false(limited.ok)
        assert.are.equal('PRECONDITION_FAILED', limited.error.code)
    end)

    it('requires the server-selected spawned character', function()
        local service = load_service(
            {},
            full_session,
            error_result(
                'CHARACTER_REQUIRED',
                'characters.error.required',
                {},
                'character-required'
            )
        )
        local result = service.snapshot(12, request, 'character-required')
        assert.is_false(result.ok)
        assert.are.equal('CHARACTER_REQUIRED', result.error.code)
    end)

    it('derives balances and starter history from the repository', function()
        local repository = {
            starter_transaction = function(character_uuid)
                assert.are.equal('character-1', character_uuid)
                return {
                    transaction_uuid = 'transaction-1',
                    operation_uuid = 'operation-1',
                    transaction_number = 'TX-1',
                }
            end,
            accounts = function()
                return {
                    {
                        account_uuid = 'wallet-1',
                        account_number = 'CASH-1',
                        account_type = 'CASH_WALLET',
                        currency = 'USD',
                        status = 'ACTIVE',
                        balance_minor = 5000,
                        version = 1,
                    },
                    {
                        account_uuid = 'checking-1',
                        account_number = 'SA-1',
                        account_type = 'PERSONAL_CHECKING',
                        currency = 'USD',
                        status = 'ACTIVE',
                        balance_minor = 25000,
                        version = 1,
                    },
                }
            end,
            recent_transactions = function()
                return {
                    {
                        transaction_uuid = 'transaction-1',
                        transaction_number = 'TX-1',
                        transaction_type = 'STARTER_ALLOCATION',
                        status = 'POSTED',
                        amount_minor = 30000,
                        currency = 'USD',
                        purpose = 'Initial character funds',
                        posted_at = '2026-07-20T12:00:00Z',
                    },
                }
            end,
        }
        local result = load_service(repository, full_session, active_character).snapshot(
            12,
            request,
            'success'
        )
        assert.is_true(result.ok)
        assert.is_true(result.data.repeated)
        assert.are.equal(5000, result.data.accounts[1].balance_minor)
        assert.are.equal(25000, result.data.accounts[2].balance_minor)
        assert.are.equal(30000, result.data.recent_transactions[1].amount_minor)
    end)
end)
