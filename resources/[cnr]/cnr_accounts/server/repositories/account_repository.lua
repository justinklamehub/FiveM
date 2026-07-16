-- Owns parameterized account persistence and never exposes raw platform identifiers.
local AccountRepository = {}

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

---@param identifier table
---@param pepper string
---@return table?, table?
function AccountRepository.find_by_identifier(identifier, pepper)
    return single(
        [[
            SELECT
                a.id,
                BIN_TO_UUID(a.public_uuid) AS public_uuid,
                a.status,
                a.version,
                a.created_at,
                a.updated_at
            FROM cnr_account_identifiers AS i
            INNER JOIN cnr_accounts AS a ON a.id = i.account_id
            WHERE i.identifier_type = ?
              AND i.identifier_hash = UNHEX(SHA2(CONCAT(?, ?), 256))
            LIMIT 1
        ]],
        { identifier.type, pepper, identifier.value }
    )
end

---@param public_uuid string
---@return table?, table?
function AccountRepository.find_by_public_uuid(public_uuid)
    return single(
        [[
            SELECT
                id,
                BIN_TO_UUID(public_uuid) AS public_uuid,
                status,
                version,
                created_at,
                updated_at
            FROM cnr_accounts
            WHERE public_uuid = UUID_TO_BIN(?)
            LIMIT 1
        ]],
        { public_uuid }
    )
end

---@param public_uuid string
---@param identifiers table
---@param pepper string
---@return table
function AccountRepository.create(public_uuid, identifiers, pepper)
    local queries = {
        {
            query = [[
                INSERT INTO cnr_accounts (public_uuid, status, created_at, updated_at)
                VALUES (UUID_TO_BIN(?), 'PENDING_REGISTRATION', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))
            ]],
            values = { public_uuid },
        },
    }

    for _, identifier in ipairs(identifiers) do
        queries[#queries + 1] = {
            query = [[
                INSERT INTO cnr_account_identifiers (
                    account_id,
                    identifier_type,
                    identifier_hash,
                    identifier_hint,
                    is_primary,
                    first_seen_at,
                    last_seen_at
                )
                SELECT
                    id,
                    ?,
                    UNHEX(SHA2(CONCAT(?, ?), 256)),
                    ?,
                    ?,
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6)
                FROM cnr_accounts
                WHERE public_uuid = UUID_TO_BIN(?)
            ]],
            values = {
                identifier.type,
                pepper,
                identifier.value,
                identifier.hint,
                identifier.is_primary and 1 or 0,
                public_uuid,
            },
        }
    end

    return transaction(queries)
end

---@param public_uuid string
---@param identifiers table
---@param pepper string
---@return table
function AccountRepository.touch_identifiers(public_uuid, identifiers, pepper)
    local queries = {}
    for _, identifier in ipairs(identifiers) do
        queries[#queries + 1] = {
            query = [[
                INSERT INTO cnr_account_identifiers (
                    account_id,
                    identifier_type,
                    identifier_hash,
                    identifier_hint,
                    is_primary,
                    first_seen_at,
                    last_seen_at
                )
                SELECT
                    id,
                    ?,
                    UNHEX(SHA2(CONCAT(?, ?), 256)),
                    ?,
                    ?,
                    UTC_TIMESTAMP(6),
                    UTC_TIMESTAMP(6)
                FROM cnr_accounts
                WHERE public_uuid = UUID_TO_BIN(?)
                ON DUPLICATE KEY UPDATE
                    identifier_hint = VALUES(identifier_hint),
                    is_primary = VALUES(is_primary),
                    last_seen_at = VALUES(last_seen_at)
            ]],
            values = {
                identifier.type,
                pepper,
                identifier.value,
                identifier.hint,
                identifier.is_primary and 1 or 0,
                public_uuid,
            },
        }
    end
    queries[#queries + 1] = {
        query = [[
            UPDATE cnr_accounts
            SET updated_at = UTC_TIMESTAMP(6), version = version + 1
            WHERE public_uuid = UUID_TO_BIN(?)
        ]],
        values = { public_uuid },
    }
    return transaction(queries)
end

---@param public_uuid string
---@return table?, table?
function AccountRepository.find_active_restriction(public_uuid)
    return single(
        [[
            SELECT
                restriction_type,
                reason_code,
                starts_at,
                ends_at
            FROM cnr_account_restrictions
            WHERE account_id = (
                SELECT id FROM cnr_accounts WHERE public_uuid = UUID_TO_BIN(?) LIMIT 1
            )
              AND starts_at <= UTC_TIMESTAMP(6)
              AND (ends_at IS NULL OR ends_at > UTC_TIMESTAMP(6))
              AND revoked_at IS NULL
            ORDER BY starts_at DESC
            LIMIT 1
        ]],
        { public_uuid }
    )
end

return AccountRepository
