-- Reports the UI resource readiness to cnr_core without owning gameplay state.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local status = {
    resource = resource_name,
    version = version,
    status = 'starting',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = {},
}
CreateThread(function()
    Wait(0)
    local ok, core_ready = pcall(function()
        return exports.cnr_core:is_ready()
    end)
    status.status = ok and core_ready and 'ready' or 'degraded'
    status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    pcall(function()
        exports.cnr_core:report_resource_status(status)
    end)
end)
exports('get_status', function()
    return status
end)
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        status.status = 'stopping'
        pcall(function()
            exports.cnr_core:report_resource_status(status)
        end)
    end
end)
AddEventHandler('cnr:sessions:started', function(session)
    if session and session.access_state == 'ONBOARDING' then
        TriggerClientEvent('cnr:ui:open', session.source or -1, 'registration', 'en')
    end
end)
AddEventHandler('playerJoining', function()
    local player_source = source
    CreateThread(function()
        Wait(0)
        local session = exports.cnr_sessions:get_session_for_source(player_source)
        if session and session.access_state == 'ONBOARDING' then
            TriggerClientEvent('cnr:ui:open', player_source, 'registration', 'en')
        elseif session and session.access_state == 'FULL' then
            TriggerClientEvent('cnr:ui:open', player_source, 'characterCreation', 'en')
        end
    end)
end)
