-- Exposes rate-limited inventory reads and transfers for a source-bound spawned character.
local Service = require('server.services.inventory_service')
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
        local item_status = exports.cnr_items:get_status()
        local character_status = exports.cnr_characters:get_status()
        if
            exports.cnr_core:is_ready()
            and item_status.status == 'ready'
            and character_status.status == 'ready'
        then
            publish('ready')
            return
        end
        publish('degraded', { reason = 'dependency_not_ready' })
        Wait(100)
    end
    publish('unavailable', { reason = 'dependency_readiness_timeout' })
end)

RegisterNetEvent('cnr:inventory:request', function(action, payload)
    local player_source = source
    local request_id = type(payload) == 'table' and payload.request_id or nil
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'inventory:' .. tostring(player_source),
        10,
        10000,
        correlation_id
    )
    local result
    if not rate_limit.ok then
        result = rate_limit
    elseif status.status ~= 'ready' then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.unavailable',
            {},
            correlation_id
        )
    elseif action == 'snapshot' then
        result = Service.snapshot(player_source, payload, correlation_id)
    elseif action == 'transfer' then
        result = Service.transfer(player_source, payload, correlation_id)
    else
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'inventory.error.invalid_action',
            {},
            correlation_id
        )
    end
    if not result.ok then
        exports.cnr_logs:log('warn', 'cnr_inventory', 'inventory.request_rejected', {
            action = type(action) == 'string' and action or 'invalid',
            code = result.error and result.error.code or 'INTERNAL_ERROR',
            correlation_id = correlation_id,
        })
    end
    TriggerClientEvent('cnr:inventory:response', player_source, action, request_id, result)
end)

AddEventHandler('cnr:characters:spawned', function(event)
    if not event or not event.source then
        return
    end
    CreateThread(function()
        local correlation_id = event.correlation_id or exports.cnr_core:create_correlation_id()
        local result = Service.provision_for_source(event.source, correlation_id)
        if not result.ok then
            exports.cnr_logs:log('error', 'cnr_inventory', 'inventory.starter_failed', {
                code = result.error and result.error.code or 'INTERNAL_ERROR',
                correlation_id = correlation_id,
            })
        end
    end)
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)
exports('snapshot_for_source', function(player_source, request_id, correlation_id)
    return Service.snapshot(player_source, {
        request_id = request_id,
        contract_version = 1,
    }, correlation_id)
end)
exports('transfer_for_source', function(player_source, payload, correlation_id)
    return Service.transfer(player_source, payload, correlation_id)
end)
