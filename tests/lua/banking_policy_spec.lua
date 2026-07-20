local Policy = dofile('resources/[cnr]/cnr_banking/shared/banking_policy.lua')

describe('banking policy', function()
    it('accepts only the narrow versioned snapshot request', function()
        local request = Policy.validate_snapshot({
            request_id = 'banking-read-1',
            contract_version = 1,
        })
        assert.is_table(request)
        assert.is_nil(Policy.validate_snapshot({
            request_id = 'banking-read-2',
            contract_version = 1,
            balance_minor = 999999,
        }))
        assert.is_nil(Policy.validate_snapshot({
            request_id = 'banking-read-3',
            contract_version = 2,
        }))
    end)

    it('normalizes integer ledger balances without accepting unknown account types', function()
        local account = Policy.normalize_account({
            account_uuid = '0190b7a0-7000-7000-8000-000000000010',
            account_number = 'SA-800000000010',
            account_type = 'PERSONAL_CHECKING',
            currency = 'USD',
            status = 'ACTIVE',
            balance_minor = '25000',
            version = '1',
        })
        assert.are.equal(25000, account.balance_minor)
        assert.is_nil(Policy.normalize_account({
            account_uuid = 'account',
            account_number = 'CLIENT',
            account_type = 'CLIENT_BALANCE',
            currency = 'USD',
            status = 'ACTIVE',
            balance_minor = 999999,
            version = 1,
        }))
    end)
end)
