-- Exercises account uniqueness, balanced posting, rollback, and starter idempotency.
DELIMITER //
CREATE PROCEDURE assert_banking_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

SET @bank_character_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000001','-',''));
SET @bank_account_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000002','-',''));
SET @bank_session_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000003','-',''));

START TRANSACTION;
INSERT INTO cnr_financial_accounts
(public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000010','-','')),
'CASH-INTEGRATION-1','CHARACTER',@bank_character_uuid,'CASH_WALLET','USD','ACTIVE',1,
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6)),
(UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000011','-','')),
'SA-INTEGRATION-1','CHARACTER',@bank_character_uuid,'PERSONAL_CHECKING','USD','ACTIVE',1,
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));

INSERT INTO cnr_financial_transactions
(public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
account_uuid, session_uuid, amount_minor, currency, purpose, source_module, request_id,
correlation_id, contract_version, payload_sha256, created_at, posted_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000020','-','')),
UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000021','-','')),
'TX-INTEGRATION-STARTER-1','STARTER_ALLOCATION','POSTED',@bank_character_uuid,
@bank_account_uuid,@bank_session_uuid,30000,'USD','Initial character funds','cnr_banking',
'banking-integration-1','banking-correlation-1',1,UNHEX(SHA2('starter',256)),
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
SET @bank_transaction_id = LAST_INSERT_ID();

INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @bank_transaction_id,id,1,-30000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE account_type='SYSTEM_SOURCE';
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @bank_transaction_id,id,2,5000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts
WHERE owner_character_uuid=@bank_character_uuid AND account_type='CASH_WALLET';
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @bank_transaction_id,id,3,25000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts
WHERE owner_character_uuid=@bank_character_uuid AND account_type='PERSONAL_CHECKING';
COMMIT;

CALL assert_banking_true(
    (SELECT SUM(signed_amount_minor)=0 FROM cnr_financial_entries
    WHERE transaction_id=@bank_transaction_id),
    'starter transaction is not balanced'
);
CALL assert_banking_true(
    (SELECT SUM(e.signed_amount_minor)=5000 FROM cnr_financial_entries e
    INNER JOIN cnr_financial_accounts a ON a.id=e.account_id
    WHERE a.owner_character_uuid=@bank_character_uuid AND a.account_type='CASH_WALLET'),
    'cash wallet balance was not derived from entries'
);
CALL assert_banking_true(
    (SELECT SUM(e.signed_amount_minor)=25000 FROM cnr_financial_entries e
    INNER JOIN cnr_financial_accounts a ON a.id=e.account_id
    WHERE a.owner_character_uuid=@bank_character_uuid AND a.account_type='PERSONAL_CHECKING'),
    'checking balance was not derived from entries'
);

DELIMITER //
CREATE PROCEDURE assert_duplicate_bank_account_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_financial_accounts
        (public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
        status, version, created_at, updated_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000012','-','')),
        'CASH-INTEGRATION-DUPLICATE','CHARACTER',@bank_character_uuid,'CASH_WALLET','USD',
        'ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
    END;
    CALL assert_banking_true(duplicate_rejected, 'duplicate character wallet was accepted');
END//
DELIMITER ;
CALL assert_duplicate_bank_account_rejected();

DELIMITER //
CREATE PROCEDURE assert_duplicate_starter_posting_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_financial_transactions
        (public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
        account_uuid, session_uuid, amount_minor, currency, purpose, source_module, request_id,
        correlation_id, contract_version, payload_sha256, created_at, posted_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000022','-','')),
        UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000023','-','')),
        'TX-INTEGRATION-STARTER-2','STARTER_ALLOCATION','POSTED',@bank_character_uuid,
        @bank_account_uuid,@bank_session_uuid,30000,'USD','Initial character funds','cnr_banking',
        'banking-integration-2','banking-correlation-2',1,UNHEX(SHA2('starter',256)),
        UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
    END;
    CALL assert_banking_true(duplicate_rejected, 'duplicate starter transaction was accepted');
END//
DELIMITER ;
CALL assert_duplicate_starter_posting_rejected();

SET @bank_recipient_character_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000040','-',''));
SET @bank_transfer_operation_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000041','-',''));
SET @bank_source_financial_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000011','-',''));
SET @bank_destination_financial_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000042','-',''));

INSERT INTO cnr_financial_accounts
(public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
status, version, created_at, updated_at)
VALUES
(@bank_destination_financial_uuid,'SA-INTEGRATION-RECIPIENT','CHARACTER',
@bank_recipient_character_uuid,'PERSONAL_CHECKING','USD','ACTIVE',1,
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));

START TRANSACTION;
UPDATE cnr_financial_accounts SET version=version+1,
last_operation_uuid=@bank_transfer_operation_uuid, updated_at=UTC_TIMESTAMP(6)
WHERE public_uuid IN (@bank_source_financial_uuid,@bank_destination_financial_uuid);
INSERT INTO cnr_financial_transactions
(public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
account_uuid, source_financial_account_uuid, destination_financial_account_uuid, session_uuid,
amount_minor, currency, purpose, source_module, request_id, correlation_id, contract_version,
payload_sha256, created_at, posted_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000043','-','')),
@bank_transfer_operation_uuid,'TX-INTEGRATION-TRANSFER-1','BANK_TRANSFER','POSTED',
@bank_character_uuid,@bank_account_uuid,@bank_source_financial_uuid,
@bank_destination_financial_uuid,@bank_session_uuid,1250,'USD','Integration transfer',
'cnr_banking','banking-transfer-integration-1','banking-transfer-correlation-1',2,
UNHEX(SHA2('transfer',256)),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
SET @bank_transfer_id = LAST_INSERT_ID();
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @bank_transfer_id,id,1,-1250,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@bank_source_financial_uuid;
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @bank_transfer_id,id,2,1250,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@bank_destination_financial_uuid;
COMMIT;

CALL assert_banking_true(
    (SELECT SUM(signed_amount_minor)=0 FROM cnr_financial_entries
    WHERE transaction_id=@bank_transfer_id),
    'bank transfer is not balanced'
);
CALL assert_banking_true(
    (SELECT SUM(e.signed_amount_minor)=23750 FROM cnr_financial_entries e
    INNER JOIN cnr_financial_accounts a ON a.id=e.account_id
    WHERE a.public_uuid=@bank_source_financial_uuid),
    'sender checking balance is incorrect after transfer'
);
CALL assert_banking_true(
    (SELECT SUM(e.signed_amount_minor)=1250 FROM cnr_financial_entries e
    INNER JOIN cnr_financial_accounts a ON a.id=e.account_id
    WHERE a.public_uuid=@bank_destination_financial_uuid),
    'recipient checking balance is incorrect after transfer'
);

DELIMITER //
CREATE PROCEDURE assert_duplicate_bank_transfer_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_financial_transactions
        (public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
        account_uuid, source_financial_account_uuid, destination_financial_account_uuid,
        session_uuid, amount_minor, currency, purpose, source_module, request_id, correlation_id,
        contract_version, payload_sha256, created_at, posted_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000044','-','')),
        @bank_transfer_operation_uuid,'TX-INTEGRATION-TRANSFER-2','BANK_TRANSFER','POSTED',
        @bank_character_uuid,@bank_account_uuid,@bank_source_financial_uuid,
        @bank_destination_financial_uuid,@bank_session_uuid,1250,'USD','Duplicate transfer',
        'cnr_banking','banking-transfer-integration-2','banking-transfer-correlation-2',2,
        UNHEX(SHA2('duplicate',256)),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
    END;
    CALL assert_banking_true(duplicate_rejected, 'duplicate transfer operation was accepted');
END//
DELIMITER ;
CALL assert_duplicate_bank_transfer_rejected();

SET @rollback_character_uuid = UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000030','-',''));
START TRANSACTION;
INSERT INTO cnr_financial_accounts
(public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7100-7000-8000-000000000031','-','')),
'CASH-INTEGRATION-ROLLBACK','CHARACTER',@rollback_character_uuid,'CASH_WALLET','USD','ACTIVE',1,
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
ROLLBACK;
CALL assert_banking_true(
    (SELECT COUNT(*)=0 FROM cnr_financial_accounts
    WHERE owner_character_uuid=@rollback_character_uuid),
    'rolled-back account was retained'
);

DELETE e FROM cnr_financial_entries e
INNER JOIN cnr_financial_transactions t ON t.id=e.transaction_id
WHERE t.character_uuid=@bank_character_uuid
OR t.destination_financial_account_uuid=@bank_destination_financial_uuid;
DELETE FROM cnr_financial_transactions WHERE character_uuid=@bank_character_uuid;
DELETE FROM cnr_financial_accounts WHERE owner_character_uuid=@bank_character_uuid;
DELETE FROM cnr_financial_accounts WHERE owner_character_uuid=@bank_recipient_character_uuid;
DROP PROCEDURE assert_duplicate_bank_transfer_rejected;
DROP PROCEDURE assert_duplicate_starter_posting_rejected;
DROP PROCEDURE assert_duplicate_bank_account_rejected;
DROP PROCEDURE assert_banking_true;
