-- Encapsulates character lifecycle, binding, appearance, and spawn transactions.
local Repository = {}
local uuid = [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))]]

local function single(sql, values)
    local result = exports.cnr_database:single(sql, values or {})
    if not result.ok then
        return nil, result
    end
    return result.data
end

local function decode_appearance(row)
    if not row or not row.model then
        return nil
    end
    local ok, features = pcall(json.decode, row.face_features)
    if not ok or type(features) ~= 'table' then
        return nil
    end
    return {
        model = row.model,
        shape_first = tonumber(row.shape_first),
        shape_second = tonumber(row.shape_second),
        shape_mix = tonumber(row.shape_mix),
        skin_mix = tonumber(row.skin_mix),
        face_features = features,
        hair_style = tonumber(row.hair_style),
        hair_texture = tonumber(row.hair_texture),
        hair_color = tonumber(row.hair_color),
        hair_highlight = tonumber(row.hair_highlight),
        eye_color = tonumber(row.eye_color),
        outfit_code = row.outfit_code,
        version = tonumber(row.appearance_version or row.version),
    }
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

function Repository.appearance(character_id)
    local row, err = single(
        [[SELECT model, shape_first, shape_second, shape_mix, skin_mix, face_features,
        hair_style, hair_texture, hair_color, hair_highlight, eye_color, outfit_code,
        version appearance_version FROM cnr_character_appearances WHERE character_id=? LIMIT 1]],
        { character_id }
    )
    if err then
        return nil, err
    end
    return decode_appearance(row)
end

function Repository.state_document(character_id)
    return single(
        ([[SELECT %s document_uuid FROM cnr_character_documents d
        INNER JOIN cnr_document_types dt ON dt.id=d.document_type_id
        WHERE d.character_id=? AND dt.code='state_id' AND d.status='ACTIVE' LIMIT 1]]):format(
            uuid:format('d.public_uuid')
        ),
        { character_id }
    )
end

function Repository.last_safe_location(character_id)
    return single(
        [[SELECT x, y, z, heading, location_type FROM cnr_character_locations
        WHERE character_id=? AND is_safe=1 LIMIT 1]],
        { character_id }
    )
end

function Repository.binding_for_session(session_id)
    local row, err = single(
        ([[SELECT b.id binding_id, %s binding_uuid, %s operation_uuid,
        LOWER(HEX(b.payload_sha256)) payload_sha256, b.status binding_status,
        b.routing_bucket, %s spawn_uuid, b.spawn_state, b.spawn_reason,
        b.spawn_x, b.spawn_y, b.spawn_z, b.spawn_heading,
        c.id character_id, %s character_uuid, c.slot_number, c.status,
        i.first_name, i.last_name, DATE_FORMAT(i.date_of_birth,'%%Y-%%m-%%d') date_of_birth,
        bg.code background_code, a.model, a.shape_first, a.shape_second, a.shape_mix,
        a.skin_mix, a.face_features, a.hair_style, a.hair_texture, a.hair_color,
        a.hair_highlight, a.eye_color, a.outfit_code, a.version appearance_version
        FROM cnr_character_session_bindings b
        INNER JOIN cnr_characters c ON c.id=b.character_id
        INNER JOIN cnr_character_identities i ON i.character_id=c.id
        INNER JOIN cnr_character_backgrounds bg ON bg.id=i.background_id
        LEFT JOIN cnr_character_appearances a ON a.character_id=c.id
        WHERE b.session_id=? LIMIT 1]]):format(
            uuid:format('b.public_uuid'),
            uuid:format('b.operation_uuid'),
            uuid:format('b.spawn_uuid'),
            uuid:format('c.public_uuid')
        ),
        { session_id }
    )
    if err then
        return nil, err
    end
    if row then
        row.appearance = decode_appearance(row)
    end
    return row
end

function Repository.find_selection_operation(operation_uuid)
    return single(
        ([[SELECT %s operation_uuid, %s account_uuid, %s binding_uuid,
        %s character_uuid, LOWER(HEX(b.payload_sha256)) payload_sha256,
        b.session_id, b.spawn_state
        FROM cnr_character_session_bindings b
        INNER JOIN cnr_accounts a ON a.id=b.account_id
        INNER JOIN cnr_characters c ON c.id=b.character_id
        WHERE b.operation_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('b.operation_uuid'),
            uuid:format('a.public_uuid'),
            uuid:format('b.public_uuid'),
            uuid:format('c.public_uuid')
        ),
        { operation_uuid }
    )
end

function Repository.find_appearance_operation(operation_uuid)
    return single(
        ([[SELECT %s operation_uuid, %s account_uuid, %s character_uuid,
        LOWER(HEX(o.payload_sha256)) payload_sha256, o.session_id, o.result_version
        FROM cnr_character_appearance_operations o
        INNER JOIN cnr_accounts a ON a.id=o.account_id
        INNER JOIN cnr_characters c ON c.id=o.character_id
        WHERE o.operation_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('o.operation_uuid'),
            uuid:format('a.public_uuid'),
            uuid:format('c.public_uuid')
        ),
        { operation_uuid }
    )
end

function Repository.selection_payload_hash(payload)
    return single(
        [[SELECT LOWER(SHA2(CONCAT('SELECT|', ?, '|', ?),256)) payload_sha256]],
        { payload.character_uuid, payload.contract_version }
    )
end

function Repository.appearance_payload_hash(payload)
    local values = {
        'APPEARANCE',
        payload.model,
        payload.shape_first,
        payload.shape_second,
        payload.shape_mix,
        payload.skin_mix,
    }
    for index = 1, 20 do
        values[#values + 1] = payload.face_features[index]
    end
    values[#values + 1] = payload.hair_style
    values[#values + 1] = payload.hair_texture
    values[#values + 1] = payload.hair_color
    values[#values + 1] = payload.hair_highlight
    values[#values + 1] = payload.eye_color
    values[#values + 1] = payload.outfit_code
    values[#values + 1] = payload.contract_version
    return single([[SELECT LOWER(SHA2(?,256)) payload_sha256]], { table.concat(values, '|') })
end

function Repository.create_binding(context)
    if context.spawn_state == 'APPEARANCE_REQUIRED' then
        return exports.cnr_database:transaction({
            {
                query = [[INSERT INTO cnr_character_session_bindings
                (public_uuid, operation_uuid, account_id, session_id, character_id, request_id,
                correlation_id, contract_version, payload_sha256, status, routing_bucket,
                spawn_uuid, spawn_state, spawn_reason, spawn_x, spawn_y, spawn_z, spawn_heading,
                selected_at)
                VALUES (UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,?,?,?,?,?,UNHEX(?),
                'ACTIVE',?,NULL,'APPEARANCE_REQUIRED',NULL,NULL,NULL,NULL,NULL,UTC_TIMESTAMP(6))]],
                values = {
                    context.binding_uuid,
                    context.operation_uuid,
                    context.account_id,
                    context.session_id,
                    context.character_id,
                    context.request_id,
                    context.correlation_id,
                    context.contract_version,
                    context.payload_sha256,
                    context.routing_bucket,
                },
            },
        })
    end
    return exports.cnr_database:transaction({
        {
            query = [[INSERT INTO cnr_character_session_bindings
            (public_uuid, operation_uuid, account_id, session_id, character_id, request_id,
            correlation_id, contract_version, payload_sha256, status, routing_bucket, spawn_uuid,
            spawn_state, spawn_reason, spawn_x, spawn_y, spawn_z, spawn_heading, selected_at)
            VALUES (UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,?,?,?,?,?,UNHEX(?),
            'ACTIVE',?,UNHEX(REPLACE(?,'-','')),?,?,?,?,?,?,UTC_TIMESTAMP(6))]],
            values = {
                context.binding_uuid,
                context.operation_uuid,
                context.account_id,
                context.session_id,
                context.character_id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.payload_sha256,
                context.routing_bucket,
                context.spawn_uuid,
                context.spawn_state,
                context.spawn_reason,
                context.spawn_x,
                context.spawn_y,
                context.spawn_z,
                context.spawn_heading,
            },
        },
    })
end

function Repository.save_appearance(context)
    return exports.cnr_database:transaction({
        {
            query = [[INSERT INTO cnr_character_appearances
            (character_id, public_uuid, model, shape_first, shape_second, shape_mix, skin_mix,
            face_features, hair_style, hair_texture, hair_color, hair_highlight, eye_color,
            outfit_code, version, created_at, updated_at)
            VALUES (?,UNHEX(REPLACE(?,'-','')),?,?,?,?,?,?,?,?,?,?,?,? ,1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))
            ON DUPLICATE KEY UPDATE model=VALUES(model), shape_first=VALUES(shape_first),
            shape_second=VALUES(shape_second), shape_mix=VALUES(shape_mix), skin_mix=VALUES(skin_mix),
            face_features=VALUES(face_features), hair_style=VALUES(hair_style),
            hair_texture=VALUES(hair_texture), hair_color=VALUES(hair_color),
            hair_highlight=VALUES(hair_highlight), eye_color=VALUES(eye_color),
            outfit_code=VALUES(outfit_code), version=version+1, updated_at=UTC_TIMESTAMP(6)]],
            values = {
                context.character_id,
                context.appearance_uuid,
                context.appearance.model,
                context.appearance.shape_first,
                context.appearance.shape_second,
                context.appearance.shape_mix,
                context.appearance.skin_mix,
                context.face_features_json,
                context.appearance.hair_style,
                context.appearance.hair_texture,
                context.appearance.hair_color,
                context.appearance.hair_highlight,
                context.appearance.eye_color,
                context.appearance.outfit_code,
            },
        },
        {
            query = [[INSERT INTO cnr_character_appearance_operations
            (operation_uuid, account_id, session_id, character_id, request_id, correlation_id,
            contract_version, payload_sha256, result_version, created_at, completed_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,?,?,?,?,?,UNHEX(?),?,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = {
                context.operation_uuid,
                context.account_id,
                context.session_id,
                context.character_id,
                context.request_id,
                context.correlation_id,
                context.contract_version,
                context.payload_sha256,
                context.result_version,
            },
        },
        {
            query = [[UPDATE cnr_character_session_bindings SET routing_bucket=0,
            spawn_uuid=UNHEX(REPLACE(?,'-','')), spawn_state='PENDING', spawn_reason=?,
            spawn_x=?, spawn_y=?, spawn_z=?, spawn_heading=?
            WHERE id=? AND session_id=? AND character_id=? AND status='ACTIVE'
            AND spawn_state='APPEARANCE_REQUIRED']],
            values = {
                context.spawn_uuid,
                context.spawn_reason,
                context.spawn_x,
                context.spawn_y,
                context.spawn_z,
                context.spawn_heading,
                context.binding_id,
                context.session_id,
                context.character_id,
            },
        },
    })
end

function Repository.mark_spawned(context)
    return exports.cnr_database:transaction({
        {
            query = [[UPDATE cnr_character_session_bindings SET spawn_state='SPAWNED',
            spawned_at=UTC_TIMESTAMP(6) WHERE id=? AND session_id=? AND status='ACTIVE'
            AND spawn_state='PENDING' AND spawn_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { context.binding_id, context.session_id, context.spawn_uuid },
        },
        {
            query = [[INSERT INTO cnr_character_locations
            (character_id, x, y, z, heading, location_type, is_safe, updated_at)
            VALUES (?,?,?,?,?,'LAST_SAFE',1,UTC_TIMESTAMP(6))
            ON DUPLICATE KEY UPDATE x=VALUES(x), y=VALUES(y), z=VALUES(z),
            heading=VALUES(heading), location_type='LAST_SAFE', is_safe=1,
            updated_at=UTC_TIMESTAMP(6)]],
            values = {
                context.character_id,
                context.spawn_x,
                context.spawn_y,
                context.spawn_z,
                context.spawn_heading,
            },
        },
    })
end

function Repository.end_binding_for_session(session_id)
    local result = exports.cnr_database:query(
        [[UPDATE cnr_character_session_bindings SET status='ENDED', spawn_state='ENDED',
        ended_at=UTC_TIMESTAMP(6) WHERE session_id=? AND status='ACTIVE']],
        { session_id }
    )
    return result
end

function Repository.close_stale_bindings()
    return exports.cnr_database:query([[UPDATE cnr_character_session_bindings b
        INNER JOIN cnr_account_sessions s ON s.id=b.session_id
        SET b.status='ENDED', b.spawn_state='ENDED', b.ended_at=UTC_TIMESTAMP(6)
        WHERE b.status='ACTIVE' AND s.status<>'ACTIVE']])
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
