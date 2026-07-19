-- Resolves registration authority from the FiveM source and applies an idempotent transition.
local Policy = require('shared.registration_policy')
local Repository = require('server.repositories.registration_repository')
local RegistrationService = {}

local function failure(code, key, details, correlation_id)
    return exports.cnr_core:create_error_result(code, key, details or {}, correlation_id)
end

local function success(data, correlation_id)
    return exports.cnr_core:create_success_result(data, correlation_id)
end

local function resolve_session(player_source, correlation_id)
    local memory_session = exports.cnr_sessions:get_session_for_source(player_source)
    if not memory_session then
        return nil,
            failure(
                'AUTHENTICATION_REQUIRED',
                'registration.error.session_required',
                {},
                correlation_id
            )
    end
    local session, database_error =
        Repository.session_for_source(exports.cnr_core:get_server_instance_id(), player_source)
    if database_error then
        return nil, database_error
    end
    if
        not session
        or session.session_uuid ~= memory_session.session_uuid
        or session.account_uuid ~= memory_session.account_uuid
    then
        return nil,
            failure(
                'AUTHENTICATION_REQUIRED',
                'registration.error.session_inactive',
                {},
                correlation_id
            )
    end
    return session
end

function RegistrationService.status(player_source, correlation_id)
    local session, session_error = resolve_session(player_source, correlation_id)
    if not session then
        return session_error
    end
    local ruleset, ruleset_error = Repository.current_ruleset()
    if ruleset_error then
        return ruleset_error
    end
    return success({
        registered = session.account_status ~= 'PENDING_REGISTRATION',
        account_status = session.account_status,
        access_state = session.access_state,
        ruleset_uuid = ruleset and ruleset.public_uuid or nil,
        ruleset_version = ruleset and tonumber(ruleset.version) or nil,
    }, correlation_id)
end

function RegistrationService.ruleset(player_source, locale, correlation_id)
    local session, session_error = resolve_session(player_source, correlation_id)
    if not session then
        return session_error
    end
    if session.account_status ~= 'PENDING_REGISTRATION' or session.access_state ~= 'ONBOARDING' then
        return failure(
            'PRECONDITION_FAILED',
            'registration.error.not_onboarding',
            {},
            correlation_id
        )
    end
    local ruleset, ruleset_error = Repository.current_ruleset()
    if ruleset_error then
        return ruleset_error
    end
    if not ruleset then
        return failure(
            'DEPENDENCY_UNAVAILABLE',
            'registration.error.ruleset_unavailable',
            {},
            correlation_id
        )
    end
    local selected_locale = 'en'
    return success({
        ruleset_uuid = ruleset.public_uuid,
        version = tonumber(ruleset.version),
        locale = selected_locale,
        content = ruleset.content_en,
        published_at = ruleset.published_at,
    }, correlation_id)
end

function RegistrationService.submit(player_source, payload, correlation_id)
    local validated, validation_code = Policy.validate(payload)
    if not validated then
        return failure(validation_code, 'registration.error.invalid_request', {}, correlation_id)
    end
    local session, session_error = resolve_session(player_source, correlation_id)
    if not session then
        return session_error
    end

    local hash, hash_error = Repository.payload_hash(validated)
    if hash_error then
        return hash_error
    end
    local previous, previous_error = Repository.find_operation(validated.operation_uuid)
    if previous_error then
        return previous_error
    end
    if previous then
        if
            previous.account_uuid ~= session.account_uuid
            or previous.payload_sha256 ~= hash.payload_sha256
        then
            exports.cnr_logs:log('warn', 'cnr_registration', 'registration.operation_conflict', {
                operation_uuid = validated.operation_uuid,
                correlation_id = correlation_id,
            })
            return failure('CONFLICT', 'registration.error.operation_conflict', {}, correlation_id)
        end
        return success({
            repeated = true,
            operation_uuid = previous.operation_uuid,
            account_status = previous.result_account_status,
            access_state = previous.result_access_state,
        }, correlation_id)
    end

    if session.account_status ~= 'PENDING_REGISTRATION' or session.access_state ~= 'ONBOARDING' then
        exports.cnr_logs:log('warn', 'cnr_registration', 'registration.precondition_rejected', {
            account_status = session.account_status,
            access_state = session.access_state,
            correlation_id = correlation_id,
        })
        return failure(
            'PRECONDITION_FAILED',
            'registration.error.not_onboarding',
            {},
            correlation_id
        )
    end

    local ruleset, ruleset_error = Repository.current_ruleset()
    if ruleset_error then
        return ruleset_error
    end
    if
        not ruleset
        or ruleset.public_uuid ~= validated.ruleset_uuid
        or tonumber(ruleset.version) ~= validated.ruleset_version
    then
        return failure(
            'PRECONDITION_FAILED',
            'registration.error.ruleset_outdated',
            {},
            correlation_id
        )
    end

    local whitelist_result = exports.cnr_whitelist:evaluate(session.account_uuid, correlation_id)
    if not whitelist_result.ok then
        return whitelist_result
    end
    local transition =
        Policy.transition(whitelist_result.data.mode, whitelist_result.data.entry_uuid ~= nil)
    local commit_result = Repository.commit_registration({
        operation_uuid = validated.operation_uuid,
        acceptance_uuid = exports.cnr_core:create_uuid_v7(),
        account_id = session.account_id,
        account_version = tonumber(session.account_version),
        session_id = session.session_id,
        ruleset_id = ruleset.id,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        contract_version = validated.contract_version,
        locale = validated.locale,
        payload_sha256 = hash.payload_sha256,
        account_status = transition.account_status,
        access_state = transition.access_state,
    })
    if not commit_result.ok then
        local concurrent = Repository.find_operation(validated.operation_uuid)
        if
            concurrent
            and concurrent.account_uuid == session.account_uuid
            and concurrent.payload_sha256 == hash.payload_sha256
        then
            return success({
                repeated = true,
                operation_uuid = concurrent.operation_uuid,
                account_status = concurrent.result_account_status,
                access_state = concurrent.result_access_state,
            }, correlation_id)
        end
        return commit_result
    end

    local committed_operation, committed_error = Repository.find_operation(validated.operation_uuid)
    if committed_error then
        return committed_error
    end
    if not committed_operation then
        return failure('CONFLICT', 'registration.error.concurrent_change', {}, correlation_id)
    end

    exports.cnr_sessions:refresh_access_for_source(
        player_source,
        session.account_uuid,
        transition.access_state
    )
    exports.cnr_logs:audit('cnr_registration', 'ruleset.accepted', {
        account_uuid = session.account_uuid,
        ruleset_uuid = ruleset.public_uuid,
        ruleset_version = tonumber(ruleset.version),
        operation_uuid = validated.operation_uuid,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    exports.cnr_logs:audit('cnr_registration', 'account.status_changed', {
        account_uuid = session.account_uuid,
        previous_status = 'PENDING_REGISTRATION',
        account_status = transition.account_status,
        access_state = transition.access_state,
        request_id = validated.request_id,
        correlation_id = correlation_id,
    })
    return success({
        repeated = false,
        operation_uuid = validated.operation_uuid,
        account_status = transition.account_status,
        access_state = transition.access_state,
    }, correlation_id)
end

return RegistrationService
