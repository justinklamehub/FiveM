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

local function dependency_failure()
    for _, dependency in ipairs({ 'cnr_sessions', 'cnr_characters', 'cnr_items' }) do
        if GetResourceState(dependency) ~= 'started' then
            return dependency .. '_not_started'
        end
    end
    local item_status = exports.cnr_items:get_status()
    if not item_status or item_status.status ~= 'ready' then
        return 'items_not_ready'
    end
    local session_status = exports.cnr_sessions:get_status()
    if not session_status or session_status.status ~= 'ready' then
        return 'sessions_not_ready'
    end
    local character_status = exports.cnr_characters:get_status()
    if not character_status or character_status.status ~= 'ready' then
        return 'characters_not_ready'
    end
    return nil
end

CreateThread(function()
    local unavailable_ticks = 0
    while true do
        local reason = dependency_failure()
        if not reason and exports.cnr_core:is_ready() then
            unavailable_ticks = 0
            if status.status ~= 'ready' then
                publish('ready')
            end
        else
            unavailable_ticks = unavailable_ticks + 1
            reason = reason or 'core_not_ready'
            local next_status = unavailable_ticks >= 300 and 'unavailable' or 'degraded'
            if status.status ~= next_status or status.details.reason ~= reason then
                publish(next_status, { reason = reason })
            end
        end
        Wait(100)
    end
end)

RegisterNetEvent('cnr:inventory:request', function(action, payload)
    local player_source = source
    local request_id = type(payload) == 'table' and payload.request_id or nil
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'inventory:' .. tostring(player_source),
        30,
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
    elseif action == 'workspace' then
        result = Service.workspace(player_source, payload, correlation_id)
    elseif action == 'reposition' then
        result = Service.reposition(player_source, payload, correlation_id)
    elseif action == 'transfer' then
        result = Service.transfer(player_source, payload, correlation_id)
    elseif action == 'use' then
        local use_limit = exports.cnr_core:consume_rate_limit(
            'inventory-use:' .. tostring(player_source),
            8,
            10000,
            correlation_id
        )
        result = use_limit.ok and Service.use_item(player_source, payload, correlation_id)
            or use_limit
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
    local internal = result.internal
    result.internal = nil
    if result.ok and internal then
        if internal.effect == 'DRINK_WATER' or internal.effect == 'EAT_FOOD' then
            TriggerClientEvent('cnr:inventory:item_effect', player_source, internal.effect)
        end
        if internal.presentation then
            local presentation = internal.presentation
            local recipient_source = presentation.recipient_source
            presentation.recipient_source = nil
            TriggerClientEvent('cnr:inventory:document', recipient_source, presentation)
        end
    end
    TriggerClientEvent('cnr:inventory:response', player_source, action, request_id, result)
end)

AddEventHandler('cnr:characters:spawned', function(event)
    if not event or not event.source then
        return
    end
    if status.status ~= 'ready' then
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
    elseif stopped == 'cnr_sessions' or stopped == 'cnr_characters' or stopped == 'cnr_items' then
        publish('degraded', { reason = stopped .. '_stopped' })
    end
end)

exports('get_status', function()
    return status
end)
exports('snapshot_for_source', function(player_source, request_id, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.snapshot(player_source, {
        request_id = request_id,
        contract_version = 5,
    }, correlation_id)
end)
exports('workspace_for_source', function(player_source, request_id, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.workspace(player_source, {
        request_id = request_id,
        contract_version = 5,
    }, correlation_id)
end)
exports('transfer_for_source', function(player_source, payload, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.transfer(player_source, payload, correlation_id)
end)
exports('use_for_source', function(player_source, payload, correlation_id)
    if status.status ~= 'ready' then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.use_item(player_source, payload, correlation_id)
end)
