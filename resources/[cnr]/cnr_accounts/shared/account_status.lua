-- Defines valid account lifecycle states and their connection restrictions.
local AccountStatus = {
    PENDING_REGISTRATION = 'PENDING_REGISTRATION',
    PENDING_WHITELIST = 'PENDING_WHITELIST',
    ACTIVE = 'ACTIVE',
    SUSPENDED = 'SUSPENDED',
    BANNED = 'BANNED',
    RESTRICTED = 'RESTRICTED',
    ARCHIVED = 'ARCHIVED',
}

local connection_blocked = {
    [AccountStatus.SUSPENDED] = true,
    [AccountStatus.BANNED] = true,
    [AccountStatus.RESTRICTED] = true,
    [AccountStatus.ARCHIVED] = true,
}

---@param status string
---@return boolean
function AccountStatus.is_connection_blocked(status)
    return connection_blocked[status] == true
end

return AccountStatus
