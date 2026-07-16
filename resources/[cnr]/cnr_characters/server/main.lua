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
    Wait(0)
    status.status = exports.cnr_core:is_ready() and 'ready' or 'degraded'
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
    elseif (action == 'configuration' or action == 'list') and not valid_read_payload(payload) then
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
    else
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'characters.error.invalid_action',
            {},
            correlation_id
        )
    end
    TriggerClientEvent(
        'cnr:characters:response',
        player_source,
        action,
        payload and payload.request_id,
        result
    )
end)

exports('get_status', function()
    return status
end)
