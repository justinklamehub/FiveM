# cnr_ui

## Responsibility
Owns the packaged English loadscreen, server-driven lifecycle handoff, central focus ownership, registration, character and personal-inventory views, limited-access and recovery UX, a separate non-networked appearance preview ped, model-specific curated starter clothing, accessible slider steppers, and execution of server-issued spawn instructions.

## Non-responsibility
Does not calculate authoritative prices, rewards, ownership, or permissions.

## Dependencies

The manifest declares only the client-compatible `/onesync` constraint and stock `spawnmanager`. Server-side integrations with
`cnr_core`, `cnr_registration`, `cnr_sessions`, `cnr_characters`, and `cnr_inventory` are ordered by `server.cfg` and
guarded by runtime readiness checks; declaring server-only resources as hard dependencies would make
the FiveM client reject `cnr_ui` because those resources have no client package.

## Public exports
`get_status`

## Events

`uiReady` and `lifecycleRefresh` (browser-to-Lua NUI callbacks), `cnr:ui:ready` and
`cnr:ui:refresh` (client-to-server events), `cnr:ui:lifecycle` (server-to-client snapshot),
registration NUI callbacks, character lifecycle callbacks, inventory snapshot/transfer callbacks, and controlled-spawn events. The server
derives the view from the source-owned session; the client cannot select its access state, lifecycle
phase, or onboarding destination.

The server sends the initial lifecycle snapshot only after the React browser has acknowledged
`uiReady`; join and source-promotion events never claim NUI delivery before the browser listener
exists. The loadscreen receives resource progress first, then the server-derived phase through
`SendLoadingScreenMessage`. Manual shutdown occurs only during the validated handoff or after an
already-spawned binding is confirmed ready.

Network-backed NUI callbacks return an immediate queue acknowledgement. The eventual server result
is delivered as a versioned `ui.request.response` message and matched by both event name and request
ID. Browser requests time out after ten seconds and expose an English retry action instead of
remaining in a permanent loading state.

## Owned tables
None.

## Configuration
NUI source lives under `packages/ui`; the two-entry production build generates interactive
`index.html` and non-interactive `loadscreen.html` into this resource. Only one loadscreen resource
may be active in the server recipe.

Browser scenario query values are `registration`, `access`, `creation`, `selection`, `appearance`,
`spawn`, and `error`. They never bypass runtime server validation because the mock transport exists
only when the FiveM NUI API is absent.

Use `?view=inventory` for the English browser inventory mock. In FiveM, F2 and the
`cnr_inventory_open` command open the source-owned personal snapshot only after controlled spawn.

For manual FXServer smoke testing, the client F8 command `cnr_registration_open` opens the English
registration view locally. It does not bypass server-side session, status, ruleset, or submission
validation.

## Error codes
Uses the stable Wave 0 result/error contract where applicable.

## Security boundary
One focus owner, one correlated response, validated versioned messages, bounded pending requests, and a fail-closed lifecycle lock that starts with the resource and releases only after the server confirms the issued spawn UUID. Lifecycle refresh carries only contract version and is rate-limited. The real player ped remains hidden, frozen, invincible, collisionless, and input-blocked during registration, limited access, selection, customization, recovery, and spawn confirmation. Appearance preview uses a local ped and cannot send an account, session, character, routing bucket, or spawn location.

## Lifecycle and recovery
Reports `ready` or `degraded` to `cnr_core`, retries source/session readiness for a bounded interval,
and exposes a correlated recovery view when dependencies remain unavailable. The refresh path asks
the server to derive a new snapshot and never accepts a destination from the client.

## Tests
Focus, English visual text, lifecycle browser mocks, contracts, manifests, and the production build are checked in CI.
