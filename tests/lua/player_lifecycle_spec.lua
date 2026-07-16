-- Verifies pure Wave 1 identifier, access-policy, and UUID contracts without FiveM.
local IdentifierService =
    dofile('resources/[cnr]/cnr_accounts/server/services/identifier_service.lua')
local WhitelistPolicy = dofile('resources/[cnr]/cnr_whitelist/shared/policy.lua')
local AccessPolicy = dofile('resources/[cnr]/cnr_sessions/shared/access_policy.lua')
local UuidV7 = dofile('resources/[cnr]/cnr_core/shared/uuid_v7.lua')

describe('player lifecycle contracts', function()
    it('normalizes supported identifiers and excludes IP addresses', function()
        local result = IdentifierService.normalize({
            'ip:127.0.0.1',
            'discord:123456',
            'license:ABCDEF1234',
            'license:abcdef1234',
        })
        assert.is_table(result)
        assert.are.equal('license', result.primary.type)
        assert.are.equal(2, #result.identifiers)
        assert.are.equal('1234', result.identifiers[1].hint)
    end)

    it('requires a Rockstar or Cfx.re primary identity', function()
        local result, code = IdentifierService.normalize({ 'discord:123456' })
        assert.is_nil(result)
        assert.are.equal('IDENTIFIER_REQUIRED', code)
    end)

    it('evaluates all whitelist modes deterministically', function()
        assert.is_true(WhitelistPolicy.evaluate('open', false).allowed)
        assert.is_false(WhitelistPolicy.evaluate('manual', false).allowed)
        assert.is_true(WhitelistPolicy.evaluate('manual', true).allowed)
        assert.is_true(WhitelistPolicy.evaluate('hybrid', false).limited)
    end)

    it('keeps new accounts in onboarding and active approved accounts in full access', function()
        local onboarding = AccessPolicy.evaluate('PENDING_REGISTRATION', {
            mode = 'manual',
            allowed = false,
            limited = false,
        })
        assert.is_true(onboarding.allowed)
        assert.are.equal('ONBOARDING', onboarding.access_state)

        local full = AccessPolicy.evaluate('ACTIVE', {
            mode = 'manual',
            allowed = true,
            limited = false,
        })
        assert.is_true(full.allowed)
        assert.are.equal('FULL', full.access_state)
    end)

    it('generates UUIDv7 values with version and variant bits', function()
        local random_values = { 0x1234, 0x5678, 0x9ABC, 0xDEF0 }
        local index = 0
        local uuid = UuidV7.create(function()
            return 1700000000123
        end, function()
            index = index + 1
            return random_values[index]
        end)
        assert.matches('^[0-9a-f]+%-[0-9a-f]+%-7[0-9a-f]+%-[89ab][0-9a-f]+%-[0-9a-f]+$', uuid)
    end)
end)
