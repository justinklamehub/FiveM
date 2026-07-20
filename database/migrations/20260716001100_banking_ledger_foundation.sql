-- migrate:up
-- Creates server-owned character accounts and an immutable double-entry starter ledger.
CREATE TABLE cnr_banking_settings (
    settings_key VARCHAR(64) NOT NULL,
    integer_value BIGINT NOT NULL,
    PRIMARY KEY (settings_key),
    CONSTRAINT ck_cnr_banking_settings_value CHECK (integer_value >= 0)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_financial_accounts (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_number VARCHAR(32) NOT NULL,
    owner_type VARCHAR(16) NOT NULL,
    owner_character_uuid BINARY(16) NULL,
    account_type VARCHAR(32) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'USD',
    status VARCHAR(24) NOT NULL DEFAULT 'ACTIVE',
    version INT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_financial_accounts_uuid (public_uuid),
    UNIQUE KEY uq_cnr_financial_accounts_number (account_number),
    UNIQUE KEY uq_cnr_financial_accounts_character_type
        (owner_character_uuid, account_type, currency),
    KEY ix_cnr_financial_accounts_owner (owner_character_uuid, status),
    CONSTRAINT ck_cnr_financial_accounts_owner CHECK (
        (owner_type='CHARACTER' AND owner_character_uuid IS NOT NULL
            AND account_type IN ('CASH_WALLET','PERSONAL_CHECKING'))
        OR (owner_type='SYSTEM' AND owner_character_uuid IS NULL
            AND account_type='SYSTEM_SOURCE')
    ),
    CONSTRAINT ck_cnr_financial_accounts_currency CHECK (currency='USD'),
    CONSTRAINT ck_cnr_financial_accounts_status CHECK (
        status IN ('ACTIVE','RESTRICTED','FROZEN','BLOCKED','CLOSED','PENDING_CLOSURE')
    ),
    CONSTRAINT ck_cnr_financial_accounts_version CHECK (version > 0)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_financial_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    operation_uuid BINARY(16) NOT NULL,
    transaction_number VARCHAR(40) NOT NULL,
    transaction_type VARCHAR(32) NOT NULL,
    status VARCHAR(16) NOT NULL,
    character_uuid BINARY(16) NOT NULL,
    account_uuid BINARY(16) NOT NULL,
    session_uuid BINARY(16) NOT NULL,
    amount_minor BIGINT UNSIGNED NOT NULL,
    currency CHAR(3) NOT NULL,
    purpose VARCHAR(120) NOT NULL,
    source_module VARCHAR(64) NOT NULL,
    request_id VARCHAR(96) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    starter_character_uuid BINARY(16)
        AS (CASE WHEN transaction_type='STARTER_ALLOCATION' THEN character_uuid ELSE NULL END) STORED,
    created_at DATETIME(6) NOT NULL,
    posted_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_financial_transactions_uuid (public_uuid),
    UNIQUE KEY uq_cnr_financial_transactions_operation (operation_uuid),
    UNIQUE KEY uq_cnr_financial_transactions_number (transaction_number),
    UNIQUE KEY uq_cnr_financial_transactions_starter (starter_character_uuid),
    KEY ix_cnr_financial_transactions_character (character_uuid, posted_at),
    CONSTRAINT ck_cnr_financial_transactions_type CHECK (
        transaction_type='STARTER_ALLOCATION'
    ),
    CONSTRAINT ck_cnr_financial_transactions_status CHECK (status='POSTED'),
    CONSTRAINT ck_cnr_financial_transactions_amount CHECK (amount_minor > 0),
    CONSTRAINT ck_cnr_financial_transactions_currency CHECK (currency='USD'),
    CONSTRAINT ck_cnr_financial_transactions_contract CHECK (contract_version=1)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_financial_entries (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    transaction_id BIGINT UNSIGNED NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    entry_sequence TINYINT UNSIGNED NOT NULL,
    signed_amount_minor BIGINT NOT NULL,
    created_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_financial_entries_sequence (transaction_id, entry_sequence),
    KEY ix_cnr_financial_entries_account (account_id, created_at),
    CONSTRAINT fk_cnr_financial_entries_transaction FOREIGN KEY (transaction_id)
        REFERENCES cnr_financial_transactions (id),
    CONSTRAINT fk_cnr_financial_entries_account FOREIGN KEY (account_id)
        REFERENCES cnr_financial_accounts (id),
    CONSTRAINT ck_cnr_financial_entries_sequence CHECK (entry_sequence BETWEEN 1 AND 16),
    CONSTRAINT ck_cnr_financial_entries_amount CHECK (signed_amount_minor <> 0)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_banking_settings (settings_key, integer_value) VALUES
('starter_cash_minor', 5000),
('starter_checking_minor', 25000);

INSERT INTO cnr_financial_accounts
(public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7000-7000-8000-000000000001','-','')),
'SYSTEM-STARTER-SOURCE', 'SYSTEM', NULL, 'SYSTEM_SOURCE', 'USD', 'ACTIVE', 1,
UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

-- migrate:down
DROP TABLE IF EXISTS cnr_financial_entries;
DROP TABLE IF EXISTS cnr_financial_transactions;
DROP TABLE IF EXISTS cnr_financial_accounts;
DROP TABLE IF EXISTS cnr_banking_settings;
