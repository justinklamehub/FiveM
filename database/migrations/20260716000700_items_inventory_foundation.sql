-- migrate:up
-- Adds the first Wave 2 item catalogue and server-authoritative personal inventories.
CREATE TABLE cnr_item_definitions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    code VARCHAR(64) NOT NULL,
    category VARCHAR(32) NOT NULL,
    label VARCHAR(96) NOT NULL,
    description VARCHAR(255) NOT NULL,
    is_stackable TINYINT(1) NOT NULL,
    is_unique TINYINT(1) NOT NULL,
    max_stack SMALLINT UNSIGNED NOT NULL,
    unit_weight_grams INT UNSIGNED NOT NULL,
    is_tradeable TINYINT(1) NOT NULL DEFAULT 1,
    is_drop_allowed TINYINT(1) NOT NULL DEFAULT 1,
    use_handler VARCHAR(96) NULL,
    metadata_schema_version SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_item_definitions_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_item_definitions_code (code),
    KEY ix_cnr_item_definitions_active (status, category, code),
    CONSTRAINT ck_cnr_item_definitions_category CHECK (
        category IN ('CONSUMABLE', 'DOCUMENT', 'TOOL', 'CONTAINER', 'MATERIAL', 'EVIDENCE')
    ),
    CONSTRAINT ck_cnr_item_definitions_flags CHECK (
        is_stackable IN (0, 1)
        AND is_unique IN (0, 1)
        AND is_tradeable IN (0, 1)
        AND is_drop_allowed IN (0, 1)
    ),
    CONSTRAINT ck_cnr_item_definitions_stack CHECK (
        (is_stackable = 1 AND is_unique = 0 AND max_stack > 1)
        OR (is_stackable = 0 AND max_stack = 1)
    ),
    CONSTRAINT ck_cnr_item_definitions_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_item_instances (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    definition_id BIGINT UNSIGNED NOT NULL,
    reference_type VARCHAR(32) NULL,
    reference_uuid BINARY(16) NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_item_instances_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_item_instances_reference (reference_type, reference_uuid),
    KEY ix_cnr_item_instances_definition (definition_id, status),
    CONSTRAINT fk_cnr_item_instances_definition FOREIGN KEY (definition_id) REFERENCES cnr_item_definitions (id),
    CONSTRAINT ck_cnr_item_instances_reference CHECK (
        (reference_type IS NULL AND reference_uuid IS NULL)
        OR (reference_type IS NOT NULL AND reference_uuid IS NOT NULL)
    ),
    CONSTRAINT ck_cnr_item_instances_status CHECK (status IN ('ACTIVE', 'CONSUMED', 'DESTROYED'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_inventories (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    owner_character_uuid BINARY(16) NOT NULL,
    inventory_type VARCHAR(24) NOT NULL,
    slot_capacity SMALLINT UNSIGNED NOT NULL,
    weight_capacity_grams INT UNSIGNED NOT NULL,
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_inventories_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_inventories_owner_type (owner_character_uuid, inventory_type),
    KEY ix_cnr_inventories_owner (owner_character_uuid, status),
    CONSTRAINT ck_cnr_inventories_type CHECK (inventory_type IN ('CHARACTER', 'PERSONAL_STORAGE')),
    CONSTRAINT ck_cnr_inventories_capacity CHECK (slot_capacity > 0 AND weight_capacity_grams > 0),
    CONSTRAINT ck_cnr_inventories_status CHECK (status IN ('ACTIVE', 'ARCHIVED'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_inventory_items (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    inventory_id BIGINT UNSIGNED NOT NULL,
    definition_id BIGINT UNSIGNED NOT NULL,
    item_instance_id BIGINT UNSIGNED NULL,
    stack_definition_id BIGINT UNSIGNED GENERATED ALWAYS AS (
        CASE WHEN item_instance_id IS NULL THEN definition_id ELSE NULL END
    ) PERSISTENT,
    slot_number SMALLINT UNSIGNED NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_inventory_items_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_inventory_items_slot (inventory_id, slot_number),
    UNIQUE KEY uq_cnr_inventory_items_instance (item_instance_id),
    UNIQUE KEY uq_cnr_inventory_items_stack (inventory_id, stack_definition_id),
    KEY ix_cnr_inventory_items_definition (definition_id, inventory_id),
    CONSTRAINT fk_cnr_inventory_items_inventory FOREIGN KEY (inventory_id) REFERENCES cnr_inventories (id),
    CONSTRAINT fk_cnr_inventory_items_definition FOREIGN KEY (definition_id) REFERENCES cnr_item_definitions (id),
    CONSTRAINT fk_cnr_inventory_items_instance FOREIGN KEY (item_instance_id) REFERENCES cnr_item_instances (id),
    CONSTRAINT ck_cnr_inventory_items_slot CHECK (slot_number > 0),
    CONSTRAINT ck_cnr_inventory_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_cnr_inventory_items_unique_quantity CHECK (item_instance_id IS NULL OR quantity = 1)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_item_transactions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    operation_uuid BINARY(16) NOT NULL,
    action VARCHAR(24) NOT NULL,
    account_uuid BINARY(16) NOT NULL,
    session_uuid BINARY(16) NOT NULL,
    character_uuid BINARY(16) NOT NULL,
    starter_character_uuid BINARY(16) GENERATED ALWAYS AS (
        CASE WHEN action = 'PROVISION_STARTER' THEN character_uuid ELSE NULL END
    ) PERSISTENT,
    source_inventory_id BIGINT UNSIGNED NULL,
    target_inventory_id BIGINT UNSIGNED NOT NULL,
    source_entry_uuid BINARY(16) NULL,
    target_entry_uuid BINARY(16) NULL,
    definition_id BIGINT UNSIGNED NULL,
    item_instance_id BIGINT UNSIGNED NULL,
    quantity INT UNSIGNED NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    result_source_version BIGINT UNSIGNED NOT NULL,
    result_target_version BIGINT UNSIGNED NOT NULL,
    result_status VARCHAR(16) NOT NULL,
    created_at DATETIME(6) NOT NULL,
    completed_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_item_transactions_operation_uuid (operation_uuid),
    UNIQUE KEY uq_cnr_item_transactions_starter_character (starter_character_uuid),
    KEY ix_cnr_item_transactions_character (character_uuid, created_at),
    KEY ix_cnr_item_transactions_source (source_inventory_id, created_at),
    KEY ix_cnr_item_transactions_target (target_inventory_id, created_at),
    CONSTRAINT fk_cnr_item_transactions_source FOREIGN KEY (source_inventory_id) REFERENCES cnr_inventories (id),
    CONSTRAINT fk_cnr_item_transactions_target FOREIGN KEY (target_inventory_id) REFERENCES cnr_inventories (id),
    CONSTRAINT fk_cnr_item_transactions_definition FOREIGN KEY (definition_id) REFERENCES cnr_item_definitions (id),
    CONSTRAINT fk_cnr_item_transactions_instance FOREIGN KEY (item_instance_id) REFERENCES cnr_item_instances (id),
    CONSTRAINT ck_cnr_item_transactions_action CHECK (action IN ('PROVISION_STARTER', 'TRANSFER')),
    CONSTRAINT ck_cnr_item_transactions_shape CHECK (
        (action = 'PROVISION_STARTER' AND source_inventory_id IS NULL AND definition_id IS NULL AND item_instance_id IS NULL)
        OR (action = 'TRANSFER' AND source_inventory_id IS NOT NULL AND source_inventory_id <> target_inventory_id AND definition_id IS NOT NULL)
    ),
    CONSTRAINT ck_cnr_item_transactions_quantity CHECK (quantity > 0),
    CONSTRAINT ck_cnr_item_transactions_versions CHECK (
        result_source_version > 0 AND result_target_version > 0
    ),
    CONSTRAINT ck_cnr_item_transactions_status CHECK (result_status = 'COMPLETED')
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_item_definitions
(public_uuid, code, category, label, description, is_stackable, is_unique, max_stack,
unit_weight_grams, is_tradeable, is_drop_allowed, use_handler, metadata_schema_version,
status, version, created_at, updated_at)
VALUES
(UNHEX(REPLACE('0190b7a0-6000-7000-8000-000000000001','-','')), 'water_bottle',
'CONSUMABLE', 'Water Bottle', 'A sealed bottle of drinking water.', 1, 0, 10, 500, 1, 1,
'consume_water', 1, 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
(UNHEX(REPLACE('0190b7a0-6000-7000-8000-000000000002','-','')), 'sandwich',
'CONSUMABLE', 'Sandwich', 'A simple wrapped sandwich.', 1, 0, 10, 250, 1, 1,
'consume_food', 1, 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
(UNHEX(REPLACE('0190b7a0-6000-7000-8000-000000000003','-','')), 'state_id',
'DOCUMENT', 'State Identification Card', 'The holder''s official state identification card.',
0, 1, 1, 20, 0, 0, NULL, 1, 'ACTIVE', 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

-- migrate:down
DROP TABLE IF EXISTS cnr_item_transactions;
DROP TABLE IF EXISTS cnr_inventory_items;
DROP TABLE IF EXISTS cnr_inventories;
DROP TABLE IF EXISTS cnr_item_instances;
DROP TABLE IF EXISTS cnr_item_definitions;
