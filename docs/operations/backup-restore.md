# Development backup and restore

Wave 0 documents the operational boundary; production automation is deliberately not included.

## Local backup

```bash
docker compose exec -T mariadb mariadb-dump \
  -uroot -p"$MARIADB_ROOT_PASSWORD" --single-transaction --routines --events \
  "$CNR_DB_NAME" > cnr-development.sql
```

## Isolated restore rehearsal

Restore only into the local test database, never over development or production without an approved change:

```bash
docker compose exec -T mariadb mariadb \
  -uroot -p"$MARIADB_ROOT_PASSWORD" "$CNR_DB_TEST_NAME" < cnr-development.sql
```

After restore, run dbmate status against `TEST_DATABASE_URL`. Production backups must be encrypted, stored separately, monitored, and periodically restored in staging.
