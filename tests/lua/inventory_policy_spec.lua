-- Verifies client input, capacity, stack, and unique-item transfer policy without FiveM.
local Policy = dofile('resources/[cnr]/cnr_inventory/shared/inventory_policy.lua')

local function transfer_payload()
    return {
        source_inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
        target_inventory_uuid = '0190b7a0-6000-7000-8000-000000000011',
        source_slot = 1,
        target_slot = 3,
        quantity = 1,
        request_id = 'inventory-transfer-1',
        operation_uuid = '0190b7a0-6000-7000-8000-000000000012',
        contract_version = 5,
    }
end

local function reposition_payload()
    return {
        inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
        source_slot = 1,
        target_slot = 4,
        request_id = 'inventory-reposition-1',
        operation_uuid = '0190b7a0-6000-7000-8000-000000000013',
        contract_version = 5,
    }
end

local function use_payload()
    return {
        inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
        source_slot = 1,
        intent = 'USE',
        request_id = 'inventory-use-1',
        operation_uuid = '0190b7a0-6000-7000-8000-000000000014',
        contract_version = 5,
    }
end

local function plan_context()
    return {
        source_entry = {
            definition_id = 10,
            quantity = 4,
            has_instance = false,
            definition = {
                is_stackable = true,
                is_unique = false,
                max_stack = 10,
                unit_weight_grams = 500,
            },
        },
        target_inventory = { slot_capacity = 4, weight_capacity_grams = 3000 },
        target_entry = nil,
        target_slot = 3,
        target_weight_grams = 0,
        quantity = 2,
    }
end

describe('inventory policy', function()
    it('accepts only the narrow versioned transfer contract', function()
        assert.is_table(Policy.validate_transfer(transfer_payload()))
        local value = transfer_payload()
        value.character_uuid = value.operation_uuid
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_transfer(value)))
        value = transfer_payload()
        value.quantity = 0
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_transfer(value)))
        value = transfer_payload()
        value.target_slot = nil
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_transfer(value)))
    end)

    it('honors the validated destination slot and enforces stack compatibility', function()
        local plan = Policy.transfer_plan(plan_context())
        assert.are.equal('CREATE_STACK', plan.mode)
        assert.are.equal(3, plan.target_slot)
        local value = plan_context()
        value.target_entry = {
            definition_id = 10,
            has_instance = false,
            quantity = 8,
        }
        assert.are.equal('STACK', Policy.transfer_plan(value).mode)
        value.target_entry.quantity = 9
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.transfer_plan(value)))
        value.target_entry = { definition_id = 11, has_instance = false, quantity = 1 }
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.transfer_plan(value)))
    end)

    it('enforces weight, quantity, slots, and unique-instance movement', function()
        local value = plan_context()
        value.target_weight_grams = 2501
        assert.are.equal('INSUFFICIENT_CAPACITY', select(2, Policy.transfer_plan(value)))
        value = plan_context()
        value.quantity = 5
        assert.are.equal('INSUFFICIENT_QUANTITY', select(2, Policy.transfer_plan(value)))
        value = plan_context()
        value.target_slot = 5
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.transfer_plan(value)))
        value = plan_context()
        value.source_entry.definition.is_stackable = false
        value.source_entry.definition.is_unique = true
        value.source_entry.has_instance = true
        value.source_entry.quantity = 1
        value.quantity = 1
        local plan = Policy.transfer_plan(value)
        assert.are.equal('MOVE_INSTANCE', plan.mode)
    end)

    it('allows only the character/personal-storage pair and validates locker distance', function()
        assert.is_true(Policy.is_personal_storage_pair('CHARACTER', 'PERSONAL_STORAGE'))
        assert.is_true(Policy.is_personal_storage_pair('PERSONAL_STORAGE', 'CHARACTER'))
        assert.is_false(Policy.is_personal_storage_pair('CHARACTER', 'CHARACTER'))
        assert.is_false(Policy.is_personal_storage_pair('PERSONAL_STORAGE', 'PERSONAL_STORAGE'))
        assert.is_true(Policy.within_access_radius({ x = 1, y = 2, z = 3 }, {
            x = 1,
            y = 2,
            z = 3,
        }, 4))
        assert.is_false(Policy.within_access_radius({ x = 10, y = 2, z = 3 }, {
            x = 1,
            y = 2,
            z = 3,
        }, 4))
        assert.is_false(Policy.within_access_radius(nil, {}, 4))
    end)

    it('validates narrow reposition intent and plans moves or swaps within capacity', function()
        assert.is_table(Policy.validate_reposition(reposition_payload()))
        local invalid = reposition_payload()
        invalid.character_uuid = invalid.operation_uuid
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_reposition(invalid)))
        invalid = reposition_payload()
        invalid.target_slot = invalid.source_slot
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_reposition(invalid)))

        local context = {
            inventory = { slot_capacity = 24 },
            source_entry = { slot_number = 1 },
            source_slot = 1,
            target_slot = 4,
        }
        local move = Policy.reposition_plan(context)
        assert.are.equal('MOVE', move.mode)
        context.target_entry = { slot_number = 4 }
        local swap = Policy.reposition_plan(context)
        assert.are.equal('SWAP', swap.mode)
        assert.are.equal(25, swap.temporary_slot)
        context.target_slot = 25
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.reposition_plan(context)))
    end)

    it('accepts only narrow item intent and derives effects from server definitions', function()
        assert.is_table(Policy.validate_use(use_payload()))
        local invalid = use_payload()
        invalid.effect = 'DRINK_WATER'
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_use(invalid)))
        invalid = use_payload()
        invalid.intent = 'DELETE'
        assert.are.equal('VALIDATION_ERROR', select(2, Policy.validate_use(invalid)))

        local water = {
            quantity = 2,
            has_instance = false,
            definition = { use_handler = 'consume_water' },
        }
        local drink = Policy.use_plan(water, 'USE')
        assert.are.equal('DRINK', drink.action)
        assert.are.equal('DRINK_WATER', drink.effect)
        assert.are.equal(1, drink.quantity_consumed)

        local document = {
            quantity = 1,
            has_instance = true,
            definition = { use_handler = 'state_id_document' },
        }
        assert.are.equal('INSPECT_ID', Policy.use_plan(document, 'INSPECT').action)
        assert.are.equal('SHOW_ID', Policy.use_plan(document, 'SHOW').action)
        assert.are.equal('PRECONDITION_FAILED', select(2, Policy.use_plan(document, 'USE')))
    end)
end)
