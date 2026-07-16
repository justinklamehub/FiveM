-- migrate:up
-- Persists session-bound character selection, appearance snapshots, and controlled spawn state.
CREATE TABLE cnr_character_session_bindings (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    operation_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    session_id BIGINT UNSIGNED NOT NULL,
    character_id BIGINT UNSIGNED NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    status VARCHAR(16) NOT NULL,
    routing_bucket INT UNSIGNED NOT NULL,
    spawn_uuid BINARY(16) NULL,
    spawn_state VARCHAR(16) NOT NULL,
    spawn_reason VARCHAR(32) NULL,
    spawn_x DECIMAL(10, 4) NULL,
    spawn_y DECIMAL(10, 4) NULL,
    spawn_z DECIMAL(10, 4) NULL,
    spawn_heading DECIMAL(7, 3) NULL,
    selected_at DATETIME(6) NOT NULL,
    spawned_at DATETIME(6) NULL,
    ended_at DATETIME(6) NULL,
    active_character_id BIGINT UNSIGNED AS (CASE WHEN status = 'ACTIVE' THEN character_id ELSE NULL END) PERSISTENT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_character_bindings_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_character_bindings_operation_uuid (operation_uuid),
    UNIQUE KEY uq_cnr_character_bindings_session (session_id),
    UNIQUE KEY uq_cnr_character_bindings_active_character (active_character_id),
    UNIQUE KEY uq_cnr_character_bindings_spawn_uuid (spawn_uuid),
    KEY ix_cnr_character_bindings_account (account_id, selected_at),
    CONSTRAINT fk_cnr_character_bindings_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_character_bindings_session FOREIGN KEY (session_id) REFERENCES cnr_account_sessions (id),
    CONSTRAINT fk_cnr_character_bindings_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT ck_cnr_character_bindings_status CHECK (status IN ('ACTIVE', 'ENDED')),
    CONSTRAINT ck_cnr_character_bindings_spawn_state CHECK (spawn_state IN ('APPEARANCE_REQUIRED', 'PENDING', 'SPAWNED', 'ENDED')),
    CONSTRAINT ck_cnr_character_bindings_spawn_coordinates CHECK (
        (spawn_state = 'APPEARANCE_REQUIRED' AND spawn_uuid IS NULL AND spawn_x IS NULL AND spawn_y IS NULL AND spawn_z IS NULL AND spawn_heading IS NULL)
        OR
        (spawn_state IN ('PENDING', 'SPAWNED') AND spawn_uuid IS NOT NULL AND spawn_x IS NOT NULL AND spawn_y IS NOT NULL AND spawn_z IS NOT NULL AND spawn_heading IS NOT NULL)
        OR
        (spawn_state = 'ENDED')
    )
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_appearances (
    character_id BIGINT UNSIGNED NOT NULL,
    public_uuid BINARY(16) NOT NULL,
    model VARCHAR(32) NOT NULL,
    shape_first SMALLINT UNSIGNED NOT NULL,
    shape_second SMALLINT UNSIGNED NOT NULL,
    shape_mix TINYINT UNSIGNED NOT NULL,
    skin_mix TINYINT UNSIGNED NOT NULL,
    face_features LONGTEXT NOT NULL,
    hair_style SMALLINT UNSIGNED NOT NULL,
    hair_texture SMALLINT UNSIGNED NOT NULL,
    hair_color TINYINT UNSIGNED NOT NULL,
    hair_highlight TINYINT UNSIGNED NOT NULL,
    eye_color TINYINT UNSIGNED NOT NULL,
    outfit_code VARCHAR(32) NOT NULL,
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (character_id),
    UNIQUE KEY uq_cnr_character_appearances_public_uuid (public_uuid),
    CONSTRAINT fk_cnr_character_appearances_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT ck_cnr_character_appearances_model CHECK (model IN ('mp_m_freemode_01', 'mp_f_freemode_01')),
    CONSTRAINT ck_cnr_character_appearances_parents CHECK (shape_first <= 45 AND shape_second <= 45),
    CONSTRAINT ck_cnr_character_appearances_mix CHECK (shape_mix <= 100 AND skin_mix <= 100),
    CONSTRAINT ck_cnr_character_appearances_face CHECK (JSON_VALID(face_features)),
    CONSTRAINT ck_cnr_character_appearances_hair CHECK (hair_style <= 76 AND hair_texture <= 10 AND hair_color <= 63 AND hair_highlight <= 63),
    CONSTRAINT ck_cnr_character_appearances_eye CHECK (eye_color <= 31),
    CONSTRAINT ck_cnr_character_appearances_outfit CHECK (outfit_code IN ('starter_casual'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_appearance_operations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    operation_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    session_id BIGINT UNSIGNED NOT NULL,
    character_id BIGINT UNSIGNED NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    result_version BIGINT UNSIGNED NOT NULL,
    created_at DATETIME(6) NOT NULL,
    completed_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_character_appearance_operations_uuid (operation_uuid),
    KEY ix_cnr_character_appearance_operations_character (character_id, created_at),
    CONSTRAINT fk_cnr_character_appearance_operations_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_character_appearance_operations_session FOREIGN KEY (session_id) REFERENCES cnr_account_sessions (id),
    CONSTRAINT fk_cnr_character_appearance_operations_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_character_locations (
    character_id BIGINT UNSIGNED NOT NULL,
    x DECIMAL(10, 4) NOT NULL,
    y DECIMAL(10, 4) NOT NULL,
    z DECIMAL(10, 4) NOT NULL,
    heading DECIMAL(7, 3) NOT NULL,
    location_type VARCHAR(24) NOT NULL,
    is_safe TINYINT(1) NOT NULL DEFAULT 1,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (character_id),
    CONSTRAINT fk_cnr_character_locations_character FOREIGN KEY (character_id) REFERENCES cnr_characters (id),
    CONSTRAINT ck_cnr_character_locations_type CHECK (location_type IN ('CENTRAL_DEFAULT', 'LAST_SAFE')),
    CONSTRAINT ck_cnr_character_locations_safe CHECK (is_safe IN (0, 1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- migrate:down
DROP TABLE IF EXISTS cnr_character_locations;
DROP TABLE IF EXISTS cnr_character_appearance_operations;
DROP TABLE IF EXISTS cnr_character_appearances;
DROP TABLE IF EXISTS cnr_character_session_bindings;
