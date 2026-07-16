-- Persists one connecting or active session per account with restart-safe server instance ownership.
local SessionRepository = {}

local function single(sql, parameters)
    local result = exports.cnr_database:single(sql, parameters)
    if not result.ok then
        return nil, result
    end
    return result.data
end

---@param server_instance_id string
---@return table
function SessionRepository.close_previous_instances(server_instance_id)
    return exports.cnr_database:transaction({
        {
            query = [[
                UPDATE cnr_account_sessions
                SET
                    status = 'STALE',
                    ended_at = UTC_TIMESTAMP(6),
                    end_reason = 'server_instance_replaced'
                WHERE status IN ('CONNECTING', 'ACTIVE')
                  AND server_instance_id <> ?
            ]],
            values = { server_instance_id },
        },
    })
end

---@param account_uuid string
---@return table?, table?
function SessionRepository.find_active(account_uuid)
    return single(
        [[
            SELECT
                LOWER(
                    INSERT(
                        INSERT(
                            INSERT(
                                INSERT(HEX(s.public_uuid), 9, 0, '-'),
                                14,
                                0,
                                '-'
                            ),
                            19,
                            0,
                            '-'
                        ),
                        24,
                        0,
                        '-'
                    )
                ) AS public_uuid,
                s.server_instance_id,
                s.source_at_start,
                s.status,
                s.access_state,
                s.started_at
            FROM cnr_account_sessions AS s
            INNER JOIN cnr_accounts AS a ON a.id = s.account_id
            WHERE a.public_uuid = UNHEX(REPLACE(?, '-', ''))
              AND s.status IN ('CONNECTING', 'ACTIVE')
            LIMIT 1
        ]],
        { account_uuid }
    )
end

---@param session table
---@return table
function SessionRepository.create(session)
    return exports.cnr_database:transaction({
        {
            query = [[
                INSERT INTO cnr_account_sessions (
                    public_uuid,
                    account_id,
                    server_instance_id,
                    source_at_start,
                    player_name,
                    status,
                    access_state,
                    started_at,
                    last_seen_at
                )
                SELECT
                    UNHEX(REPLACE(?, '-', '')),
                    id,
                    ?,
                    ?,
                    ?,
                    'CONNECTING',
                    ?,
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6)
                FROM cnr_accounts
                WHERE public_uuid = UNHEX(REPLACE(?, '-', ''))
            ]],
            values = {
                session.public_uuid,
                session.server_instance_id,
                session.source,
                session.player_name,
                session.access_state,
                session.account_uuid,
            },
        },
    })
end

---@param session_uuid string
---@return table
function SessionRepository.activate(session_uuid)
    return exports.cnr_database:transaction({
        {
            query = [[
                UPDATE cnr_account_sessions
                SET status = 'ACTIVE', activated_at = UTC_TIMESTAMP(6), last_seen_at = UTC_TIMESTAMP(6)
                WHERE public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND status = 'CONNECTING'
            ]],
            values = { session_uuid },
        },
    })
end

---@param session_uuid string
---@param server_instance_id string
---@param temporary_source integer
---@param final_source integer
---@return table
function SessionRepository.promote_source(
    session_uuid,
    server_instance_id,
    temporary_source,
    final_source
)
    return exports.cnr_database:query(
        [[
            UPDATE cnr_account_sessions
            SET source_at_start = ?, last_seen_at = UTC_TIMESTAMP(6)
            WHERE public_uuid = UNHEX(REPLACE(?, '-', ''))
              AND server_instance_id = ?
              AND source_at_start = ?
              AND status = 'ACTIVE'
        ]],
        { final_source, session_uuid, server_instance_id, temporary_source }
    )
end

---@param session_uuid string
---@param status string
---@param reason string
---@param client_drop_reason? integer
---@return table
function SessionRepository.close(session_uuid, status, reason, client_drop_reason)
    return exports.cnr_database:transaction({
        {
            query = [[
                UPDATE cnr_account_sessions
                SET
                    status = ?,
                    ended_at = UTC_TIMESTAMP(6),
                    last_seen_at = UTC_TIMESTAMP(6),
                    end_reason = ?,
                    client_drop_reason = ?
                WHERE public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND status IN ('CONNECTING', 'ACTIVE')
            ]],
            values = { status, reason, client_drop_reason, session_uuid },
        },
    })
end

---@param server_instance_id string
---@param source integer
---@param reason string
---@param client_drop_reason? integer
---@return table
function SessionRepository.close_by_source(server_instance_id, source, reason, client_drop_reason)
    return exports.cnr_database:transaction({
        {
            query = [[
                UPDATE cnr_account_sessions
                SET
                    status = 'ENDED',
                    ended_at = UTC_TIMESTAMP(6),
                    last_seen_at = UTC_TIMESTAMP(6),
                    end_reason = ?,
                    client_drop_reason = ?
                WHERE server_instance_id = ?
                  AND source_at_start = ?
                  AND status IN ('CONNECTING', 'ACTIVE')
            ]],
            values = { reason, client_drop_reason, server_instance_id, source },
        },
    })
end

return SessionRepository
