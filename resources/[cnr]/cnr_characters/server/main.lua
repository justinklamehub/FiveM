-- Exposes rate-limited character lifecycle requests to the existing NUI bridge.
local Service = require('server.services.character_service')
local resource_name = GetCurrentResourceName()
local status = {
    resource = resource_name,
    version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0',
    status = 'starting',
    changed_at = '',
    details = {},
}

local function valid_read_payload(payload)
    if
        type(payload) ~= 'table'
        or payload.contract_version ~= 1
        or type(payload.request_id) ~= 'string'
        or #payload.request_id < 1
        or #payload.request_id > 64
    then
        return false
    end
    for key in pairs(payload) do
        if key ~= 'request_id' and key ~= 'contract_version' then
            return false
        end
    end
    return true
end

CreateThread(function()
    for _ = 1, 300 do
        if exports.cnr_core:is_ready() then
            local recovery = Service.recover_stale_bindings()
            if not recovery.ok then
                status.status = 'unavailable'
                status.details = { reason = 'binding_recovery_failed' }
                status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
                exports.cnr_core:report_resource_status(status)
                return
            end
            status.status = 'ready'
            status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
            exports.cnr_core:report_resource_status(status)
            return
        end
        status.status = 'degraded'
        status.details = { reason = 'core_not_ready' }
        status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
        exports.cnr_core:report_resource_status(status)
        Wait(100)
    end
    status.status = 'unavailable'
    status.details = { reason = 'core_readiness_timeout' }
    status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    exports.cnr_core:report_resource_status(status)
end)

RegisterNetEvent('cnr:characters:request', function(action, payload)
    local player_source = source
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'characters:' .. tostring(player_source),
        12,
        10000,
        correlation_id
    )
    local result
    if not rate_limit.ok then
        result = rate_limit
    elseif status.status ~= 'ready' then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'characters.error.unavailable',
            {},
            correlation_id
        )
    elseif
        (
            action == 'configuration'
            or action == 'list'
            or action == 'selectionStatus'
            or action == 'appearanceConfiguration'
        ) and not valid_read_payload(payload)
    then
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'characters.error.invalid_request',
            {},
            correlation_id
        )
    elseif action == 'configuration' then
        result = Service.configuration(player_source, correlation_id)
    elseif action == 'list' then
        result = Service.list(player_source, correlation_id)
    elseif action == 'createDraft' then
        result = Service.create_draft(player_source, payload, correlation_id)
    elseif action == 'activate' then
        result = Service.activate(player_source, payload, correlation_id)
    elseif action == 'selectionStatus' then
        result = Service.selection_status(player_source, correlation_id)
    elseif action == 'select' then
        result = Service.select_character(player_source, payload, correlation_id)
    elseif action == 'appearanceConfiguration' then
        result = Service.appearance_configuration(player_source, correlation_id)
    elseif action == 'appearanceSave' then
        result = Service.save_appearance(player_source, payload, correlation_id)
    else
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'characters.error.invalid_action',
            {},
            correlation_id
        )
    end
    local instruction = result.ok and result.data and result.data.spawn_instruction or nil
    local resume_spawned = result.ok and result.data and result.data.resume_spawned or false
    if instruction then
        result.data.spawn_instruction = nil
        TriggerClientEvent('cnr:characters:spawn', player_source, instruction)
    end
    if resume_spawned then
        result.data.resume_spawned = nil
        TriggerClientEvent('cnr:characters:lifecycleReady', player_source)
    end
    if not result.ok then
        exports.cnr_logs:log('warn', 'cnr_characters', 'character.request_rejected', {
            action = type(action) == 'string' and action or 'invalid',
            code = result.error and result.error.code or 'INTERNAL_ERROR',
            correlation_id = correlation_id,
        })
    end
    TriggerClientEvent(
        'cnr:characters:response',
        player_source,
        action,
        payload and payload.request_id,
        result
    )
end)

RegisterNetEvent('cnr:characters:spawnAck', function(payload)
    local player_source = source
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'characters:spawn:' .. tostring(player_source),
        4,
        10000,
        correlation_id
    )
    local result = rate_limit.ok
            and Service.acknowledge_spawn(player_source, payload, correlation_id)
        or rate_limit
    if result.ok then
        TriggerClientEvent('cnr:characters:spawnConfirmed', player_source, result.data.spawn_uuid)
    else
        exports.cnr_logs:log('warn', 'cnr_characters', 'character.spawn_ack_rejected', {
            code = result.error and result.error.code or 'INTERNAL_ERROR',
            correlation_id = correlation_id,
        })
        TriggerClientEvent('cnr:characters:spawnRejected', player_source, correlation_id)
    end
end)

AddEventHandler('cnr:sessions:ending', function(session)
    Service.end_session_binding(session)
end)

exports('get_status', function()
    return status
end)
