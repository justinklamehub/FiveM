# cnr_permissions

## Responsibility

Owns database-driven technical roles, permission catalogs, account role assignments, and server-authoritative permission checks.

## Non-responsibility

Does not own character jobs, police ranks, business employment, factions, inventory access, money, or any roleplay authority.

## Dependencies

`/onesync`, `cnr_database`, `cnr_logs`, `cnr_locales`, `cnr_config`, `cnr_core`, `cnr_accounts`

## Public exports

- `get_status()`
- `get_snapshot(account_uuid, correlation_id)`
- `has_permission(account_uuid, permission_code, correlation_id)`
- `require_permission(account_uuid, permission_code, correlation_id)`
- `grant_role(actor_uuid, account_uuid, role_code, reason_code, ends_at, correlation_id)`
- `revoke_role(actor_uuid, account_uuid, role_code, reason_code, correlation_id)`

Role mutations require the actor account to hold `permissions.manage`. The protected `owner` role can only be assigned or revoked through the FXServer console.

## Console bootstrap commands

```text
cnr_role_grant <account_uuid> <role_code> [reason_code]
cnr_role_revoke <account_uuid> <role_code> [reason_code]
cnr_role_show <account_uuid>
```

These commands only accept source `0`, which means the server console. They are intended to create the first owner assignment and to recover access before a control panel exists.

## Owned tables

- `cnr_technical_permissions`
- `cnr_technical_roles`
- `cnr_technical_role_permissions`
- `cnr_account_technical_roles`

## Default technical roles

- `owner`
- `administrator`
- `moderator`
- `support`

The migration seeds sensible defaults, but runtime checks read the database instead of hardcoding role membership. A later control panel can therefore change role-to-permission mappings without rewriting gameplay scripts.

## Security boundary

Clients never submit an authoritative role or permission decision. Consumers must pass a server-resolved account UUID, and mutation exports independently verify `permissions.manage`. The owner role is excluded from normal mutation exports.

## Lifecycle and recovery

Expired assignments are transitioned from `ACTIVE` to `EXPIRED` before evaluation. The database also prevents duplicate active assignments for the same account and role.

## Tests

Identifier validation is covered by Busted. Manifest, migration ownership, seeded roles, and the active-assignment uniqueness contract are checked in CI.
