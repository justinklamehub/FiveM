-- Exposes whitelist decisions and validates the configured mode during startup.
local Policy = require('shared.policy')
local WhitelistService = require('server.services.whitelist_service')
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local status = {
    resource = resource_name,
    version = version,
    status = 'starting',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = {},
}

local function publish(next_status, details)
    status.status = next_status
    status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    status.details = details or {}
    exports.cnr_core:report_resource_status(status)
end

CreateThread(function()
    Wait(0)
    local mode = GetConvar('cnr_whitelist_mode', 'open'):lower()
    if not Policy.is_valid_mode(mode) then
        publish('unavailable', { reason = 'invalid_whitelist_mode', mode = mode })
        return
    end
    if not exports.cnr_core:is_ready() then
        publish('degraded', { reason = 'core_not_ready' })
        return
    end
    publish('ready', { mode = mode })
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)
exports('evaluate', function(account_uuid, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'whitelist.error.unavailable',
            { status = status.status },
            correlation_id
        )
    end
    return WhitelistService.evaluate(account_uuid, correlation_id)
end)
