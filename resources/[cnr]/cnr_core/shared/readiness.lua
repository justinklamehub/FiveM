-- Models the shared resource readiness lifecycle and immutable status snapshots.
local Readiness = {}
Readiness.__index = Readiness
local valid =
    { starting = true, ready = true, degraded = true, unavailable = true, stopping = true }

---@param resource string
---@param version string
---@param clock? fun(): string
---@return table
function Readiness.new(resource, version, clock)
    return setmetatable({
        resource = resource,
        version = version,
        status = 'starting',
        changed_at = (clock or function()
            return os.date('!%Y-%m-%dT%H:%M:%SZ')
        end)(),
        details = {},
        clock = clock,
    }, Readiness)
end

---@param status string
---@param details? table
---@return boolean, string?
function Readiness:set(status, details)
    if not valid[status] then
        return false, 'invalid_status'
    end
    self.status = status
    self.changed_at = (self.clock or function()
        return os.date('!%Y-%m-%dT%H:%M:%SZ')
    end)()
    self.details = details or {}
    return true
end

---@return table
function Readiness:snapshot()
    return {
        resource = self.resource,
        version = self.version,
        status = self.status,
        changed_at = self.changed_at,
        details = self.details,
    }
end

return Readiness
