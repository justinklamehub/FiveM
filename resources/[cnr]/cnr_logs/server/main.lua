-- Emits structured JSON application and audit records to the FXServer output.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
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
local function set_status(value)
    status.status, status.changed_at = value, now()
end
local function emit(channel, level, module, operation, fields)
    local record = {
        timestamp = now(),
        channel = channel,
        level = level,
        module = module,
        operation = operation,
        fields = fields or {},
    }
    print(json.encode(record))
    return record
end
set_status('ready')
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        set_status('stopping')
    end
end)
exports('get_status', function()
    return status
end)
exports('log', function(level, module, operation, fields)
    return emit('application', level, module, operation, fields)
end)
exports('audit', function(module, operation, fields)
    return emit('audit', 'info', module, operation, fields)
end)
