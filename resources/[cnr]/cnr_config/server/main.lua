-- Exposes copied static configuration values and the maintenance-mode ConVar.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local status = {
    resource = resource_name,
    version = version,
    status = 'ready',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = { revision = 'static-wave-0' },
}
local function copy(value)
    if type(value) ~= 'table' then
        return value
    end
    local result = {}
    for key, item in pairs(value) do
        result[key] = copy(item)
    end
    return result
end
local function get(path)
    local value = CNR_STATIC_CONFIG
    for segment in path:gmatch('[^.]+') do
        if type(value) ~= 'table' then
            return nil
        end
        value = value[segment]
    end
    return copy(value)
end
exports('get_status', function()
    return status
end)
exports('get', get)
exports('is_maintenance_mode', function()
    return GetConvarInt('cnr_maintenance_mode', 0) == 1
end)
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        status.status = 'stopping'
    end
end)
