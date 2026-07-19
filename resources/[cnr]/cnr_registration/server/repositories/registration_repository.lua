-- Persists registration evidence and the account/session transition in one database transaction.
local RegistrationRepository = {}

local function single(sql, parameters)
    local result = exports.cnr_database:single(sql, parameters)
    if not result.ok then
        return nil, result
    end
    return result.data
end

local uuid_sql =
    [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s), 9, 0, '-'), 14, 0, '-'), 19, 0, '-'), 24, 0, '-'))]]

function RegistrationRepository.current_ruleset()
    return single(
        ([[
        SELECT id, %s AS public_uuid, version, content_de, content_en,
               LOWER(HEX(content_sha256)) AS content_sha256, published_at
        FROM cnr_rulesets WHERE status = 'CURRENT' LIMIT 1
    ]]):format(uuid_sql:format('public_uuid')),
        {}
    )
end

function RegistrationRepository.session_for_source(server_instance_id, player_source)
    return single(
        ([[
        SELECT s.id AS session_id, %s AS session_uuid, a.id AS account_id,
               %s AS account_uuid, a.status AS account_status, a.version AS account_version,
               s.status AS session_status, s.access_state
        FROM cnr_account_sessions s
        INNER JOIN cnr_accounts a ON a.id = s.account_id
        WHERE s.server_instance_id = ? AND s.source_at_start = ? AND s.status = 'ACTIVE'
        LIMIT 1
    ]]):format(uuid_sql:format('s.public_uuid'), uuid_sql:format('a.public_uuid')),
        {
            server_instance_id,
            player_source,
        }
    )
end

function RegistrationRepository.find_operation(operation_uuid)
    return single(
        ([[
        SELECT %s AS operation_uuid, %s AS account_uuid, request_id, contract_version, locale,
               LOWER(HEX(payload_sha256)) AS payload_sha256,
               result_account_status, result_access_state, completed_at
        FROM cnr_registration_operations operation_row
        INNER JOIN cnr_accounts account_row ON account_row.id = operation_row.account_id
        WHERE operation_row.operation_uuid = UNHEX(REPLACE(?, '-', '')) LIMIT 1
    ]]):format(
            uuid_sql:format('operation_row.operation_uuid'),
            uuid_sql:format('account_row.public_uuid')
        ),
        { operation_uuid }
    )
end

function RegistrationRepository.payload_hash(payload)
    -- request_id is transport correlation metadata and may change during a safe network retry.
    return single([[SELECT LOWER(SHA2(CONCAT_WS('|', ?, ?, ?, ?, ?), 256)) AS payload_sha256]], {
        payload.ruleset_uuid,
        payload.ruleset_version,
        payload.acceptance and 1 or 0,
        payload.locale,
        payload.contract_version,
    })
end

function RegistrationRepository.commit_registration(context)
    return exports.cnr_database:transaction({
        {
            query = [[
                INSERT INTO cnr_registration_operations (
                    operation_uuid, account_id, session_id, ruleset_id, request_id,
                    correlation_id, contract_version, locale, accepted, payload_sha256,
                    result_account_status, result_access_state, created_at, completed_at
                ) SELECT UNHEX(REPLACE(?, '-', '')), account_row.id, session_row.id, ?, ?, ?, ?, ?,
                         1, UNHEX(?), ?, ?, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)
                    FROM cnr_accounts account_row
                    INNER JOIN cnr_account_sessions session_row
                       ON session_row.id = ? AND session_row.account_id = account_row.id
                   WHERE account_row.id = ? AND account_row.status = 'PENDING_REGISTRATION'
                     AND account_row.version = ? AND session_row.status = 'ACTIVE'
                     AND session_row.access_state = 'ONBOARDING'
            ]],
            values = {
                context.operation_uuid,
                context.ruleset_id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.locale,
                context.payload_sha256,
                context.account_status,
                context.access_state,
                context.session_id,
                context.account_id,
                context.account_version,
            },
        },
        {
            query = [[
                INSERT INTO cnr_ruleset_acceptances (
                    public_uuid, account_id, ruleset_id, operation_id, session_id, locale,
                    accepted_at, ruleset_content_sha256
                ) SELECT UNHEX(REPLACE(?, '-', '')), ?, ?, operation_row.id, ?, ?,
                         UTC_TIMESTAMP(6), ruleset_row.content_sha256
                  FROM cnr_registration_operations operation_row
                  INNER JOIN cnr_rulesets ruleset_row ON ruleset_row.id = ?
                 WHERE operation_row.operation_uuid = UNHEX(REPLACE(?, '-', ''))
            ]],
            values = {
                context.acceptance_uuid,
                context.account_id,
                context.ruleset_id,
                context.session_id,
                context.locale,
                context.ruleset_id,
                context.operation_uuid,
            },
        },
        {
            query = [[
                UPDATE cnr_accounts SET status = ?, version = version + 1, updated_at = UTC_TIMESTAMP(6)
                 WHERE id = ? AND status = 'PENDING_REGISTRATION' AND version = ?
            ]],
            values = { context.account_status, context.account_id, context.account_version },
        },
        {
            query = [[
                UPDATE cnr_account_sessions SET access_state = ?, last_seen_at = UTC_TIMESTAMP(6)
                 WHERE id = ? AND account_id = ? AND status = 'ACTIVE' AND access_state = 'ONBOARDING'
            ]],
            values = { context.access_state, context.session_id, context.account_id },
        },
    })
end

return RegistrationRepository
