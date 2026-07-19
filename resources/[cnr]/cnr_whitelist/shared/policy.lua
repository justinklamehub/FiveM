-- Evaluates the configured whitelist mode without performing database or FiveM operations.
local Policy = {}
local valid_modes = { open = true, automatic = true, manual = true, hybrid = true }

---@param mode string
---@return boolean
function Policy.is_valid_mode(mode)
    return valid_modes[mode] == true
end

---@param mode string
---@param has_entry boolean
---@return table
function Policy.evaluate(mode, has_entry)
    if mode == 'manual' then
        return { allowed = has_entry, limited = false }
    end
    if mode == 'hybrid' then
        return { allowed = true, limited = not has_entry }
    end
    return { allowed = true, limited = false }
end

return Policy
