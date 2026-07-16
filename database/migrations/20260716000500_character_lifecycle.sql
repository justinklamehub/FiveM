-- migrate:up
-- Owns configurable character slots, draft identity, creation operations, and base documents.
CREATE TABLE cnr_character_settings (
    settings_key VARCHAR(64) NOT NULL,
    integer_value INT UNSIGNED NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (settings_key),
    CONSTRAINT ck_cnr_character_settings_value CHECK (integer_value BETWEEN 1 AND 100)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_backgrounds (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    code VARCHAR(64) NOT NULL,
    label VARCHAR(96) NOT NULL,
    description VARCHAR(255) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    sort_order SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_character_backgrounds_code (code),
    CONSTRAINT ck_cnr_character_backgrounds_active CHECK (is_active IN (0, 1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_characters (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    slot_number SMALLINT UNSIGNED NOT NULL,
    status VARCHAR(24) NOT NULL,
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    activated_at DATETIME(6) NULL,
    archived_at DATETIME(6) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_characters_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_characters_account_slot (account_id, slot_number),
    KEY ix_cnr_characters_account_status (account_id, status),
    CONSTRAINT fk_cnr_characters_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT ck_cnr_characters_status CHECK (status IN ('DRAFT', 'ACTIVE', 'INJURED', 'JAILED', 'RESTRICTED', 'ARCHIVED', 'DECEASED', 'PENDING_DELETION')),
    CONSTRAINT ck_cnr_characters_slot CHECK (slot_number > 0)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_identities (
    character_id BIGINT UNSIGNED NOT NULL,
    first_name VARCHAR(48) NOT NULL,
    last_name VARCHAR(48) NOT NULL,
    date_of_birth DATE NOT NULL,
    background_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (character_id),
    KEY ix_cnr_character_identities_name (last_name, first_name),
    CONSTRAINT fk_cnr_character_identities_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT fk_cnr_character_identities_background FOREIGN KEY (background_id) REFERENCES cnr_character_backgrounds (id)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_document_types (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    code VARCHAR(64) NOT NULL,
    label VARCHAR(96) NOT NULL,
    number_prefix VARCHAR(12) NOT NULL,
    is_base_document TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_document_types_code (code),
    CONSTRAINT ck_cnr_document_types_base CHECK (is_base_document IN (0, 1)),
    CONSTRAINT ck_cnr_document_types_active CHECK (is_active IN (0, 1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_documents (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    character_id BIGINT UNSIGNED NOT NULL,
    document_type_id BIGINT UNSIGNED NOT NULL,
    document_number VARCHAR(48) NOT NULL,
    status VARCHAR(16) NOT NULL,
    issued_at DATETIME(6) NOT NULL,
    expires_at DATETIME(6) NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_character_documents_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_character_documents_number (document_number),
    UNIQUE KEY uq_cnr_character_documents_type (character_id, document_type_id),
    CONSTRAINT fk_cnr_character_documents_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT fk_cnr_character_documents_type FOREIGN KEY (document_type_id) REFERENCES cnr_document_types (id),
    CONSTRAINT ck_cnr_character_documents_status CHECK (status IN ('ACTIVE', 'EXPIRED', 'SUSPENDED', 'REVOKED', 'LOST'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_operations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    operation_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    session_id BIGINT UNSIGNED NOT NULL,
    character_id BIGINT UNSIGNED NOT NULL,
    action VARCHAR(24) NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    result_status VARCHAR(24) NOT NULL,
    created_at DATETIME(6) NOT NULL,
    completed_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_character_operations_uuid (operation_uuid),
    KEY ix_cnr_character_operations_account (account_id, created_at),
    CONSTRAINT fk_cnr_character_operations_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_character_operations_session FOREIGN KEY (session_id) REFERENCES cnr_account_sessions (id),
    CONSTRAINT fk_cnr_character_operations_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT ck_cnr_character_operations_action CHECK (action IN ('CREATE_DRAFT', 'ACTIVATE')),
    CONSTRAINT ck_cnr_character_operations_status CHECK (result_status IN ('DRAFT', 'ACTIVE'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_character_settings (settings_key, integer_value, updated_at) VALUES
    ('slot_limit', 3, UTC_TIMESTAMP(6)),
    ('minimum_age', 18, UTC_TIMESTAMP(6)),
    ('maximum_age', 85, UTC_TIMESTAMP(6));

INSERT INTO cnr_character_backgrounds (code, label, description, is_active, sort_order, created_at, updated_at) VALUES
    ('local', 'San Andreas Local', 'Born and raised in San Andreas.', 1, 10, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    ('new_arrival', 'New Arrival', 'Recently moved to San Andreas for a new beginning.', 1, 20, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    ('returning_resident', 'Returning Resident', 'Returned to San Andreas after time away.', 1, 30, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

INSERT INTO cnr_document_types (code, label, number_prefix, is_base_document, is_active, created_at, updated_at) VALUES
    ('state_id', 'State Identification Card', 'SID', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

-- migrate:down
DROP TABLE IF EXISTS cnr_character_operations;
DROP TABLE IF EXISTS cnr_character_documents;
DROP TABLE IF EXISTS cnr_document_types;
DROP TABLE IF EXISTS cnr_character_identities;
DROP TABLE IF EXISTS cnr_characters;
DROP TABLE IF EXISTS cnr_character_backgrounds;
DROP TABLE IF EXISTS cnr_character_settings;
