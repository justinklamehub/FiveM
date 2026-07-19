-- migrate:up
-- Persists detailed, replayable transfer outcomes for the personal-locker workspace.
ALTER TABLE cnr_item_transactions
    ADD COLUMN transfer_mode VARCHAR(24) NULL AFTER target_slot,
    DROP CONSTRAINT ck_cnr_item_transactions_shape;

ALTER TABLE cnr_item_transactions
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
    );

-- migrate:down
ALTER TABLE cnr_item_transactions
    DROP CONSTRAINT ck_cnr_item_transactions_shape;

UPDATE cnr_item_transactions
SET source_slot=NULL, target_slot=NULL, transfer_mode=NULL
WHERE action='TRANSFER';

ALTER TABLE cnr_item_transactions
    ADD CONSTRAINT ck_cnr_item_transactions_shape CHECK (
        (
            action = 'PROVISION_STARTER'
            AND source_inventory_id IS NULL
            AND definition_id IS NULL
            AND item_instance_id IS NULL
            AND source_slot IS NULL
            AND target_slot IS NULL
        )
        OR (
            action = 'TRANSFER'
            AND source_inventory_id IS NOT NULL
            AND source_inventory_id <> target_inventory_id
            AND definition_id IS NOT NULL
            AND source_slot IS NULL
            AND target_slot IS NULL
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
        )
    ),
    DROP COLUMN transfer_mode;
