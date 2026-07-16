-- Verifies resource-local module loading without Lua's package library.
local loader_path = 'resources/[cnr]/cnr_core/shared/module_path.lua'

local function create_environment(module_source)
    local reads = 0
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment._G = environment
    environment.package = nil
    environment.GetCurrentResourceName = function()
        return 'cnr_test'
    end
    environment.LoadResourceFile = function(resource_name, module_path)
        assert.are.equal('cnr_test', resource_name)
        assert.are.equal('shared/example.lua', module_path)
        reads = reads + 1
        return module_source
    end
    environment.require = function(module_name)
        error(('Unexpected native require fallback for %s'):format(module_name))
    end

    local loader = assert(loadfile(loader_path, 't', environment))
    loader()
    return environment, function()
        return reads
    end
end

describe('FiveM resource module loader', function()
    it('loads and caches modules when package is unavailable', function()
        local environment, read_count = create_environment('return { value = 42 }')

        local first = environment.require('shared.example')
        local second = environment.require('shared.example')

        assert.are.equal(42, first.value)
        assert.is_true(rawequal(first, second))
        assert.are.equal(1, read_count())
    end)

    it('rejects traversal and malformed module names', function()
        local environment = create_environment('return true')

        assert.has_error(function()
            environment.require('../secret')
        end)
        assert.has_error(function()
            environment.require('shared..secret')
        end)
    end)
end)
