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
    for _ = 1, 300 do
        local ok, core_ready = pcall(function()
            return exports.cnr_core:is_ready()
        end)
        status.status = ok and core_ready and 'ready' or 'degraded'
        status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
        pcall(function()
            exports.cnr_core:report_resource_status(status)
        end)
        if status.status == 'ready' then
            return
        end
        Wait(100)
    end
    status.status = 'unavailable'
    status.details = { reason = 'core_readiness_timeout' }
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

local ready_sources = {}
local function open_for_session(player_source)
    local session = exports.cnr_sessions:get_session_for_source(player_source)
    if session and session.access_state == 'ONBOARDING' then
        TriggerClientEvent('cnr:ui:open', player_source, 'registration', 'en')
        return true
    elseif session and session.access_state == 'FULL' then
        TriggerClientEvent('cnr:ui:open', player_source, 'characterLifecycle', 'en')
        return true
    end
    return false
end

local function open_when_session_is_ready(player_source)
    if ready_sources[player_source] then
        return
    end
    ready_sources[player_source] = 'pending'
    CreateThread(function()
        for _ = 1, 50 do
            if open_for_session(player_source) then
                ready_sources[player_source] = true
                return
            end
            Wait(100)
        end
        ready_sources[player_source] = nil
    end)
end

RegisterNetEvent('cnr:ui:ready', function()
    local player_source = source
    open_when_session_is_ready(player_source)
end)

AddEventHandler('playerDropped', function()
    ready_sources[source] = nil
end)
