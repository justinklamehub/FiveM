-- Exercises item/inventory constraints, idempotency, unique instances, and transfer rollback.
DELIMITER //
CREATE PROCEDURE assert_inventory_true(IN condition_value BOOLEAN, IN failure_message VARCHAR(255))
BEGIN
    IF condition_value IS NULL OR condition_value = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = failure_message;
    END IF;
END//
DELIMITER ;

SET @inventory_character_uuid = UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000001','-',''));
SET @inventory_account_uuid = UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000002','-',''));
SET @inventory_session_uuid = UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000003','-',''));
SET @water_definition_id = (SELECT id FROM cnr_item_definitions WHERE code='water_bottle');
SET @state_id_definition_id = (SELECT id FROM cnr_item_definitions WHERE code='state_id');

INSERT INTO cnr_inventories
(public_uuid, owner_character_uuid, inventory_type, slot_capacity, weight_capacity_grams,
version, status, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000010','-','')),
@inventory_character_uuid, 'CHARACTER', 24, 30000, 1, 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @source_inventory_id = LAST_INSERT_ID();
INSERT INTO cnr_inventories
(public_uuid, owner_character_uuid, inventory_type, slot_capacity, weight_capacity_grams,
version, status, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000011','-','')),
@inventory_character_uuid, 'PERSONAL_STORAGE', 12, 100000, 1, 'ACTIVE', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @target_inventory_id = LAST_INSERT_ID();

INSERT INTO cnr_inventory_items
(public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000020','-','')),
@source_inventory_id, @water_definition_id, NULL, 1, 2, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @source_entry_id = LAST_INSERT_ID();

DELIMITER //
CREATE PROCEDURE assert_duplicate_stack_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_inventory_items
        (public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
        version, created_at, updated_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000021','-','')),
        @source_inventory_id, @water_definition_id, NULL, 2, 1, 1,
        UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_inventory_true(duplicate_rejected, 'duplicate stack was accepted');
END//
DELIMITER ;
CALL assert_duplicate_stack_rejected();

DELIMITER //
CREATE PROCEDURE assert_zero_quantity_rejected()
BEGIN
    DECLARE invalid_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET invalid_rejected = TRUE;
        INSERT INTO cnr_inventory_items
        (public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
        version, created_at, updated_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000022','-','')),
        @target_inventory_id, @water_definition_id, NULL, 2, 0, 1,
        UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_inventory_true(invalid_rejected, 'zero quantity was accepted');
END//
DELIMITER ;
CALL assert_zero_quantity_rejected();

START TRANSACTION;
SELECT id FROM cnr_inventories
WHERE id IN (@source_inventory_id, @target_inventory_id) ORDER BY id FOR UPDATE;
INSERT INTO cnr_item_transactions
(operation_uuid, action, account_uuid, session_uuid, character_uuid, source_inventory_id,
target_inventory_id, source_entry_uuid, target_entry_uuid, definition_id, item_instance_id,
quantity, request_id, correlation_id, contract_version, payload_sha256,
result_source_version, result_target_version, result_status, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000030','-','')), 'TRANSFER',
@inventory_account_uuid, @inventory_session_uuid, @inventory_character_uuid,
@source_inventory_id, @target_inventory_id,
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000020','-','')),
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000023','-','')),
@water_definition_id, NULL, 1, 'inventory-transfer-rollback', 'inventory-correlation-rollback',
1, UNHEX(SHA2('inventory-transfer',256)), 2, 2, 'COMPLETED', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
UPDATE cnr_inventory_items SET quantity=quantity-1, version=version+1
WHERE id=@source_entry_id;
INSERT INTO cnr_inventory_items
(public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000023','-','')),
@target_inventory_id, @water_definition_id, NULL, 1, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
ROLLBACK;
CALL assert_inventory_true(
    (SELECT quantity=2 FROM cnr_inventory_items WHERE id=@source_entry_id),
    'rolled-back transfer changed source quantity'
);
CALL assert_inventory_true(
    (SELECT COUNT(*)=0 FROM cnr_inventory_items WHERE inventory_id=@target_inventory_id),
    'rolled-back transfer retained target item'
);
CALL assert_inventory_true(
    (SELECT COUNT(*)=0 FROM cnr_item_transactions
    WHERE operation_uuid=UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000030','-',''))),
    'rolled-back transfer retained operation'
);

START TRANSACTION;
SELECT id FROM cnr_inventories
WHERE id IN (@source_inventory_id, @target_inventory_id) ORDER BY id FOR UPDATE;
INSERT INTO cnr_item_transactions
(operation_uuid, action, account_uuid, session_uuid, character_uuid, source_inventory_id,
target_inventory_id, source_entry_uuid, target_entry_uuid, definition_id, item_instance_id,
quantity, request_id, correlation_id, contract_version, payload_sha256,
result_source_version, result_target_version, result_status, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000030','-','')), 'TRANSFER',
@inventory_account_uuid, @inventory_session_uuid, @inventory_character_uuid,
@source_inventory_id, @target_inventory_id,
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000020','-','')),
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000023','-','')),
@water_definition_id, NULL, 1, 'inventory-transfer-commit', 'inventory-correlation-commit',
1, UNHEX(SHA2('inventory-transfer',256)), 2, 2, 'COMPLETED', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
UPDATE cnr_inventory_items SET quantity=quantity-1, version=version+1
WHERE id=@source_entry_id;
INSERT INTO cnr_inventory_items
(public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000023','-','')),
@target_inventory_id, @water_definition_id, NULL, 1, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
UPDATE cnr_inventories SET version=version+1 WHERE id IN (@source_inventory_id, @target_inventory_id);
COMMIT;
CALL assert_inventory_true(
    (SELECT quantity=1 FROM cnr_inventory_items WHERE id=@source_entry_id),
    'committed transfer did not debit source'
);
CALL assert_inventory_true(
    (SELECT quantity=1 FROM cnr_inventory_items WHERE inventory_id=@target_inventory_id),
    'committed transfer did not credit target'
);

DELIMITER //
CREATE PROCEDURE assert_duplicate_operation_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_item_transactions
        (operation_uuid, action, account_uuid, session_uuid, character_uuid,
        source_inventory_id, target_inventory_id, source_entry_uuid, target_entry_uuid,
        definition_id, quantity, request_id, correlation_id, contract_version, payload_sha256,
        result_source_version, result_target_version, result_status, created_at, completed_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000030','-','')), 'TRANSFER',
        @inventory_account_uuid, @inventory_session_uuid, @inventory_character_uuid,
        @source_inventory_id, @target_inventory_id,
        UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000020','-','')),
        UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000023','-','')),
        @water_definition_id, 1, 'inventory-transfer-duplicate',
        'inventory-correlation-duplicate', 1, UNHEX(SHA2('changed',256)), 3, 3,
        'COMPLETED', UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_inventory_true(duplicate_rejected, 'duplicate operation UUID was accepted');
END//
DELIMITER ;
CALL assert_duplicate_operation_rejected();

INSERT INTO cnr_item_instances
(public_uuid, definition_id, reference_type, reference_uuid, status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000040','-','')),
@state_id_definition_id, 'CHARACTER_DOCUMENT',
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000041','-','')),
'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
SET @document_instance_id = LAST_INSERT_ID();

DELIMITER //
CREATE PROCEDURE assert_duplicate_reference_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_item_instances
        (public_uuid, definition_id, reference_type, reference_uuid, status, version,
        created_at, updated_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000042','-','')),
        @state_id_definition_id, 'CHARACTER_DOCUMENT',
        UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000041','-','')),
        'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_inventory_true(duplicate_rejected, 'duplicate item reference was accepted');
END//
DELIMITER ;
CALL assert_duplicate_reference_rejected();

INSERT INTO cnr_inventory_items
(public_uuid, inventory_id, definition_id, item_instance_id, slot_number, quantity,
version, created_at, updated_at)
SELECT
UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000043','-','')),
@source_inventory_id, @state_id_definition_id, inst.id, 3, 1, 1,
UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)
FROM cnr_item_instances inst WHERE inst.id=@document_instance_id
ON DUPLICATE KEY UPDATE public_uuid=cnr_inventory_items.public_uuid;

INSERT INTO cnr_item_transactions
(operation_uuid, action, account_uuid, session_uuid, character_uuid,
source_inventory_id, target_inventory_id, quantity, request_id, correlation_id,
contract_version, payload_sha256, result_source_version, result_target_version,
result_status, created_at, completed_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000050','-','')),
'PROVISION_STARTER', @inventory_account_uuid, @inventory_session_uuid,
@inventory_character_uuid, NULL, @source_inventory_id, 5, 'starter-provision-1',
'starter-correlation-1', 1, UNHEX(SHA2('starter',256)), 3, 3, 'COMPLETED',
UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

DELIMITER //
CREATE PROCEDURE assert_duplicate_starter_rejected()
BEGIN
    DECLARE duplicate_rejected BOOLEAN DEFAULT FALSE;
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET duplicate_rejected = TRUE;
        INSERT INTO cnr_item_transactions
        (operation_uuid, action, account_uuid, session_uuid, character_uuid,
        source_inventory_id, target_inventory_id, quantity, request_id, correlation_id,
        contract_version, payload_sha256, result_source_version, result_target_version,
        result_status, created_at, completed_at)
        VALUES
        (UNHEX(REPLACE('0190b7a0-6100-7000-8000-000000000051','-','')),
        'PROVISION_STARTER', @inventory_account_uuid, @inventory_session_uuid,
        @inventory_character_uuid, NULL, @source_inventory_id, 5, 'starter-provision-2',
        'starter-correlation-2', 1, UNHEX(SHA2('starter',256)), 3, 3, 'COMPLETED',
        UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));
    END;
    CALL assert_inventory_true(duplicate_rejected, 'duplicate starter package was accepted');
END//
DELIMITER ;
CALL assert_duplicate_starter_rejected();

DELETE FROM cnr_item_transactions WHERE character_uuid=@inventory_character_uuid;
DELETE FROM cnr_inventory_items WHERE inventory_id IN (@source_inventory_id, @target_inventory_id);
DELETE FROM cnr_item_instances WHERE id=@document_instance_id;
DELETE FROM cnr_inventories WHERE id IN (@source_inventory_id, @target_inventory_id);
DROP PROCEDURE assert_duplicate_starter_rejected;
DROP PROCEDURE assert_duplicate_reference_rejected;
DROP PROCEDURE assert_duplicate_operation_rejected;
DROP PROCEDURE assert_zero_quantity_rejected;
DROP PROCEDURE assert_duplicate_stack_rejected;
DROP PROCEDURE assert_inventory_true;
