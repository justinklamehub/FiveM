-- migrate:up
-- Owns versioned rulesets, durable acceptance evidence, and idempotent registration operations.
CREATE TABLE cnr_rulesets (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    version INT UNSIGNED NOT NULL,
    status VARCHAR(16) NOT NULL,
    content_de MEDIUMTEXT NOT NULL,
    content_en MEDIUMTEXT NOT NULL,
    content_sha256 BINARY(32) NOT NULL,
    published_at DATETIME(6) NOT NULL,
    retired_at DATETIME(6) NULL,
    current_slot TINYINT UNSIGNED
        GENERATED ALWAYS AS (CASE WHEN status = 'CURRENT' THEN 1 ELSE NULL END) PERSISTENT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_rulesets_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_rulesets_version (version),
    UNIQUE KEY uq_cnr_rulesets_one_current (current_slot),
    CONSTRAINT ck_cnr_rulesets_status CHECK (status IN ('CURRENT', 'RETIRED'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_registration_operations (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    operation_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    session_id BIGINT UNSIGNED NOT NULL,
    ruleset_id BIGINT UNSIGNED NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    correlation_id VARCHAR(96) NOT NULL,
    contract_version SMALLINT UNSIGNED NOT NULL,
    locale VARCHAR(8) NOT NULL,
    accepted TINYINT(1) NOT NULL,
    payload_sha256 BINARY(32) NOT NULL,
    result_account_status VARCHAR(32) NOT NULL,
    result_access_state VARCHAR(16) NOT NULL,
    created_at DATETIME(6) NOT NULL,
    completed_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_registration_operations_uuid (operation_uuid),
    UNIQUE KEY uq_cnr_registration_operations_account (account_id),
    KEY ix_cnr_registration_operations_account (account_id, created_at),
    CONSTRAINT fk_cnr_registration_operations_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_registration_operations_session FOREIGN KEY (session_id) REFERENCES cnr_account_sessions (id),
    CONSTRAINT fk_cnr_registration_operations_ruleset FOREIGN KEY (ruleset_id) REFERENCES cnr_rulesets (id),
    CONSTRAINT ck_cnr_registration_operations_accepted CHECK (accepted = 1),
    CONSTRAINT ck_cnr_registration_operations_locale CHECK (locale IN ('de', 'en')),
    CONSTRAINT ck_cnr_registration_operations_account_status CHECK (result_account_status IN ('PENDING_WHITELIST', 'ACTIVE')),
    CONSTRAINT ck_cnr_registration_operations_access CHECK (result_access_state IN ('LIMITED', 'FULL'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_ruleset_acceptances (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    ruleset_id BIGINT UNSIGNED NOT NULL,
    operation_id BIGINT UNSIGNED NOT NULL,
    session_id BIGINT UNSIGNED NOT NULL,
    locale VARCHAR(8) NOT NULL,
    accepted_at DATETIME(6) NOT NULL,
    ruleset_content_sha256 BINARY(32) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_ruleset_acceptances_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_ruleset_acceptances_account_ruleset (account_id, ruleset_id),
    UNIQUE KEY uq_cnr_ruleset_acceptances_operation (operation_id),
    CONSTRAINT fk_cnr_ruleset_acceptances_account FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_ruleset_acceptances_ruleset FOREIGN KEY (ruleset_id) REFERENCES cnr_rulesets (id),
    CONSTRAINT fk_cnr_ruleset_acceptances_operation FOREIGN KEY (operation_id) REFERENCES cnr_registration_operations (id),
    CONSTRAINT fk_cnr_ruleset_acceptances_session FOREIGN KEY (session_id) REFERENCES cnr_account_sessions (id),
    CONSTRAINT ck_cnr_ruleset_acceptances_locale CHECK (locale IN ('de', 'en'))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_rulesets (
    public_uuid, version, status, content_de, content_en, content_sha256, published_at
) VALUES (
    UNHEX(REPLACE('0190b7a0-0000-7000-8000-000000000001', '-', '')),
    1,
    'CURRENT',
    'Behandle andere respektvoll. Cheating, Exploits und Belästigung sind verboten. Roleplay bleibt fair und nachvollziehbar. Folge den Anweisungen des Serverteams.',
    'Treat others respectfully. Cheating, exploits, and harassment are prohibited. Roleplay must remain fair and understandable. Follow server staff instructions.',
    UNHEX(SHA2(CONCAT(
        'Behandle andere respektvoll. Cheating, Exploits und Belästigung sind verboten. Roleplay bleibt fair und nachvollziehbar. Folge den Anweisungen des Serverteams.',
        '\n',
        'Treat others respectfully. Cheating, exploits, and harassment are prohibited. Roleplay must remain fair and understandable. Follow server staff instructions.'
    ), 256)),
    UTC_TIMESTAMP(6)
);

-- migrate:down
DROP TABLE IF EXISTS cnr_ruleset_acceptances;
DROP TABLE IF EXISTS cnr_registration_operations;
DROP TABLE IF EXISTS cnr_rulesets;
