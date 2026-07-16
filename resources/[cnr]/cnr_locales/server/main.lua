-- Resolves localized technical messages without exposing mutable dictionaries.
local resource_name = GetCurrentResourceName()
local version = GetResourceMetadata(resource_name, 'version', 0) or '0.0.0'
local dictionaries = { de = CNR_LOCALE_DE, en = CNR_LOCALE_EN }
local status = {
    resource = resource_name,
    version = version,
    status = 'ready',
    changed_at = os.date('!%Y-%m-%dT%H:%M:%SZ'),
    details = { default_locale = 'de' },
}
local function interpolate(value, parameters)
    for key, replacement in pairs(parameters or {}) do
        value = value:gsub('{' .. key .. '}', tostring(replacement))
    end
    return value
end
exports('get_status', function()
    return status
end)
exports('translate', function(key, locale, parameters)
    local selected = dictionaries[locale] or dictionaries.de
    return interpolate(selected[key] or dictionaries.de[key] or key, parameters)
end)
AddEventHandler('onResourceStop', function(stopped)
    if stopped == resource_name then
        status.status = 'stopping'
    end
end)
