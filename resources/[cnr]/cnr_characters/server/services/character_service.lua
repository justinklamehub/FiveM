-- Resolves source authority and orchestrates idempotent character draft and activation operations.
local Policy = require('shared.character_policy')
local Repository = require('server.repositories.character_repository')
local Service = {}

local function failure(code, key, details, correlation_id)
    return exports.cnr_core:create_error_result(code, key, details or {}, correlation_id)
end
local function success(data, correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id)
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

return Service
