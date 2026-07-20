-- Verifies that inventory authority is resolved from the FULL session and spawned character.
local policy = dofile('resources/[cnr]/cnr_inventory/shared/inventory_policy.lua')

local function error_result(code, key, details, correlation_id)
    return {
        ok = false,
        error = {
            code = code,
            message_key = key,
            safe_details = details,
            correlation_id = correlation_id,
        },
    }
end

local function load_service(repository, session, character_result, player_coordinates)
    local environment = {}
    setmetatable(environment, { __index = _G })
    environment.require = function(name)
        if name == 'shared.inventory_policy' then
            return policy
        end
        if name == 'server.repositories.inventory_repository' then
            return repository
        end
        error('unexpected module: ' .. name)
    end
    environment.GetConvarInt = function(_, default)
        return default
    end
    environment.GetConvar = function(_, default)
        return default
    end
    environment.GetPlayerPed = function()
        return 1
    end
    environment.GetEntityCoords = function()
        return player_coordinates or { x = 215.76, y = -810.12, z = 30.73 }
    end
    environment.GetPlayers = function()
        return {}
    end
    environment.exports = {
        cnr_sessions = {
            get_session_for_source = function()
                return session
            end,
        },
        cnr_characters = {
            active_character_for_source = function()
                return character_result
            end,
        },
        cnr_core = {
            create_uuid_v7 = function()
                return '0190b7a0-6000-7000-8000-000000000099'
            end,
            create_error_result = function(_, code, key, details, correlation_id)
                return error_result(code, key, details, correlation_id)
            end,
            create_success_result = function(_, data, correlation_id)
                return { ok = true, data = data, correlation_id = correlation_id }
            end,
        },
        cnr_logs = {
            audit = function() end,
        },
    }
    local chunk = assert(
        loadfile(
            'resources/[cnr]/cnr_inventory/server/services/inventory_service.lua',
            't',
            environment
        )
    )
    return chunk()
end

local function inventory_row(inventory_uuid, inventory_type)
    return {
        id = inventory_type == 'CHARACTER' and 1 or 2,
        inventory_uuid = inventory_uuid,
        owner_character_uuid = 'character-1',
        inventory_type = inventory_type,
        slot_capacity = inventory_type == 'CHARACTER' and 24 or 48,
        weight_capacity_grams = inventory_type == 'CHARACTER' and 30000 or 100000,
        current_weight_grams = 0,
        version = 1,
        status = 'ACTIVE',
    }
end

local read = { request_id = 'inventory-read-1', contract_version = 5 }
local transfer = {
    source_inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
    target_inventory_uuid = '0190b7a0-6000-7000-8000-000000000011',
    source_slot = 1,
    target_slot = 4,
    quantity = 1,
    request_id = 'inventory-transfer-1',
    operation_uuid = '0190b7a0-6000-7000-8000-000000000012',
    contract_version = 5,
}
local reposition = {
    inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
    source_slot = 1,
    target_slot = 4,
    request_id = 'inventory-reposition-1',
    operation_uuid = '0190b7a0-6000-7000-8000-000000000013',
    contract_version = 5,
}
local use_item = {
    inventory_uuid = '0190b7a0-6000-7000-8000-000000000010',
    source_slot = 1,
    intent = 'USE',
    request_id = 'inventory-use-1',
    operation_uuid = '0190b7a0-6000-7000-8000-000000000014',
    contract_version = 5,
}

describe('inventory service authority', function()
    it('rejects missing and LIMITED sessions before database access', function()
        local missing = load_service({}, nil, nil).snapshot(12, read, 'correlation-missing')
        assert.is_false(missing.ok)
        assert.are.equal('AUTHENTICATION_REQUIRED', missing.error.code)

        local limited = load_service({}, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'LIMITED',
        }, nil).snapshot(12, read, 'correlation-limited')
        assert.is_false(limited.ok)
        assert.are.equal('PRECONDITION_FAILED', limited.error.code)
    end)

    it('requires the character resource to resolve a spawned character', function()
        local result = load_service({}, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, error_result(
            'CHARACTER_REQUIRED',
            'character.required',
            {},
            'character-correlation'
        )).snapshot(12, read, 'correlation-character')
        assert.is_false(result.ok)
        assert.are.equal('CHARACTER_REQUIRED', result.error.code)
    end)

    it('rejects inventory UUIDs not owned by the source-bound character', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('a', 64) }
            end,
            transaction = function()
                return nil
            end,
            find_owned = function()
                return nil
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).transfer(12, transfer, 'correlation-foreign')
        assert.is_false(result.ok)
        assert.are.equal('NOT_FOUND', result.error.code)
    end)

    it('rejects a reused reposition operation with changed semantic content', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('b', 64) }
            end,
            transaction = function()
                return {
                    action = 'REPOSITION',
                    account_uuid = 'account-1',
                    character_uuid = 'character-1',
                    payload_sha256 = string.rep('a', 64),
                }
            end,
            find_owned = function()
                return inventory_row(reposition.inventory_uuid, 'CHARACTER')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).reposition(12, reposition, 'correlation-reposition')
        assert.is_false(result.ok)
        assert.are.equal('CONFLICT', result.error.code)
    end)

    it('returns the stored result for an identical reposition operation', function()
        local hash = string.rep('a', 64)
        local repository = {
            payload_hash = function()
                return { payload_sha256 = hash }
            end,
            transaction = function()
                return {
                    operation_uuid = reposition.operation_uuid,
                    action = 'REPOSITION',
                    account_uuid = 'account-1',
                    character_uuid = 'character-1',
                    payload_sha256 = hash,
                    result_target_version = 4,
                    source_slot = 1,
                    target_slot = 4,
                    reposition_mode = 'MOVE',
                }
            end,
            find_owned = function()
                return inventory_row(reposition.inventory_uuid, 'CHARACTER')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).reposition(12, reposition, 'correlation-repeated')
        assert.is_true(result.ok)
        assert.is_true(result.data.repeated)
        assert.are.equal(4, result.data.inventory_version)
        assert.are.equal('MOVE', result.data.mode)
    end)

    it('requires server-verified locker proximity before a cross-inventory transfer', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('a', 64) }
            end,
            transaction = function()
                return nil
            end,
            find_owned = function(_, inventory_uuid)
                if inventory_uuid == transfer.source_inventory_uuid then
                    return inventory_row(inventory_uuid, 'CHARACTER')
                end
                return inventory_row(inventory_uuid, 'PERSONAL_STORAGE')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }, { x = 500.0, y = 500.0, z = 30.0 }).transfer(
            12,
            transfer,
            'correlation-storage-distance'
        )
        assert.is_false(result.ok)
        assert.are.equal('PRECONDITION_FAILED', result.error.code)
    end)

    it('validates and commits the destination slot selected by direct drag/drop', function()
        local captured
        local repository = {
            payload_hash = function(parts)
                assert.are.equal(4, parts[5])
                assert.are.equal(5, parts[7])
                return { payload_sha256 = string.rep('a', 64) }
            end,
            transaction = function()
                return nil
            end,
            find_owned = function(_, inventory_uuid)
                if inventory_uuid == transfer.source_inventory_uuid then
                    return inventory_row(inventory_uuid, 'CHARACTER')
                end
                return inventory_row(inventory_uuid, 'PERSONAL_STORAGE')
            end,
            entries = function(inventory_id)
                if inventory_id == 2 then
                    return {}
                end
                return {
                    {
                        id = 10,
                        entry_uuid = '0190b7a0-6000-7000-8000-000000000020',
                        slot_number = 1,
                        quantity = 2,
                        version = 1,
                        definition_id = 3,
                        has_instance = false,
                        definition_uuid = '0190b7a0-6000-7000-8000-000000000021',
                        code = 'sandwich',
                        category = 'CONSUMABLE',
                        label = 'Sandwich',
                        description = 'A wrapped sandwich.',
                        icon_key = 'sandwich',
                        is_stackable = true,
                        is_unique = false,
                        max_stack = 10,
                        unit_weight_grams = 250,
                        definition_version = 1,
                    },
                }
            end,
            transfer = function(context)
                captured = context
                return { ok = true }
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).transfer(12, transfer, 'correlation-direct-drop')
        assert.is_true(result.ok)
        assert.are.equal(4, result.data.target_slot)
        assert.are.equal(4, captured.plan.target_slot)
        assert.are.equal('CREATE_STACK', captured.plan.mode)
    end)

    it('rejects operation UUID reuse when the destination slot changes', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('b', 64) }
            end,
            transaction = function()
                return {
                    action = 'TRANSFER',
                    account_uuid = 'account-1',
                    character_uuid = 'character-1',
                    payload_sha256 = string.rep('a', 64),
                }
            end,
            find_owned = function(_, inventory_uuid)
                if inventory_uuid == transfer.source_inventory_uuid then
                    return inventory_row(inventory_uuid, 'CHARACTER')
                end
                return inventory_row(inventory_uuid, 'PERSONAL_STORAGE')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).transfer(12, transfer, 'correlation-transfer-conflict')
        assert.is_false(result.ok)
        assert.are.equal('CONFLICT', result.error.code)
    end)

    it('replays the stored server-validated transfer placement', function()
        local hash = string.rep('a', 64)
        local repository = {
            payload_hash = function()
                return { payload_sha256 = hash }
            end,
            transaction = function()
                return {
                    operation_uuid = transfer.operation_uuid,
                    action = 'TRANSFER',
                    account_uuid = 'account-1',
                    character_uuid = 'character-1',
                    payload_sha256 = hash,
                    source_slot = 1,
                    target_slot = 4,
                    target_entry_uuid = '0190b7a0-6000-7000-8000-000000000014',
                    quantity = 1,
                    transfer_mode = 'CREATE_STACK',
                    result_source_version = 2,
                    result_target_version = 3,
                }
            end,
            find_owned = function(_, inventory_uuid)
                if inventory_uuid == transfer.source_inventory_uuid then
                    return inventory_row(inventory_uuid, 'CHARACTER')
                end
                return inventory_row(inventory_uuid, 'PERSONAL_STORAGE')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).transfer(12, transfer, 'correlation-transfer-repeated')
        assert.is_true(result.ok)
        assert.is_true(result.data.repeated)
        assert.are.equal(4, result.data.target_slot)
        assert.are.equal('CREATE_STACK', result.data.mode)
        assert.are.equal(3, result.data.target_version)
    end)

    it('consumes exactly one server-defined item and records the selected slot', function()
        local captured
        local repository = {
            payload_hash = function(parts)
                assert.are.equal('USE_ITEM', parts[1])
                assert.are.equal('USE', parts[4])
                return { payload_sha256 = string.rep('a', 64) }
            end,
            transaction = function()
                return nil
            end,
            find_owned = function()
                return inventory_row(use_item.inventory_uuid, 'CHARACTER')
            end,
            entries = function()
                return {
                    {
                        id = 10,
                        entry_uuid = '0190b7a0-6000-7000-8000-000000000020',
                        slot_number = 1,
                        quantity = 2,
                        version = 1,
                        definition_id = 3,
                        has_instance = false,
                        definition_uuid = '0190b7a0-6000-7000-8000-000000000021',
                        code = 'water_bottle',
                        category = 'CONSUMABLE',
                        label = 'Water Bottle',
                        description = 'A sealed bottle.',
                        icon_key = 'water_bottle',
                        use_handler = 'consume_water',
                        is_stackable = true,
                        is_unique = false,
                        max_stack = 10,
                        unit_weight_grams = 500,
                        definition_version = 1,
                    },
                }
            end,
            use_item = function(context)
                captured = context
                return { ok = true }
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).use_item(12, use_item, 'correlation-use')
        assert.is_true(result.ok)
        assert.are.equal(1, result.data.quantity_consumed)
        assert.are.equal('DRINK_WATER', result.data.effect)
        assert.are.equal('DRINK', captured.plan.action)
    end)

    it('rejects a reused item-use operation with changed intent', function()
        local repository = {
            payload_hash = function()
                return { payload_sha256 = string.rep('b', 64) }
            end,
            transaction = function()
                return {
                    action = 'USE_ITEM',
                    account_uuid = 'account-1',
                    character_uuid = 'character-1',
                    payload_sha256 = string.rep('a', 64),
                }
            end,
            find_owned = function()
                return inventory_row(use_item.inventory_uuid, 'CHARACTER')
            end,
        }
        local result = load_service(repository, {
            account_uuid = 'account-1',
            session_uuid = 'session-1',
            access_state = 'FULL',
        }, {
            ok = true,
            data = {
                character_uuid = 'character-1',
                binding_uuid = 'binding-1',
                state_document_uuid = 'document-1',
            },
        }).use_item(12, use_item, 'correlation-use-conflict')
        assert.is_false(result.ok)
        assert.are.equal('CONFLICT', result.error.code)
    end)
end)
