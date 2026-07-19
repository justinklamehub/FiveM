-- Verifies dynamic reposition SQL parameter construction without oxmysql or FiveM.
local function load_repository(captured)
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment.exports = {
        cnr_database = {
            transaction = function(_, queries)
                captured.queries = queries
                return { ok = true }
            end,
        },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_inventory/server/repositories/inventory_repository.lua',
            't',
            environment
        )
    )
    return chunk()
end

local function context(mode)
    local value = {
        operation_uuid = '0190b7a0-6200-7000-8000-000000000001',
        account_uuid = '0190b7a0-6200-7000-8000-000000000002',
        session_uuid = '0190b7a0-6200-7000-8000-000000000003',
        character_uuid = '0190b7a0-6200-7000-8000-000000000004',
        inventory = {
            id = 1,
            inventory_uuid = '0190b7a0-6200-7000-8000-000000000005',
            version = 3,
            slot_capacity = 24,
        },
        source_entry = {
            id = 10,
            entry_uuid = '0190b7a0-6200-7000-8000-000000000006',
            definition_id = 2,
            item_instance_id = nil,
            slot_number = 1,
            version = 4,
            quantity = 2,
        },
        request_id = 'inventory-reposition-repository-1',
        correlation_id = 'inventory-reposition-correlation-1',
        contract_version = 2,
        payload_sha256 = string.rep('a', 64),
        plan = { mode = mode, source_slot = 1, target_slot = 4 },
    }
    if mode == 'SWAP' then
        value.plan.temporary_slot = 25
        value.source_entry.item_instance_id = 12
        value.source_entry.quantity = 1
        value.target_entry = {
            id = 11,
            entry_uuid = '0190b7a0-6200-7000-8000-000000000007',
            slot_number = 4,
            version = 5,
        }
    end
    return value
end

local function placeholder_count(query)
    local _, count = query:gsub('%?', '')
    return count
end

describe('inventory repository reposition transaction', function()
    for _, mode in ipairs({ 'MOVE', 'SWAP' }) do
        it('matches every dynamic SQL placeholder for ' .. mode, function()
            local captured = {}
            local repository = load_repository(captured)
            local result = repository.reposition(context(mode))
            assert.is_true(result.ok)
            local operation = captured.queries[3]
            assert.are.equal(placeholder_count(operation.query), #operation.values)
            assert.is_truthy(operation.query:find("'REPOSITION'", 1, true))
            if mode == 'SWAP' then
                assert.are.equal(7, #captured.queries)
            else
                assert.are.equal(5, #captured.queries)
            end
        end)
    end
end)
