-- Converts account and whitelist states into a connection access state.
local AccessPolicy = {}

---@param account_status string
---@param whitelist table
---@return table
function AccessPolicy.evaluate(account_status, whitelist)
    if account_status == 'PENDING_REGISTRATION' then
        return { allowed = true, access_state = 'ONBOARDING' }
    end
    if account_status == 'PENDING_WHITELIST' then
        if whitelist.mode == 'hybrid' then
            return { allowed = true, access_state = 'LIMITED' }
        end
        return { allowed = false, code = 'WHITELIST_REQUIRED' }
    end
    if account_status ~= 'ACTIVE' then
        return { allowed = false, code = 'ACCOUNT_RESTRICTED' }
    end
    if not whitelist.allowed then
        return { allowed = false, code = 'WHITELIST_REQUIRED' }
    end
    return {
        allowed = true,
        access_state = whitelist.limited and 'LIMITED' or 'FULL',
    }
end

return AccessPolicy
