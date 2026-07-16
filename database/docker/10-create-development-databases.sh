#!/usr/bin/env bash
set -euo pipefail

required=(
  CNR_DB_NAME CNR_DB_TEST_NAME CNR_DB_RUNTIME_USER CNR_DB_RUNTIME_PASSWORD
  CNR_DB_MIGRATION_USER CNR_DB_MIGRATION_PASSWORD MARIADB_ROOT_PASSWORD
)
for name in "${required[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    echo "Missing required environment variable: ${name}" >&2
    exit 1
  fi
done

for identifier_name in CNR_DB_NAME CNR_DB_TEST_NAME CNR_DB_RUNTIME_USER CNR_DB_MIGRATION_USER; do
  if [[ ! "${!identifier_name}" =~ ^[A-Za-z0-9_]+$ ]]; then
    echo "Unsafe SQL identifier in ${identifier_name}" >&2
    exit 1
  fi
done
for password_name in CNR_DB_RUNTIME_PASSWORD CNR_DB_MIGRATION_PASSWORD MARIADB_ROOT_PASSWORD; do
  if [[ ! "${!password_name}" =~ ^[A-Za-z0-9_@%+=:,.-]+$ ]]; then
    echo "Use only safe local password characters in ${password_name}." >&2
    exit 1
  fi
done

mariadb --protocol=socket -uroot -p"${MARIADB_ROOT_PASSWORD}" <<SQL
CREATE DATABASE IF NOT EXISTS \`${CNR_DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`${CNR_DB_TEST_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${CNR_DB_RUNTIME_USER}'@'%' IDENTIFIED BY '${CNR_DB_RUNTIME_PASSWORD}';
CREATE USER IF NOT EXISTS '${CNR_DB_MIGRATION_USER}'@'%' IDENTIFIED BY '${CNR_DB_MIGRATION_PASSWORD}';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON \`${CNR_DB_NAME}\`.* TO '${CNR_DB_RUNTIME_USER}'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON \`${CNR_DB_TEST_NAME}\`.* TO '${CNR_DB_RUNTIME_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${CNR_DB_NAME}\`.* TO '${CNR_DB_MIGRATION_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${CNR_DB_TEST_NAME}\`.* TO '${CNR_DB_MIGRATION_USER}'@'%';
FLUSH PRIVILEGES;
SQL
