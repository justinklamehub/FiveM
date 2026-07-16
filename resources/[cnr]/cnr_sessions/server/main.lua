-- Orchestrates connection deferrals, account resolution, whitelist checks, and session ownership.
local AccessPolicy = require('shared.access_policy')
local SessionRepository = require('server.repositories.session_repository')
local SessionService = require('server.services.session_service')
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local source_sessions = {}
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

local function translate(key, parameters)
    return exports.cnr_locales:translate(key, 'en', parameters)
end

local function normalize_source(value)
    return tonumber(value) or value
end

local function safe_done(deferrals, state, reason)
    if state.done then
        return
    end
    state.done = true
    -- Cfx.re requires at least one tick between a prior deferral method and done.
    Wait(0)
    if reason then
        deferrals.done(reason)
    else
        -- The Cfx callback bridge distinguishes zero arguments from an explicit nil argument.
        deferrals.done()
    end
end

local function reject(deferrals, state, correlation_id, code, message_key)
    exports.cnr_logs:log('warn', 'cnr_sessions', 'connection.rejected', {
        code = code,
        correlation_id = correlation_id,
    })
    safe_done(deferrals, state, translate(message_key, { correlation_id = correlation_id }))
end

local function handle_connection(player_source, player_name, deferrals)
    local state = { done = false }
    local correlation_id = exports.cnr_core:create_correlation_id()
    deferrals.update(translate('sessions.progress.checking_connection'))

    local mutation = exports.cnr_core:is_mutation_allowed()
    if not mutation.ok then
        reject(deferrals, state, correlation_id, mutation.error.code, mutation.error.message_key)
        return
    end

    local account_result =
        exports.cnr_accounts:resolve_connection(GetPlayerIdentifiers(player_source), correlation_id)
    if not account_result.ok then
        reject(
            deferrals,
            state,
            correlation_id,
            account_result.error.code,
            account_result.error.message_key
        )
        return
    end

    deferrals.update(translate('sessions.progress.checking_access'))
    local account = account_result.data.account
    local whitelist_result = exports.cnr_whitelist:evaluate(account.public_uuid, correlation_id)
    if not whitelist_result.ok then
        reject(
            deferrals,
            state,
            correlation_id,
            whitelist_result.error.code,
            whitelist_result.error.message_key
        )
        return
    end

    local access = AccessPolicy.evaluate(account.status, whitelist_result.data)
    if not access.allowed then
        reject(deferrals, state, correlation_id, access.code, 'sessions.error.access_denied')
        return
    end

    deferrals.update(translate('sessions.progress.creating_session'))
    local session_result = SessionService.open(
        account.public_uuid,
        player_source,
        player_name,
        access.access_state,
        correlation_id
    )
    if not session_result.ok then
        reject(
            deferrals,
            state,
            correlation_id,
            session_result.error.code,
            session_result.error.message_key
        )
        return
    end

    source_sessions[player_source] = session_result.data
    TriggerEvent('cnr:sessions:started', session_result.data)
    safe_done(deferrals, state)
end

CreateThread(function()
    for _ = 1, 300 do
        if exports.cnr_core:is_ready() then
            break
        end
        publish('degraded', { reason = 'core_not_ready' })
        Wait(100)
    end
    if not exports.cnr_core:is_ready() then
        publish('unavailable', { reason = 'core_readiness_timeout' })
        return
    end
    local cleanup =
        SessionRepository.close_previous_instances(exports.cnr_core:get_server_instance_id())
    if not cleanup.ok then
        publish('unavailable', { reason = 'session_cleanup_failed' })
        return
    end
    publish('ready')
end)

AddEventHandler('playerConnecting', function(player_name, _, deferrals)
    local player_source = normalize_source(source)
    deferrals.defer()
    Wait(0)

    if status.status ~= 'ready' then
        for _ = 1, 300 do
            if status.status == 'ready' then
                break
            end
            deferrals.update('Session services are starting. Please wait…')
            Wait(100)
        end
        if status.status ~= 'ready' then
            Wait(0)
            deferrals.done(translate('sessions.error.unavailable'))
            return
        end
    end

    -- Keep the documented deferrals object intact and do not wrap this yielding flow in pcall.
    handle_connection(player_source, player_name, deferrals)
end)

AddEventHandler('playerJoining', function(old_id)
    local final_source = normalize_source(source)
    local temporary_source = normalize_source(old_id)
    local session = source_sessions[temporary_source]
    if not session then
        return
    end

    local promotion = SessionRepository.promote_source(
        session.session_uuid,
        exports.cnr_core:get_server_instance_id(),
        temporary_source,
        final_source
    )
    if not promotion.ok then
        exports.cnr_logs:log('error', 'cnr_sessions', 'session.source_promotion_failed', {
            session_uuid = session.session_uuid,
            correlation_id = promotion.error and promotion.error.correlation_id or nil,
        })
        return
    end

    source_sessions[temporary_source] = nil
    source_sessions[final_source] = session
    session.source = final_source
    TriggerEvent('cnr:sessions:source_promoted', session)
end)

AddEventHandler('playerDropped', function(reason, _, client_drop_reason)
    local player_source = normalize_source(source)
    local session = source_sessions[player_source]
    source_sessions[player_source] = nil
    if session then
        SessionService.close(session.session_uuid, 'ENDED', reason:sub(1, 128), client_drop_reason)
    else
        SessionRepository.close_by_source(
            exports.cnr_core:get_server_instance_id(),
            player_source,
            reason:sub(1, 128),
            client_drop_reason
        )
    end
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        publish('stopping')
    end
end)

exports('get_status', function()
    return status
end)
exports('get_session_for_source', function(player_source)
    local session = source_sessions[normalize_source(player_source)]
    if not session then
        return nil
    end
    return {
        session_uuid = session.session_uuid,
        account_uuid = session.account_uuid,
        access_state = session.access_state,
    }
end)
exports('refresh_access_for_source', function(player_source, account_uuid, access_state)
    local session = source_sessions[normalize_source(player_source)]
    if not session or session.account_uuid ~= account_uuid then
        return false
    end
    if access_state ~= 'LIMITED' and access_state ~= 'FULL' then
        return false
    end
    session.access_state = access_state
    TriggerEvent('cnr:sessions:access_changed', session)
    return true
end)

RegisterCommand('cnr_session_show', function(command_source, arguments)
    if command_source ~= 0 then
        print(('[cnr_sessions] Rejected in-game use from source %s.'):format(command_source))
        return
    end

    local player_source = normalize_source(arguments[1])
    if not player_source then
        print('[cnr_sessions] Usage: cnr_session_show <source>')
        return
    end

    local session = source_sessions[player_source]
    if not session then
        print(('[cnr_sessions] No active session found for source %s.'):format(player_source))
        return
    end

    print(('[cnr_sessions] Source: %s'):format(player_source))
    print(('[cnr_sessions] Account UUID: %s'):format(session.account_uuid))
    print(('[cnr_sessions] Session UUID: %s'):format(session.session_uuid))
    print(('[cnr_sessions] Access state: %s'):format(session.access_state))
end, false)
