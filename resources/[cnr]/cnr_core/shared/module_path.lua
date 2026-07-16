-- Provides resource-local module loading without relying on Lua's package library.
local resource_name = GetCurrentResourceName()
local native_require = rawget(_G, 'require')
local loaded_modules = {}
local loading_modules = {}

local function module_to_path(module_name)
    if type(module_name) ~= 'string' or module_name == '' then
        error('CNR module names must be non-empty strings.', 3)
    end

    local starts_with_dot = module_name:sub(1, 1) == '.'
    local ends_with_dot = module_name:sub(-1) == '.'
    local has_empty_segment = module_name:find('..', 1, true) ~= nil
    local has_unsafe_character = module_name:find('[^%w_%.]') ~= nil

    if starts_with_dot or ends_with_dot or has_empty_segment or has_unsafe_character then
        error(('Invalid CNR module name: %s'):format(module_name), 3)
    end

    return module_name:gsub('%.', '/') .. '.lua'
end

local function read_module(module_path)
    if type(LoadResourceFile) == 'function' then
        local source = LoadResourceFile(resource_name, module_path)
        if source then
            return source
        end
    end

    if io and type(io.open) == 'function' then
        local file = io.open(('@%s/%s'):format(resource_name, module_path), 'r')
        if file then
            local source = file:read('*a')
            file:close()
            return source
        end
    end

    return nil
end

local function require_resource_module(module_name)
    if loaded_modules[module_name] ~= nil then
        return loaded_modules[module_name]
    end

    if loading_modules[module_name] then
        error(('Circular CNR module dependency detected: %s'):format(module_name), 2)
    end

    local module_path = module_to_path(module_name)
    local source = read_module(module_path)
    if not source then
        if type(native_require) == 'function' then
            return native_require(module_name)
        end
        error(('CNR module %s was not found in resource %s.'):format(module_name, resource_name), 2)
    end

    loading_modules[module_name] = true
    local chunk, compile_error =
        load(source, ('@%s/%s'):format(resource_name, module_path), 't', _ENV)
    if not chunk then
        loading_modules[module_name] = nil
        error(('Unable to compile CNR module %s: %s'):format(module_name, compile_error), 2)
    end

    local ok, result = pcall(chunk)
    loading_modules[module_name] = nil
    if not ok then
        error(result, 0)
    end

    if result == nil then
        result = true
    end
    loaded_modules[module_name] = result
    return result
end

_G.CNRRequire = require_resource_module
_G.require = require_resource_module
