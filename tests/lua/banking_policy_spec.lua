local Policy = dofile('resources/[cnr]/cnr_banking/shared/banking_policy.lua')

describe('banking policy', function()
    it('accepts only the narrow versioned snapshot request', function()
        local request = Policy.validate_snapshot({
            request_id = 'banking-read-1',
            contract_version = 2,
        })
        assert.is_table(request)
        assert.is_nil(Policy.validate_snapshot({
            request_id = 'banking-read-2',
            contract_version = 2,
            balance_minor = 999999,
        }))
        assert.is_nil(Policy.validate_snapshot({
            request_id = 'banking-read-3',
            contract_version = 1,
        }))
    end)

    it('accepts only a bounded transfer intent and normalizes public account references', function()
        local transfer = Policy.validate_transfer({
            recipient_account_number = 'sa-8000000000000012',
            amount_minor = 1250,
            purpose = ' Shared fuel cost ',
            request_id = 'banking-transfer-1',
            operation_uuid = '0190b7a0-7000-7000-8000-000000000099',
            contract_version = 2,
        })
        assert.are.equal('SA-8000000000000012', transfer.recipient_account_number)
        assert.are.equal('Shared fuel cost', transfer.purpose)
        assert.is_nil(Policy.validate_transfer({
            recipient_account_number = 'SA-8000000000000012',
            amount_minor = 0,
            purpose = 'Invalid',
            request_id = 'banking-transfer-2',
            operation_uuid = '0190b7a0-7000-7000-8000-000000000099',
            contract_version = 2,
        }))
        assert.is_nil(Policy.validate_transfer({
            recipient_account_number = 'SA-8000000000000012',
            amount_minor = 1250,
            purpose = 'Client authority',
            request_id = 'banking-transfer-3',
            operation_uuid = '0190b7a0-7000-7000-8000-000000000099',
            contract_version = 2,
            source_account_number = 'SA-CLIENT',
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
