# cnr_whitelist

## Responsibility

Evaluates open, automatic, manual, and hybrid whitelist modes against active account entries.

## Non-responsibility

Does not create accounts, sessions, characters, bans, jobs, or gameplay permissions.

## Dependencies

`/onesync`, `cnr_database`, `cnr_logs`, `cnr_locales`, `cnr_config`, `cnr_core`

## Public exports

- `get_status()`
- `evaluate(account_uuid, correlation_id)`

## Events

None.

## Owned tables

- `cnr_whitelist_entries`
- `cnr_whitelist_applications` is reserved for a later registration slice

## Configuration

- `cnr_whitelist_mode`: `open`, `automatic`, `manual`, or `hybrid`

## Error codes

`WHITELIST_REQUIRED`, `DEPENDENCY_UNAVAILABLE`

## Security boundary

The client cannot choose the whitelist mode or submit an authoritative allow decision. Only the account UUID from the server connection flow is evaluated.

## Lifecycle and recovery

An invalid mode makes the resource unavailable. Existing entries remain persistent and no schema change runs during startup.

## Tests

The pure mode policy is covered by Busted. Manifest and migration contracts run in CI.
