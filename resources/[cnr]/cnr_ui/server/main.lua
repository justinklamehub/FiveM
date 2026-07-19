-- Reports the UI resource readiness to cnr_core without owning gameplay state.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local status = {
    resource = resource_name,
    version = version,
    status = 'starting',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = {},
}
CreateThread(function()
    for _ = 1, 300 do
        local ok, core_ready = pcall(function()
            return exports.cnr_core:is_ready()
        end)
        status.status = ok and core_ready and 'ready' or 'degraded'
        status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
        pcall(function()
            exports.cnr_core:report_resource_status(status)
        end)
        if status.status == 'ready' then
            return
        end
        Wait(100)
    end
    status.status = 'unavailable'
    status.details = { reason = 'core_readiness_timeout' }
    status.changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ')
    pcall(function()
        exports.cnr_core:report_resource_status(status)
    end)
end)
exports('get_status', function()
    return status
end)
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        status.status = 'stopping'
        pcall(function()
            exports.cnr_core:report_resource_status(status)
        end)
    end
end)
local source_generations = {}
local opened_sources = {}

CreateThread(function()
    Wait(0)
    if GetResourceState('basic-gamemode') == 'started' then
        print(
            '^3[cnr_ui] WARNING: basic-gamemode is running and can request an unauthorized stock spawn. Remove it from the CNR txAdmin recipe.^7'
        )
    end
end)

local function snapshot(phase, retryable, correlation_id)
    return {
        contract_version = CNR_UI_LIFECYCLE_CONTRACT.version,
        phase = phase,
        retryable = retryable,
        correlation_id = correlation_id,
    }
end

local function emit_snapshot(player_source, lifecycle_snapshot)
    if not CNR_UI_LIFECYCLE_CONTRACT.is_valid_phase(lifecycle_snapshot.phase) then
        return false
    end
    TriggerClientEvent('cnr:ui:lifecycle', player_source, lifecycle_snapshot)
    return true
end

local function resolve_snapshot(player_source)
    if status.status ~= 'ready' then
        return nil
    end
    local correlation_id = exports.cnr_core:create_correlation_id()
    local session_called, session = pcall(function()
        return exports.cnr_sessions:get_session_for_source(player_source)
    end)
    if not session_called or not session then
        return nil
    end

    local access_phase = CNR_UI_LIFECYCLE_CONTRACT.phase_for_access(session.access_state)
    if access_phase and access_phase ~= 'RECOVERABLE_ERROR' then
        return snapshot(access_phase, access_phase == 'ACCESS_PENDING', correlation_id)
    elseif session.access_state ~= 'FULL' then
        exports.cnr_logs:log('warn', 'cnr_ui', 'lifecycle.access_state_rejected', {
            code = 'PRECONDITION_FAILED',
            correlation_id = correlation_id,
        })
        return snapshot('RECOVERABLE_ERROR', true, correlation_id)
    end

    local called, result = pcall(function()
        return exports.cnr_characters:lifecycle_snapshot(player_source, correlation_id)
    end)
    if not called or not result or not result.ok then
        local code = result and result.error and result.error.code or 'DEPENDENCY_UNAVAILABLE'
        if code == 'DEPENDENCY_UNAVAILABLE' or code == 'AUTHENTICATION_REQUIRED' then
            return nil
        end
        exports.cnr_logs:log('warn', 'cnr_ui', 'lifecycle.snapshot_rejected', {
            code = code,
            correlation_id = correlation_id,
        })
        return snapshot('RECOVERABLE_ERROR', true, correlation_id)
    end
    if not result.data or not CNR_UI_LIFECYCLE_CONTRACT.is_valid_phase(result.data.phase) then
        exports.cnr_logs:log('error', 'cnr_ui', 'lifecycle.snapshot_invalid', {
            correlation_id = correlation_id,
        })
        return snapshot('RECOVERABLE_ERROR', true, correlation_id)
    end
    return snapshot(result.data.phase, result.data.phase ~= 'READY', correlation_id)
end

local function open_for_session(player_source)
    local lifecycle_snapshot = resolve_snapshot(player_source)
    if not lifecycle_snapshot then
        return false
    end
    return emit_snapshot(player_source, lifecycle_snapshot)
end

local function open_when_session_is_ready(player_source, force)
    if opened_sources[player_source] and not force then
        return
    end
    source_generations[player_source] = (source_generations[player_source] or 0) + 1
    local generation = source_generations[player_source]
    opened_sources[player_source] = false
    CreateThread(function()
        for _ = 1, 50 do
            if source_generations[player_source] ~= generation then
                return
            end
            if open_for_session(player_source) then
                opened_sources[player_source] = true
                return
            end
            Wait(100)
        end
        if source_generations[player_source] ~= generation then
            return
        end
        local correlation_id = exports.cnr_core:create_correlation_id()
        exports.cnr_logs:log('warn', 'cnr_ui', 'lifecycle.snapshot_timeout', {
            code = 'DEPENDENCY_UNAVAILABLE',
            correlation_id = correlation_id,
        })
        emit_snapshot(player_source, snapshot('RECOVERABLE_ERROR', true, correlation_id))
        opened_sources[player_source] = true
    end)
end

local function consume_lifecycle_rate_limit(player_source)
    local correlation_id = exports.cnr_core:create_correlation_id()
    local result = exports.cnr_core:consume_rate_limit(
        'ui:lifecycle:' .. tostring(player_source),
        6,
        10000,
        correlation_id
    )
    return result, correlation_id
end

RegisterNetEvent('cnr:ui:ready', function()
    local player_source = source
    local rate_limit, correlation_id = consume_lifecycle_rate_limit(player_source)
    if not rate_limit.ok then
        emit_snapshot(player_source, snapshot('RECOVERABLE_ERROR', true, correlation_id))
        return
    end
    open_when_session_is_ready(player_source, false)
end)

RegisterNetEvent('cnr:ui:refresh', function()
    local player_source = source
    local rate_limit, correlation_id = consume_lifecycle_rate_limit(player_source)
    if not rate_limit.ok then
        emit_snapshot(player_source, snapshot('RECOVERABLE_ERROR', true, correlation_id))
        return
    end
    open_when_session_is_ready(player_source, true)
end)

AddEventHandler('cnr:sessions:access_changed', function(session)
    if session and session.source then
        open_when_session_is_ready(session.source, true)
    end
end)

AddEventHandler('playerDropped', function()
    source_generations[source] = nil
    opened_sources[source] = nil
end)
