# cnr_sessions

## Responsibility

Owns connection deferrals and the one-active-session invariant for each account.

## Non-responsibility

Does not own account identity, whitelist entries, characters, spawn selection, money, inventory, or gameplay state.

## Dependencies

`/onesync`, `cnr_database`, `cnr_logs`, `cnr_locales`, `cnr_config`, `cnr_core`, `cnr_accounts`, `cnr_whitelist`

## Public exports

- `get_status()`
- `get_session_for_source(source)`

## Events

- local `cnr:sessions:started` after a session is committed and activated

## Owned tables

- `cnr_account_sessions`

## Configuration

Uses account registration, whitelist, maintenance, schema, and identifier settings from lower-level resources.

## Error codes

`SESSION_ALREADY_ACTIVE`, `WHITELIST_REQUIRED`, `ACCOUNT_RESTRICTED`, `DEPENDENCY_UNAVAILABLE`, `INTERNAL_ERROR`

## Security boundary

The temporary FiveM source is stored only as active-session metadata and never becomes durable account identity. Deferrals use only server-resolved account and whitelist decisions.

## Lifecycle and recovery

Sessions from a replaced FXServer instance become `STALE`. The server instance UUID is retained in server-owned global state across resource-only restarts, so active sessions can still be closed by source on disconnect.

## Tests

The access policy is covered by Busted. Database uniqueness and migration contracts run in CI.
