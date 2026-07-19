-- Defines the Lua-compatible, server-driven Wave 1 lifecycle phases.
local LifecycleContract = {
    version = 1,
    phases = {
        CONNECTING = true,
        SESSION_PENDING = true,
        REGISTRATION_REQUIRED = true,
        ACCESS_PENDING = true,
        CHARACTER_CREATION_REQUIRED = true,
        CHARACTER_SELECTION_REQUIRED = true,
        APPEARANCE_REQUIRED = true,
        SPAWN_PENDING = true,
        READY = true,
        RECOVERABLE_ERROR = true,
    },
}

function LifecycleContract.is_valid_phase(phase)
    return type(phase) == 'string' and LifecycleContract.phases[phase] == true
end

function LifecycleContract.phase_for_access(access_state)
    if access_state == 'ONBOARDING' then
        return 'REGISTRATION_REQUIRED'
    elseif access_state == 'LIMITED' then
        return 'ACCESS_PENDING'
    elseif access_state == 'FULL' then
        return nil
    end
    return 'RECOVERABLE_ERROR'
end

CNR_UI_LIFECYCLE_CONTRACT = LifecycleContract
return LifecycleContract
