-- Exercises binding, appearance, spawn constraints, idempotency keys, and transaction rollback.
DELIMITER //
CREATE PROCEDURE assert_selection_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

INSERT INTO cnr_accounts (public_uuid, status, version, created_at, updated_at)
VALUES (UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000001', '-', '')), 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @selection_account_id = LAST_INSERT_ID();
INSERT INTO cnr_account_sessions (public_uuid, account_id, server_instance_id, source_at_start, player_name, status, access_state, started_at, activated_at, last_seen_at)
VALUES (UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000002', '-', '')), @selection_account_id, 'selection-db-test', 44, 'Selection Test', 'ACTIVE', 'FULL', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @selection_session_id = LAST_INSERT_ID();
INSERT INTO cnr_characters (public_uuid, account_id, slot_number, status, created_at, updated_at, activated_at)
VALUES (UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000003', '-', '')), @selection_account_id, 1, 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @selection_character_id = LAST_INSERT_ID();
SET @selection_background_id = (SELECT id FROM cnr_character_backgrounds WHERE code = 'local');
INSERT INTO cnr_character_identities (character_id, first_name, last_name, date_of_birth, background_id, created_at, updated_at)
VALUES (@selection_character_id, 'Taylor', 'Reed', '1994-04-12', @selection_background_id, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

INSERT INTO cnr_character_session_bindings
(public_uuid, operation_uuid, account_id, session_id, character_id, request_id, correlation_id, contract_version, payload_sha256, status, routing_bucket, spawn_uuid, spawn_state, spawn_reason, spawn_x, spawn_y, spawn_z, spawn_heading, selected_at)
VALUES
(UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000004', '-', '')), UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000005', '-', '')), @selection_account_id, @selection_session_id, @selection_character_id, 'selection-db-1', 'selection-correlation-1', 1, UNHEX(SHA2('select', 256)), 'ACTIVE', 10044, NULL, 'APPEARANCE_REQUIRED', NULL, NULL, NULL, NULL, NULL, UTC_TIMESTAMP(6));
SET @selection_binding_id = LAST_INSERT_ID();

DELIMITER //
CREATE PROCEDURE assert_duplicate_selection_operation_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_character_session_bindings
        (public_uuid, operation_uuid, account_id, session_id, character_id, request_id, correlation_id, contract_version, payload_sha256, status, routing_bucket, spawn_state, selected_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000006', '-', '')), UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000005', '-', '')), @selection_account_id, @selection_session_id, @selection_character_id, 'selection-db-duplicate', 'selection-correlation-duplicate', 1, UNHEX(SHA2('changed', 256)), 'ACTIVE', 10044, 'APPEARANCE_REQUIRED', UTC_TIMESTAMP(6));
    END;
    CALL assert_selection_true(duplicate_rejected, 'duplicate selection operation was accepted');
END//
DELIMITER ;
CALL assert_duplicate_selection_operation_rejected();

START TRANSACTION;
INSERT INTO cnr_character_appearances
(character_id, public_uuid, model, shape_first, shape_second, shape_mix, skin_mix, face_features, hair_style, hair_texture, hair_color, hair_highlight, eye_color, outfit_code, version, created_at, updated_at)
VALUES
(@selection_character_id, UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000007', '-', '')), 'mp_m_freemode_01', 0, 21, 50, 50, JSON_ARRAY(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 0, 0, 0, 0, 0, 'starter_casual', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
INSERT INTO cnr_character_appearance_operations
(operation_uuid, account_id, session_id, character_id, request_id, correlation_id, contract_version, payload_sha256, result_version, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000008', '-', '')), @selection_account_id, @selection_session_id, @selection_character_id, 'appearance-db-1', 'appearance-correlation-1', 1, UNHEX(SHA2('appearance', 256)), 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
UPDATE cnr_character_session_bindings
SET routing_bucket = 0,
    spawn_uuid = UNHEX(REPLACE('0190b7a0-4000-7000-8000-000000000009', '-', '')),
    spawn_state = 'PENDING',
    spawn_reason = 'CENTRAL_DEFAULT',
    spawn_x = 215.76,
    spawn_y = -810.12,
    spawn_z = 30.73,
    spawn_heading = 157.0
WHERE id = @selection_binding_id AND spawn_state = 'APPEARANCE_REQUIRED';
COMMIT;

CALL assert_selection_true((SELECT COUNT(*) = 1 FROM cnr_character_appearances WHERE character_id = @selection_character_id), 'appearance snapshot missing');
CALL assert_selection_true((SELECT spawn_state = 'PENDING' FROM cnr_character_session_bindings WHERE id = @selection_binding_id), 'spawn was not prepared');

START TRANSACTION;
UPDATE cnr_character_session_bindings SET spawn_state = 'SPAWNED', spawned_at = UTC_TIMESTAMP(6) WHERE id = @selection_binding_id AND spawn_state = 'PENDING';
INSERT INTO cnr_character_locations (character_id, x, y, z, heading, location_type, is_safe, updated_at)
VALUES (@selection_character_id, 215.76, -810.12, 30.73, 157.0, 'LAST_SAFE', 1, UTC_TIMESTAMP(6));
ROLLBACK;
CALL assert_selection_true((SELECT spawn_state = 'PENDING' FROM cnr_character_session_bindings WHERE id = @selection_binding_id), 'spawn rollback changed binding state');
CALL assert_selection_true((SELECT COUNT(*) = 0 FROM cnr_character_locations WHERE character_id = @selection_character_id), 'spawn rollback retained location');

START TRANSACTION;
UPDATE cnr_character_session_bindings SET spawn_state = 'SPAWNED', spawned_at = UTC_TIMESTAMP(6) WHERE id = @selection_binding_id AND spawn_state = 'PENDING';
INSERT INTO cnr_character_locations (character_id, x, y, z, heading, location_type, is_safe, updated_at)
VALUES (@selection_character_id, 215.76, -810.12, 30.73, 157.0, 'LAST_SAFE', 1, UTC_TIMESTAMP(6));
COMMIT;
CALL assert_selection_true((SELECT spawn_state = 'SPAWNED' FROM cnr_character_session_bindings WHERE id = @selection_binding_id), 'spawn acknowledgement missing');

UPDATE cnr_character_session_bindings SET status = 'ENDED', spawn_state = 'ENDED', ended_at = UTC_TIMESTAMP(6) WHERE id = @selection_binding_id;
DELETE FROM cnr_character_locations WHERE character_id = @selection_character_id;
DELETE FROM cnr_character_appearance_operations WHERE character_id = @selection_character_id;
DELETE FROM cnr_character_appearances WHERE character_id = @selection_character_id;
DELETE FROM cnr_character_session_bindings WHERE character_id = @selection_character_id;
DELETE FROM cnr_character_identities WHERE character_id = @selection_character_id;
DELETE FROM cnr_characters WHERE id = @selection_character_id;
DELETE FROM cnr_account_sessions WHERE id = @selection_session_id;
DELETE FROM cnr_accounts WHERE id = @selection_account_id;
DROP PROCEDURE assert_duplicate_selection_operation_rejected;
DROP PROCEDURE assert_selection_true;
