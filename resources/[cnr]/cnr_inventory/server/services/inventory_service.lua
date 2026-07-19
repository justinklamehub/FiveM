-- Resolves source-owned character authority and coordinates personal-inventory mutations.
local Policy = require('shared.inventory_policy')
local Repository = require('server.repositories.inventory_repository')
local Service = {}

local function failure(code, key, details, correlation_id)
    return exports.cnr_core:create_error_result(code, key, details or {}, correlation_id)
end

local function success(data, correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id)
end

local function source_context(player_source, correlation_id)
    local session = exports.cnr_sessions:get_session_for_source(player_source)
    if not session then
        return nil,
            failure(
                'AUTHENTICATION_REQUIRED',
                'inventory.error.session_required',
                {},
                correlation_id
            )
    end
    if session.access_state ~= 'FULL' then
        return nil,
            failure(
                'PRECONDITION_FAILED',
                'inventory.error.full_access_required',
                {},
                correlation_id
            )
    end
    local character =
        exports.cnr_characters:active_character_for_source(player_source, correlation_id)
    if not character.ok then
        return nil, character
    end
    return {
        account_uuid = session.account_uuid,
        session_uuid = session.session_uuid,
        character_uuid = character.data.character_uuid,
        binding_uuid = character.data.binding_uuid,
        state_document_uuid = character.data.state_document_uuid,
    }
end

local function convar_number(name, default)
    return tonumber(GetConvar(name, tostring(default))) or default
end

local function personal_locker_access(player_source, correlation_id)
    local ped = GetPlayerPed(player_source)
    if type(ped) ~= 'number' or ped <= 0 then
        return failure(
            'PRECONDITION_FAILED',
            'inventory.error.storage_access_required',
            {},
            correlation_id
        )
    end
    local coordinates = GetEntityCoords(ped)
    local player = coordinates
            and {
                x = tonumber(coordinates.x),
                y = tonumber(coordinates.y),
                z = tonumber(coordinates.z),
            }
        or nil
    local locker = {
        x = convar_number('cnr_inventory_locker_x', 215.76),
        y = convar_number('cnr_inventory_locker_y', -810.12),
        z = convar_number('cnr_inventory_locker_z', 30.73),
    }
    local radius = convar_number('cnr_inventory_locker_radius', 4.0)
    if not Policy.within_access_radius(player, locker, radius) then
        return failure(
            'PRECONDITION_FAILED',
            'inventory.error.storage_access_required',
            {},
            correlation_id
        )
    end
    return nil
end

local function inventory_values(row)
    return {
        id = tonumber(row.id),
        inventory_uuid = row.inventory_uuid,
        owner_character_uuid = row.owner_character_uuid,
        inventory_type = row.inventory_type,
        slot_capacity = tonumber(row.slot_capacity),
        weight_capacity_grams = tonumber(row.weight_capacity_grams),
        current_weight_grams = tonumber(row.current_weight_grams),
        version = tonumber(row.version),
        status = row.status,
    }
end

local function entry_values(row)
    return {
        id = tonumber(row.id),
        entry_uuid = row.entry_uuid,
        slot_number = tonumber(row.slot_number),
        quantity = tonumber(row.quantity),
        version = tonumber(row.version),
        definition_id = tonumber(row.definition_id),
        item_instance_id = row.item_instance_id and tonumber(row.item_instance_id) or nil,
        has_instance = tonumber(row.has_instance) == 1,
        definition = {
            definition_uuid = row.definition_uuid,
            code = row.code,
            category = row.category,
            label = row.label,
            description = row.description,
            icon_key = row.icon_key,
            is_stackable = tonumber(row.is_stackable) == 1,
            is_unique = tonumber(row.is_unique) == 1,
            max_stack = tonumber(row.max_stack),
            unit_weight_grams = tonumber(row.unit_weight_grams),
            version = tonumber(row.definition_version),
        },
    }
end

local function entries_for(inventory)
    local rows, database_error = Repository.entries(inventory.id)
    if database_error then
        return nil, database_error
    end
    local entries = {}
    for _, row in ipairs(rows) do
        entries[#entries + 1] = entry_values(row)
    end
    return entries
end

local function public_snapshot(inventory, entries, starter_provisioned)
    local public_entries = {}
    for _, entry in ipairs(entries) do
        public_entries[#public_entries + 1] = {
            entry_uuid = entry.entry_uuid,
            slot_number = entry.slot_number,
            quantity = entry.quantity,
            definition = entry.definition,
            total_weight_grams = entry.quantity * entry.definition.unit_weight_grams,
        }
    end
    return {
        inventory_uuid = inventory.inventory_uuid,
        inventory_type = inventory.inventory_type,
        slot_capacity = inventory.slot_capacity,
        weight_capacity_grams = inventory.weight_capacity_grams,
        current_weight_grams = inventory.current_weight_grams,
        version = inventory.version,
        starter_provisioned = starter_provisioned,
        entries = public_entries,
    }
end

local function ensure_inventory(context, correlation_id)
    local row, database_error = Repository.find_character_inventory(context.character_uuid)
    if database_error then
        return nil, database_error
    end
    if not row then
        row, database_error = Repository.ensure_character_inventory(
            context.character_uuid,
            exports.cnr_core:create_uuid_v7(),
            GetConvarInt('cnr_inventory_character_slots', 24),
            GetConvarInt('cnr_inventory_character_weight_grams', 30000)
        )
    end
    if database_error then
        return nil, database_error
    end
    if not row or row.status ~= 'ACTIVE' then
        return nil, failure('CONFLICT', 'inventory.error.inventory_unavailable', {}, correlation_id)
    end
    return inventory_values(row)
end

local function ensure_personal_storage(context, correlation_id)
    local row, database_error = Repository.find_personal_storage(context.character_uuid)
    if database_error then
        return nil, database_error
    end
    if not row then
        row, database_error = Repository.ensure_personal_storage(
            context.character_uuid,
            exports.cnr_core:create_uuid_v7(),
            GetConvarInt('cnr_inventory_storage_slots', 48),
            GetConvarInt('cnr_inventory_storage_weight_grams', 100000)
        )
    end
    if database_error then
        return nil, database_error
    end
    if not row or row.status ~= 'ACTIVE' then
        return nil, failure('CONFLICT', 'inventory.error.storage_unavailable', {}, correlation_id)
    end
    return inventory_values(row)
end

local function provision(context, inventory, correlation_id)
    local existing, existing_error = Repository.starter_transaction(context.character_uuid)
    if existing_error then
        return nil, existing_error
    end
    if existing then
        return {
            repeated = true,
            operation_uuid = existing.operation_uuid,
            inventory_version = tonumber(existing.result_target_version),
        }
    end
    local hash, hash_error = Repository.payload_hash({
        'PROVISION_STARTER',
        context.character_uuid,
        context.state_document_uuid,
        '1',
    })
    if hash_error then
        return nil, hash_error
    end
    local operation_uuid = exports.cnr_core:create_uuid_v7()
    local committed = Repository.provision_starter({
        inventory = inventory,
        operation_uuid = operation_uuid,
        account_uuid = context.account_uuid,
        session_uuid = context.session_uuid,
        character_uuid = context.character_uuid,
        state_document_uuid = context.state_document_uuid,
        water_entry_uuid = exports.cnr_core:create_uuid_v7(),
        food_entry_uuid = exports.cnr_core:create_uuid_v7(),
        document_instance_uuid = exports.cnr_core:create_uuid_v7(),
        document_entry_uuid = exports.cnr_core:create_uuid_v7(),
        request_id = 'spawn-starter-provision',
        correlation_id = correlation_id,
        contract_version = 1,
        payload_sha256 = hash.payload_sha256,
    })
    if not committed.ok then
        local concurrent = Repository.starter_transaction(context.character_uuid)
        if concurrent then
            return {
                repeated = true,
                operation_uuid = concurrent.operation_uuid,
                inventory_version = tonumber(concurrent.result_target_version),
            }
        end
        return nil, committed
    end
    exports.cnr_logs:audit('cnr_inventory', 'inventory.starter_provisioned', {
        character_uuid = context.character_uuid,
        inventory_uuid = inventory.inventory_uuid,
        operation_uuid = operation_uuid,
        correlation_id = correlation_id,
    })
    return {
        repeated = false,
        operation_uuid = operation_uuid,
        inventory_version = inventory.version + 1,
    }
end

function Service.provision_for_source(player_source, correlation_id)
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local inventory, inventory_error = ensure_inventory(context, correlation_id)
    if not inventory then
        return inventory_error
    end
    local result, provision_error = provision(context, inventory, correlation_id)
    if not result then
        return provision_error
    end
    return success(result, correlation_id)
end

function Service.snapshot(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_read(payload)
    if not validated then
        return failure(validation_code, 'inventory.error.invalid_request', {}, correlation_id)
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local inventory, inventory_error = ensure_inventory(context, correlation_id)
    if not inventory then
        return inventory_error
    end
    local provisioned, provision_error = provision(context, inventory, correlation_id)
    if not provisioned then
        return provision_error
    end
    local refreshed, refresh_error = Repository.find_character_inventory(context.character_uuid)
    if refresh_error then
        return refresh_error
    end
    inventory = inventory_values(refreshed)
    local entries, entries_error = entries_for(inventory)
    if not entries then
        return entries_error
    end
    return success(public_snapshot(inventory, entries, true), correlation_id)
end

function Service.workspace(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_read(payload)
    if not validated then
        return failure(validation_code, 'inventory.error.invalid_request', {}, correlation_id)
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local access_error = personal_locker_access(player_source, correlation_id)
    if access_error then
        return access_error
    end
    local inventory, inventory_error = ensure_inventory(context, correlation_id)
    if not inventory then
        return inventory_error
    end
    local provisioned, provision_error = provision(context, inventory, correlation_id)
    if not provisioned then
        return provision_error
    end
    local refreshed, refresh_error = Repository.find_character_inventory(context.character_uuid)
    if refresh_error then
        return refresh_error
    end
    inventory = inventory_values(refreshed)
    local storage, storage_error = ensure_personal_storage(context, correlation_id)
    if not storage then
        return storage_error
    end
    local inventory_entries, inventory_entries_error = entries_for(inventory)
    if not inventory_entries then
        return inventory_entries_error
    end
    local storage_entries, storage_entries_error = entries_for(storage)
    if not storage_entries then
        return storage_entries_error
    end
    return success({
        character = public_snapshot(inventory, inventory_entries, true),
        storage = public_snapshot(storage, storage_entries, false),
        access_label = 'Personal Locker',
    }, correlation_id)
end

local function repeated_transfer(operation, context, hash, payload, correlation_id)
    if not operation then
        return nil
    end
    if
        operation.action ~= 'TRANSFER'
        or operation.account_uuid ~= context.account_uuid
        or operation.character_uuid ~= context.character_uuid
        or operation.payload_sha256 ~= hash
    then
        return failure('CONFLICT', 'inventory.error.operation_conflict', {}, correlation_id)
    end
    return success({
        repeated = true,
        operation_uuid = operation.operation_uuid,
        source_inventory_uuid = payload.source_inventory_uuid,
        target_inventory_uuid = payload.target_inventory_uuid,
        source_slot = tonumber(operation.source_slot),
        target_slot = tonumber(operation.target_slot),
        target_entry_uuid = operation.target_entry_uuid,
        quantity = tonumber(operation.quantity),
        mode = operation.transfer_mode,
        source_version = tonumber(operation.result_source_version),
        target_version = tonumber(operation.result_target_version),
    }, correlation_id)
end

local function repeated_reposition(operation, context, hash, correlation_id)
    if not operation then
        return nil
    end
    if
        operation.action ~= 'REPOSITION'
        or operation.account_uuid ~= context.account_uuid
        or operation.character_uuid ~= context.character_uuid
        or operation.payload_sha256 ~= hash
    then
        return failure('CONFLICT', 'inventory.error.operation_conflict', {}, correlation_id)
    end
    return success({
        repeated = true,
        operation_uuid = operation.operation_uuid,
        inventory_version = tonumber(operation.result_target_version),
        source_slot = tonumber(operation.source_slot),
        target_slot = tonumber(operation.target_slot),
        mode = operation.reposition_mode,
    }, correlation_id)
end

function Service.reposition(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_reposition(payload)
    if not validated then
        return failure(validation_code, 'inventory.error.invalid_request', {}, correlation_id)
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local hash, hash_error = Repository.payload_hash({
        'REPOSITION',
        validated.inventory_uuid,
        validated.source_slot,
        validated.target_slot,
        validated.contract_version,
    })
    if hash_error then
        return hash_error
    end
    local operation, operation_error = Repository.transaction(validated.operation_uuid)
    if operation_error then
        return operation_error
    end
    local inventory_row, inventory_error =
        Repository.find_owned(context.character_uuid, validated.inventory_uuid)
    if inventory_error then
        return inventory_error
    end
    if not inventory_row then
        return failure('NOT_FOUND', 'inventory.error.inventory_not_found', {}, correlation_id)
    end
    local inventory = inventory_values(inventory_row)
    if inventory.inventory_type == 'PERSONAL_STORAGE' then
        local access_error = personal_locker_access(player_source, correlation_id)
        if access_error then
            return access_error
        end
    end
    local repeated = repeated_reposition(operation, context, hash.payload_sha256, correlation_id)
    if repeated then
        return repeated
    end
    local entries, entries_error = entries_for(inventory)
    if not entries then
        return entries_error
    end
    local source_entry
    local target_entry
    for _, entry in ipairs(entries) do
        if entry.slot_number == validated.source_slot then
            source_entry = entry
        elseif entry.slot_number == validated.target_slot then
            target_entry = entry
        end
    end
    if not source_entry then
        return failure('NOT_FOUND', 'inventory.error.item_not_found', {}, correlation_id)
    end
    local plan, plan_error = Policy.reposition_plan({
        inventory = inventory,
        source_entry = source_entry,
        target_entry = target_entry,
        source_slot = validated.source_slot,
        target_slot = validated.target_slot,
    })
    if not plan then
        return failure(plan_error, 'inventory.error.reposition_rejected', {}, correlation_id)
    end
    local committed = Repository.reposition({
        operation_uuid = validated.operation_uuid,
        account_uuid = context.account_uuid,
        session_uuid = context.session_uuid,
        character_uuid = context.character_uuid,
        inventory = inventory,
        source_entry = source_entry,
        target_entry = target_entry,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = hash.payload_sha256,
        plan = plan,
    })
    if not committed.ok then
        local concurrent = Repository.transaction(validated.operation_uuid)
        local recovered =
            repeated_reposition(concurrent, context, hash.payload_sha256, correlation_id)
        return recovered or committed
    end
    exports.cnr_logs:audit('cnr_inventory', 'inventory.item_repositioned', {
        character_uuid = context.character_uuid,
        inventory_uuid = inventory.inventory_uuid,
        item_code = source_entry.definition.code,
        source_slot = validated.source_slot,
        target_slot = validated.target_slot,
        operation_uuid = validated.operation_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    return success({
        repeated = false,
        operation_uuid = validated.operation_uuid,
        inventory_version = inventory.version + 1,
        source_slot = validated.source_slot,
        target_slot = validated.target_slot,
        mode = plan.mode,
    }, correlation_id)
end

function Service.transfer(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_transfer(payload)
    if not validated then
        return failure(validation_code, 'inventory.error.invalid_request', {}, correlation_id)
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local hash, hash_error = Repository.payload_hash({
        'TRANSFER',
        validated.source_inventory_uuid,
        validated.target_inventory_uuid,
        validated.source_slot,
        validated.quantity,
        validated.contract_version,
    })
    if hash_error then
        return hash_error
    end
    local operation, operation_error = Repository.transaction(validated.operation_uuid)
    if operation_error then
        return operation_error
    end
    local source_row, source_error =
        Repository.find_owned(context.character_uuid, validated.source_inventory_uuid)
    local target_row, target_error =
        Repository.find_owned(context.character_uuid, validated.target_inventory_uuid)
    if source_error or target_error then
        return source_error or target_error
    end
    if not source_row or not target_row then
        return failure('NOT_FOUND', 'inventory.error.inventory_not_found', {}, correlation_id)
    end
    local source_inventory = inventory_values(source_row)
    local target_inventory = inventory_values(target_row)
    if
        not Policy.is_personal_storage_pair(
            source_inventory.inventory_type,
            target_inventory.inventory_type
        )
    then
        return failure(
            'PRECONDITION_FAILED',
            'inventory.error.transfer_rejected',
            {},
            correlation_id
        )
    end
    local access_error = personal_locker_access(player_source, correlation_id)
    if access_error then
        return access_error
    end
    local repeated =
        repeated_transfer(operation, context, hash.payload_sha256, validated, correlation_id)
    if repeated then
        return repeated
    end
    local source_entries, entries_error = entries_for(source_inventory)
    if not source_entries then
        return entries_error
    end
    local target_entries, target_entries_error = entries_for(target_inventory)
    if not target_entries then
        return target_entries_error
    end
    local source_entry
    for _, entry in ipairs(source_entries) do
        if entry.slot_number == validated.source_slot then
            source_entry = entry
            break
        end
    end
    if not source_entry then
        return failure('NOT_FOUND', 'inventory.error.item_not_found', {}, correlation_id)
    end
    local target_stack
    if source_entry.definition.is_stackable then
        for _, entry in ipairs(target_entries) do
            if entry.definition_id == source_entry.definition_id and not entry.has_instance then
                target_stack = entry
                break
            end
        end
    end
    local plan, plan_error = Policy.transfer_plan({
        source_entry = source_entry,
        target_inventory = target_inventory,
        target_entries = target_entries,
        target_stack = target_stack,
        target_weight_grams = target_inventory.current_weight_grams,
        quantity = validated.quantity,
    })
    if not plan then
        local code = plan_error == 'INSUFFICIENT_QUANTITY' and 'PRECONDITION_FAILED' or plan_error
        return failure(code, 'inventory.error.transfer_rejected', {}, correlation_id)
    end
    local target_entry_uuid = target_stack and target_stack.entry_uuid
        or plan.mode == 'MOVE_INSTANCE' and source_entry.entry_uuid
        or exports.cnr_core:create_uuid_v7()
    local committed = Repository.transfer({
        operation_uuid = validated.operation_uuid,
        account_uuid = context.account_uuid,
        session_uuid = context.session_uuid,
        character_uuid = context.character_uuid,
        source_inventory = source_inventory,
        target_inventory = target_inventory,
        source_entry = source_entry,
        target_entry = target_stack,
        target_entry_uuid = target_entry_uuid,
        quantity = validated.quantity,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = hash.payload_sha256,
        plan = plan,
    })
    if not committed.ok then
        local concurrent = Repository.transaction(validated.operation_uuid)
        local recovered =
            repeated_transfer(concurrent, context, hash.payload_sha256, validated, correlation_id)
        return recovered or committed
    end
    exports.cnr_logs:audit('cnr_inventory', 'inventory.item_transferred', {
        character_uuid = context.character_uuid,
        source_inventory_uuid = source_inventory.inventory_uuid,
        target_inventory_uuid = target_inventory.inventory_uuid,
        item_code = source_entry.definition.code,
        quantity = validated.quantity,
        operation_uuid = validated.operation_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    return success({
        repeated = false,
        operation_uuid = validated.operation_uuid,
        source_inventory_uuid = validated.source_inventory_uuid,
        target_inventory_uuid = validated.target_inventory_uuid,
        source_slot = validated.source_slot,
        target_slot = plan.target_slot,
        target_entry_uuid = target_entry_uuid,
        quantity = validated.quantity,
        mode = plan.mode,
        source_version = source_inventory.version + 1,
        target_version = target_inventory.version + 1,
    }, correlation_id)
end

return Service
