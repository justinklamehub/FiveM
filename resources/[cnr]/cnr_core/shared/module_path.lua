-- Adds the current resource root to Lua's module search path for dotted local imports.
local resource_name = GetCurrentResourceName()
local resource_path = GetResourcePath(resource_name)

if type(resource_path) ~= 'string' or resource_path == '' then
    error(('Unable to resolve resource path for %s'):format(resource_name))
end

local module_patterns = {
    resource_path .. '/?.lua',
    resource_path .. '/?/init.lua',
}

for _, pattern in ipairs(module_patterns) do
    if not package.path:find(pattern, 1, true) then
        package.path = pattern .. ';' .. package.path
    end
end
