-- Exposes account resolution and reports readiness without owning connection deferrals.
local AccountService = require('server.services.account_service')
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
    local pepper = GetConvar('cnr_identifier_pepper', '')
    if #pepper < 32 or pepper:find('replace', 1, true) then
        publish('unavailable', { reason = 'identifier_pepper_missing' })
        return
    end
    if not exports.cnr_core:is_ready() then
        publish('degraded', { reason = 'core_not_ready' })
        return
    end
    publish('ready')
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)
exports('resolve_connection', function(raw_identifiers, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'accounts.error.unavailable',
            { status = status.status },
            correlation_id
        )
    end
    return AccountService.resolve(raw_identifiers, correlation_id)
end)
