-- Exercises ATM constraints, balanced cash movement, idempotency, and rollback behavior.
DELIMITER //
CREATE PROCEDURE assert_atm_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

SET @atm_character_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000001','-',''));
SET @atm_account_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000002','-',''));
SET @atm_session_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000003','-',''));
SET @atm_terminal_uuid = UNHEX(REPLACE('0190b7a0-7400-7000-8000-000000000010','-',''));
SET @atm_wallet_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000010','-',''));
SET @atm_checking_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000011','-',''));
SET @atm_operation_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000020','-',''));

CALL assert_atm_true(
    (SELECT COUNT(*) = 1 FROM cnr_atms WHERE public_uuid = @atm_terminal_uuid AND status = 'ACTIVE'),
    'seed ATM is unavailable'
);
CALL assert_atm_true(
    (SELECT COUNT(*) = 2 FROM cnr_technical_role_permissions AS mapping
    INNER JOIN cnr_technical_permissions AS permission_row ON permission_row.id = mapping.permission_id
    INNER JOIN cnr_technical_roles AS role_row ON role_row.id = mapping.role_id
    WHERE permission_row.code = 'banking.atms.manage'
    AND role_row.code IN ('owner', 'administrator')),
    'ATM management permission was not assigned to both administrative roles'
);

INSERT INTO cnr_financial_accounts
(public_uuid, account_number, owner_type, owner_character_uuid, account_type, currency,
status, version, created_at, updated_at)
VALUES
(@atm_wallet_uuid,'CASH-ATM-INTEGRATION','CHARACTER',@atm_character_uuid,'CASH_WALLET','USD',
'ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6)),
(@atm_checking_uuid,'SA-ATM-INTEGRATION','CHARACTER',@atm_character_uuid,'PERSONAL_CHECKING','USD',
'ACTIVE',1,UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));

INSERT INTO cnr_financial_transactions
(public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
account_uuid, session_uuid, amount_minor, currency, purpose, source_module, request_id,
correlation_id, contract_version, payload_sha256, created_at, posted_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000012','-','')),
UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000013','-','')),
'TX-ATM-INTEGRATION-STARTER','STARTER_ALLOCATION','POSTED',@atm_character_uuid,
@atm_account_uuid,@atm_session_uuid,30000,'USD','Initial character funds','cnr_banking',
'atm-integration-starter','atm-integration-correlation',1,UNHEX(SHA2('atm-starter',256)),
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
SET @atm_starter_transaction_id = LAST_INSERT_ID();

INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @atm_starter_transaction_id,id,1,-30000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE account_type='SYSTEM_SOURCE';
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @atm_starter_transaction_id,id,2,5000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@atm_wallet_uuid;
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @atm_starter_transaction_id,id,3,25000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@atm_checking_uuid;

START TRANSACTION;
UPDATE cnr_financial_accounts SET version=version+1,
last_operation_uuid=@atm_operation_uuid,updated_at=UTC_TIMESTAMP(6)
WHERE public_uuid IN (@atm_wallet_uuid,@atm_checking_uuid);
INSERT INTO cnr_financial_transactions
(public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
account_uuid, source_financial_account_uuid, destination_financial_account_uuid, atm_uuid,
session_uuid, amount_minor, currency, purpose, source_module, request_id, correlation_id,
contract_version, payload_sha256, created_at, posted_at)
VALUES
(UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000021','-','')),
@atm_operation_uuid,'TX-ATM-INTEGRATION-DEPOSIT','ATM_DEPOSIT','POSTED',@atm_character_uuid,
@atm_account_uuid,@atm_wallet_uuid,@atm_checking_uuid,@atm_terminal_uuid,@atm_session_uuid,
2000,'USD','ATM cash deposit','cnr_banking','atm-integration-deposit',
'atm-integration-correlation',1,UNHEX(SHA2('atm-deposit',256)),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
SET @atm_deposit_transaction_id = LAST_INSERT_ID();
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @atm_deposit_transaction_id,id,1,-2000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@atm_wallet_uuid;
INSERT INTO cnr_financial_entries
(transaction_id, account_id, entry_sequence, signed_amount_minor, created_at)
SELECT @atm_deposit_transaction_id,id,2,2000,UTC_TIMESTAMP(6)
FROM cnr_financial_accounts WHERE public_uuid=@atm_checking_uuid;
COMMIT;

CALL assert_atm_true(
    (SELECT SUM(signed_amount_minor)=0 FROM cnr_financial_entries
    WHERE transaction_id=@atm_deposit_transaction_id),
    'ATM transaction is not balanced'
);
CALL assert_atm_true(
    (SELECT SUM(entry_row.signed_amount_minor)=3000 FROM cnr_financial_entries AS entry_row
    INNER JOIN cnr_financial_accounts AS account_row ON account_row.id=entry_row.account_id
    WHERE account_row.public_uuid=@atm_wallet_uuid),
    'cash wallet balance is incorrect after ATM deposit'
);
CALL assert_atm_true(
    (SELECT SUM(entry_row.signed_amount_minor)=27000 FROM cnr_financial_entries AS entry_row
    INNER JOIN cnr_financial_accounts AS account_row ON account_row.id=entry_row.account_id
    WHERE account_row.public_uuid=@atm_checking_uuid),
    'checking balance is incorrect after ATM deposit'
);

DELIMITER //
CREATE PROCEDURE assert_duplicate_atm_operation_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_financial_transactions
        (public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
        account_uuid, source_financial_account_uuid, destination_financial_account_uuid, atm_uuid,
        session_uuid, amount_minor, currency, purpose, source_module, request_id, correlation_id,
        contract_version, payload_sha256, created_at, posted_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000022','-','')),
        @atm_operation_uuid,'TX-ATM-INTEGRATION-DUPLICATE','ATM_DEPOSIT','POSTED',
        @atm_character_uuid,@atm_account_uuid,@atm_wallet_uuid,@atm_checking_uuid,
        @atm_terminal_uuid,@atm_session_uuid,2000,'USD','Duplicate ATM deposit','cnr_banking',
        'atm-integration-duplicate','atm-integration-correlation',1,
        UNHEX(SHA2('atm-duplicate',256)),UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
    END;
    CALL assert_atm_true(duplicate_rejected, 'duplicate ATM operation was accepted');
END//
DELIMITER ;
CALL assert_duplicate_atm_operation_rejected();

DELIMITER //
CREATE PROCEDURE assert_missing_atm_rejected()
BEGIN
    DECLARE shape_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET shape_rejected = TRUE;
        INSERT INTO cnr_financial_transactions
        (public_uuid, operation_uuid, transaction_number, transaction_type, status, character_uuid,
        account_uuid, source_financial_account_uuid, destination_financial_account_uuid, atm_uuid,
        session_uuid, amount_minor, currency, purpose, source_module, request_id, correlation_id,
        contract_version, payload_sha256, created_at, posted_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000023','-','')),
        UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000024','-','')),
        'TX-ATM-INTEGRATION-NO-ATM','ATM_WITHDRAWAL','POSTED',@atm_character_uuid,
        @atm_account_uuid,@atm_checking_uuid,@atm_wallet_uuid,NULL,@atm_session_uuid,500,'USD',
        'ATM cash withdrawal','cnr_banking','atm-integration-no-atm',
        'atm-integration-correlation',1,UNHEX(SHA2('atm-no-atm',256)),
        UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
    END;
    CALL assert_atm_true(shape_rejected, 'ATM transaction without terminal reference was accepted');
END//
DELIMITER ;
CALL assert_missing_atm_rejected();

SET @rollback_atm_uuid = UNHEX(REPLACE('0190b7a0-7410-7000-8000-000000000030','-',''));
START TRANSACTION;
INSERT INTO cnr_atms
(public_uuid,code,label,coordinate_x,coordinate_y,coordinate_z,heading,interaction_radius,
status,version,created_at,updated_at)
VALUES (@rollback_atm_uuid,'ATM-ROLLBACK','Rollback ATM',100,100,30,0,2.5,'ACTIVE',1,
UTC_TIMESTAMP(6),UTC_TIMESTAMP(6));
ROLLBACK;
CALL assert_atm_true(
    (SELECT COUNT(*)=0 FROM cnr_atms WHERE public_uuid=@rollback_atm_uuid),
    'rolled-back ATM was retained'
);

DELETE entry_row FROM cnr_financial_entries AS entry_row
INNER JOIN cnr_financial_transactions AS transaction_row
    ON transaction_row.id=entry_row.transaction_id
WHERE transaction_row.character_uuid=@atm_character_uuid;
DELETE FROM cnr_financial_transactions WHERE character_uuid=@atm_character_uuid;
DELETE FROM cnr_financial_accounts WHERE owner_character_uuid=@atm_character_uuid;
DROP PROCEDURE assert_missing_atm_rejected;
DROP PROCEDURE assert_duplicate_atm_operation_rejected;
DROP PROCEDURE assert_atm_true;
