# cnr_registration

## Responsibility

Owns the current versioned ruleset, explicit acceptance evidence, idempotent registration operations, and the atomic transition from `PENDING_REGISTRATION`.

## Security boundary

The FiveM source resolves the active ONBOARDING session and account. Client-supplied account, session, whitelist, status, or access values are never accepted. Reusing an operation UUID with different content is a conflict.

## Public interface

- Network request `cnr:registration:request` with actions `status`, `ruleset`, and `submit`.
- Network response `cnr:registration:response`, correlated by the client request ID.

## Owned tables

- `cnr_rulesets`
- `cnr_ruleset_acceptances`
- `cnr_registration_operations`

## Non-responsibility

Does not create accounts, characters, roleplay identities, spawn access, or gameplay state.
