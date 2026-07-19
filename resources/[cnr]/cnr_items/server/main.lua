-- Publishes item-catalogue readiness and server-only definition exports.
local Repository = require('server.repositories.item_repository')
local Service = require('server.services.item_service')
local resource_name = GetCurrentResourceName()
local status = {
    resource = resource_name,
    version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0',
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
    for _ = 1, 300 do
        if exports.cnr_core:is_ready() then
            local definitions, database_error = Repository.list_active()
            if database_error or not definitions or #definitions == 0 then
                publish('unavailable', { reason = 'item_catalogue_unavailable' })
                return
            end
            publish('ready', { active_definitions = #definitions })
            return
        end
        publish('degraded', { reason = 'core_not_ready' })
        Wait(100)
    end
    publish('unavailable', { reason = 'core_readiness_timeout' })
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)
exports('list_active', function(correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'items.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.list(correlation_id)
end)
exports('get_active', function(code, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'items.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.find(code, correlation_id)
end)
