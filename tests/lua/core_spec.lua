local ErrorCodes = require('shared.error_codes')
local Correlation = require('shared.correlation')
local Result = require('shared.result')
local Readiness = require('shared.readiness')
local RateLimiter = require('shared.rate_limiter')
local RequestContext = require('shared.request_context')

describe('Wave 0 core contracts', function()
    it('creates a stable success result', function()
        local result = Result.success({ value = 42 }, 'corr-test')
        assert.is_true(result.ok)
        assert.are.equal('corr-test', result.correlation_id)
        assert.are.equal(42, result.data.value)
    end)
    it('normalizes unknown error codes', function()
        local result = Result.failure('UNKNOWN', 'core.error.internal', {}, 'corr-test')
        assert.is_false(result.ok)
        assert.are.equal(ErrorCodes.INTERNAL_ERROR, result.error.code)
        assert.are.equal('corr-test', result.error.correlation_id)
    end)
    it('creates deterministic correlation IDs with injected adapters', function()
        local value = Correlation.create(function()
            return 123
        end, function()
            return 255
        end)
        assert.is_truthy(value:match('^corr%-0000000000123%-%x+%-0000ff$'))
    end)
    it('enforces a fixed-window rate limit', function()
        local now = 100
        local limiter = RateLimiter.new(function()
            return now
        end)
        assert.is_true(limiter:consume('player:1', 2, 1000))
        assert.is_true(limiter:consume('player:1', 2, 1000))
        local allowed, retry = limiter:consume('player:1', 2, 1000)
        assert.is_false(allowed)
        assert.are.equal(1000, retry)
        now = 1100
        assert.is_true(limiter:consume('player:1', 2, 1000))
    end)
    it('builds a non-authoritative request context foundation', function()
        local context = RequestContext.create(12, { request_id = 'req-1', contract_version = 1 }, {
            correlation_id = function()
                return 'corr-test'
            end,
            now = function()
                return '2026-07-16T00:00:00Z'
            end,
        })
        assert.are.equal(12, context.source)
        assert.are.equal('corr-test', context.correlation_id)
        assert.is_nil(context.character_id)
    end)
    it('rejects invalid readiness states', function()
        local readiness = Readiness.new('cnr_test', '0.1.0', function()
            return 'now'
        end)
        local ok = readiness:set('booted')
        assert.is_false(ok)
        assert.are.equal('starting', readiness:snapshot().status)
    end)
end)
