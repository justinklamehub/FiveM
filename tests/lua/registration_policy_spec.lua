-- Verifies registration input and all server-side whitelist transitions without FiveM.
local Policy = dofile('resources/[cnr]/cnr_registration/shared/registration_policy.lua')
local base = {
    ruleset_uuid = '0190b7a0-0000-7000-8000-000000000001',
    ruleset_version = 1,
    acceptance = true,
    locale = 'en',
    request_id = 'request-1',
    operation_uuid = '0190b7a0-0000-7000-8000-000000000002',
    contract_version = 1,
}

local function copy(values)
    local result = {}
    for key, value in pairs(values) do
        result[key] = value
    end
    return result
end

describe('registration policy', function()
    it(
        'requires explicit current-contract acceptance and rejects extra authority fields',
        function()
            assert.is_table(Policy.validate(copy(base)))
            local rejected = copy(base)
            rejected.acceptance = false
            assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate(rejected)))
            rejected = copy(base)
            rejected.account_uuid = base.operation_uuid
            assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate(rejected)))
        end
    )

    it('rejects stale contract versions and malformed operation UUIDs', function()
        local stale = copy(base)
        stale.contract_version = 2
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.validate(stale)))
        local malformed = copy(base)
        malformed.operation_uuid = 'not-a-uuid'
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate(malformed)))
    end)

    it('evaluates open and automatic as active full access', function()
        assert.same(
            { account_status = 'ACTIVE', access_state = 'FULL' },
            Policy.transition('open', false)
        )
        assert.same(
            { account_status = 'ACTIVE', access_state = 'FULL' },
            Policy.transition('automatic', false)
        )
    end)

    it('evaluates manual and hybrid from server-resolved entries', function()
        assert.same(
            { account_status = 'PENDING_WHITELIST', access_state = 'LIMITED' },
            Policy.transition('manual', false)
        )
        assert.same(
            { account_status = 'ACTIVE', access_state = 'FULL' },
            Policy.transition('manual', true)
        )
        assert.same(
            { account_status = 'PENDING_WHITELIST', access_state = 'LIMITED' },
            Policy.transition('hybrid', false)
        )
        assert.same(
            { account_status = 'ACTIVE', access_state = 'FULL' },
            Policy.transition('hybrid', true)
        )
    end)
end)
