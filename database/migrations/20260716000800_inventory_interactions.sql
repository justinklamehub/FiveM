-- migrate:up
-- Adds server-validated personal-inventory repositioning and stable item image keys.
ALTER TABLE cnr_item_definitions
    ADD COLUMN icon_key VARCHAR(96) NULL AFTER description;

UPDATE cnr_item_definitions
SET icon_key=code, updated_at=UTC_TIMESTAMP(6)
WHERE icon_key IS NULL;

ALTER TABLE cnr_item_definitions
    MODIFY COLUMN icon_key VARCHAR(96) NOT NULL,
    ADD CONSTRAINT ck_cnr_item_definitions_icon_key CHECK (
        icon_key REGEXP '^[a-z][a-z0-9_]*$'
    );

ALTER TABLE cnr_item_transactions
    ADD COLUMN source_slot SMALLINT UNSIGNED NULL AFTER target_entry_uuid,
    ADD COLUMN target_slot SMALLINT UNSIGNED NULL AFTER source_slot,
    DROP CONSTRAINT ck_cnr_item_transactions_action,
    DROP CONSTRAINT ck_cnr_item_transactions_shape;

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
    );

-- migrate:down
ALTER TABLE cnr_item_transactions
    DROP CONSTRAINT ck_cnr_item_transactions_shape,
    DROP CONSTRAINT ck_cnr_item_transactions_action;

ALTER TABLE cnr_item_transactions
    ADD CONSTRAINT ck_cnr_item_transactions_action CHECK (
        action IN ('PROVISION_STARTER', 'TRANSFER')
    ),
    ADD CONSTRAINT ck_cnr_item_transactions_shape CHECK (
        (action = 'PROVISION_STARTER' AND source_inventory_id IS NULL AND definition_id IS NULL AND item_instance_id IS NULL)
        OR (action = 'TRANSFER' AND source_inventory_id IS NOT NULL AND source_inventory_id <> target_inventory_id AND definition_id IS NOT NULL)
    ),
    DROP COLUMN target_slot,
    DROP COLUMN source_slot;

ALTER TABLE cnr_item_definitions
    DROP CONSTRAINT ck_cnr_item_definitions_icon_key,
    DROP COLUMN icon_key;
