-- Verifies English identity input and age/status rules without FiveM.
local Policy = dofile('resources/[cnr]/cnr_characters/shared/character_policy.lua')
local settings = { minimum_age = 18, maximum_age = 85 }
local now = os.time({ year = 2026, month = 7, day = 16, hour = 12 })

local function payload()
    return {
        first_name = 'Alex',
        last_name = "O'Connor",
        date_of_birth = '1995-05-20',
        background_code = 'local',
        request_id = 'request-1',
        operation_uuid = '0190b7a0-2000-7000-8000-000000000001',
        contract_version = 1,
    }
end

describe('character policy', function()
    it('normalizes a valid identity and accepts realistic duplicate names', function()
        local result = Policy.validate_draft(payload(), settings, now)
        assert.are.equal('Alex', result.first_name)
        assert.are.equal("O'Connor", result.last_name)
    end)
    it(
        'rejects underage, impossible dates, unsafe names, and unexpected authority fields',
        function()
            local value = payload()
            value.date_of_birth = '2010-01-01'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.date_of_birth = '1995-02-31'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.first_name = '<script>'
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
            value = payload()
            value.account_uuid = value.operation_uuid
            assert.are.equal(
                'VALIDATION_ERROR',
                select(2, Policy.validate_draft(value, settings, now))
            )
        end
    )
    it('requires narrow versioned activation input', function()
        assert.is_table(Policy.validate_activation({
            character_uuid = '0190b7a0-2000-7000-8000-000000000001',
            request_id = 'request-2',
            operation_uuid = '0190b7a0-2000-7000-8000-000000000002',
            contract_version = 1,
        }))
    end)
end)
