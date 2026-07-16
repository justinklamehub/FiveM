-- Resolves source authority for character creation, binding, appearance, and spawn operations.
local Policy = require('shared.character_policy')
local Repository = require('server.repositories.character_repository')
local Service = {}

local function failure(code, key, details, correlation_id)
    return exports.cnr_core:create_error_result(code, key, details or {}, correlation_id)
end
local function success(data, correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id)
end

local function character_summary(row)
    return {
        character_uuid = row.character_uuid,
        slot_number = tonumber(row.slot_number),
        status = row.status,
        first_name = row.first_name,
        last_name = row.last_name,
        date_of_birth = row.date_of_birth,
        background_code = row.background_code,
    }
end

local function next_state(binding)
    if binding.spawn_state == 'APPEARANCE_REQUIRED' then
        return 'APPEARANCE_REQUIRED'
    elseif binding.spawn_state == 'SPAWNED' then
        return 'SPAWNED'
    end
    return 'SPAWN_PENDING'
end

local function spawn_location(character_id)
    local location, location_error = Repository.last_safe_location(character_id)
    if location_error then
        return nil, location_error
    end
    if location then
        return {
            reason = 'LAST_SAFE',
            x = tonumber(location.x),
            y = tonumber(location.y),
            z = tonumber(location.z),
            heading = tonumber(location.heading),
        }
    end
    return {
        reason = 'CENTRAL_DEFAULT',
        x = tonumber(GetConvar('cnr_spawn_default_x', '215.76')),
        y = tonumber(GetConvar('cnr_spawn_default_y', '-810.12')),
        z = tonumber(GetConvar('cnr_spawn_default_z', '30.73')),
        heading = tonumber(GetConvar('cnr_spawn_default_heading', '157.0')),
    }
end

local function spawn_instruction(binding)
    if binding.spawn_state ~= 'PENDING' or not binding.spawn_uuid or not binding.appearance then
        return nil
    end
    return {
        spawn_uuid = binding.spawn_uuid,
        binding_uuid = binding.binding_uuid,
        reason = binding.spawn_reason,
        x = tonumber(binding.spawn_x),
        y = tonumber(binding.spawn_y),
        z = tonumber(binding.spawn_z),
        heading = tonumber(binding.spawn_heading),
        appearance = binding.appearance,
    }
end

local function session_for_source(player_source, correlation_id)
    local memory = exports.cnr_sessions:get_session_for_source(player_source)
    local session, database_error =
        Repository.session_for_source(exports.cnr_core:get_server_instance_id(), player_source)
    if database_error then
        return nil, database_error
    end
    if
        not memory
        or not session
        or memory.session_uuid ~= session.session_uuid
        or memory.account_uuid ~= session.account_uuid
    then
        return nil,
            failure(
                'AUTHENTICATION_REQUIRED',
                'characters.error.session_required',
                {},
                correlation_id
            )
    end
    if session.account_status ~= 'ACTIVE' or session.access_state ~= 'FULL' then
        return nil,
            failure(
                'PRECONDITION_FAILED',
                'characters.error.full_access_required',
                {},
                correlation_id
            )
    end
    return session
end

local function repeated_or_conflict(session, payload, action, correlation_id)
    local hash, hash_error = Repository.payload_hash(action, payload)
    if hash_error then
        return nil, nil, hash_error
    end
    local operation, operation_error = Repository.find_operation(payload.operation_uuid)
    if operation_error then
        return nil, nil, operation_error
    end
    if not operation then
        return nil, hash.payload_sha256
    end
    if
        operation.account_uuid ~= session.account_uuid
        or operation.action ~= action
        or operation.payload_sha256 ~= hash.payload_sha256
    then
        return nil,
            nil,
            failure('CONFLICT', 'characters.error.operation_conflict', {}, correlation_id)
    end
    return success({
        repeated = true,
        operation_uuid = operation.operation_uuid,
        character_uuid = operation.character_uuid,
        status = operation.result_status,
    }, correlation_id)
end

function Service.configuration(player_source, correlation_id)
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local settings, settings_error = Repository.settings()
    if settings_error then
        return settings_error
    end
    local backgrounds, backgrounds_error = Repository.backgrounds()
    if backgrounds_error then
        return backgrounds_error
    end
    return success({
        slot_limit = settings.slot_limit,
        minimum_age = settings.minimum_age,
        maximum_age = settings.maximum_age,
        backgrounds = backgrounds,
    }, correlation_id)
end

function Service.list(player_source, correlation_id)
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local characters, database_error = Repository.list(session.account_id)
    if database_error then
        return database_error
    end
    local settings, settings_error = Repository.settings()
    if settings_error then
        return settings_error
    end
    return success({ slot_limit = settings.slot_limit, characters = characters }, correlation_id)
end

function Service.create_draft(player_source, payload, correlation_id)
    local settings, settings_error = Repository.settings()
    if settings_error then
        return settings_error
    end
    local validated, validation_code = Policy.validate_draft(payload, settings, os.time())
    if not validated then
        return failure(validation_code, 'characters.error.invalid_identity', {}, correlation_id)
    end
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local repeated, payload_hash, operation_error =
        repeated_or_conflict(session, validated, 'CREATE_DRAFT', correlation_id)
    if operation_error then
        return operation_error
    end
    if repeated then
        return repeated
    end
    local existing, list_error = Repository.list(session.account_id)
    if list_error then
        return list_error
    end
    if #existing >= settings.slot_limit then
        return failure(
            'CONFLICT',
            'characters.error.slot_limit',
            { slot_limit = settings.slot_limit },
            correlation_id
        )
    end
    local occupied = {}
    for _, character in ipairs(existing) do
        occupied[tonumber(character.slot_number)] = true
    end
    local slot_number = 1
    while occupied[slot_number] and slot_number <= settings.slot_limit do
        slot_number = slot_number + 1
    end
    local background, background_error = Repository.find_background(validated.background_code)
    if background_error then
        return background_error
    end
    if not background then
        return failure(
            'VALIDATION_ERROR',
            'characters.error.background_invalid',
            {},
            correlation_id
        )
    end
    local character_uuid = exports.cnr_core:create_uuid_v7()
    local result = Repository.create_draft({
        character_uuid = character_uuid,
        account_id = session.account_id,
        session_id = session.session_id,
        slot_number = slot_number,
        background_id = background.id,
        first_name = validated.first_name,
        last_name = validated.last_name,
        date_of_birth = validated.date_of_birth,
        operation_uuid = validated.operation_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = payload_hash,
    })
    if not result.ok then
        local concurrent = Repository.find_operation(validated.operation_uuid)
        if
            concurrent
            and concurrent.account_uuid == session.account_uuid
            and concurrent.payload_sha256 == payload_hash
        then
            return success({
                repeated = true,
                operation_uuid = concurrent.operation_uuid,
                character_uuid = concurrent.character_uuid,
                status = concurrent.result_status,
            }, correlation_id)
        end
        return result
    end
    local character = Repository.find_owned(session.account_id, character_uuid)
    if not character then
        return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_characters', 'character.draft_created', {
        account_uuid = session.account_uuid,
        character_uuid = character_uuid,
        slot_number = character.slot_number,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    return success(
        { repeated = false, operation_uuid = validated.operation_uuid, character = character },
        correlation_id
    )
end

function Service.activate(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_activation(payload)
    if not validated then
        return failure(validation_code, 'characters.error.invalid_request', {}, correlation_id)
    end
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local repeated, payload_hash, operation_error =
        repeated_or_conflict(session, validated, 'ACTIVATE', correlation_id)
    if operation_error then
        return operation_error
    end
    if repeated then
        return repeated
    end
    local character, character_error =
        Repository.find_owned(session.account_id, validated.character_uuid)
    if character_error then
        return character_error
    end
    if not character then
        return failure('NOT_FOUND', 'characters.error.not_found', {}, correlation_id)
    end
    if character.status ~= 'DRAFT' then
        return failure('PRECONDITION_FAILED', 'characters.error.not_draft', {}, correlation_id)
    end
    local result = Repository.activate({
        operation_uuid = validated.operation_uuid,
        account_id = session.account_id,
        session_id = session.session_id,
        character_id = character.id,
        character_uuid = character.character_uuid,
        character_version = tonumber(character.version),
        document_uuid = exports.cnr_core:create_uuid_v7(),
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = payload_hash,
    })
    if not result.ok then
        return result
    end
    local activated = Repository.find_owned(session.account_id, validated.character_uuid)
    if not activated or activated.status ~= 'ACTIVE' then
        return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_characters', 'character.activated', {
        account_uuid = session.account_uuid,
        character_uuid = validated.character_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    exports.cnr_logs:audit('cnr_characters', 'document.issued', {
        character_uuid = validated.character_uuid,
        document_type = 'state_id',
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    return success(
        { repeated = false, operation_uuid = validated.operation_uuid, character = activated },
        correlation_id
    )
end

function Service.selection_status(player_source, correlation_id)
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local binding, binding_error = Repository.binding_for_session(session.session_id)
    if binding_error then
        return binding_error
    end
    if not binding or binding.binding_status ~= 'ACTIVE' then
        return success({
            selected = false,
            binding_uuid = nil,
            character = nil,
            next_state = nil,
        }, correlation_id)
    end
    local result = success({
        selected = true,
        binding_uuid = binding.binding_uuid,
        character = character_summary(binding),
        next_state = next_state(binding),
    }, correlation_id)
    result.data.spawn_instruction = spawn_instruction(binding)
    if binding.spawn_state == 'SPAWNED' then
        result.data.resume_spawned = true
    end
    return result
end

function Service.select_character(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_selection(payload)
    if not validated then
        return failure(validation_code, 'characters.error.invalid_request', {}, correlation_id)
    end
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local hash, hash_error = Repository.selection_payload_hash(validated)
    if hash_error then
        return hash_error
    end
    local operation, operation_error = Repository.find_selection_operation(validated.operation_uuid)
    if operation_error then
        return operation_error
    end
    if operation then
        if
            operation.account_uuid ~= session.account_uuid
            or tonumber(operation.session_id) ~= tonumber(session.session_id)
            or operation.character_uuid ~= validated.character_uuid
            or operation.payload_sha256 ~= hash.payload_sha256
        then
            return failure('CONFLICT', 'characters.error.operation_conflict', {}, correlation_id)
        end
        local repeated = Repository.binding_for_session(session.session_id)
        if not repeated then
            return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
        end
        local result = success({
            repeated = true,
            operation_uuid = validated.operation_uuid,
            binding_uuid = repeated.binding_uuid,
            character = character_summary(repeated),
            next_state = next_state(repeated),
        }, correlation_id)
        result.data.spawn_instruction = spawn_instruction(repeated)
        return result
    end
    local existing, binding_error = Repository.binding_for_session(session.session_id)
    if binding_error then
        return binding_error
    end
    if existing then
        return failure('CONFLICT', 'characters.error.session_already_bound', {}, correlation_id)
    end
    local character, character_error =
        Repository.find_owned(session.account_id, validated.character_uuid)
    if character_error then
        return character_error
    end
    if not character then
        return failure('NOT_FOUND', 'characters.error.not_found', {}, correlation_id)
    end
    if character.status ~= 'ACTIVE' then
        return failure('PRECONDITION_FAILED', 'characters.error.not_active', {}, correlation_id)
    end
    local appearance, appearance_error = Repository.appearance(character.id)
    if appearance_error then
        return appearance_error
    end
    local location
    if appearance then
        location, appearance_error = spawn_location(character.id)
        if appearance_error then
            return appearance_error
        end
    end
    local preview_bucket = 10000 + (tonumber(player_source) or 0)
    local context = {
        binding_uuid = exports.cnr_core:create_uuid_v7(),
        operation_uuid = validated.operation_uuid,
        account_id = session.account_id,
        session_id = session.session_id,
        character_id = character.id,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = hash.payload_sha256,
        routing_bucket = appearance and 0 or preview_bucket,
        spawn_uuid = appearance and exports.cnr_core:create_uuid_v7() or nil,
        spawn_state = appearance and 'PENDING' or 'APPEARANCE_REQUIRED',
        spawn_reason = location and location.reason or nil,
        spawn_x = location and location.x or nil,
        spawn_y = location and location.y or nil,
        spawn_z = location and location.z or nil,
        spawn_heading = location and location.heading or nil,
    }
    local created = Repository.create_binding(context)
    if not created.ok then
        local concurrent = Repository.find_selection_operation(validated.operation_uuid)
        if
            concurrent
            and concurrent.account_uuid == session.account_uuid
            and tonumber(concurrent.session_id) == tonumber(session.session_id)
            and concurrent.character_uuid == validated.character_uuid
            and concurrent.payload_sha256 == hash.payload_sha256
        then
            local repeated = Repository.binding_for_session(session.session_id)
            if repeated then
                local recovered = success({
                    repeated = true,
                    operation_uuid = validated.operation_uuid,
                    binding_uuid = repeated.binding_uuid,
                    character = character_summary(repeated),
                    next_state = next_state(repeated),
                }, correlation_id)
                recovered.data.spawn_instruction = spawn_instruction(repeated)
                return recovered
            end
        end
        return created
    end
    SetPlayerRoutingBucket(player_source, context.routing_bucket)
    local binding = Repository.binding_for_session(session.session_id)
    if not binding then
        return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_characters', 'character.selected', {
        account_uuid = session.account_uuid,
        character_uuid = character.character_uuid,
        binding_uuid = binding.binding_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    local result = success({
        repeated = false,
        operation_uuid = validated.operation_uuid,
        binding_uuid = binding.binding_uuid,
        character = character_summary(binding),
        next_state = next_state(binding),
    }, correlation_id)
    result.data.spawn_instruction = spawn_instruction(binding)
    return result
end

function Service.appearance_configuration(player_source, correlation_id)
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local binding, binding_error = Repository.binding_for_session(session.session_id)
    if binding_error then
        return binding_error
    end
    if
        not binding
        or binding.binding_status ~= 'ACTIVE'
        or binding.spawn_state ~= 'APPEARANCE_REQUIRED'
    then
        return failure(
            'PRECONDITION_FAILED',
            'characters.error.selection_required',
            {},
            correlation_id
        )
    end
    return success({
        models = { 'mp_m_freemode_01', 'mp_f_freemode_01' },
        parent_minimum = 0,
        parent_maximum = 45,
        face_feature_count = 20,
        face_feature_minimum = -100,
        face_feature_maximum = 100,
        hair_style_maximum = 76,
        hair_texture_maximum = 10,
        hair_color_maximum = 63,
        eye_color_maximum = 31,
        outfit_codes = { 'starter_casual' },
        defaults = {
            model = 'mp_m_freemode_01',
            shape_first = 0,
            shape_second = 21,
            shape_mix = 50,
            skin_mix = 50,
            face_features = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
            hair_style = 0,
            hair_texture = 0,
            hair_color = 0,
            hair_highlight = 0,
            eye_color = 0,
            outfit_code = 'starter_casual',
        },
    }, correlation_id)
end

function Service.save_appearance(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_appearance(payload)
    if not validated then
        return failure(validation_code, 'characters.error.invalid_appearance', {}, correlation_id)
    end
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local binding, binding_error = Repository.binding_for_session(session.session_id)
    if binding_error then
        return binding_error
    end
    if not binding or binding.binding_status ~= 'ACTIVE' then
        return failure(
            'PRECONDITION_FAILED',
            'characters.error.selection_required',
            {},
            correlation_id
        )
    end
    local hash, hash_error = Repository.appearance_payload_hash(validated)
    if hash_error then
        return hash_error
    end
    local operation, operation_error =
        Repository.find_appearance_operation(validated.operation_uuid)
    if operation_error then
        return operation_error
    end
    if operation then
        if
            operation.account_uuid ~= session.account_uuid
            or tonumber(operation.session_id) ~= tonumber(session.session_id)
            or operation.character_uuid ~= binding.character_uuid
            or operation.payload_sha256 ~= hash.payload_sha256
        then
            return failure('CONFLICT', 'characters.error.operation_conflict', {}, correlation_id)
        end
        local repeated = Repository.binding_for_session(session.session_id)
        local result = success({
            repeated = true,
            operation_uuid = validated.operation_uuid,
            appearance_version = tonumber(operation.result_version),
            next_state = 'SPAWN_PENDING',
        }, correlation_id)
        result.data.spawn_instruction = spawn_instruction(repeated)
        return result
    end
    if binding.spawn_state ~= 'APPEARANCE_REQUIRED' then
        return failure(
            'PRECONDITION_FAILED',
            'characters.error.appearance_not_allowed',
            {},
            correlation_id
        )
    end
    local location, location_error = spawn_location(binding.character_id)
    if location_error then
        return location_error
    end
    local spawn_uuid = exports.cnr_core:create_uuid_v7()
    local saved = Repository.save_appearance({
        appearance_uuid = exports.cnr_core:create_uuid_v7(),
        operation_uuid = validated.operation_uuid,
        account_id = session.account_id,
        session_id = session.session_id,
        character_id = binding.character_id,
        binding_id = binding.binding_id,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        payload_sha256 = hash.payload_sha256,
        result_version = binding.appearance and binding.appearance.version + 1 or 1,
        appearance = validated,
        face_features_json = json.encode(validated.face_features),
        spawn_uuid = spawn_uuid,
        spawn_reason = location.reason,
        spawn_x = location.x,
        spawn_y = location.y,
        spawn_z = location.z,
        spawn_heading = location.heading,
    })
    if not saved.ok then
        local concurrent = Repository.find_appearance_operation(validated.operation_uuid)
        if
            concurrent
            and concurrent.account_uuid == session.account_uuid
            and tonumber(concurrent.session_id) == tonumber(session.session_id)
            and concurrent.character_uuid == binding.character_uuid
            and concurrent.payload_sha256 == hash.payload_sha256
        then
            local repeated = Repository.binding_for_session(session.session_id)
            local recovered = success({
                repeated = true,
                operation_uuid = validated.operation_uuid,
                appearance_version = tonumber(concurrent.result_version),
                next_state = 'SPAWN_PENDING',
            }, correlation_id)
            recovered.data.spawn_instruction = spawn_instruction(repeated)
            return recovered
        end
        return saved
    end
    SetPlayerRoutingBucket(player_source, 0)
    local updated = Repository.binding_for_session(session.session_id)
    if not updated or updated.spawn_state ~= 'PENDING' then
        return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_characters', 'character.appearance_saved', {
        account_uuid = session.account_uuid,
        character_uuid = binding.character_uuid,
        appearance_version = updated.appearance.version,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    local result = success({
        repeated = false,
        operation_uuid = validated.operation_uuid,
        appearance_version = updated.appearance.version,
        next_state = 'SPAWN_PENDING',
    }, correlation_id)
    result.data.spawn_instruction = spawn_instruction(updated)
    return result
end

function Service.acknowledge_spawn(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate_spawn_ack(payload)
    if not validated then
        return failure(validation_code, 'characters.error.invalid_spawn_ack', {}, correlation_id)
    end
    local session, session_error = session_for_source(player_source, correlation_id)
    if not session then
        return session_error
    end
    local binding, binding_error = Repository.binding_for_session(session.session_id)
    if binding_error then
        return binding_error
    end
    if
        binding
        and binding.binding_status == 'ACTIVE'
        and binding.spawn_state == 'SPAWNED'
        and binding.spawn_uuid == validated.spawn_uuid
    then
        return success({ spawn_uuid = validated.spawn_uuid, repeated = true }, correlation_id)
    end
    if
        not binding
        or binding.binding_status ~= 'ACTIVE'
        or binding.spawn_state ~= 'PENDING'
        or binding.spawn_uuid ~= validated.spawn_uuid
    then
        return failure(
            'PRECONDITION_FAILED',
            'characters.error.spawn_not_pending',
            {},
            correlation_id
        )
    end
    local committed = Repository.mark_spawned({
        binding_id = binding.binding_id,
        session_id = session.session_id,
        character_id = binding.character_id,
        spawn_uuid = validated.spawn_uuid,
        spawn_x = tonumber(binding.spawn_x),
        spawn_y = tonumber(binding.spawn_y),
        spawn_z = tonumber(binding.spawn_z),
        spawn_heading = tonumber(binding.spawn_heading),
    })
    if not committed.ok then
        return committed
    end
    local updated = Repository.binding_for_session(session.session_id)
    if not updated or updated.spawn_state ~= 'SPAWNED' then
        return failure('CONFLICT', 'characters.error.concurrent_change', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_characters', 'character.spawned', {
        account_uuid = session.account_uuid,
        character_uuid = binding.character_uuid,
        binding_uuid = binding.binding_uuid,
        spawn_uuid = validated.spawn_uuid,
        spawn_reason = binding.spawn_reason,
        correlation_id = correlation_id,
    })
    return success({ spawn_uuid = validated.spawn_uuid }, correlation_id)
end

function Service.end_session_binding(session)
    if not session or not session.session_uuid then
        return
    end
    local persisted =
        Repository.session_for_source(exports.cnr_core:get_server_instance_id(), session.source)
    if persisted then
        Repository.end_binding_for_session(persisted.session_id)
    end
end

function Service.recover_stale_bindings()
    return Repository.close_stale_bindings()
end

return Service
