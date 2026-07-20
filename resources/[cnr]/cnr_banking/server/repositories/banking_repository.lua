-- Owns financial account persistence and atomic starter funding.
local Repository = {}
local uuid = [[LOWER(INSERT(INSERT(INSERT(INSERT(HEX(%s),9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))]]

local function single(sql, values)
    local result = exports.cnr_database:single(sql, values or {})
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.settings()
    local result =
        exports.cnr_database:query([[SELECT settings_key, integer_value FROM cnr_banking_settings]])
    if not result.ok then
        return nil, result
    end
    local settings = {}
    for _, row in ipairs(result.data) do
        settings[row.settings_key] = tonumber(row.integer_value)
    end
    return settings
end

function Repository.starter_transaction(character_uuid)
    return single(
        ([[SELECT %s transaction_uuid, %s operation_uuid, transaction_number,
        amount_minor, currency, posted_at FROM cnr_financial_transactions
        WHERE transaction_type='STARTER_ALLOCATION'
        AND character_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('public_uuid'),
            uuid:format('operation_uuid')
        ),
        { character_uuid }
    )
end

function Repository.accounts(character_uuid)
    local result = exports.cnr_database:query(
        ([[SELECT %s account_uuid, a.account_number, a.account_type, a.currency,
        a.status, a.version, COALESCE(SUM(e.signed_amount_minor),0) balance_minor
        FROM cnr_financial_accounts a
        LEFT JOIN cnr_financial_entries e ON e.account_id=a.id
        WHERE a.owner_type='CHARACTER'
        AND a.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        GROUP BY a.id ORDER BY FIELD(a.account_type,'CASH_WALLET','PERSONAL_CHECKING')]]):format(
            uuid:format('a.public_uuid')
        ),
        { character_uuid }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.recent_transactions(character_uuid)
    local result = exports.cnr_database:query(
        ([[SELECT %s transaction_uuid, t.transaction_number, t.transaction_type,
        t.status, ABS(SUM(e.signed_amount_minor)) amount_minor, t.currency, t.purpose,
        CASE WHEN SUM(e.signed_amount_minor) < 0 THEN 'DEBIT' ELSE 'CREDIT' END direction,
        DATE_FORMAT(t.posted_at,'%%Y-%%m-%%dT%%H:%%i:%%sZ') posted_at
        FROM cnr_financial_transactions t
        INNER JOIN cnr_financial_entries e ON e.transaction_id=t.id
        INNER JOIN cnr_financial_accounts a ON a.id=e.account_id
        WHERE a.owner_type='CHARACTER'
        AND a.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        GROUP BY t.id
        ORDER BY t.posted_at DESC, t.id DESC LIMIT 20]]):format(
            uuid:format('t.public_uuid')
        ),
        { character_uuid }
    )
    if not result.ok then
        return nil, result
    end
    return result.data
end

function Repository.transfer_transaction(operation_uuid)
    return single(
        ([[SELECT %s transaction_uuid, %s operation_uuid, t.transaction_number,
        t.amount_minor, t.currency, t.purpose, LOWER(HEX(t.payload_sha256)) payload_sha256,
        source.account_number source_account_number,
        destination.account_number recipient_account_number,
        DATE_FORMAT(t.posted_at,'%%Y-%%m-%%dT%%H:%%i:%%sZ') posted_at
        FROM cnr_financial_transactions t
        INNER JOIN cnr_financial_accounts source
            ON source.public_uuid=t.source_financial_account_uuid
        INNER JOIN cnr_financial_accounts destination
            ON destination.public_uuid=t.destination_financial_account_uuid
        WHERE t.transaction_type='BANK_TRANSFER'
        AND t.operation_uuid=UNHEX(REPLACE(?,'-','')) LIMIT 1]]):format(
            uuid:format('t.public_uuid'),
            uuid:format('t.operation_uuid')
        ),
        { operation_uuid }
    )
end

function Repository.transfer_context(character_uuid, recipient_account_number)
    return single(
        ([[SELECT source.id source_id, %s source_uuid,
        source.account_number source_account_number, source.version source_version,
        COALESCE((SELECT SUM(entry.signed_amount_minor) FROM cnr_financial_entries entry
            WHERE entry.account_id=source.id),0) source_balance_minor,
        destination.id destination_id, %s destination_uuid,
        destination.account_number recipient_account_number,
        destination.version destination_version
        FROM cnr_financial_accounts source
        INNER JOIN cnr_financial_accounts destination
            ON destination.account_number=?
            AND destination.owner_type='CHARACTER'
            AND destination.account_type='PERSONAL_CHECKING'
            AND destination.status='ACTIVE'
        WHERE source.owner_type='CHARACTER'
        AND source.owner_character_uuid=UNHEX(REPLACE(?,'-',''))
        AND source.account_type='PERSONAL_CHECKING'
        AND source.status='ACTIVE'
        AND source.id<>destination.id
        LIMIT 1]]):format(
            uuid:format('source.public_uuid'),
            uuid:format('destination.public_uuid')
        ),
        { recipient_account_number, character_uuid }
    )
end

function Repository.transfer_payload_hash(
    character_uuid,
    recipient_account_number,
    amount_minor,
    purpose,
    contract_version
)
    return single(
        [[SELECT LOWER(SHA2(CONCAT('BANK_TRANSFER|',?,'|',?,'|',?,'|',?,'|',?),256))
        payload_sha256]],
        {
            character_uuid,
            recipient_account_number,
            amount_minor,
            purpose,
            contract_version,
        }
    )
end

function Repository.post_transfer(context)
    return exports.cnr_database:transaction({
        {
            query = [[UPDATE cnr_financial_accounts account_row
            SET account_row.version=account_row.version+1,
                account_row.last_operation_uuid=UNHEX(REPLACE(?,'-','')),
                account_row.updated_at=UTC_TIMESTAMP(6)
            WHERE (
                account_row.id=? AND account_row.version=? AND account_row.status='ACTIVE'
                AND COALESCE((SELECT SUM(entry.signed_amount_minor)
                    FROM cnr_financial_entries entry
                    WHERE entry.account_id=account_row.id),0)>=?
            ) OR (
                account_row.id=? AND account_row.version=? AND account_row.status='ACTIVE'
            )]],
            values = {
                context.operation_uuid,
                context.source_id,
                context.source_version,
                context.amount_minor,
                context.destination_id,
                context.destination_version,
            },
        },
        {
            query = [[INSERT INTO cnr_financial_transactions
            (public_uuid, operation_uuid, transaction_number, transaction_type, status,
            character_uuid, account_uuid, source_financial_account_uuid,
            destination_financial_account_uuid, session_uuid, amount_minor, currency, purpose,
            source_module, request_id, correlation_id, contract_version, payload_sha256,
            created_at, posted_at)
            SELECT UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,'BANK_TRANSFER','POSTED',
            UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),source.public_uuid,
            destination.public_uuid,UNHEX(REPLACE(?,'-','')),?,'USD',?,'cnr_banking',?,?,2,
            UNHEX(?),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6)
            FROM cnr_financial_accounts source
            INNER JOIN cnr_financial_accounts destination ON destination.id=?
            WHERE source.id=?
            AND source.last_operation_uuid=UNHEX(REPLACE(?,'-',''))
            AND destination.last_operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = {
                context.transaction_uuid,
                context.operation_uuid,
                context.transaction_number,
                context.character_uuid,
                context.account_uuid,
                context.session_uuid,
                context.amount_minor,
                context.purpose,
                context.request_id,
                context.correlation_id,
                context.payload_sha256,
                context.destination_id,
                context.source_id,
                context.operation_uuid,
                context.operation_uuid,
            },
        },
        {
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT transaction_row.id,source.id,1,?,UTC_TIMESTAMP(6)
            FROM cnr_financial_transactions transaction_row
            INNER JOIN cnr_financial_accounts source
                ON source.public_uuid=transaction_row.source_financial_account_uuid
            WHERE transaction_row.operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { -context.amount_minor, context.operation_uuid },
        },
        {
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT transaction_row.id,destination.id,2,?,UTC_TIMESTAMP(6)
            FROM cnr_financial_transactions transaction_row
            INNER JOIN cnr_financial_accounts destination
                ON destination.public_uuid=transaction_row.destination_financial_account_uuid
            WHERE transaction_row.operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { context.amount_minor, context.operation_uuid },
        },
        {
            -- A missing guarded transaction deliberately violates NOT NULL and rolls back
            -- both account version markers instead of committing partial internal state.
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT NULL,NULL,0,0,UTC_TIMESTAMP(6)
            WHERE NOT EXISTS (
                SELECT 1 FROM cnr_financial_transactions
                WHERE operation_uuid=UNHEX(REPLACE(?,'-',''))
            )]],
            values = { context.operation_uuid },
        },
    })
end

function Repository.payload_hash(character_uuid, cash_minor, checking_minor, contract_version)
    return single(
        [[SELECT LOWER(SHA2(CONCAT('STARTER|',?,'|',?,'|',?,'|',?),256)) payload_sha256]],
        { character_uuid, cash_minor, checking_minor, contract_version }
    )
end

function Repository.provision_starter(context)
    local total = context.cash_minor + context.checking_minor
    return exports.cnr_database:transaction({
        {
            query = [[SELECT id FROM cnr_financial_accounts
            WHERE account_type='SYSTEM_SOURCE' AND status='ACTIVE' FOR UPDATE]],
            values = {},
        },
        {
            query = [[INSERT IGNORE INTO cnr_financial_accounts
            (public_uuid, account_number, owner_type, owner_character_uuid, account_type,
            currency, status, version, created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,'CHARACTER',UNHEX(REPLACE(?,'-','')),
            'CASH_WALLET','USD','ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = { context.wallet_uuid, context.wallet_number, context.character_uuid },
        },
        {
            query = [[INSERT IGNORE INTO cnr_financial_accounts
            (public_uuid, account_number, owner_type, owner_character_uuid, account_type,
            currency, status, version, created_at, updated_at)
            VALUES (UNHEX(REPLACE(?,'-','')),?,'CHARACTER',UNHEX(REPLACE(?,'-','')),
            'PERSONAL_CHECKING','USD','ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = { context.checking_uuid, context.checking_number, context.character_uuid },
        },
        {
            query = [[INSERT INTO cnr_financial_transactions
            (public_uuid, operation_uuid, transaction_number, transaction_type, status,
            character_uuid, account_uuid, session_uuid, amount_minor, currency, purpose,
            source_module, request_id, correlation_id, contract_version, payload_sha256,
            created_at, posted_at)
            VALUES (UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,
            'STARTER_ALLOCATION','POSTED',UNHEX(REPLACE(?,'-','')),
            UNHEX(REPLACE(?,'-','')),UNHEX(REPLACE(?,'-','')),?,'USD',
            'Initial character funds','cnr_banking',?,?,1,UNHEX(?),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6))]],
            values = {
                context.transaction_uuid,
                context.operation_uuid,
                context.transaction_number,
                context.character_uuid,
                context.account_uuid,
                context.session_uuid,
                total,
                context.request_id,
                context.correlation_id,
                context.payload_sha256,
            },
        },
        {
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT t.id,a.id,1,?,UTC_TIMESTAMP(6)
            FROM cnr_financial_transactions t
            INNER JOIN cnr_financial_accounts a ON a.account_type='SYSTEM_SOURCE'
            WHERE t.operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { -total, context.operation_uuid },
        },
        {
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT t.id,a.id,2,?,UTC_TIMESTAMP(6)
            FROM cnr_financial_transactions t
            INNER JOIN cnr_financial_accounts a
                ON a.owner_character_uuid=t.character_uuid AND a.account_type='CASH_WALLET'
            WHERE t.operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { context.cash_minor, context.operation_uuid },
        },
        {
            query = [[INSERT INTO cnr_financial_entries
            (transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
            SELECT t.id,a.id,3,?,UTC_TIMESTAMP(6)
            FROM cnr_financial_transactions t
            INNER JOIN cnr_financial_accounts a
                ON a.owner_character_uuid=t.character_uuid
                AND a.account_type='PERSONAL_CHECKING'
            WHERE t.operation_uuid=UNHEX(REPLACE(?,'-',''))]],
            values = { context.checking_minor, context.operation_uuid },
        },
    })
end

return Repository
