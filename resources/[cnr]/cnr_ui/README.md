# cnr_ui

## Responsibility
Bridges the common React NUI shell, central focus ownership, English registration and character lifecycle views, local appearance preview, and execution of server-issued spawn instructions.

## Non-responsibility
Does not calculate authoritative prices, rewards, ownership, or permissions.

## Dependencies

The manifest declares only the client-compatible `/onesync` constraint and stock `spawnmanager`. Server-side integrations with
`cnr_core`, `cnr_registration`, `cnr_sessions`, and `cnr_characters` are ordered by `server.cfg` and
guarded by runtime readiness checks; declaring server-only resources as hard dependencies would make
the FiveM client reject `cnr_ui` because those resources have no client package.

## Public exports
`get_status`

## Events

`uiReady` (browser-to-Lua NUI callback), `cnr:ui:ready` (client-to-server readiness handshake),
`cnr:ui:open` (server-to-client network event), registration NUI callbacks, character lifecycle callbacks, and controlled-spawn events. The server derives
the view from the source-owned session; the client cannot select its access state or onboarding
destination.

The server sends the initial open event only after the React browser has acknowledged `uiReady`;
join and source-promotion events never claim NUI delivery before the browser listener exists.

Network-backed NUI callbacks return an immediate queue acknowledgement. The eventual server result
is delivered as a versioned `ui.request.response` message and matched by both event name and request
ID. Browser requests time out after ten seconds and expose an English retry action instead of
remaining in a permanent loading state.

## Owned tables
None.

## Configuration
NUI source lives under `packages/ui`; the build is generated into this resource.

For manual FXServer smoke testing, the client F8 command `cnr_registration_open` opens the English
registration view locally. It does not bypass server-side session, status, ruleset, or submission
validation.

## Error codes
Uses the stable Wave 0 result/error contract where applicable.

## Security boundary
One focus owner, one correlated response, validated versioned messages, bounded pending requests, and a lifecycle lock that releases only after the server confirms the issued spawn UUID. Appearance preview cannot send an account, session, character, routing bucket, or spawn location.

## Lifecycle and recovery
Reports `ready` or `degraded` to `cnr_core` and releases focus on client resource stop.

## Tests
Focus, English visual text, lifecycle browser mocks, contracts, manifests, and the production build are checked in CI.
