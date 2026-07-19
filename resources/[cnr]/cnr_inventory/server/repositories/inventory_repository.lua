-- Owns personal-inventory persistence, idempotency records, and atomic transfers.
local Repository = {}
local uuid = [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))]]

local function single(sql, values)
    local result = exports.cnr_database:single(sql, values or {})
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.ensure_character_inventory(character_uuid, inventory_uuid, slots, weight_grams)
    local result = exports.cnr_database:query(
        [[INSERT IGNORE INTO cnr_inventories
        (public_uuid, owner_character_uuid, inventory_type, slot_capacity,
        weight_capacity_grams, version, status, created_at, updated_at)
        VALUES (UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),'CHARACTER',?,?,1,
        'ACTIVE',UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
        { inventory_uuid, character_uuid, slots, weight_grams }
    )
    if not result.ok then
        return nil, result
    end
    return Repository.find_character_inventory(character_uuid)
end

function Repository.ensure_personal_storage(character_uuid, inventory_uuid, slots, weight_grams)
    local result = exports.cnr_database:query(
        [[INSERT IGNORE INTO cnr_inventories
        (public_uuid, owner_character_uuid, inventory_type, slot_capacity,
        weight_capacity_grams, version, status, created_at, updated_at)
        VALUES (UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),'PERSONAL_STORAGE',?,?,1,
        'ACTIVE',UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
        { inventory_uuid, character_uuid, slots, weight_grams }
    )
    if not result.ok then
        return nil, result
    end
    return Repository.find_personal_storage(character_uuid)
end

function Repository.find_owned(character_uuid, inventory_uuid)
    return single(
        ([[SELECT i.id, %s inventory_uuid, %s owner_character_uuid, i.inventory_type,
        i.slot_capacity, i.weight_capacity_grams, i.version, i.status,
        (SELECT COALESCE(SUM(ii.quantity*d.unit_weight_grams),0)
        FROM cnr_inventory_items ii INNER JOIN cnr_item_definitions d ON d.id=ii.definition_id
        WHERE ii.inventory_id=i.id) current_weight_grams
        FROM cnr_inventories i
        WHERE i.public_uuid=UNHEX(REPLACE(?,'-',''))
        AND i.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        LIMIT 1]]):format(
            uuid:format('i.public_uuid'),
            uuid:format('i.owner_character_uuid')
        ),
        { inventory_uuid, character_uuid }
    )
end

function Repository.find_character_inventory(character_uuid)
    return single(
        ([[SELECT i.id, %s inventory_uuid, %s owner_character_uuid, i.inventory_type,
        i.slot_capacity, i.weight_capacity_grams, i.version, i.status,
        (SELECT COALESCE(SUM(ii.quantity*d.unit_weight_grams),0)
        FROM cnr_inventory_items ii INNER JOIN cnr_item_definitions d ON d.id=ii.definition_id
        WHERE ii.inventory_id=i.id) current_weight_grams
        FROM cnr_inventories i
        WHERE i.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        AND i.inventory_type='CHARACTER' LIMIT 1]]):format(
            uuid:format('i.public_uuid'),
            uuid:format('i.owner_character_uuid')
        ),
        { character_uuid }
    )
end

function Repository.find_personal_storage(character_uuid)
    return single(
        ([[SELECT i.id, %s inventory_uuid, %s owner_character_uuid, i.inventory_type,
        i.slot_capacity, i.weight_capacity_grams, i.version, i.status,
        (SELECT COALESCE(SUM(ii.quantity*d.unit_weight_grams),0)
        FROM cnr_inventory_items ii INNER JOIN cnr_item_definitions d ON d.id=ii.definition_id
        WHERE ii.inventory_id=i.id) current_weight_grams
        FROM cnr_inventories i
        WHERE i.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        AND i.inventory_type='PERSONAL_STORAGE' LIMIT 1]]):format(
            uuid:format('i.public_uuid'),
            uuid:format('i.owner_character_uuid')
        ),
        { character_uuid }
    )
end

function Repository.entries(inventory_id)
    local result = exports.cnr_database:query(
        ([[SELECT ii.id, %s entry_uuid, ii.slot_number, ii.quantity, ii.version,
        d.id definition_id, %s definition_uuid, d.code, d.category, d.label, d.description,
        d.icon_key,
        d.is_stackable, d.is_unique, d.max_stack, d.unit_weight_grams, d.version definition_version,
        inst.id item_instance_id, CASE WHEN inst.id IS NULL THEN 0 ELSE 1 END has_instance
        FROM cnr_inventory_items ii
        INNER JOIN cnr_item_definitions d ON d.id=ii.definition_id
        LEFT JOIN cnr_item_instances inst ON inst.id=ii.item_instance_id
        WHERE ii.inventory_id=? ORDER BY ii.slot_number]]):format(
            uuid:format('ii.public_uuid'),
            uuid:format('d.public_uuid')
        ),
        { inventory_id }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.starter_transaction(character_uuid)
    return single(
        ([[SELECT %s operation_uuid, result_target_version
        FROM cnr_item_transactions WHERE action='PROVISION_STARTER'
        AND character_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('operation_uuid')
        ),
        { character_uuid }
    )
end

function Repository.transaction(operation_uuid)
    return single(
        ([[SELECT %s operation_uuid, action, %s account_uuid, %s session_uuid,
        %s character_uuid, %s target_entry_uuid, LOWER(HEX(payload_sha256)) payload_sha256,
        source_slot, target_slot, transfer_mode, quantity,
        CASE WHEN target_entry_uuid IS NULL THEN 'MOVE' ELSE 'SWAP' END reposition_mode,
        result_source_version, result_target_version, result_status
        FROM cnr_item_transactions WHERE operation_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('operation_uuid'),
            uuid:format('account_uuid'),
            uuid:format('session_uuid'),
            uuid:format('character_uuid'),
            uuid:format('target_entry_uuid')
        ),
        { operation_uuid }
    )
end

function Repository.payload_hash(parts)
    return single([[SELECT LOWER(SHA2(?,256)) payload_sha256]], { table.concat(parts, '|') })
end

function Repository.starter_definitions()
    local result = exports.cnr_database:query([[SELECT id, code FROM cnr_item_definitions
        WHERE code IN ('water_bottle','sandwich','state_id') AND status='ACTIVE']])
    if not result.ok then
        return nil, result
    end
    local definitions = {}
    for _, row in ipairs(result.data) do
        definitions[row.code] = tonumber(row.id)
    end
    return definitions
end

function Repository.provision_starter(context)
    local definitions, definitions_error = Repository.starter_definitions()
    if definitions_error then
        return definitions_error
    end
    if not definitions.water_bottle or not definitions.sandwich or not definitions.state_id then
        return exports.cnr_core:create_error_result(
            'DEPENDENCY_UNAVAILABLE',
            'inventory.error.starter_definitions_missing',
            {},
            context.correlation_id
        )
    end
    return exports.cnr_database:transaction({
        {
            query = [[SELECT id FROM cnr_inventories WHERE id=? FOR UPDATE]],
            values = { context.inventory.id },
        },
        {
            query = [[INSERT INTO cnr_inventory_items
            (public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
            version, created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,?,NULL,1,2,1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))
            ON DUPLICATE KEY UPDATE public_uuid=public_uuid]],
            values = { context.water_entry_uuid, context.inventory.id, definitions.water_bottle },
        },
        {
            query = [[INSERT INTO cnr_inventory_items
            (public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
            version, created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,?,NULL,2,2,1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))
            ON DUPLICATE KEY UPDATE public_uuid=public_uuid]],
            values = { context.food_entry_uuid, context.inventory.id, definitions.sandwich },
        },
        {
            query = [[INSERT INTO cnr_item_instances
            (public_uuid, definition_id, reference_type, reference_uuid, status, version,
            created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,'CHARACTER_DOCUMENT',UNHEX(REPLACE(?,'-','')),
            'ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))
            ON DUPLICATE KEY UPDATE public_uuid=public_uuid]],
            values = {
                context.document_instance_uuid,
                definitions.state_id,
                context.state_document_uuid,
            },
        },
        {
            query = [[INSERT INTO cnr_inventory_items
            (public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
            version, created_at, updated_at)
            SELECT UNHEX(REPLACE(?,'-','')),?,?,inst.id,3,1,1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6)
            FROM cnr_item_instances inst WHERE inst.reference_type='CHARACTER_DOCUMENT'
            AND inst.reference_uuid=UNHEX(REPLACE(?,'-',''))
            ON DUPLICATE KEY UPDATE public_uuid=cnr_inventory_items.public_uuid]],
            values = {
                context.document_entry_uuid,
                context.inventory.id,
                definitions.state_id,
                context.state_document_uuid,
            },
        },
        {
            query = [[UPDATE cnr_inventories SET version=version+1, updated_at=UTC_TIMESTAMP(6)
            WHERE id=? AND version=? AND status='ACTIVE']],
            values = { context.inventory.id, context.inventory.version },
        },
        {
            query = [[INSERT INTO cnr_item_transactions
            (operation_uuid, action, account_uuid, session_uuid, character_uuid,
            source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
            definition_id, item_instance_id, quantity, request_id, correlation_id,
            contract_version, payload_sha256, result_source_version, result_target_version,
            result_status, created_at, completed_at)
            VALUES (UNHEX(REPLACE(?,'-','')),'PROVISION_STARTER',UNHEX(REPLACE(?,'-','')),
            UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),NULL,?,NULL,NULL,NULL,NULL,5,?,?,?,
            UNHEX(?),COALESCE((SELECT version FROM cnr_inventories WHERE id=? AND version=?),0),
            COALESCE((SELECT version FROM cnr_inventories WHERE id=? AND version=?),0),
            'COMPLETED',UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = {
                context.operation_uuid,
                context.account_uuid,
                context.session_uuid,
                context.character_uuid,
                context.inventory.id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.payload_sha256,
                context.inventory.id,
                context.inventory.version + 1,
                context.inventory.id,
                context.inventory.version + 1,
            },
        },
    })
end

local function transfer_guard(context)
    local instance_guard = 'AND si.item_instance_id IS NULL '
    local instance_values = {}
    if context.source_entry.item_instance_id then
        instance_guard = 'AND si.item_instance_id=? '
        instance_values[1] = context.source_entry.item_instance_id
    end
    local target_guard
    local target_values
    if context.target_entry then
        target_guard = [[AND EXISTS (SELECT 1 FROM cnr_inventory_items ti
        WHERE ti.id=? AND ti.inventory_id=t.id AND ti.version=? AND ti.quantity=?
        AND ti.definition_id=? AND ti.item_instance_id IS NULL
        AND ti.quantity+?<=?) ]]
        target_values = {
            context.target_entry.id,
            context.target_entry.version,
            context.target_entry.quantity,
            context.source_entry.definition_id,
            context.quantity,
            context.source_entry.definition.max_stack,
        }
    else
        target_guard = [[AND NOT EXISTS (SELECT 1 FROM cnr_inventory_items ti
        WHERE ti.inventory_id=t.id AND ti.slot_number=?) ]]
        target_values = { context.plan.target_slot }
    end
    local sql = ([[COALESCE((SELECT s.version+1 FROM cnr_inventories s
    INNER JOIN cnr_inventories t ON t.id=?
    INNER JOIN cnr_inventory_items si ON si.inventory_id=s.id
    WHERE s.id=? AND s.version=? AND t.version=? AND s.status='ACTIVE' AND t.status='ACTIVE'
    AND s.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
    AND t.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
    AND si.id=? AND si.version=? AND si.quantity=? AND si.definition_id=? %s
    AND (SELECT COALESCE(SUM(x.quantity*d.unit_weight_grams),0)
    FROM cnr_inventory_items x INNER JOIN cnr_item_definitions d ON d.id=x.definition_id
    WHERE x.inventory_id=t.id)+?<=t.weight_capacity_grams %s LIMIT 1),0)]]):format(
        instance_guard,
        target_guard
    )
    local values = {
        context.target_inventory.id,
        context.source_inventory.id,
        context.source_inventory.version,
        context.target_inventory.version,
        context.character_uuid,
        context.character_uuid,
        context.source_entry.id,
        context.source_entry.version,
        context.source_entry.quantity,
        context.source_entry.definition_id,
    }
    for _, value in ipairs(instance_values) do
        values[#values + 1] = value
    end
    values[#values + 1] = context.quantity * context.source_entry.definition.unit_weight_grams
    for _, value in ipairs(target_values) do
        values[#values + 1] = value
    end
    return sql, values
end

function Repository.transfer(context)
    local guard_sql, guard_values = transfer_guard(context)
    local instance_value_sql = 'NULL'
    local operation_values = {
        context.operation_uuid,
        context.account_uuid,
        context.session_uuid,
        context.character_uuid,
        context.source_inventory.id,
        context.target_inventory.id,
        context.source_entry.entry_uuid,
        context.target_entry_uuid,
        context.source_entry.definition_id,
    }
    if context.source_entry.item_instance_id then
        instance_value_sql = '?'
        operation_values[#operation_values + 1] = context.source_entry.item_instance_id
    end
    operation_values[#operation_values + 1] = context.source_entry.slot_number
    operation_values[#operation_values + 1] = context.plan.target_slot
    operation_values[#operation_values + 1] = context.plan.mode
    operation_values[#operation_values + 1] = context.quantity
    operation_values[#operation_values + 1] = context.request_id
    operation_values[#operation_values + 1] = context.correlation_id
    operation_values[#operation_values + 1] = context.contract_version
    operation_values[#operation_values + 1] = context.payload_sha256
    for _, value in ipairs(guard_values) do
        operation_values[#operation_values + 1] = value
    end
    operation_values[#operation_values + 1] = context.target_inventory.version + 1

    local queries = {
        {
            query = [[SELECT id FROM cnr_inventories WHERE id IN (?,?) ORDER BY id FOR UPDATE]],
            values = { context.source_inventory.id, context.target_inventory.id },
        },
        {
            query = [[SELECT id FROM cnr_inventory_items WHERE inventory_id IN (?,?)
            ORDER BY id FOR UPDATE]],
            values = { context.source_inventory.id, context.target_inventory.id },
        },
        {
            query = ([[INSERT INTO cnr_item_transactions
            (operation_uuid, action, account_uuid, session_uuid, character_uuid,
            source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
            definition_id, item_instance_id, source_slot, target_slot, transfer_mode, quantity,
            request_id, correlation_id,
            contract_version, payload_sha256, result_source_version, result_target_version,
            result_status, created_at, completed_at)
            VALUES (UNHEX(REPLACE(?,'-','')),'TRANSFER',UNHEX(REPLACE(?,'-','')),
            UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,?,UNHEX(REPLACE(?,'-','')),
            UNHEX(REPLACE(?,'-','')),?,%s,?,?,?,?,?,?,?,UNHEX(?),%s,?,'COMPLETED',
            UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]]):format(instance_value_sql, guard_sql),
            values = operation_values,
        },
    }

    if context.plan.mode == 'MOVE_INSTANCE' then
        queries[#queries + 1] = {
            query = [[UPDATE cnr_inventory_items SET inventory_id=?, slot_number=?,
            version=version+1, updated_at=UTC_TIMESTAMP(6) WHERE id=?]],
            values = {
                context.target_inventory.id,
                context.plan.target_slot,
                context.source_entry.id,
            },
        }
    else
        if context.plan.mode == 'STACK' then
            queries[#queries + 1] = {
                query = [[UPDATE cnr_inventory_items SET quantity=quantity+?, version=version+1,
                updated_at=UTC_TIMESTAMP(6) WHERE id=?]],
                values = { context.quantity, context.target_entry.id },
            }
        else
            queries[#queries + 1] = {
                query = [[INSERT INTO cnr_inventory_items
                (public_uuid, inventory_id, definition_id, item_instance_id, slot_number,
                quantity, version, created_at, updated_at)
                VALUES (UNHEX(REPLACE(?,'-','')),?,?,NULL,?,?,1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
                values = {
                    context.target_entry_uuid,
                    context.target_inventory.id,
                    context.source_entry.definition_id,
                    context.plan.target_slot,
                    context.quantity,
                },
            }
        end
        if context.quantity == context.source_entry.quantity then
            queries[#queries + 1] = {
                query = [[DELETE FROM cnr_inventory_items WHERE id=?]],
                values = { context.source_entry.id },
            }
        else
            queries[#queries + 1] = {
                query = [[UPDATE cnr_inventory_items SET quantity=quantity-?, version=version+1,
                updated_at=UTC_TIMESTAMP(6) WHERE id=?]],
                values = { context.quantity, context.source_entry.id },
            }
        end
    end
    queries[#queries + 1] = {
        query = [[UPDATE cnr_inventories SET version=version+1, updated_at=UTC_TIMESTAMP(6)
        WHERE id=?]],
        values = { context.source_inventory.id },
    }
    queries[#queries + 1] = {
        query = [[UPDATE cnr_inventories SET version=version+1, updated_at=UTC_TIMESTAMP(6)
        WHERE id=?]],
        values = { context.target_inventory.id },
    }
    return exports.cnr_database:transaction(queries)
end

local function reposition_guard(context)
    local instance_guard = 'AND si.item_instance_id IS NULL '
    local instance_values = {}
    if context.source_entry.item_instance_id then
        instance_guard = 'AND si.item_instance_id=? '
        instance_values[1] = context.source_entry.item_instance_id
    end
    local target_guard
    local target_values
    if context.target_entry then
        target_guard = [[AND EXISTS (SELECT 1 FROM cnr_inventory_items ti
        WHERE ti.id=? AND ti.inventory_id=i.id AND ti.slot_number=? AND ti.version=?) ]]
        target_values = {
            context.target_entry.id,
            context.target_entry.slot_number,
            context.target_entry.version,
        }
    else
        target_guard = [[AND NOT EXISTS (SELECT 1 FROM cnr_inventory_items ti
        WHERE ti.inventory_id=i.id AND ti.slot_number=?) ]]
        target_values = { context.plan.target_slot }
    end
    local temporary_guard = ''
    local temporary_values = {}
    if context.plan.mode == 'SWAP' then
        temporary_guard = [[AND NOT EXISTS (SELECT 1 FROM cnr_inventory_items tmp
        WHERE tmp.inventory_id=i.id AND tmp.slot_number=?) ]]
        temporary_values[1] = context.plan.temporary_slot
    end
    local sql = ([[COALESCE((SELECT i.version+1 FROM cnr_inventories i
    INNER JOIN cnr_inventory_items si ON si.inventory_id=i.id
    WHERE i.id=? AND i.public_uuid=UNHEX(REPLACE(?,'-','')) AND i.version=?
    AND i.status='ACTIVE' AND i.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
    AND si.id=? AND si.slot_number=? AND si.version=? AND si.quantity=?
    AND si.definition_id=? %s AND ?<=i.slot_capacity %s %s LIMIT 1),0)]]):format(
        instance_guard,
        target_guard,
        temporary_guard
    )
    local values = {
        context.inventory.id,
        context.inventory.inventory_uuid,
        context.inventory.version,
        context.character_uuid,
        context.source_entry.id,
        context.source_entry.slot_number,
        context.source_entry.version,
        context.source_entry.quantity,
        context.source_entry.definition_id,
    }
    for _, value in ipairs(instance_values) do
        values[#values + 1] = value
    end
    values[#values + 1] = context.plan.target_slot
    for _, value in ipairs(target_values) do
        values[#values + 1] = value
    end
    for _, value in ipairs(temporary_values) do
        values[#values + 1] = value
    end
    return sql, values
end

function Repository.reposition(context)
    local guard_sql, guard_values = reposition_guard(context)
    local target_entry_sql = 'NULL'
    local instance_sql = 'NULL'
    local values = {
        context.operation_uuid,
        context.account_uuid,
        context.session_uuid,
        context.character_uuid,
        context.inventory.id,
        context.inventory.id,
        context.source_entry.entry_uuid,
    }
    if context.target_entry then
        target_entry_sql = [[UNHEX(REPLACE(?,'-',''))]]
        values[#values + 1] = context.target_entry.entry_uuid
    end
    values[#values + 1] = context.source_entry.definition_id
    if context.source_entry.item_instance_id then
        instance_sql = '?'
        values[#values + 1] = context.source_entry.item_instance_id
    end
    values[#values + 1] = context.plan.source_slot
    values[#values + 1] = context.plan.target_slot
    values[#values + 1] = context.source_entry.quantity
    values[#values + 1] = context.request_id
    values[#values + 1] = context.correlation_id
    values[#values + 1] = context.contract_version
    values[#values + 1] = context.payload_sha256
    for _, value in ipairs(guard_values) do
        values[#values + 1] = value
    end
    values[#values + 1] = context.inventory.version + 1

    local queries = {
        {
            query = [[SELECT id FROM cnr_inventories WHERE id=? FOR UPDATE]],
            values = { context.inventory.id },
        },
        {
            query = [[SELECT id FROM cnr_inventory_items WHERE inventory_id=?
            ORDER BY id FOR UPDATE]],
            values = { context.inventory.id },
        },
        {
            query = ([[INSERT INTO cnr_item_transactions
            (operation_uuid, action, account_uuid, session_uuid, character_uuid,
            source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
            definition_id, item_instance_id, source_slot, target_slot, quantity, request_id,
            correlation_id, contract_version, payload_sha256, result_source_version,
            result_target_version, result_status, created_at, completed_at)
            VALUES (UNHEX(REPLACE(?,'-','')),'REPOSITION',UNHEX(REPLACE(?,'-','')),
            UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,?,
            UNHEX(REPLACE(?,'-','')),%s,?,%s,?,?,?,?,?,?,UNHEX(?),%s,?,'COMPLETED',
            UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]]):format(
                target_entry_sql,
                instance_sql,
                guard_sql
            ),
            values = values,
        },
    }
    if context.plan.mode == 'SWAP' then
        queries[#queries + 1] = {
            query = [[UPDATE cnr_inventory_items SET slot_number=? WHERE id=?]],
            values = { context.plan.temporary_slot, context.source_entry.id },
        }
        queries[#queries + 1] = {
            query = [[UPDATE cnr_inventory_items SET slot_number=?, version=version+1,
            updated_at=UTC_TIMESTAMP(6) WHERE id=?]],
            values = { context.plan.source_slot, context.target_entry.id },
        }
    end
    queries[#queries + 1] = {
        query = [[UPDATE cnr_inventory_items SET slot_number=?, version=version+1,
        updated_at=UTC_TIMESTAMP(6) WHERE id=?]],
        values = { context.plan.target_slot, context.source_entry.id },
    }
    queries[#queries + 1] = {
        query = [[UPDATE cnr_inventories SET version=version+1, updated_at=UTC_TIMESTAMP(6)
        WHERE id=?]],
        values = { context.inventory.id },
    }
    return exports.cnr_database:transaction(queries)
end

return Repository
