# cnr_ui

## Responsibility
Bridges the common React NUI shell, central focus ownership, and localized registration view.

## Non-responsibility
Does not calculate authoritative prices, rewards, ownership, or permissions.

## Dependencies
`/onesync`, `cnr_core`, `cnr_logs`, `cnr_locales`, `cnr_config`, `cnr_registration`, `cnr_sessions`

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
