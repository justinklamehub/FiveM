-- Exercises registration constraints and an atomic activation against real MariaDB.
DELIMITER //
CREATE PROCEDURE assert_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

INSERT INTO cnr_accounts (public_uuid, status, version, created_at, updated_at)
VALUES (UNHEX(REPLACE('0190b7a0-1000-7000-8000-000000000001', '-', '')), 'PENDING_REGISTRATION', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @account_id = LAST_INSERT_ID();
INSERT INTO cnr_account_sessions (public_uuid, account_id, server_instance_id, source_at_start, player_name, status, access_state, started_at, activated_at, last_seen_at)
VALUES (UNHEX(REPLACE('0190b7a0-1000-7000-8000-000000000002', '-', '')), @account_id, 'mariadb-test', 42, 'Test', 'ACTIVE', 'ONBOARDING', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @session_id = LAST_INSERT_ID();
SET @ruleset_id = (SELECT id FROM cnr_rulesets WHERE status = 'CURRENT');

START TRANSACTION;
INSERT INTO cnr_registration_operations (operation_uuid, account_id, session_id, ruleset_id, request_id, correlation_id, contract_version, locale, accepted, payload_sha256, result_account_status, result_access_state, created_at, completed_at)
VALUES (UNHEX(REPLACE('0190b7a0-1000-7000-8000-000000000003', '-', '')), @account_id, @session_id, @ruleset_id, 'db-test', 'db-correlation', 1, 'de', 1, UNHEX(SHA2('payload', 256)), 'ACTIVE', 'FULL', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @operation_id = LAST_INSERT_ID();
INSERT INTO cnr_ruleset_acceptances (public_uuid, account_id, ruleset_id, operation_id, session_id, locale, accepted_at, ruleset_content_sha256)
SELECT UNHEX(REPLACE('0190b7a0-1000-7000-8000-000000000004', '-', '')), @account_id, @ruleset_id, @operation_id, @session_id, 'de', UTC_TIMESTAMP(6), content_sha256 FROM cnr_rulesets WHERE id = @ruleset_id;
UPDATE cnr_accounts SET status = 'ACTIVE', version = version + 1 WHERE id = @account_id AND status = 'PENDING_REGISTRATION' AND version = 1;
UPDATE cnr_account_sessions SET access_state = 'FULL' WHERE id = @session_id AND status = 'ACTIVE' AND access_state = 'ONBOARDING';
COMMIT;

CALL assert_true((SELECT COUNT(*) = 1 FROM cnr_registration_operations WHERE account_id = @account_id), 'expected one registration operation');
CALL assert_true((SELECT COUNT(*) = 1 FROM cnr_ruleset_acceptances WHERE account_id = @account_id), 'expected one ruleset acceptance');
CALL assert_true((SELECT status = 'ACTIVE' FROM cnr_accounts WHERE id = @account_id), 'account transition missing');
CALL assert_true((SELECT access_state = 'FULL' FROM cnr_account_sessions WHERE id = @session_id), 'session transition missing');

DELIMITER //
CREATE PROCEDURE assert_duplicate_operation_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_registration_operations (operation_uuid, account_id, session_id, ruleset_id, request_id, correlation_id, contract_version, locale, accepted, payload_sha256, result_account_status, result_access_state, created_at, completed_at)
        VALUES (UNHEX(REPLACE('0190b7a0-1000-7000-8000-000000000003', '-', '')), @account_id, @session_id, @ruleset_id, 'changed', 'db-correlation-2', 1, 'en', 1, UNHEX(SHA2('changed-payload', 256)), 'ACTIVE', 'FULL', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_true(duplicate_rejected, 'duplicate operation UUID was accepted');
END//
DELIMITER ;
CALL assert_duplicate_operation_rejected();

DELETE FROM cnr_ruleset_acceptances WHERE account_id = @account_id;
DELETE FROM cnr_registration_operations WHERE account_id = @account_id;
DELETE FROM cnr_account_sessions WHERE account_id = @account_id;
DELETE FROM cnr_accounts WHERE id = @account_id;
DROP PROCEDURE assert_duplicate_operation_rejected;
DROP PROCEDURE assert_true;
