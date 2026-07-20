-- migrate:up
-- Adds a unique character-bound tablet and replay-safe tablet provisioning/use records.
INSERT INTO cnr_item_definitions
(public_uuid, code, category, label, description, icon_key, is_stackable, is_unique, max_stack,
unit_weight_grams, is_tradeable, is_drop_allowed, use_handler, metadata_schema_version,
status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6000-7000-8000-000000000004','-','')), 'city_tablet',
'TOOL', 'City Tablet', 'A secure tablet for city services and personal applications.', 'city_tablet',
0, 1, 1, 650, 0, 0, 'open_tablet', 1, 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

ALTER TABLE cnr_item_transactions
    DROP CONSTRAINT ck_cnr_item_transactions_action,
    DROP CONSTRAINT ck_cnr_item_transactions_shape;

ALTER TABLE cnr_item_transactions
    ADD COLUMN tablet_character_uuid BINARY(16) GENERATED ALWAYS AS (
        CASE WHEN action = 'PROVISION_TABLET' THEN character_uuid ELSE NULL END
    ) PERSISTENT AFTER starter_character_uuid,
    ADD UNIQUE KEY uq_cnr_item_transactions_tablet_character (tablet_character_uuid),
    ADD CONSTRAINT ck_cnr_item_transactions_action CHECK (
        action IN ('PROVISION_STARTER', 'PROVISION_TABLET', 'TRANSFER', 'REPOSITION', 'USE_ITEM')
    ),
    ADD CONSTRAINT ck_cnr_item_transactions_shape CHECK (
        (
            action = 'PROVISION_STARTER'
            AND source_inventory_id IS NULL
            AND definition_id IS NULL
            AND item_instance_id IS NULL
            AND source_slot IS NULL
            AND target_slot IS NULL
            AND transfer_mode IS NULL
            AND item_action IS NULL
        )
        OR (
            action = 'PROVISION_TABLET'
            AND source_inventory_id IS NULL
            AND source_entry_uuid IS NULL
            AND target_entry_uuid IS NOT NULL
            AND definition_id IS NOT NULL
            AND item_instance_id IS NOT NULL
            AND source_slot IS NULL
            AND target_slot IS NOT NULL
            AND target_slot > 0
            AND transfer_mode IS NULL
            AND item_action IS NULL
            AND quantity = 1
        )
        OR (
            action = 'TRANSFER'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id <> target_inventory_id
            AND definition_id IS NOT NULL
            AND item_action IS NULL
            AND (
                (
                    source_slot IS NULL
                    AND target_slot IS NULL
                    AND transfer_mode IS NULL
                )
                OR (
                    source_slot IS NOT NULL
                    AND target_slot IS NOT NULL
                    AND source_slot > 0
                    AND target_slot > 0
                    AND transfer_mode IN ('MOVE_INSTANCE', 'STACK', 'CREATE_STACK')
                )
            )
        )
        OR (
            action = 'REPOSITION'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id = target_inventory_id
            AND definition_id IS NOT NULL
            AND source_slot IS NOT NULL
            AND target_slot IS NOT NULL
            AND source_slot > 0
            AND target_slot > 0
            AND source_slot <> target_slot
            AND transfer_mode IS NULL
            AND item_action IS NULL
        )
        OR (
            action = 'USE_ITEM'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id = target_inventory_id
            AND source_entry_uuid IS NOT NULL
            AND target_entry_uuid IS NULL
            AND definition_id IS NOT NULL
            AND source_slot IS NOT NULL
            AND source_slot > 0
            AND target_slot IS NULL
            AND transfer_mode IS NULL
            AND item_action IN ('DRINK', 'EAT', 'INSPECT_ID', 'SHOW_ID', 'OPEN_TABLET')
            AND quantity = 1
        )
    );

-- migrate:down
DELETE FROM cnr_item_transactions
WHERE action='USE_ITEM' AND item_action='OPEN_TABLET';
DELETE FROM cnr_item_transactions WHERE action='PROVISION_TABLET';
DELETE transaction_row FROM cnr_item_transactions transaction_row
INNER JOIN cnr_item_definitions definition ON definition.id=transaction_row.definition_id
WHERE definition.code='city_tablet';

DELETE ii FROM cnr_inventory_items ii
INNER JOIN cnr_item_definitions d ON d.id=ii.definition_id
WHERE d.code='city_tablet';
DELETE inst FROM cnr_item_instances inst
INNER JOIN cnr_item_definitions d ON d.id=inst.definition_id
WHERE d.code='city_tablet';
DELETE FROM cnr_item_definitions WHERE code='city_tablet';

ALTER TABLE cnr_item_transactions
    DROP CONSTRAINT ck_cnr_item_transactions_shape,
    DROP CONSTRAINT ck_cnr_item_transactions_action,
    DROP KEY uq_cnr_item_transactions_tablet_character,
    DROP COLUMN tablet_character_uuid;

ALTER TABLE cnr_item_transactions
    ADD CONSTRAINT ck_cnr_item_transactions_action CHECK (
        action IN ('PROVISION_STARTER', 'TRANSFER', 'REPOSITION', 'USE_ITEM')
    ),
    ADD CONSTRAINT ck_cnr_item_transactions_shape CHECK (
        (
            action = 'PROVISION_STARTER'
            AND source_inventory_id IS NULL
            AND definition_id IS NULL
            AND item_instance_id IS NULL
            AND source_slot IS NULL
            AND target_slot IS NULL
            AND transfer_mode IS NULL
            AND item_action IS NULL
        )
        OR (
            action = 'TRANSFER'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id <> target_inventory_id
            AND definition_id IS NOT NULL
            AND item_action IS NULL
            AND (
                (
                    source_slot IS NULL
                    AND target_slot IS NULL
                    AND transfer_mode IS NULL
                )
                OR (
                    source_slot IS NOT NULL
                    AND target_slot IS NOT NULL
                    AND source_slot > 0
                    AND target_slot > 0
                    AND transfer_mode IN ('MOVE_INSTANCE', 'STACK', 'CREATE_STACK')
                )
            )
        )
        OR (
            action = 'REPOSITION'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id = target_inventory_id
            AND definition_id IS NOT NULL
            AND source_slot IS NOT NULL
            AND target_slot IS NOT NULL
            AND source_slot > 0
            AND target_slot > 0
            AND source_slot <> target_slot
            AND transfer_mode IS NULL
            AND item_action IS NULL
        )
        OR (
            action = 'USE_ITEM'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id = target_inventory_id
            AND source_entry_uuid IS NOT NULL
            AND target_entry_uuid IS NULL
            AND definition_id IS NOT NULL
            AND source_slot IS NOT NULL
            AND source_slot > 0
            AND target_slot IS NULL
            AND transfer_mode IS NULL
            AND item_action IN ('DRINK', 'EAT', 'INSPECT_ID', 'SHOW_ID')
            AND quantity = 1
        )
    );
