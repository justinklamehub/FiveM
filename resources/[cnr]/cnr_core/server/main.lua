-- Coordinates dependency readiness and exposes common technical contracts without gameplay state.
local ErrorCodes = require('shared.error_codes')
local Correlation = require('shared.correlation')
local UuidV7 = require('shared.uuid_v7')
local Result = require('shared.result')
local Readiness = require('shared.readiness')
local RateLimiter = require('shared.rate_limiter')
local RequestContext = require('shared.request_context')

local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local readiness = Readiness.new(resource_name, version)
local rate_limiter = RateLimiter.new(GetGameTimer)
local dependencies = { 'cnr_database', 'cnr_logs', 'cnr_locales', 'cnr_config' }
local registry = {}
local function runtime_now_ms()
    return math.floor(os.time() * 1000) + (GetGameTimer() % 1000)
end
local server_instance_id = GlobalState.cnrServerInstanceId
if type(server_instance_id) ~= 'string' or server_instance_id == '' then
    server_instance_id = UuidV7.create(runtime_now_ms)
    GlobalState.cnrServerInstanceId = server_instance_id
end

local function copy(value)
    if type(value) ~= 'table' then
        return value
    end

    local result = {}
    for key, item in pairs(value) do
        result[key] = copy(item)
    end
    return result
end

local function publish(status, details)
    readiness:set(status, details)
    registry[resource_name] = readiness:snapshot()
    TriggerEvent('cnr:core:status_changed', registry[resource_name])
end

local function read_dependency(resource)
    local state = GetResourceState(resource)
    if state ~= 'started' then
        return {
            resource = resource,
            version = 'unknown',
            status = 'unavailable',
            changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            details = { state = state },
        }
    end
    local ok, snapshot = pcall(function()
        return exports[resource]:get_status()
    end)
    if not ok or type(snapshot) ~= 'table' then
        return {
            resource = resource,
            version = 'unknown',
            status = 'unavailable',
            changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            details = { reason = 'status_export_failed' },
        }
    end
    return snapshot
end

local function refresh_dependencies()
    local all_ready = true
    for _, dependency in ipairs(dependencies) do
        local snapshot = read_dependency(dependency)
        registry[dependency] = snapshot
        if snapshot.status ~= 'ready' then
            all_ready = false
        end
    end
    if all_ready then
        publish('ready', { dependencies = dependencies })
    else
        publish('degraded', { dependencies = dependencies })
    end
end

local function report_resource_status(snapshot)
    local caller = GetInvokingResource()
    if not caller or type(snapshot) ~= 'table' or snapshot.resource ~= caller then
        return Result.failure(ErrorCodes.VALIDATION_ERROR, 'core.error.invalid_resource_status')
    end
    local probe = Readiness.new(snapshot.resource, snapshot.version or 'unknown')
    local valid = probe:set(snapshot.status, snapshot.details)
    if not valid then
        return Result.failure(ErrorCodes.VALIDATION_ERROR, 'core.error.invalid_resource_status')
    end
    registry[caller] = probe:snapshot()
    TriggerEvent('cnr:core:resource_status_changed', registry[caller])
    return Result.success(registry[caller])
end

CreateThread(function()
    for _ = 1, 300 do
        refresh_dependencies()
        if readiness.status == 'ready' then
            return
        end
        Wait(100)
    end
end)
AddEventHandler('cnr:database:status_changed', function()
    CreateThread(function()
        Wait(0)
        refresh_dependencies()
    end)
end)
AddEventHandler('onResourceStart', function(started)
    if started == resource_name then
        return
    end
    for _, dependency in ipairs(dependencies) do
        if dependency == started then
            CreateThread(function()
                Wait(250)
                refresh_dependencies()
            end)
        end
    end
end)
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
        return
    end
    if registry[stopped] then
        registry[stopped].status = 'stopping'
        registry[stopped].changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    end
    for _, dependency in ipairs(dependencies) do
        if dependency == stopped then
            refresh_dependencies()
        end
    end
end)

exports('get_status', function()
    return readiness:snapshot()
end)
exports('get_resource_status', function(name)
    return copy(registry[name])
end)
exports('get_all_resource_statuses', function()
    return copy(registry)
end)
exports('report_resource_status', report_resource_status)
exports('is_ready', function()
    return readiness.status == 'ready'
end)
exports('is_mutation_allowed', function()
    if readiness.status ~= 'ready' then
        return Result.failure(
            ErrorCodes.DEPENDENCY_UNAVAILABLE,
            'core.error.dependency_unavailable'
        )
    end
    local maintenance = exports.cnr_config:is_maintenance_mode()
    if maintenance then
        return Result.failure(ErrorCodes.MAINTENANCE_MODE, 'core.error.maintenance_mode')
    end
    return Result.success({ allowed = true })
end)
exports('consume_rate_limit', function(key, limit, window_ms, correlation_id)
    local allowed, retry_after_ms = rate_limiter:consume(key, limit, window_ms)
    if not allowed then
        return Result.failure(
            ErrorCodes.RATE_LIMITED,
            'core.error.rate_limited',
            { retry_after_ms = retry_after_ms },
            correlation_id
        )
    end
    return Result.success({ allowed = true, retry_after_ms = retry_after_ms }, correlation_id)
end)
exports('create_request_context', RequestContext.create)
exports('create_correlation_id', Correlation.create)
exports('create_uuid_v7', function()
    return UuidV7.create(runtime_now_ms)
end)
exports('get_server_instance_id', function()
    return server_instance_id
end)
exports('create_success_result', Result.success)
exports('create_error_result', Result.failure)
exports('get_error_codes', function()
    return copy(ErrorCodes)
end)
