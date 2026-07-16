-- Exercises atomic draft identity, activation, base documents, and uniqueness constraints.
DELIMITER //
CREATE PROCEDURE assert_character_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;
INSERT INTO cnr_accounts (public_uuid, status, version, created_at, updated_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000001', '-', '')), 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @character_account_id = LAST_INSERT_ID();
INSERT INTO cnr_account_sessions (public_uuid, account_id, server_instance_id, source_at_start, player_name, status, access_state, started_at, activated_at, last_seen_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000002', '-', '')), @character_account_id, 'character-db-test', 43, 'Character Test', 'ACTIVE', 'FULL', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @character_session_id = LAST_INSERT_ID();

START TRANSACTION;
INSERT INTO cnr_characters (public_uuid, account_id, slot_number, status, created_at, updated_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000003', '-', '')), @character_account_id, 1, 'DRAFT', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @character_id = LAST_INSERT_ID();
SET @background_id = (SELECT id FROM cnr_character_backgrounds WHERE code = 'local');
INSERT INTO cnr_character_identities (character_id, first_name, last_name, date_of_birth, background_id, created_at, updated_at)
VALUES (@character_id, 'Alex', 'Morgan', '1995-05-20', @background_id, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
INSERT INTO cnr_character_operations (operation_uuid, account_id, session_id, character_id, action, request_id, correlation_id, contract_version, payload_sha256, result_status, created_at, completed_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000004', '-', '')), @character_account_id, @character_session_id, @character_id, 'CREATE_DRAFT', 'character-db-1', 'character-correlation-1', 1, UNHEX(SHA2('draft', 256)), 'DRAFT', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
COMMIT;

START TRANSACTION;
UPDATE cnr_characters SET status = 'ACTIVE', version = version + 1, activated_at = UTC_TIMESTAMP(6), updated_at = UTC_TIMESTAMP(6) WHERE id = @character_id AND status = 'DRAFT' AND version = 1;
SET @document_type_id = (SELECT id FROM cnr_document_types WHERE code = 'state_id');
INSERT INTO cnr_character_documents (public_uuid, character_id, document_type_id, document_number, status, issued_at, updated_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000005', '-', '')), @character_id, @document_type_id, 'SID-000000000003', 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
INSERT INTO cnr_character_operations (operation_uuid, account_id, session_id, character_id, action, request_id, correlation_id, contract_version, payload_sha256, result_status, created_at, completed_at)
VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000006', '-', '')), @character_account_id, @character_session_id, @character_id, 'ACTIVATE', 'character-db-2', 'character-correlation-2', 1, UNHEX(SHA2('activate', 256)), 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
COMMIT;

CALL assert_character_true((SELECT status = 'ACTIVE' FROM cnr_characters WHERE id = @character_id), 'character activation missing');
CALL assert_character_true((SELECT COUNT(*) = 1 FROM cnr_character_identities WHERE character_id = @character_id), 'character identity missing');
CALL assert_character_true((SELECT COUNT(*) = 1 FROM cnr_character_documents WHERE character_id = @character_id), 'base document missing');

DELIMITER //
CREATE PROCEDURE assert_duplicate_character_slot_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_characters (public_uuid, account_id, slot_number, status, created_at, updated_at)
        VALUES (UNHEX(REPLACE('0190b7a0-3000-7000-8000-000000000007', '-', '')), @character_account_id, 1, 'DRAFT', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_character_true(duplicate_rejected, 'duplicate account slot was accepted');
END//
DELIMITER ;
CALL assert_duplicate_character_slot_rejected();

DELETE FROM cnr_character_operations WHERE account_id = @character_account_id;
DELETE FROM cnr_character_documents WHERE character_id = @character_id;
DELETE FROM cnr_character_identities WHERE character_id = @character_id;
DELETE FROM cnr_characters WHERE account_id = @character_account_id;
DELETE FROM cnr_account_sessions WHERE account_id = @character_account_id;
DELETE FROM cnr_accounts WHERE id = @character_account_id;
DROP PROCEDURE assert_duplicate_character_slot_rejected;
DROP PROCEDURE assert_character_true;
