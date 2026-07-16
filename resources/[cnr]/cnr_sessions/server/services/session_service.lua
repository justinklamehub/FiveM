-- Reserves, activates, and closes sessions while preserving the one-active-session invariant.
local SessionRepository = require('server.repositories.session_repository')
local SessionService = {}

---@param account_uuid string
---@param source integer
---@param player_name string
---@param access_state string
---@param correlation_id string
---@return table
function SessionService.open(account_uuid, source, player_name, access_state, correlation_id)
    local active, active_error = SessionRepository.find_active(account_uuid)
    if active_error then
        return active_error
    end
    if active then
        return exports.cnr_core:create_error_result(
            'SESSION_ALREADY_ACTIVE',
            'sessions.error.already_active',
            {},
            correlation_id
        )
    end

    local session_uuid = exports.cnr_core:create_uuid_v7()
    local session = {
        public_uuid = session_uuid,
        account_uuid = account_uuid,
        server_instance_id = exports.cnr_core:get_server_instance_id(),
        source = source,
        player_name = player_name:sub(1, 64),
        access_state = access_state,
    }
    local create_result = SessionRepository.create(session)
    if not create_result.ok then
        local concurrent = SessionRepository.find_active(account_uuid)
        if concurrent then
            return exports.cnr_core:create_error_result(
                'SESSION_ALREADY_ACTIVE',
                'sessions.error.already_active',
                {},
                correlation_id
            )
        end
        return create_result
    end

    local activate_result = SessionRepository.activate(session_uuid)
    if not activate_result.ok then
        SessionRepository.close(session_uuid, 'REJECTED', 'activation_failed')
        return activate_result
    end

    exports.cnr_logs:audit('cnr_sessions', 'session.started', {
        account_uuid = account_uuid,
        session_uuid = session_uuid,
        access_state = access_state,
        correlation_id = correlation_id,
    })
    return exports.cnr_core:create_success_result({
        session_uuid = session_uuid,
        account_uuid = account_uuid,
        access_state = access_state,
        source = source,
    }, correlation_id)
end

---@param session_uuid string
---@param status string
---@param reason string
---@param client_drop_reason? integer
function SessionService.close(session_uuid, status, reason, client_drop_reason)
    return SessionRepository.close(session_uuid, status, reason, client_drop_reason)
end

return SessionService
