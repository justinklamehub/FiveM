-- Exposes rate-limited banking reads and transfers for a source-bound spawned character.
local Service = require('server.services.banking_service')
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
    if GetResourceState('cnr_sessions') ~= 'started' then
        return 'cnr_sessions_not_started'
    end
    if GetResourceState('cnr_characters') ~= 'started' then
        return 'cnr_characters_not_started'
    end
    if GetResourceState('cnr_permissions') ~= 'started' then
        return 'cnr_permissions_not_started'
    end
    local session_status = exports.cnr_sessions:get_status()
    if not session_status or session_status.status ~= 'ready' then
        return 'cnr_sessions_not_ready'
    end
    local character_status = exports.cnr_characters:get_status()
    if not character_status or character_status.status ~= 'ready' then
        return 'cnr_characters_not_ready'
    end
    local permission_status = exports.cnr_permissions:get_status()
    if not permission_status or permission_status.status ~= 'ready' then
        return 'cnr_permissions_not_ready'
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

RegisterNetEvent('cnr:banking:request', function(action, payload)
    local player_source = source
    local request_id = type(payload) == 'table' and payload.request_id or nil
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'banking:' .. tostring(player_source),
        20,
        10000,
        correlation_id
    )
    local result
    if not rate_limit.ok then
        result = rate_limit
    elseif status.status ~= 'ready' then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'banking.error.unavailable',
            {},
            correlation_id
        )
    elseif action == 'snapshot' then
        result = Service.snapshot(player_source, payload, correlation_id)
    elseif action == 'transfer' then
        local transfer_limit = exports.cnr_core:consume_rate_limit(
            'banking-transfer:' .. tostring(player_source),
            5,
            10000,
            correlation_id
        )
        if transfer_limit.ok then
            result = Service.transfer(player_source, payload, correlation_id)
        else
            result = transfer_limit
        end
    elseif action == 'atmCash' then
        local atm_cash_limit = exports.cnr_core:consume_rate_limit(
            'banking-atm-cash:' .. tostring(player_source),
            5,
            10000,
            correlation_id
        )
        if atm_cash_limit.ok then
            result = Service.atm_cash(player_source, payload, correlation_id)
        else
            result = atm_cash_limit
        end
    else
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'banking.error.invalid_action',
            {},
            correlation_id
        )
    end
    if not result.ok then
        exports.cnr_logs:log('warn', 'cnr_banking', 'banking.request_rejected', {
            action = type(action) == 'string' and action or 'invalid',
            code = result.error and result.error.code or 'INTERNAL_ERROR',
            correlation_id = correlation_id,
        })
    end
    TriggerClientEvent('cnr:banking:response', player_source, action, request_id, result)
end)

RegisterNetEvent('cnr:banking:atmDirectoryRequest', function(payload)
    local player_source = source
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'banking-atm-directory:' .. tostring(player_source),
        6,
        10000,
        correlation_id
    )
    local result = rate_limit
    if rate_limit.ok and status.status == 'ready' then
        result = Service.atm_directory(player_source, payload, correlation_id)
    elseif rate_limit.ok then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'banking.error.unavailable',
            {},
            correlation_id
        )
    end
    TriggerClientEvent('cnr:banking:atmDirectory', player_source, result)
end)

RegisterNetEvent('cnr:banking:atmOpenRequest', function(payload)
    local player_source = source
    local correlation_id = exports.cnr_core:create_correlation_id()
    local request_id = type(payload) == 'table' and payload.request_id or nil
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'banking-atm-open:' .. tostring(player_source),
        6,
        10000,
        correlation_id
    )
    local result = rate_limit
    if rate_limit.ok and status.status == 'ready' then
        result = Service.atm_snapshot(player_source, payload, correlation_id)
    elseif rate_limit.ok then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'banking.error.unavailable',
            {},
            correlation_id
        )
    end
    if not result.ok then
        exports.cnr_logs:log('warn', 'cnr_banking', 'banking.atm_open_rejected', {
            code = result.error and result.error.code or 'INTERNAL_ERROR',
            correlation_id = correlation_id,
        })
    end
    TriggerClientEvent('cnr:banking:atmOpenResponse', player_source, request_id, result)
end)

local function command_message(player_source, message, color)
    TriggerClientEvent('chat:addMessage', player_source, {
        color = color or { 229, 174, 62 },
        multiline = false,
        args = { 'CNR Banking', message },
    })
end

local function command_failure(player_source, action, result)
    local code = result and result.error and result.error.code or 'INTERNAL_ERROR'
    local correlation_id = result and result.error and result.error.correlation_id or 'unavailable'
    exports.cnr_logs:log('warn', 'cnr_banking', 'banking.atm_management_rejected', {
        action = action,
        code = code,
        correlation_id = correlation_id,
    })
    command_message(
        player_source,
        ('The ATM command was rejected (%s). Reference: %s'):format(code, correlation_id),
        { 239, 91, 91 }
    )
end

local function management_rate_limit(player_source, correlation_id)
    return exports.cnr_core:consume_rate_limit(
        'banking-atm-management:' .. tostring(player_source),
        5,
        60000,
        correlation_id
    )
end

local function broadcast_directory_change()
    TriggerClientEvent('cnr:banking:atmDirectoryChanged', -1)
end

RegisterCommand('cnr_atm_create', function(player_source, arguments)
    if player_source == 0 then
        print('[cnr_banking] cnr_atm_create must be used by an in-game administrator.')
        return
    end
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = management_rate_limit(player_source, correlation_id)
    if not rate_limit.ok then
        command_failure(player_source, 'create', rate_limit)
        return
    end
    local label = table.concat(arguments, ' ')
    if label == '' then
        label = 'Managed ATM'
    end
    local result = Service.create_atm(player_source, label, correlation_id)
    if not result.ok then
        command_failure(player_source, 'create', result)
        return
    end
    command_message(
        player_source,
        ('ATM %s created at your current position. Reference: %s'):format(
            result.data.code,
            result.correlation_id
        )
    )
    broadcast_directory_change()
end, false)

RegisterCommand('cnr_atm_remove', function(player_source)
    if player_source == 0 then
        print('[cnr_banking] cnr_atm_remove must be used by an in-game administrator.')
        return
    end
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = management_rate_limit(player_source, correlation_id)
    if not rate_limit.ok then
        command_failure(player_source, 'remove', rate_limit)
        return
    end
    local result = Service.remove_nearest_atm(player_source, correlation_id)
    if not result.ok then
        command_failure(player_source, 'remove', result)
        return
    end
    command_message(
        player_source,
        ('ATM %s was deactivated. Reference: %s'):format(result.data.code, result.correlation_id)
    )
    broadcast_directory_change()
end, false)

RegisterCommand('cnr_atm_list', function(player_source)
    if player_source == 0 then
        print('[cnr_banking] cnr_atm_list must be used by an in-game administrator.')
        return
    end
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = management_rate_limit(player_source, correlation_id)
    if not rate_limit.ok then
        command_failure(player_source, 'list', rate_limit)
        return
    end
    local result = Service.list_atms(player_source, correlation_id)
    if not result.ok then
        command_failure(player_source, 'list', result)
        return
    end
    command_message(player_source, ('Active ATMs: %d'):format(#result.data.atms))
    for index = 1, math.min(#result.data.atms, 10) do
        local atm = result.data.atms[index]
        command_message(
            player_source,
            ('%s — %s — %.1f m away'):format(atm.code, atm.label, atm.distance)
        )
    end
end, false)

AddEventHandler('cnr:characters:spawned', function(event)
    if not event or not event.source or status.status ~= 'ready' then
        return
    end
    CreateThread(function()
        local correlation_id = event.correlation_id or exports.cnr_core:create_correlation_id()
        local result = Service.provision_for_source(event.source, correlation_id)
        if not result.ok then
            exports.cnr_logs:log('error', 'cnr_banking', 'banking.starter_failed', {
                code = result.error and result.error.code or 'INTERNAL_ERROR',
                correlation_id = correlation_id,
            })
        end
    end)
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    elseif
        stopped == 'cnr_sessions'
        or stopped == 'cnr_characters'
        or stopped == 'cnr_permissions'
    then
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
            'banking.error.unavailable',
            {},
            correlation_id
        )
    end
    return Service.snapshot(player_source, {
        request_id = request_id,
        contract_version = 2,
    }, correlation_id)
end)
