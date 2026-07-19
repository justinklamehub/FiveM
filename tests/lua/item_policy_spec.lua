-- Verifies stable item codes and catalogue normalization without FiveM.
local Policy = dofile('resources/[cnr]/cnr_items/shared/item_policy.lua')

describe('item policy', function()
    it('accepts stable lowercase item codes only', function()
        assert.is_true(Policy.is_code('water_bottle'))
        assert.is_false(Policy.is_code('WaterBottle'))
        assert.is_false(Policy.is_code('../water'))
        assert.is_false(Policy.is_code('x'))
    end)

    it('normalizes numeric and boolean database values', function()
        local definition = Policy.definition({
            definition_uuid = '0190b7a0-6000-7000-8000-000000000001',
            code = 'water_bottle',
            category = 'CONSUMABLE',
            label = 'Water Bottle',
            description = 'Water',
            icon_key = 'water_bottle',
            is_stackable = 1,
            is_unique = 0,
            max_stack = '10',
            unit_weight_grams = '500',
            is_tradeable = 1,
            is_drop_allowed = 1,
            metadata_schema_version = '1',
            version = '1',
        })
        assert.is_true(definition.is_stackable)
        assert.is_false(definition.is_unique)
        assert.are.equal('water_bottle', definition.icon_key)
        assert.are.equal(500, definition.unit_weight_grams)
    end)
end)
