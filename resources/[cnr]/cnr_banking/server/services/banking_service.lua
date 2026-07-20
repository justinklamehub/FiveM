-- Resolves source authority and posts server-derived double-entry transfers.
local Policy = require('shared.banking_policy')
local Repository = require('server.repositories.banking_repository')
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
            failure('AUTHENTICATION_REQUIRED', 'banking.error.session_required', {}, correlation_id)
    end
    if session.access_state ~= 'FULL' then
        return nil,
            failure('PRECONDITION_FAILED', 'banking.error.full_access_required', {}, correlation_id)
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
    }
end

local function compact_uuid(value)
    return value:gsub('-', ''):upper()
end

local function ensure_starter(context, request_id, correlation_id)
    local existing, existing_error = Repository.starter_transaction(context.character_uuid)
    if existing_error then
        return nil, existing_error
    end
    if existing then
        return existing, nil, true
    end
    local settings, settings_error = Repository.settings()
    if settings_error then
        return nil, settings_error
    end
    local cash_minor = settings.starter_cash_minor
    local checking_minor = settings.starter_checking_minor
    if not cash_minor or not checking_minor or cash_minor <= 0 or checking_minor <= 0 then
        return nil,
            failure(
                'DEPENDENCY_UNAVAILABLE',
                'banking.error.settings_unavailable',
                {},
                correlation_id
            )
    end
    local payload_sha256, hash_error =
        Repository.payload_hash(context.character_uuid, cash_minor, checking_minor, 1)
    if hash_error then
        return nil, hash_error
    end
    if not payload_sha256 or type(payload_sha256.payload_sha256) ~= 'string' then
        return nil, failure('INTERNAL_ERROR', 'banking.error.hash_failed', {}, correlation_id)
    end
    local wallet_uuid = exports.cnr_core:create_uuid_v7()
    local checking_uuid = exports.cnr_core:create_uuid_v7()
    local transaction_uuid = exports.cnr_core:create_uuid_v7()
    local operation_uuid = exports.cnr_core:create_uuid_v7()
    local committed = Repository.provision_starter({
        character_uuid = context.character_uuid,
        account_uuid = context.account_uuid,
        session_uuid = context.session_uuid,
        wallet_uuid = wallet_uuid,
        checking_uuid = checking_uuid,
        wallet_number = 'CASH-' .. compact_uuid(wallet_uuid):sub(-16),
        checking_number = 'SA-' .. compact_uuid(checking_uuid):sub(-16),
        transaction_uuid = transaction_uuid,
        operation_uuid = operation_uuid,
        transaction_number = 'TX-' .. compact_uuid(transaction_uuid),
        cash_minor = cash_minor,
        checking_minor = checking_minor,
        request_id = request_id,
        correlation_id = correlation_id,
        payload_sha256 = payload_sha256.payload_sha256,
    })
    if not committed.ok then
        local recovered, recovered_error = Repository.starter_transaction(context.character_uuid)
        if recovered_error then
            return nil, recovered_error
        end
        if recovered then
            return recovered, nil, true
        end
        return nil, committed
    end
    local created, created_error = Repository.starter_transaction(context.character_uuid)
    if created_error then
        return nil, created_error
    end
    if not created then
        return nil, failure('INTERNAL_ERROR', 'banking.error.provision_failed', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_banking', 'banking.starter_posted', {
        character_uuid = context.character_uuid,
        transaction_uuid = created.transaction_uuid,
        transaction_number = created.transaction_number,
        amount_minor = cash_minor + checking_minor,
        currency = 'USD',
        correlation_id = correlation_id,
    })
    return created, nil, false
end

local function build_snapshot(context, repeated, correlation_id)
    local account_rows, accounts_error = Repository.accounts(context.character_uuid)
    if accounts_error then
        return accounts_error
    end
    local accounts = {}
    for _, row in ipairs(account_rows) do
        local account = Policy.normalize_account(row)
        if not account then
            return failure('INTERNAL_ERROR', 'banking.error.invalid_account', {}, correlation_id)
        end
        accounts[#accounts + 1] = account
    end
    if #accounts ~= 2 then
        return failure('INTERNAL_ERROR', 'banking.error.accounts_missing', {}, correlation_id)
    end
    local rows, transactions_error = Repository.recent_transactions(context.character_uuid)
    if transactions_error then
        return transactions_error
    end
    local transactions = {}
    for _, row in ipairs(rows) do
        transactions[#transactions + 1] = {
            transaction_uuid = row.transaction_uuid,
            transaction_number = row.transaction_number,
            transaction_type = row.transaction_type,
            status = row.status,
            amount_minor = tonumber(row.amount_minor),
            direction = row.direction,
            currency = row.currency,
            purpose = row.purpose,
            posted_at = row.posted_at,
        }
    end
    return success({
        currency = 'USD',
        starter_provisioned = true,
        repeated = repeated,
        accounts = accounts,
        recent_transactions = transactions,
    }, correlation_id)
end

local function transfer_receipt(context, transaction, repeated, correlation_id)
    local snapshot = build_snapshot(context, true, correlation_id)
    if not snapshot.ok then
        return snapshot
    end
    return success({
        repeated = repeated,
        operation_uuid = transaction.operation_uuid,
        transaction_uuid = transaction.transaction_uuid,
        transaction_number = transaction.transaction_number,
        source_account_number = transaction.source_account_number,
        recipient_account_number = transaction.recipient_account_number,
        amount_minor = tonumber(transaction.amount_minor),
        currency = transaction.currency,
        purpose = transaction.purpose,
        posted_at = transaction.posted_at,
        snapshot = snapshot.data,
    }, correlation_id)
end

function Service.snapshot(player_source, payload, correlation_id)
    local validated, validation_error = Policy.validate_snapshot(payload)
    if not validated then
        return failure(
            'VALIDATION_ERROR',
            'banking.error.invalid_request',
            { field = validation_error },
            correlation_id
        )
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local _, provision_error, repeated =
        ensure_starter(context, validated.request_id, correlation_id)
    if provision_error then
        return provision_error
    end
    return build_snapshot(context, repeated, correlation_id)
end

function Service.provision_for_source(player_source, correlation_id)
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local request_id = 'banking-spawn-' .. exports.cnr_core:create_uuid_v7()
    local transaction, provision_error, repeated =
        ensure_starter(context, request_id, correlation_id)
    if provision_error then
        return provision_error
    end
    return success({
        transaction_uuid = transaction.transaction_uuid,
        repeated = repeated,
    }, correlation_id)
end

function Service.transfer(player_source, payload, correlation_id)
    local validated, validation_error = Policy.validate_transfer(payload)
    if not validated then
        return failure(
            'VALIDATION_ERROR',
            'banking.error.invalid_transfer',
            { field = validation_error },
            correlation_id
        )
    end
    local context, context_error = source_context(player_source, correlation_id)
    if not context then
        return context_error
    end
    local _, provision_error = ensure_starter(context, validated.request_id, correlation_id)
    if provision_error then
        return provision_error
    end

    local hash, hash_error = Repository.transfer_payload_hash(
        context.character_uuid,
        validated.recipient_account_number,
        validated.amount_minor,
        validated.purpose,
        validated.contract_version
    )
    if hash_error then
        return hash_error
    end
    if not hash or type(hash.payload_sha256) ~= 'string' then
        return failure('INTERNAL_ERROR', 'banking.error.hash_failed', {}, correlation_id)
    end

    local existing, existing_error = Repository.transfer_transaction(validated.operation_uuid)
    if existing_error then
        return existing_error
    end
    if existing then
        if existing.payload_sha256 ~= hash.payload_sha256 then
            return failure('CONFLICT', 'banking.error.operation_conflict', {}, correlation_id)
        end
        return transfer_receipt(context, existing, true, correlation_id)
    end

    local transfer_context, transfer_context_error =
        Repository.transfer_context(context.character_uuid, validated.recipient_account_number)
    if transfer_context_error then
        return transfer_context_error
    end
    if not transfer_context then
        return failure(
            'PRECONDITION_FAILED',
            'banking.error.recipient_unavailable',
            {},
            correlation_id
        )
    end
    local settings, settings_error = Repository.settings()
    if settings_error then
        return settings_error
    end
    if
        not settings.maximum_transfer_minor
        or validated.amount_minor > settings.maximum_transfer_minor
    then
        return failure('VALIDATION_ERROR', 'banking.error.transfer_limit', {}, correlation_id)
    end
    if tonumber(transfer_context.source_balance_minor) < validated.amount_minor then
        return failure(
            'PRECONDITION_FAILED',
            'banking.error.insufficient_funds',
            {},
            correlation_id
        )
    end

    local transaction_uuid = exports.cnr_core:create_uuid_v7()
    local committed = Repository.post_transfer({
        source_id = tonumber(transfer_context.source_id),
        source_version = tonumber(transfer_context.source_version),
        destination_id = tonumber(transfer_context.destination_id),
        destination_version = tonumber(transfer_context.destination_version),
        character_uuid = context.character_uuid,
        account_uuid = context.account_uuid,
        session_uuid = context.session_uuid,
        transaction_uuid = transaction_uuid,
        operation_uuid = validated.operation_uuid,
        transaction_number = 'TX-' .. compact_uuid(transaction_uuid),
        amount_minor = validated.amount_minor,
        purpose = validated.purpose,
        request_id = validated.request_id,
        correlation_id = correlation_id,
        payload_sha256 = hash.payload_sha256,
    })
    local posted, posted_error = Repository.transfer_transaction(validated.operation_uuid)
    if posted_error then
        return posted_error
    end
    if not posted then
        if not committed.ok then
            return committed
        end
        local refreshed =
            Repository.transfer_context(context.character_uuid, validated.recipient_account_number)
        if refreshed and tonumber(refreshed.source_balance_minor) < validated.amount_minor then
            return failure(
                'PRECONDITION_FAILED',
                'banking.error.insufficient_funds',
                {},
                correlation_id
            )
        end
        return failure('PRECONDITION_FAILED', 'banking.error.concurrent_change', {}, correlation_id)
    end
    if posted.payload_sha256 ~= hash.payload_sha256 then
        return failure('CONFLICT', 'banking.error.operation_conflict', {}, correlation_id)
    end
    exports.cnr_logs:audit('cnr_banking', 'banking.transfer_posted', {
        character_uuid = context.character_uuid,
        transaction_uuid = posted.transaction_uuid,
        operation_uuid = validated.operation_uuid,
        amount_minor = validated.amount_minor,
        currency = 'USD',
        correlation_id = correlation_id,
    })
    return transfer_receipt(context, posted, false, correlation_id)
end

return Service
