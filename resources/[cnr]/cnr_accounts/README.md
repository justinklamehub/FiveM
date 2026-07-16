# cnr_accounts

## Responsibility

Owns technical accounts, normalized platform identifier mappings, registration state, and account restrictions.

## Non-responsibility

Does not own active sessions, whitelist decisions, characters, roleplay identity, money, inventory, jobs, or spawn selection.

## Dependencies

`/onesync`, `cnr_database`, `cnr_logs`, `cnr_locales`, `cnr_config`, `cnr_core`

## Public exports

- `get_status()`
- `resolve_connection(raw_identifiers, correlation_id)`

## Events

No public network events. Account creation is audited internally.

## Owned tables

- `cnr_accounts`
- `cnr_account_identifiers`
- `cnr_account_restrictions`

## Configuration

- `cnr_identifier_pepper`: server-only secret with at least 32 characters
- `cnr_registration_enabled`: `1` or `0`

## Error codes

`IDENTIFIER_REQUIRED`, `IDENTIFIER_CONFLICT`, `REGISTRATION_DISABLED`, `ACCOUNT_BANNED`, `ACCOUNT_RESTRICTED`, `DEPENDENCY_UNAVAILABLE`

## Security boundary

Raw platform identifiers are used only transiently for hashing. IP addresses are excluded from durable identity, and only identifier type plus a four-character hint may enter safe logs or responses.

## Lifecycle and recovery

The resource becomes unavailable when the identifier pepper is missing. Account creation retries lookup after uniqueness races and never runs DDL at startup.

## Tests

Identifier normalization and UUID contracts are covered by Busted. Manifest and migration ownership are checked in CI.
