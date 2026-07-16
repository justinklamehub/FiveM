-- migrate:up
-- Creates database-driven technical roles and permissions without mixing them with character jobs.
CREATE TABLE cnr_technical_permissions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    code VARCHAR(96) NOT NULL,
    label_key VARCHAR(128) NOT NULL,
    description_key VARCHAR(128) NOT NULL,
    is_system TINYINT(1) NOT NULL DEFAULT 1,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_technical_permissions_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_technical_permissions_code (code),
    KEY ix_cnr_technical_permissions_active (is_active, code),
    CONSTRAINT ck_cnr_technical_permissions_system CHECK (is_system IN (0, 1)),
    CONSTRAINT ck_cnr_technical_permissions_active CHECK (is_active IN (0, 1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_technical_roles (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    code VARCHAR(64) NOT NULL,
    label_key VARCHAR(128) NOT NULL,
    description_key VARCHAR(128) NOT NULL,
    priority SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    is_system TINYINT(1) NOT NULL DEFAULT 1,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_technical_roles_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_technical_roles_code (code),
    KEY ix_cnr_technical_roles_active (is_active, priority, code),
    CONSTRAINT ck_cnr_technical_roles_system CHECK (is_system IN (0, 1)),
    CONSTRAINT ck_cnr_technical_roles_active CHECK (is_active IN (0, 1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_technical_role_permissions (
    role_id BIGINT UNSIGNED NOT NULL,
    permission_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME(6) NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    KEY ix_cnr_technical_role_permissions_permission (permission_id, role_id),
    CONSTRAINT fk_cnr_technical_role_permissions_role
        FOREIGN KEY (role_id) REFERENCES cnr_technical_roles (id),
    CONSTRAINT fk_cnr_technical_role_permissions_permission
        FOREIGN KEY (permission_id) REFERENCES cnr_technical_permissions (id)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE cnr_account_technical_roles (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    public_uuid BINARY(16) NOT NULL,
    account_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    granted_by_account_id BIGINT UNSIGNED NULL,
    reason_code VARCHAR(96) NOT NULL,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE',
    starts_at DATETIME(6) NOT NULL,
    ends_at DATETIME(6) NULL,
    revoked_at DATETIME(6) NULL,
    revoked_by_account_id BIGINT UNSIGNED NULL,
    revocation_reason_code VARCHAR(96) NULL,
    created_at DATETIME(6) NOT NULL,
    updated_at DATETIME(6) NOT NULL,
    active_role_id BIGINT UNSIGNED
        GENERATED ALWAYS AS (
            CASE WHEN status = 'ACTIVE' THEN role_id ELSE NULL END
        ) PERSISTENT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cnr_account_technical_roles_public_uuid (public_uuid),
    UNIQUE KEY uq_cnr_account_technical_roles_active (account_id, active_role_id),
    KEY ix_cnr_account_technical_roles_lookup (account_id, status, starts_at, ends_at),
    KEY ix_cnr_account_technical_roles_role (role_id, status),
    CONSTRAINT fk_cnr_account_technical_roles_account
        FOREIGN KEY (account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_account_technical_roles_role
        FOREIGN KEY (role_id) REFERENCES cnr_technical_roles (id),
    CONSTRAINT fk_cnr_account_technical_roles_granted_by
        FOREIGN KEY (granted_by_account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT fk_cnr_account_technical_roles_revoked_by
        FOREIGN KEY (revoked_by_account_id) REFERENCES cnr_accounts (id),
    CONSTRAINT ck_cnr_account_technical_roles_status CHECK (
        status IN ('ACTIVE', 'REVOKED', 'EXPIRED')
    )
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO cnr_technical_permissions (
    public_uuid,
    code,
    label_key,
    description_key,
    is_system,
    is_active,
    created_at,
    updated_at
)
VALUES
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000001', '-', '')), 'system.status.read', 'permissions.permission.system_status_read.label', 'permissions.permission.system_status_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000002', '-', '')), 'logs.read', 'permissions.permission.logs_read.label', 'permissions.permission.logs_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000003', '-', '')), 'accounts.read', 'permissions.permission.accounts_read.label', 'permissions.permission.accounts_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000004', '-', '')), 'accounts.manage', 'permissions.permission.accounts_manage.label', 'permissions.permission.accounts_manage.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000005', '-', '')), 'permissions.read', 'permissions.permission.permissions_read.label', 'permissions.permission.permissions_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000006', '-', '')), 'permissions.manage', 'permissions.permission.permissions_manage.label', 'permissions.permission.permissions_manage.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000007', '-', '')), 'whitelist.read', 'permissions.permission.whitelist_read.label', 'permissions.permission.whitelist_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000008', '-', '')), 'whitelist.manage', 'permissions.permission.whitelist_manage.label', 'permissions.permission.whitelist_manage.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-000000000009', '-', '')), 'sessions.read', 'permissions.permission.sessions_read.label', 'permissions.permission.sessions_read.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-8000-00000000000a', '-', '')), 'sessions.terminate', 'permissions.permission.sessions_terminate.label', 'permissions.permission.sessions_terminate.description', 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

INSERT INTO cnr_technical_roles (
    public_uuid,
    code,
    label_key,
    description_key,
    priority,
    is_system,
    is_active,
    created_at,
    updated_at
)
VALUES
    (UNHEX(REPLACE('018f0000-0000-7000-9000-000000000001', '-', '')), 'owner', 'permissions.role.owner.label', 'permissions.role.owner.description', 1000, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-9000-000000000002', '-', '')), 'administrator', 'permissions.role.administrator.label', 'permissions.role.administrator.description', 800, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-9000-000000000003', '-', '')), 'moderator', 'permissions.role.moderator.label', 'permissions.role.moderator.description', 500, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6)),
    (UNHEX(REPLACE('018f0000-0000-7000-9000-000000000004', '-', '')), 'support', 'permissions.role.support.label', 'permissions.role.support.description', 300, 1, 1, UTC_TIMESTAMP(6), UTC_TIMESTAMP(6));

INSERT INTO cnr_technical_role_permissions (role_id, permission_id, created_at)
SELECT
    role_row.id,
    permission_row.id,
    UTC_TIMESTAMP(6)
FROM cnr_technical_roles AS role_row
CROSS JOIN cnr_technical_permissions AS permission_row
WHERE
    role_row.code IN ('owner', 'administrator')
    OR (
        role_row.code = 'moderator'
        AND permission_row.code IN (
            'system.status.read',
            'logs.read',
            'accounts.read',
            'permissions.read',
            'whitelist.read',
            'whitelist.manage',
            'sessions.read',
            'sessions.terminate'
        )
    )
    OR (
        role_row.code = 'support'
        AND permission_row.code IN (
            'system.status.read',
            'logs.read',
            'accounts.read',
            'permissions.read',
            'whitelist.read',
            'sessions.read'
        )
    );

-- migrate:down
DROP TABLE IF EXISTS cnr_account_technical_roles;
DROP TABLE IF EXISTS cnr_technical_role_permissions;
DROP TABLE IF EXISTS cnr_technical_roles;
DROP TABLE IF EXISTS cnr_technical_permissions;
