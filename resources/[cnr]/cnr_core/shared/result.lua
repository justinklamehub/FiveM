-- Builds the standardized success and failure result envelopes.
local ErrorCodes = require('shared.error_codes')
local Correlation = require('shared.correlation')
local Result = {}

---@generic T
---@param data T
---@param correlation_id? string
---@return table
function Result.success(data, correlation_id)
    return { ok = true, data = data, correlation_id = correlation_id or Correlation.create() }
end

---@param code string
---@param message_key string
---@param safe_details? table
---@param correlation_id? string
---@return table
function Result.failure(code, message_key, safe_details, correlation_id)
    if not ErrorCodes[code] then
        code = ErrorCodes.INTERNAL_ERROR
    end
    local id = correlation_id or Correlation.create()
    return {
        ok = false,
        error = {
            code = code,
            message_key = message_key,
            safe_details = safe_details or {},
            correlation_id = id,
        },
    }
end

return Result
