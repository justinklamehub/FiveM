-- migrate:up
-- Extends the immutable ledger with replay-safe character-to-character checking transfers.
ALTER TABLE cnr_financial_accounts
    ADD COLUMN last_operation_uuid BINARY(16) NULL AFTER version,
    ADD KEY ix_cnr_financial_accounts_last_operation (last_operation_uuid);

ALTER TABLE cnr_financial_transactions
    DROP CONSTRAINT ck_cnr_financial_transactions_type,
    DROP CONSTRAINT ck_cnr_financial_transactions_contract,
    ADD COLUMN source_financial_account_uuid BINARY(16) NULL AFTER account_uuid,
    ADD COLUMN destination_financial_account_uuid BINARY(16) NULL
        AFTER source_financial_account_uuid,
    ADD KEY ix_cnr_financial_transactions_source (source_financial_account_uuid, posted_at),
    ADD KEY ix_cnr_financial_transactions_destination
        (destination_financial_account_uuid, posted_at),
    ADD CONSTRAINT fk_cnr_financial_transactions_source FOREIGN KEY
        (source_financial_account_uuid) REFERENCES cnr_financial_accounts (public_uuid),
    ADD CONSTRAINT fk_cnr_financial_transactions_destination FOREIGN KEY
        (destination_financial_account_uuid) REFERENCES cnr_financial_accounts (public_uuid),
    ADD CONSTRAINT ck_cnr_financial_transactions_type CHECK (
        (
            transaction_type='STARTER_ALLOCATION'
            AND source_financial_account_uuid IS NULL
            AND destination_financial_account_uuid IS NULL
        )
        OR (
            transaction_type='BANK_TRANSFER'
            AND source_financial_account_uuid IS NOT NULL
            AND destination_financial_account_uuid IS NOT NULL
            AND source_financial_account_uuid <> destination_financial_account_uuid
        )
    ),
    ADD CONSTRAINT ck_cnr_financial_transactions_contract CHECK (
        (transaction_type='STARTER_ALLOCATION' AND contract_version=1)
        OR (transaction_type='BANK_TRANSFER' AND contract_version=2)
    );

INSERT INTO cnr_banking_settings (settings_key, integer_value)
VALUES ('maximum_transfer_minor', 100000000);

-- migrate:down
DELETE entry_row FROM cnr_financial_entries entry_row
INNER JOIN cnr_financial_transactions transaction_row
    ON transaction_row.id=entry_row.transaction_id
WHERE transaction_row.transaction_type='BANK_TRANSFER';
DELETE FROM cnr_financial_transactions WHERE transaction_type='BANK_TRANSFER';
DELETE FROM cnr_banking_settings WHERE settings_key='maximum_transfer_minor';

ALTER TABLE cnr_financial_transactions
    DROP CONSTRAINT ck_cnr_financial_transactions_contract,
    DROP CONSTRAINT ck_cnr_financial_transactions_type,
    DROP FOREIGN KEY fk_cnr_financial_transactions_destination,
    DROP FOREIGN KEY fk_cnr_financial_transactions_source,
    DROP KEY ix_cnr_financial_transactions_destination,
    DROP KEY ix_cnr_financial_transactions_source,
    DROP COLUMN destination_financial_account_uuid,
    DROP COLUMN source_financial_account_uuid,
    ADD CONSTRAINT ck_cnr_financial_transactions_type CHECK (
        transaction_type='STARTER_ALLOCATION'
    ),
    ADD CONSTRAINT ck_cnr_financial_transactions_contract CHECK (contract_version=1);

ALTER TABLE cnr_financial_accounts
    DROP KEY ix_cnr_financial_accounts_last_operation,
    DROP COLUMN last_operation_uuid;
