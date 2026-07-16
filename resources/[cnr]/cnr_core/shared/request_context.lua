-- Builds a server-owned request context from a non-authoritative client envelope.
local Correlation = require('shared.correlation')
local RequestContext = {}

---@param source integer
---@param request table
---@param adapters? table
---@return table
function RequestContext.create(source, request, adapters)
    adapters = adapters or {}
    local correlation_id = request.correlation_id
        or (adapters.correlation_id and adapters.correlation_id())
        or Correlation.create()
    local now = adapters.now and adapters.now() or os.date('!%Y-%m-%dT%H:%M:%SZ')
    return {
        source = source,
        request_id = request.request_id,
        operation_uuid = request.operation_uuid,
        contract_version = request.contract_version,
        correlation_id = correlation_id,
        server_time = now,
        account_id = nil,
        session_id = nil,
        character_id = nil,
        routing_bucket = nil,
    }
end

return RequestContext
