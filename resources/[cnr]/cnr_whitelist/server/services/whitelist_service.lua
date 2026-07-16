-- Produces a server-authoritative whitelist decision from mode and active entry state.
local Policy = require('shared.policy')
local WhitelistRepository = require('server.repositories.whitelist_repository')
local WhitelistService = {}

---@param account_uuid string
---@param correlation_id string
---@return table
function WhitelistService.evaluate(account_uuid, correlation_id)
    local mode = GetConvar('cnr_whitelist_mode', 'open'):lower()
    if not Policy.is_valid_mode(mode) then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'whitelist.error.invalid_mode',
            { mode = mode },
            correlation_id
        )
    end

    local entry, database_error = WhitelistRepository.find_active(account_uuid)
    if database_error then
        return database_error
    end
    local decision = Policy.evaluate(mode, entry ~= nil)
    decision.mode = mode
    decision.entry_uuid = entry and entry.public_uuid or nil
    return exports.cnr_core:create_success_result(decision, correlation_id)
end

return WhitelistService
