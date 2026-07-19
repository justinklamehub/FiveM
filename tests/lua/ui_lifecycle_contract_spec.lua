-- Verifies the Lua-compatible player lifecycle contract used by cnr_ui.
local contract = dofile('resources/[cnr]/cnr_ui/shared/lifecycle_contract.lua')

describe('UI lifecycle contract', function()
    it('maps only server-owned session access states to destinations', function()
        assert.are.equal('REGISTRATION_REQUIRED', contract.phase_for_access('ONBOARDING'))
        assert.are.equal('ACCESS_PENDING', contract.phase_for_access('LIMITED'))
        assert.is_nil(contract.phase_for_access('FULL'))
        assert.are.equal('RECOVERABLE_ERROR', contract.phase_for_access('INVALID'))
    end)

    it('accepts the complete Wave 1 phase set and rejects client authority', function()
        for phase in pairs(contract.phases) do
            assert.is_true(contract.is_valid_phase(phase))
        end
        assert.is_false(contract.is_valid_phase('CLIENT_SELECTED_ACCOUNT'))
        assert.is_false(contract.is_valid_phase(nil))
    end)
end)
