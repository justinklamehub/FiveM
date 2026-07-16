-- Owns technical role and permission persistence without exposing gameplay job state.
local PermissionRepository = {}

local function query(sql, parameters)
    local result = exports.cnr_database:query(sql, parameters)
    if not result.ok then
        return nil, result
    end
    return result.data
end

local function single(sql, parameters)
    local result = exports.cnr_database:single(sql, parameters)
    if not result.ok then
        return nil, result
    end
    return result.data
end

local function transaction(queries)
    return exports.cnr_database:transaction(queries)
end

---@return table?, table?
function PermissionRepository.get_catalog_counts()
    return single([[
        SELECT
            (SELECT COUNT(*) FROM cnr_technical_roles WHERE is_active = 1) AS role_count,
            (SELECT COUNT(*) FROM cnr_technical_permissions WHERE is_active = 1) AS permission_count
    ]])
end

---@param account_uuid string
---@return boolean?, table?
function PermissionRepository.account_exists(account_uuid)
    local row, database_error = single(
        [[
            SELECT EXISTS(
                SELECT 1
                FROM cnr_accounts
                WHERE public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND archived_at IS NULL
            ) AS account_exists
        ]],
        { account_uuid }
    )
    if database_error then
        return nil, database_error
    end
    return row and tonumber(row.account_exists) == 1 or false
end

---@param role_code string
---@return table?, table?
function PermissionRepository.find_role(role_code)
    return single(
        [[
            SELECT
                id,
                code,
                priority,
                is_system
            FROM cnr_technical_roles
            WHERE code = ?
              AND is_active = 1
            LIMIT 1
        ]],
        { role_code }
    )
end

---@param account_uuid string
---@return table?, table?
function PermissionRepository.get_snapshot(account_uuid)
    local roles, role_error = query(
        [[
            SELECT
                role_row.code,
                role_row.priority,
                assignment.starts_at,
                assignment.ends_at
            FROM cnr_account_technical_roles AS assignment
            INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
            INNER JOIN cnr_technical_roles AS role_row ON role_row.id = assignment.role_id
            WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
              AND account_row.archived_at IS NULL
              AND assignment.status = 'ACTIVE'
              AND assignment.starts_at <= UTC_TIMESTAMP(6)
              AND (assignment.ends_at IS NULL OR assignment.ends_at > UTC_TIMESTAMP(6))
              AND role_row.is_active = 1
            ORDER BY role_row.priority DESC, role_row.code ASC
        ]],
        { account_uuid }
    )
    if role_error then
        return nil, role_error
    end

    local permissions, permission_error = query(
        [[
            SELECT DISTINCT permission_row.code
            FROM cnr_account_technical_roles AS assignment
            INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
            INNER JOIN cnr_technical_roles AS role_row ON role_row.id = assignment.role_id
            INNER JOIN cnr_technical_role_permissions AS role_permission
                ON role_permission.role_id = role_row.id
            INNER JOIN cnr_technical_permissions AS permission_row
                ON permission_row.id = role_permission.permission_id
            WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
              AND account_row.archived_at IS NULL
              AND assignment.status = 'ACTIVE'
              AND assignment.starts_at <= UTC_TIMESTAMP(6)
              AND (assignment.ends_at IS NULL OR assignment.ends_at > UTC_TIMESTAMP(6))
              AND role_row.is_active = 1
              AND permission_row.is_active = 1
            ORDER BY permission_row.code ASC
        ]],
        { account_uuid }
    )
    if permission_error then
        return nil, permission_error
    end

    return { roles = roles or {}, permissions = permissions or {} }
end

---@param account_uuid string
---@param permission_code string
---@return boolean?, table?
function PermissionRepository.has_permission(account_uuid, permission_code)
    local row, database_error = single(
        [[
            SELECT EXISTS(
                SELECT 1
                FROM cnr_account_technical_roles AS assignment
                INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
                INNER JOIN cnr_technical_roles AS role_row ON role_row.id = assignment.role_id
                INNER JOIN cnr_technical_role_permissions AS role_permission
                    ON role_permission.role_id = role_row.id
                INNER JOIN cnr_technical_permissions AS permission_row
                    ON permission_row.id = role_permission.permission_id
                WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND account_row.archived_at IS NULL
                  AND assignment.status = 'ACTIVE'
                  AND assignment.starts_at <= UTC_TIMESTAMP(6)
                  AND (assignment.ends_at IS NULL OR assignment.ends_at > UTC_TIMESTAMP(6))
                  AND role_row.is_active = 1
                  AND permission_row.is_active = 1
                  AND permission_row.code = ?
            ) AS allowed
        ]],
        { account_uuid, permission_code }
    )
    if database_error then
        return nil, database_error
    end
    return row and tonumber(row.allowed) == 1 or false
end

---@param account_uuid string
---@return table
function PermissionRepository.expire_assignments(account_uuid)
    return transaction({
        {
            query = [[
                UPDATE cnr_account_technical_roles AS assignment
                INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
                SET
                    assignment.status = 'EXPIRED',
                    assignment.updated_at = UTC_TIMESTAMP(6)
                WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND assignment.status = 'ACTIVE'
                  AND assignment.ends_at IS NOT NULL
                  AND assignment.ends_at <= UTC_TIMESTAMP(6)
            ]],
            values = { account_uuid },
        },
    })
end

---@param account_uuid string
---@param role_code string
---@return table?, table?
function PermissionRepository.find_active_assignment(account_uuid, role_code)
    return single(
        [[
            SELECT
                assignment.id,
                assignment.starts_at,
                assignment.ends_at
            FROM cnr_account_technical_roles AS assignment
            INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
            INNER JOIN cnr_technical_roles AS role_row ON role_row.id = assignment.role_id
            WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
              AND role_row.code = ?
              AND assignment.status = 'ACTIVE'
              AND assignment.starts_at <= UTC_TIMESTAMP(6)
              AND (assignment.ends_at IS NULL OR assignment.ends_at > UTC_TIMESTAMP(6))
            LIMIT 1
        ]],
        { account_uuid, role_code }
    )
end

---@param assignment table
---@return table
function PermissionRepository.grant_role(assignment)
    local actor_uuid = assignment.actor_uuid or ''
    local ends_at = assignment.ends_at or ''

    return transaction({
        {
            query = [[
                INSERT INTO cnr_account_technical_roles (
                    public_uuid,
                    account_id,
                    role_id,
                    granted_by_account_id,
                    reason_code,
                    status,
                    starts_at,
                    ends_at,
                    created_at,
                    updated_at
                )
                SELECT
                    UNHEX(REPLACE(?, '-', '')),
                    account_row.id,
                    role_row.id,
                    CASE
                        WHEN ? = '' THEN NULL
                        ELSE (
                            SELECT actor_row.id
                            FROM cnr_accounts AS actor_row
                            WHERE actor_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                            LIMIT 1
                        )
                    END,
                    ?,
                    'ACTIVE',
                    UTC_TIMESTAMP(6),
                    NULLIF(?, ''),
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6)
                FROM cnr_accounts AS account_row
                INNER JOIN cnr_technical_roles AS role_row
                    ON role_row.code = ? AND role_row.is_active = 1
                WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND account_row.archived_at IS NULL
            ]],
            values = {
                assignment.public_uuid,
                actor_uuid,
                actor_uuid,
                assignment.reason_code,
                ends_at,
                assignment.role_code,
                assignment.account_uuid,
            },
        },
    })
end

---@param revocation table
---@return table
function PermissionRepository.revoke_role(revocation)
    local actor_uuid = revocation.actor_uuid or ''

    return transaction({
        {
            query = [[
                UPDATE cnr_account_technical_roles AS assignment
                INNER JOIN cnr_accounts AS account_row ON account_row.id = assignment.account_id
                INNER JOIN cnr_technical_roles AS role_row ON role_row.id = assignment.role_id
                SET
                    assignment.status = 'REVOKED',
                    assignment.revoked_at = UTC_TIMESTAMP(6),
                    assignment.revoked_by_account_id = CASE
                        WHEN ? = '' THEN NULL
                        ELSE (
                            SELECT actor_row.id
                            FROM cnr_accounts AS actor_row
                            WHERE actor_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                            LIMIT 1
                        )
                    END,
                    assignment.revocation_reason_code = ?,
                    assignment.updated_at = UTC_TIMESTAMP(6)
                WHERE account_row.public_uuid = UNHEX(REPLACE(?, '-', ''))
                  AND role_row.code = ?
                  AND assignment.status = 'ACTIVE'
                  AND assignment.starts_at <= UTC_TIMESTAMP(6)
                  AND (assignment.ends_at IS NULL OR assignment.ends_at > UTC_TIMESTAMP(6))
            ]],
            values = {
                actor_uuid,
                actor_uuid,
                revocation.reason_code,
                revocation.account_uuid,
                revocation.role_code,
            },
        },
    })
end

return PermissionRepository
