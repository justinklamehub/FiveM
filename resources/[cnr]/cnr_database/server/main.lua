-- Encapsulates oxmysql access and blocks writes until the supported schema is present.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local minimum_schema = GetConvar('cnr_schema_minimum', '20260716000100')
local correlation_counter = 0
local status = {
    resource = resource_name,
    version = version,
    status = 'starting',
    changed_at = '',
    details = {},
}

local function now()
    return os.date('!%Y-%m-%dT%H:%M:%SZ')
end
local function set_status(next_status, details)
    status.status, status.changed_at, status.details = next_status, now(), details or {}
    TriggerEvent('cnr:database:status_changed', status)
end
local function correlation_id()
    correlation_counter = correlation_counter + 1
    return ('db-%d-%06d'):format(GetGameTimer(), correlation_counter % 1000000)
end

local function failure(code, key, details)
    return {
        ok = false,
        error = {
            code = code,
            message_key = key,
            safe_details = details or {},
            correlation_id = correlation_id(),
        },
    }
end
local function success(data)
    return { ok = true, data = data, correlation_id = correlation_id() }
end
local function require_ready()
    if status.status ~= 'ready' then
        return nil,
            failure(
                'DEPENDENCY_UNAVAILABLE',
                'database.error.unavailable',
                { status = status.status }
            )
    end
    return true
end

CreateThread(function()
    local ok, result = pcall(function()
        local rows = MySQL.query.await(
            'SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;'
        )
        return rows and rows[1] and tostring(rows[1].version) or nil
    end)
    if not ok then
        set_status('unavailable', { reason = 'database_or_schema_unavailable' })
    elseif not result or result < minimum_schema then
        set_status(
            'unavailable',
            { reason = 'schema_too_old', minimum = minimum_schema, current = result }
        )
    else
        set_status('ready', { schema_version = result, minimum_schema = minimum_schema })
    end
end)

AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        set_status('stopping')
    end
end)
exports('get_status', function()
    return {
        resource = status.resource,
        version = status.version,
        status = status.status,
        changed_at = status.changed_at,
        details = status.details,
    }
end)
exports('query', function(sql, parameters)
    local ready, err = require_ready()
    if not ready then
        return err
    end
    local ok, rows = pcall(MySQL.query.await, sql, parameters or {})
    if not ok then
        return failure('INTERNAL_ERROR', 'database.error.query_failed')
    end
    return success(rows)
end)
exports('single', function(sql, parameters)
    local ready, err = require_ready()
    if not ready then
        return err
    end
    local ok, row = pcall(MySQL.single.await, sql, parameters or {})
    if not ok then
        return failure('INTERNAL_ERROR', 'database.error.query_failed')
    end
    return success(row)
end)
exports('transaction', function(queries)
    local ready, err = require_ready()
    if not ready then
        return err
    end
    local ok, committed = pcall(MySQL.transaction.await, queries)
    if not ok or not committed then
        return failure('INTERNAL_ERROR', 'database.error.transaction_failed')
    end
    return success({ committed = true })
end)
