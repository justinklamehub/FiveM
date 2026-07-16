-- Encapsulates character queries and atomic draft/activation transactions.
local Repository = {}
local uuid = [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))]]

local function single(sql, values)
    local result = exports.cnr_database:single(sql, values or {})
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.session_for_source(instance_id, player_source)
    return single(
        ([[SELECT s.id session_id, %s session_uuid, a.id account_id, %s account_uuid,
        a.status account_status, s.access_state FROM cnr_account_sessions s
        INNER JOIN cnr_accounts a ON a.id=s.account_id
        WHERE s.server_instance_id=? AND s.source_at_start=? AND s.status='ACTIVE' LIMIT 1]]):format(
            uuid:format('s.public_uuid'),
            uuid:format('a.public_uuid')
        ),
        { instance_id, player_source }
    )
end

function Repository.settings()
    local result = exports.cnr_database:query(
        [[SELECT settings_key, integer_value FROM cnr_character_settings]]
    )
    if not result.ok then
        return nil, result
    end
    local values = {}
    for _, row in ipairs(result.data) do
        values[row.settings_key] = tonumber(row.integer_value)
    end
    return values
end

function Repository.backgrounds()
    local result = exports.cnr_database:query(
        [[SELECT code, label, description FROM cnr_character_backgrounds WHERE is_active=1 ORDER BY sort_order, code]]
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.find_background(code)
    return single(
        [[SELECT id, code FROM cnr_character_backgrounds WHERE code=? AND is_active=1 LIMIT 1]],
        { code }
    )
end

function Repository.list(account_id)
    local result = exports.cnr_database:query(
        ([[SELECT %s character_uuid, c.slot_number, c.status, i.first_name, i.last_name, DATE_FORMAT(i.date_of_birth,'%%Y-%%m-%%d') date_of_birth, b.code background_code
        FROM cnr_characters c INNER JOIN cnr_character_identities i ON i.character_id=c.id
        INNER JOIN cnr_character_backgrounds b ON b.id=i.background_id
        WHERE c.account_id=? AND c.status<>'ARCHIVED' ORDER BY c.slot_number]]):format(
            uuid:format('c.public_uuid')
        ),
        { account_id }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.find_owned(account_id, character_uuid)
    return single(
        ([[SELECT c.id, %s character_uuid, c.status, c.version, c.slot_number,
        i.first_name, i.last_name, DATE_FORMAT(i.date_of_birth,'%%Y-%%m-%%d') date_of_birth, b.code background_code
        FROM cnr_characters c INNER JOIN cnr_character_identities i ON i.character_id=c.id
        INNER JOIN cnr_character_backgrounds b ON b.id=i.background_id
        WHERE c.account_id=? AND c.public_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('c.public_uuid')
        ),
        { account_id, character_uuid }
    )
end

function Repository.payload_hash(action, payload)
    local canonical = action == 'CREATE_DRAFT'
            and table.concat({
                payload.first_name,
                payload.last_name,
                payload.date_of_birth,
                payload.background_code,
                payload.contract_version,
            }, '|')
        or table.concat({ payload.character_uuid, payload.contract_version }, '|')
    return single([[SELECT LOWER(SHA2(?,256)) payload_sha256]], { canonical })
end

function Repository.find_operation(operation_uuid)
    return single(
        ([[SELECT %s operation_uuid, %s account_uuid, %s character_uuid,
        o.action, LOWER(HEX(o.payload_sha256)) payload_sha256, o.result_status
        FROM cnr_character_operations o INNER JOIN cnr_accounts a ON a.id=o.account_id
        INNER JOIN cnr_characters c ON c.id=o.character_id
        WHERE o.operation_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('o.operation_uuid'),
            uuid:format('a.public_uuid'),
            uuid:format('c.public_uuid')
        ),
        { operation_uuid }
    )
end

function Repository.create_draft(context)
    return exports.cnr_database:transaction({
        {
            query = [[INSERT INTO cnr_characters (public_uuid, account_id, slot_number, status, created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')), ?, ?, 'DRAFT', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6))]],
            values = { context.character_uuid, context.account_id, context.slot_number },
        },
        {
            query = [[INSERT INTO cnr_character_identities (character_id, first_name, last_name, date_of_birth, background_id, created_at, updated_at)
            SELECT c.id, ?, ?, ?, ?, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6) FROM cnr_characters c WHERE c.public_uuid=UNHEX(REPLACE(?,'-','')) AND c.account_id=?]],
            values = {
                context.first_name,
                context.last_name,
                context.date_of_birth,
                context.background_id,
                context.character_uuid,
                context.account_id,
            },
        },
        {
            query = [[INSERT INTO cnr_character_operations (operation_uuid, account_id, session_id, character_id, action, request_id, correlation_id, contract_version, payload_sha256, result_status, created_at, completed_at)
            SELECT UNHEX(REPLACE(?,'-','')), ?, ?, c.id, 'CREATE_DRAFT', ?, ?, ?, UNHEX(?), 'DRAFT', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)
            FROM cnr_characters c WHERE c.public_uuid=UNHEX(REPLACE(?,'-','')) AND c.account_id=?]],
            values = {
                context.operation_uuid,
                context.account_id,
                context.session_id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.payload_sha256,
                context.character_uuid,
                context.account_id,
            },
        },
    })
end

function Repository.activate(context)
    return exports.cnr_database:transaction({
        {
            query = [[UPDATE cnr_characters SET status='ACTIVE', version=version+1, activated_at=UTC_TIMESTAMP(6), updated_at=UTC_TIMESTAMP(6) WHERE id=? AND account_id=? AND status='DRAFT' AND version=?]],
            values = { context.character_id, context.account_id, context.character_version },
        },
        {
            query = [[INSERT INTO cnr_character_documents (public_uuid, character_id, document_type_id, document_number, status, issued_at, updated_at)
            SELECT UNHEX(REPLACE(?,'-','')), ?, dt.id, CONCAT(dt.number_prefix,'-',UPPER(RIGHT(REPLACE(?,'-',''),12))), 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)
            FROM cnr_document_types dt WHERE dt.code='state_id' AND dt.is_base_document=1 AND dt.is_active=1]],
            values = { context.document_uuid, context.character_id, context.character_uuid },
        },
        {
            query = [[INSERT INTO cnr_character_operations (operation_uuid, account_id, session_id, character_id, action, request_id, correlation_id, contract_version, payload_sha256, result_status, created_at, completed_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,?,?,'ACTIVATE',?,?,?,UNHEX(?),'ACTIVE',UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = {
                context.operation_uuid,
                context.account_id,
                context.session_id,
                context.character_id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.payload_sha256,
            },
        },
    })
end

return Repository
