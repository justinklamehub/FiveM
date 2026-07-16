# cnr_ui

## Responsibility
Bridges the common React NUI shell, central focus ownership, and localized registration view.

## Non-responsibility
Does not calculate authoritative prices, rewards, ownership, or permissions.

## Dependencies

The manifest declares only the client-compatible `/onesync` constraint. Server-side integrations with
`cnr_core`, `cnr_registration`, `cnr_sessions`, and `cnr_characters` are ordered by `server.cfg` and
guarded by runtime readiness checks; declaring server-only resources as hard dependencies would make
the FiveM client reject `cnr_ui` because those resources have no client package.

## Public exports
`get_status`

## Events
`cnr:ui:open` (server-to-client network event) and registration NUI callbacks.

## Owned tables
None.

## Configuration
NUI source lives under `packages/ui`; the build is generated into this resource.

## Error codes
Uses the stable Wave 0 result/error contract where applicable.

## Security boundary
One focus owner, one callback response, validated versioned messages, and a defined Escape/close path.

## Lifecycle and recovery
Reports `ready` or `degraded` to `cnr_core` and releases focus on client resource stop.

## Tests
Focus, localization, contracts, manifests, and the production build are checked in CI.
