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
        t.status, t.amount_minor, t.currency, t.purpose,
        DATE_FORMAT(t.posted_at,'%%Y-%%m-%%dT%%H:%%i:%%sZ') posted_at
        FROM cnr_financial_transactions t
        WHERE t.character_uuid=UNHEX(REPLACE(?,'-',''))
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
