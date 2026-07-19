-- Exposes normalized, read-only item definitions to trusted server resources.
local Policy = require('shared.item_policy')
local Repository = require('server.repositories.item_repository')
local Service = {}

local function failure(code, key, correlation_id)
    return exports.cnr_core:create_error_result(code, key, {}, correlation_id)
end

function Service.list(correlation_id)
    local rows, database_error = Repository.list_active()
    if database_error then
        return database_error
    end
    local definitions = {}
    for _, row in ipairs(rows) do
        definitions[#definitions + 1] = Policy.definition(row)
    end
    return exports.cnr_core:create_success_result({ definitions = definitions }, correlation_id)
end

function Service.find(code, correlation_id)
    if not Policy.is_code(code) then
        return failure('VALIDATION_ERROR', 'items.error.invalid_code', correlation_id)
    end
    local row, database_error = Repository.find_active(code)
    if database_error then
        return database_error
    end
    if not row then
        return failure('NOT_FOUND', 'items.error.not_found', correlation_id)
    end
    return exports.cnr_core:create_success_result(Policy.definition(row), correlation_id)
end

return Service
