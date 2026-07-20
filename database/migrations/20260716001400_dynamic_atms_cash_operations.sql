-- migrate:up
-- Adds persistent, permission-managed ATMs and replay-safe cash/checking ledger movements.
INSERT INTO cnr_technical_permissions (
    public_uuid,
    code,
    label_key,
    description_key,
    is_system,
    is_active,
    created_at,
    updated_at
)
VALUES (
    UNHEX(REPLACE('0190b7a0-7400-7000-8000-000000000001', '-', '')),
    'banking.atms.manage',
    'permissions.permission.banking_atms_manage.label',
    'permissions.permission.banking_atms_manage.description',
    1,
    1,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6)
);

INSERT INTO cnr_technical_role_permissions (role_id, permission_id, created_at)
SELECT role_row.id, permission_row.id, UTC_TIMESTAMP(6)
FROM cnr_technical_roles AS role_row
INNER JOIN cnr_technical_permissions AS permission_row
    ON permission_row.code = 'banking.atms.manage'
WHERE role_row.code IN ('owner', 'administrator');

CREATE TABLE cnr_atms (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    code VARCHAR(64) NOT NULL,
    label VARCHAR(96) NOT NULL,
    coordinate_x DECIMAL(11, 4) NOT NULL,
    coordinate_y DECIMAL(11, 4) NOT NULL,
    coordinate_z DECIMAL(11, 4) NOT NULL,
    heading DECIMAL(7, 3) NOT NULL DEFAULT 0,
    interaction_radius DECIMAL(5, 2) NOT NULL DEFAULT 2.50,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    version INT UNSIGNED NOT NULL DEFAULT 1,
    created_by_account_uuid BINARY(16) NULL,
    deactivated_by_account_uuid BINARY(16) NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    deactivated_at DATETIME(6) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_atms_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_atms_code (code),
    KEY ix_cnr_atms_active_location (status, coordinate_x, coordinate_y, coordinate_z),
    CONSTRAINT fk_cnr_atms_created_by FOREIGN KEY (created_by_account_uuid)
        REFERENCES cnr_accounts (public_uuid),
    CONSTRAINT fk_cnr_atms_deactivated_by FOREIGN KEY (deactivated_by_account_uuid)
        REFERENCES cnr_accounts (public_uuid),
    CONSTRAINT ck_cnr_atms_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT ck_cnr_atms_radius CHECK (interaction_radius BETWEEN 1.00 AND 10.00),
    CONSTRAINT ck_cnr_atms_version CHECK (version > 0),
    CONSTRAINT ck_cnr_atms_deactivation CHECK (
        (status = 'ACTIVE' AND deactivated_by_account_uuid IS NULL AND deactivated_at IS NULL)
        OR (status = 'INACTIVE' AND deactivated_at IS NOT NULL)
    )
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_atms (
    public_uuid,
    code,
    label,
    coordinate_x,
    coordinate_y,
    coordinate_z,
    heading,
    interaction_radius,
    status,
    version,
    created_at,
    updated_at
)
VALUES (
    UNHEX(REPLACE('0190b7a0-7400-7000-8000-000000000010', '-', '')),
    'ATM-LEGION-PARKING',
    'Legion Square Parking ATM',
    215.7600,
    -810.1200,
    30.7300,
    157.000,
    3.00,
    'ACTIVE',
    1,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6)
);

ALTER TABLE cnr_financial_transactions
    DROP CONSTRAINT ck_cnr_financial_transactions_type,
    DROP CONSTRAINT ck_cnr_financial_transactions_contract,
    ADD COLUMN atm_uuid BINARY(16) NULL AFTER destination_financial_account_uuid,
    ADD KEY ix_cnr_financial_transactions_atm (atm_uuid, posted_at),
    ADD CONSTRAINT fk_cnr_financial_transactions_atm FOREIGN KEY (atm_uuid)
        REFERENCES cnr_atms (public_uuid),
    ADD CONSTRAINT ck_cnr_financial_transactions_type CHECK (
        (
            transaction_type = 'STARTER_ALLOCATION'
            AND source_financial_account_uuid IS NULL
            AND destination_financial_account_uuid IS NULL
            AND atm_uuid IS NULL
        )
        OR (
            transaction_type = 'BANK_TRANSFER'
            AND source_financial_account_uuid IS NOT NULL
            AND destination_financial_account_uuid IS NOT NULL
            AND source_financial_account_uuid <> destination_financial_account_uuid
            AND atm_uuid IS NULL
        )
        OR (
            transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL')
            AND source_financial_account_uuid IS NOT NULL
            AND destination_financial_account_uuid IS NOT NULL
            AND source_financial_account_uuid <> destination_financial_account_uuid
            AND atm_uuid IS NOT NULL
        )
    ),
    ADD CONSTRAINT ck_cnr_financial_transactions_contract CHECK (
        (transaction_type = 'STARTER_ALLOCATION' AND contract_version = 1)
        OR (transaction_type = 'BANK_TRANSFER' AND contract_version = 2)
        OR (transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL') AND contract_version = 1)
    );

INSERT INTO cnr_banking_settings (settings_key, integer_value)
VALUES ('maximum_atm_operation_minor', 10000000);

-- migrate:down
DELETE entry_row FROM cnr_financial_entries AS entry_row
INNER JOIN cnr_financial_transactions AS transaction_row
    ON transaction_row.id = entry_row.transaction_id
WHERE transaction_row.transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL');
DELETE FROM cnr_financial_transactions
WHERE transaction_type IN ('ATM_DEPOSIT', 'ATM_WITHDRAWAL');
DELETE FROM cnr_banking_settings WHERE settings_key = 'maximum_atm_operation_minor';

ALTER TABLE cnr_financial_transactions
    DROP CONSTRAINT ck_cnr_financial_transactions_contract,
    DROP CONSTRAINT ck_cnr_financial_transactions_type,
    DROP FOREIGN KEY fk_cnr_financial_transactions_atm,
    DROP KEY ix_cnr_financial_transactions_atm,
    DROP COLUMN atm_uuid,
    ADD CONSTRAINT ck_cnr_financial_transactions_type CHECK (
        (
            transaction_type = 'STARTER_ALLOCATION'
            AND source_financial_account_uuid IS NULL
            AND destination_financial_account_uuid IS NULL
        )
        OR (
            transaction_type = 'BANK_TRANSFER'
            AND source_financial_account_uuid IS NOT NULL
            AND destination_financial_account_uuid IS NOT NULL
            AND source_financial_account_uuid <> destination_financial_account_uuid
        )
    ),
    ADD CONSTRAINT ck_cnr_financial_transactions_contract CHECK (
        (transaction_type = 'STARTER_ALLOCATION' AND contract_version = 1)
        OR (transaction_type = 'BANK_TRANSFER' AND contract_version = 2)
    );

DROP TABLE IF EXISTS cnr_atms;

DELETE role_permission FROM cnr_technical_role_permissions AS role_permission
INNER JOIN cnr_technical_permissions AS permission_row
    ON permission_row.id = role_permission.permission_id
WHERE permission_row.code = 'banking.atms.manage';
DELETE FROM cnr_technical_permissions WHERE code = 'banking.atms.manage';
