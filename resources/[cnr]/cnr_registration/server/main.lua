-- Exposes rate-limited registration requests and returns correlation-safe results to the caller.
local RegistrationService = require('server.services.registration_service')
local resource_name = GetCurrentResourceName()
local status = {
    resource = resource_name,
    version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0',
    status = 'starting',
    changed_at = '',
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
            publish('ready')
            return
        end
        publish('degraded', { reason = 'core_not_ready' })
        Wait(100)
    end
    publish('unavailable', { reason = 'core_readiness_timeout' })
end)

RegisterNetEvent('cnr:registration:request', function(action, payload)
    local player_source = source
    local correlation_id = exports.cnr_core:create_correlation_id()
    local rate_limit = exports.cnr_core:consume_rate_limit(
        'registration:' .. tostring(player_source),
        8,
        10000,
        correlation_id
    )
    local result
    if not rate_limit.ok then
        result = rate_limit
    elseif status.status ~= 'ready' then
        result = exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'registration.error.unavailable',
            {},
            correlation_id
        )
    elseif action == 'status' then
        result = RegistrationService.status(player_source, correlation_id)
    elseif action == 'ruleset' then
        result =
            RegistrationService.ruleset(player_source, payload and payload.locale, correlation_id)
    elseif action == 'submit' then
        result = RegistrationService.submit(player_source, payload, correlation_id)
    else
        result = exports.cnr_core:create_error_result(
            'VALIDATION_ERROR',
            'registration.error.invalid_action',
            {},
            correlation_id
        )
    end
    TriggerClientEvent(
        'cnr:registration:response',
        player_source,
        action,
        payload and payload.request_id,
        result
    )
end)

exports('get_status', function()
    return status
end)
