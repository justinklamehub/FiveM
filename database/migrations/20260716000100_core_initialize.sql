-- migrate:up
-- Wave 0 intentionally creates no gameplay tables. Applying this migration proves that the
-- migration pipeline and schema-version check are operational before domain schemas exist.
SELECT 1;

-- migrate:down
-- Forward migrations are preferred in production. This no-op down section exists only so the
-- local verification workflow can prove that dbmate rollback is wired correctly.
SELECT 1;
