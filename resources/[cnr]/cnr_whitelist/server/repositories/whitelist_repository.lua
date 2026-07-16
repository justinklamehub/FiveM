-- Reads active whitelist entries without mutating account-owned records.
local WhitelistRepository = {}

---@param account_uuid string
---@return table?, table?
function WhitelistRepository.find_active(account_uuid)
    local result = exports.cnr_database:single(
        [[
            SELECT
                BIN_TO_UUID(w.public_uuid) AS public_uuid,
                w.entry_type,
                w.starts_at,
                w.ends_at
            FROM cnr_whitelist_entries AS w
            INNER JOIN cnr_accounts AS a ON a.id = w.account_id
            WHERE a.public_uuid = UUID_TO_BIN(?)
              AND w.status = 'ACTIVE'
              AND w.starts_at <= UTC_TIMESTAMP(6)
              AND (w.ends_at IS NULL OR w.ends_at > UTC_TIMESTAMP(6))
            ORDER BY w.starts_at DESC
            LIMIT 1
        ]],
        { account_uuid }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

return WhitelistRepository
