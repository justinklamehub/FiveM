-- migrate:up
-- Creates the first Wave 1 account, identifier, whitelist, restriction, and session tables.
CREATE TABLE cnr_accounts (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    status VARCHAR(32) NOT NULL,
    version BIGINT UNSIGNED NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    archived_at DATETIME(6) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_accounts_public_uuid (public_uuid),
    KEY ix_cnr_accounts_status (status),
    CONSTRAINT ck_cnr_accounts_status CHECK (
        status IN (
            'PENDING_REGISTRATION',
            'PENDING_WHITELIST',
            'ACTIVE',
            'SUSPENDED',
            'BANNED',
            'RESTRICTED',
            'ARCHIVED'
        )
    )
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_account_identifiers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    account_id BIGINT UNSIGNED NOT NULL,
    identifier_type VARCHAR(32) NOT NULL,
    identifier_hash BINARY(32) NOT NULL,
    identifier_hint VARCHAR(16) NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    first_seen_at DATETIME(6) NOT NULL,
    last_seen_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_account_identifiers_hash (identifier_type, identifier_hash),
    KEY ix_cnr_account_identifiers_account (account_id, is_primary),
    CONSTRAINT fk_cnr_account_identifiers_account
        FOREIGN KEY (account_id) REFERENCES cnr_accounts (id)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_account_restrictions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    restriction_type VARCHAR(32) NOT NULL,
    reason_code VARCHAR(64) NOT NULL,
    starts_at DATETIME(6) NOT NULL,
    ends_at DATETIME(6) NULL,
    revoked_at DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_account_restrictions_public_uuid (public_uuid),
    KEY ix_cnr_account_restrictions_active (account_id, starts_at, ends_at, revoked_at),
    CONSTRAINT fk_cnr_account_restrictions_account
        FOREIGN KEY (account_id) REFERENCES cnr_accounts (id)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_whitelist_entries (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    entry_type VARCHAR(32) NOT NULL DEFAULT 'STANDARD',
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    starts_at DATETIME(6) NOT NULL,
    ends_at DATETIME(6) NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_whitelist_entries_public_uuid (public_uuid),
    KEY ix_cnr_whitelist_entries_active (account_id, status, starts_at, ends_at),
    CONSTRAINT fk_cnr_whitelist_entries_account
        FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT ck_cnr_whitelist_entries_status CHECK (status IN ('ACTIVE', 'REVOKED', 'EXPIRED'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_account_sessions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    server_instance_id VARCHAR(96) NOT NULL,
    source_at_start INT UNSIGNED NOT NULL,
    player_name VARCHAR(64) NOT NULL,
    status VARCHAR(16) NOT NULL,
    access_state VARCHAR(16) NOT NULL,
    started_at DATETIME(6) NOT NULL,
    activated_at DATETIME(6) NULL,
    last_seen_at DATETIME(6) NOT NULL,
    ended_at DATETIME(6) NULL,
    end_reason VARCHAR(128) NULL,
    client_drop_reason INT UNSIGNED NULL,
    active_account_id BIGINT UNSIGNED
        GENERATED ALWAYS AS (
            CASE WHEN status IN ('CONNECTING', 'ACTIVE') THEN account_id ELSE NULL END
        ) PERSISTENT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_account_sessions_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_account_sessions_one_active (active_account_id),
    KEY ix_cnr_account_sessions_source (server_instance_id, source_at_start, status),
    KEY ix_cnr_account_sessions_account_time (account_id, started_at),
    CONSTRAINT fk_cnr_account_sessions_account
        FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT ck_cnr_account_sessions_status CHECK (
        status IN ('CONNECTING', 'ACTIVE', 'ENDED', 'REJECTED', 'STALE')
    ),
    CONSTRAINT ck_cnr_account_sessions_access CHECK (
        access_state IN ('ONBOARDING', 'LIMITED', 'FULL')
    )
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- migrate:down
DROP TABLE IF EXISTS cnr_account_sessions;
DROP TABLE IF EXISTS cnr_whitelist_entries;
DROP TABLE IF EXISTS cnr_account_restrictions;
DROP TABLE IF EXISTS cnr_account_identifiers;
DROP TABLE IF EXISTS cnr_accounts;
