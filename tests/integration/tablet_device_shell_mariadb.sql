-- Exercises unique Tablet provisioning, zero-consumption use, and rollback safety.
DELIMITER //
CREATE PROCEDURE assert_tablet_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

SET @tablet_character_uuid = UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000001','-',''));
SET @tablet_account_uuid = UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000002','-',''));
SET @tablet_session_uuid = UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000003','-',''));
SET @tablet_definition_id = (SELECT id FROM cnr_item_definitions WHERE code='city_tablet');

CALL assert_tablet_true(@tablet_definition_id IS NOT NULL, 'Tablet definition is missing');
CALL assert_tablet_true(
    (SELECT is_unique=1 AND is_tradeable=0 AND is_drop_allowed=0 AND use_handler='open_tablet'
    FROM cnr_item_definitions WHERE id=@tablet_definition_id),
    'Tablet definition authority flags are invalid'
);

INSERT INTO cnr_inventories
(public_uuid, owner_character_uuid, inventory_type, slot_capacity, weight_capacity_grams,
version, status, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000010','-','')),
@tablet_character_uuid, 'CHARACTER', 24, 30000, 1, 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @tablet_inventory_id = LAST_INSERT_ID();

START TRANSACTION;
INSERT INTO cnr_item_instances
(public_uuid, definition_id, reference_type, reference_uuid, status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000020','-','')),
@tablet_definition_id, 'CHARACTER_TABLET', @tablet_character_uuid, 'ACTIVE', 1,
UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @tablet_instance_id = LAST_INSERT_ID();
INSERT INTO cnr_inventory_items
(public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000021','-','')),
@tablet_inventory_id, @tablet_definition_id, @tablet_instance_id, 1, 1, 1,
UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
UPDATE cnr_inventories SET version=2 WHERE id=@tablet_inventory_id AND version=1;
INSERT INTO cnr_item_transactions
(operation_uuid, action, account_uuid, session_uuid, character_uuid,
source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
definition_id, item_instance_id, source_slot, target_slot, transfer_mode, item_action,
quantity, request_id, correlation_id, contract_version, payload_sha256,
result_source_version, result_target_version, result_status, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000030','-','')), 'PROVISION_TABLET',
@tablet_account_uuid, @tablet_session_uuid, @tablet_character_uuid, NULL, @tablet_inventory_id,
NULL, UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000021','-','')),
@tablet_definition_id, @tablet_instance_id, NULL, 1, NULL, NULL, 1,
'tablet-provision-1', 'tablet-provision-correlation-1', 1,
UNHEX(SHA2('tablet-provision',256)), 2, 2, 'COMPLETED', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
COMMIT;

DELIMITER //
CREATE PROCEDURE assert_duplicate_tablet_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_item_transactions
        (operation_uuid, action, account_uuid, session_uuid, character_uuid,
        source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
        definition_id, item_instance_id, source_slot, target_slot, transfer_mode, item_action,
        quantity, request_id, correlation_id, contract_version, payload_sha256,
        result_source_version, result_target_version, result_status, created_at, completed_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000031','-','')),
        'PROVISION_TABLET', @tablet_account_uuid, @tablet_session_uuid,
        @tablet_character_uuid, NULL, @tablet_inventory_id, NULL,
        UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000021','-','')),
        @tablet_definition_id, @tablet_instance_id, NULL, 1, NULL, NULL, 1,
        'tablet-provision-2', 'tablet-provision-correlation-2', 1,
        UNHEX(SHA2('tablet-provision',256)), 2, 2, 'COMPLETED',
        UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_tablet_true(duplicate_rejected, 'duplicate Tablet provisioning was accepted');
END//
DELIMITER ;
CALL assert_duplicate_tablet_rejected();

INSERT INTO cnr_item_transactions
(operation_uuid, action, account_uuid, session_uuid, character_uuid,
source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
definition_id, item_instance_id, source_slot, target_slot, transfer_mode, item_action,
quantity, request_id, correlation_id, contract_version, payload_sha256,
result_source_version, result_target_version, result_status, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000040','-','')), 'USE_ITEM',
@tablet_account_uuid, @tablet_session_uuid, @tablet_character_uuid,
@tablet_inventory_id, @tablet_inventory_id,
UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000021','-','')), NULL,
@tablet_definition_id, @tablet_instance_id, 1, NULL, NULL, 'OPEN_TABLET', 1,
'tablet-open-1', 'tablet-open-correlation-1', 5, UNHEX(SHA2('tablet-open',256)),
2, 2, 'COMPLETED', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
CALL assert_tablet_true(
    (SELECT result_source_version=result_target_version AND item_action='OPEN_TABLET'
    FROM cnr_item_transactions
    WHERE operation_uuid=UNHEX(REPLACE('0190b7a0-6200-7000-8000-000000000040','-',''))),
    'Tablet use mutated inventory state or lost its replay effect'
);

START TRANSACTION;
DELETE FROM cnr_inventory_items WHERE inventory_id=@tablet_inventory_id;
ROLLBACK;
CALL assert_tablet_true(
    (SELECT COUNT(*)=1 FROM cnr_inventory_items WHERE inventory_id=@tablet_inventory_id),
    'rolled-back Tablet mutation changed inventory contents'
);

DELETE FROM cnr_item_transactions WHERE character_uuid=@tablet_character_uuid;
DELETE FROM cnr_inventory_items WHERE inventory_id=@tablet_inventory_id;
DELETE FROM cnr_item_instances WHERE id=@tablet_instance_id;
DELETE FROM cnr_inventories WHERE id=@tablet_inventory_id;
DROP PROCEDURE assert_duplicate_tablet_rejected;
DROP PROCEDURE assert_tablet_true;
