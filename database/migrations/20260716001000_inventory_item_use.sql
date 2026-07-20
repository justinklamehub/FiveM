-- migrate:up
-- Adds replayable, server-authoritative consumable and State ID actions.
UPDATE cnr_item_definitions
SET use_handler='state_id_document', version=version+1, updated_at=UTC_TIMESTAMP(6)
WHERE code='state_id' AND use_handler IS NULL;

ALTER TABLE cnr_item_transactions
    ADD COLUMN item_action VARCHAR(24) NULL AFTER transfer_mode,
    DROP CONSTRAINT ck_cnr_item_transactions_action,
    DROP CONSTRAINT ck_cnr_item_transactions_shape;

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

-- migrate:down
DELETE FROM cnr_item_transactions WHERE action='USE_ITEM';

ALTER TABLE cnr_item_transactions
    DROP CONSTRAINT ck_cnr_item_transactions_shape,
    DROP CONSTRAINT ck_cnr_item_transactions_action;

ALTER TABLE cnr_item_transactions
    ADD CONSTRAINT ck_cnr_item_transactions_action CHECK (
        action IN ('PROVISION_STARTER', 'TRANSFER', 'REPOSITION')
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
        )
        OR (
            action = 'TRANSFER'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id <> target_inventory_id
            AND definition_id IS NOT NULL
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
        )
    ),
    DROP COLUMN item_action;

UPDATE cnr_item_definitions
SET use_handler=NULL, version=version+1, updated_at=UTC_TIMESTAMP(6)
WHERE code='state_id' AND use_handler='state_id_document';
