# cnr_ui

## Responsibility
Owns the packaged English loadscreen, server-driven lifecycle handoff, central focus ownership, registration, character, personal-inventory, reusable City Tablet, and read-only Banking app views, reviewed item PNG artwork, limited-access and recovery UX, a separate non-networked appearance preview ped, model-specific curated starter clothing, accessible slider steppers, and execution of server-issued spawn instructions.

## Non-responsibility
Does not calculate authoritative prices, rewards, ownership, or permissions.

## Dependencies

The manifest declares only the client-compatible `/onesync` constraint and stock `spawnmanager`. Server-side integrations with
`cnr_core`, `cnr_registration`, `cnr_sessions`, `cnr_characters`, `cnr_inventory`, and `cnr_banking` are ordered by `server.cfg` and
guarded by runtime readiness checks; declaring server-only resources as hard dependencies would make
the FiveM client reject `cnr_ui` because those resources have no client package.

## Public exports
`get_status`

## Events

`uiReady` and `lifecycleRefresh` (browser-to-Lua NUI callbacks), `cnr:ui:ready` and
`cnr:ui:refresh` (client-to-server events), `cnr:ui:lifecycle` (server-to-client snapshot),
registration NUI callbacks, character lifecycle callbacks, inventory snapshot/reposition/transfer/use callbacks, banking snapshot callbacks, State ID presentation, and controlled-spawn events. The server
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

Use `?view=inventory` for the English personal-inventory mock, `?view=storage` for the two-panel
locker workspace, `?view=document` for the State ID presentation, `?view=tablet` for the Tablet
home, and `?view=banking` for the Tablet opened directly to its read-only Banking app. In FiveM, F2 or
`cnr_inventory_open` opens the character inventory after controlled
spawn. F3 or `cnr_storage_open` requests the personal locker, which the server exposes only within the
configured radius. Occupied slots use direct pointer drag-and-drop with a destination highlight and
drop animation; click-selection is not part of movement. Cross-inventory stacks open a bounded quantity
selector after their direct drop, and the UI applies the server-validated placement only after confirmation.
Double-click or right-click opens only actions published by the server definition. Every confirmed item
action closes the inventory and releases its focus before gameplay resumes. Consumables play the
server-issued animation after one-unit persistence. State ID inspection hands focus directly to a compact,
left-docked English document card without reopening or retaining the inventory; closing the card returns to
gameplay. State ID presentation uses the same bounded card for the server-selected nearby recipient. Reviewed
transparent PNGs are resolved from an explicit allowlist for the three starter image keys and City Tablet. Unknown keys
or failed image loads retain deterministic two-letter fallback tiles.

The unique City Tablet is used from F2 inventory. Only the persisted server-confirmed `OPEN_TABLET`
effect transfers focus into the reusable Tablet shell. Banking is its first enabled application; the
former direct F4 command does not exist. The Banking app sends only a versioned snapshot request and
renders server-derived integer balances and posted history. It has no payment, transfer,
account-selection, balance, or starter-funding authority.

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
Focus, English visual text, lifecycle and Tablet browser mocks, inventory image-key resolution, PNG dimensions and transparency, banking currency formatting, contracts, manifests, and the production build are checked in CI.
