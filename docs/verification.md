# Project verification

The automated pipeline covers the Wave 0 foundation, all six Wave 1 slices, and the first Wave 2 item/inventory slice. Live operator passes have confirmed one English Wave 1 path from connection through registration, character creation, visible appearance customization, persistence, the packaged CNR loadscreen, automatic character-selection handoff, controlled entry, a successful reconnect with the stored appearance and spawn location, the hybrid-policy LIMITED-access barrier, and fail-closed recovery after stopping and restarting `cnr_characters`. The Wave 2 personal inventory requires a fresh FXServer operator pass and is not claimed as runtime-verified here.

Run from a fresh checkout:

```bash
./tools/materialize-lockfile.sh
cp .env.example .env
# Replace local placeholders.
corepack enable
corepack prepare pnpm@11.13.1 --activate
pnpm install --frozen-lockfile
docker compose up -d mariadb
pnpm db:migrate
pnpm db:status
pnpm verify
luarocks --lua-version=5.4 install busted 2.3.0
pnpm test:lua
lua-language-server --check=. --checklevel=Error
```

Expected results:

- MariaDB health is `healthy`.
- dbmate reports every ordered migration through `20260716000800_inventory_interactions.sql` as applied.
- formatting, manifest validation, secret scan, lint, type checking, Vitest, and NUI build pass.
- Busted passes all pure Lua core, Wave 1, item, and inventory policy tests.
- no banking, vehicles, character jobs, rewards, oil, or crime gameplay exists; the implemented inventory is an economic foundation only.

For a destructive local migration rehearsal only:

```bash
pnpm db:rollback
pnpm db:migrate
```

## Wave 1 connection foundation

- Connect with a Rockstar `license` or Cfx.re `fivem` identifier and verify that an account is created once.
- Confirm the session row changes from the temporary `playerConnecting` source to the final
  `playerJoining` NetID and remains resolvable by client-initiated server events.
- Confirm that `ip:` is never persisted in `cnr_account_identifiers`.
- Attempt two concurrent connections with the same account and verify that only one session becomes active.
- Restart only `cnr_sessions` and confirm the active session can still be closed by `playerDropped`.
- Restart only `cnr_core` and confirm the server instance UUID remains unchanged. Restart the full FXServer and confirm sessions from the replaced instance become `STALE`.
- Test all four whitelist modes with and without an active entry.
- Confirm rejection messages expose a correlation ID but no raw identifier or SQL detail.

## Wave 1 technical permissions

1. Connect once so the target account and active session exist.
2. Read the server-resolved account UUID from the FXServer console:

   ```text
   cnr_session_show <source>
   ```

3. Grant the protected bootstrap role from the FXServer console:

   ```text
   cnr_role_grant <account_uuid> owner initial_owner
   ```

4. Inspect the resolved role and permission snapshot:

   ```text
   cnr_role_show <account_uuid>
   ```

5. Verify that attempting the same grant again returns `CONFLICT` and does not create a duplicate active assignment.
6. Grant and revoke `administrator`, `moderator`, and `support` from the server console and confirm every mutation produces an audit log.
7. Confirm an account without `permissions.manage` receives `PERMISSION_DENIED` from normal grant or revoke exports.
8. Confirm normal mutation exports refuse to assign or revoke `owner`.
9. Add an expired assignment in a local test database and confirm the next permission evaluation changes it to `EXPIRED`.
10. Confirm technical role tables contain no character job, police rank, or business employment state.

## Wave 1 registration and activation

1. Connect with a new account and confirm the English registration view opens only for the active ONBOARDING session.
   If automatic opening must be isolated during diagnosis, run `cnr_registration_open` in the client
   F8 console. Confirm the ruleset replaces the loading state; a missing server response must show an
   English retry action within ten seconds rather than leaving the NUI pending indefinitely.
2. Fetch the current ruleset with the English locale and an unsupported locale; verify the server returns English content and that its UUID and version come from MariaDB.
3. Submit without acceptance and with an outdated version; confirm both fail without database changes.
4. Submit a valid operation in every whitelist mode and verify the server-chosen account/access transition.
5. Repeat the same semantic payload with the same operation UUID and a new request ID; confirm `repeated = true` and one operation/acceptance row.
6. Change locale, acceptance, ruleset, or contract version while reusing the operation UUID; confirm `CONFLICT`.
7. End the session and replay the request; confirm `AUTHENTICATION_REQUIRED` and a data-minimized security log.
8. Confirm `ruleset.accepted` and `account.status_changed` audits carry request/correlation IDs but no raw platform identifier or full rules text.

## Wave 1 character lifecycle

1. Connect with an ACTIVE account and FULL session; verify the English character creation view opens.
2. Confirm the server returns the configured slot/age limits and active English background options.
3. Create three drafts and confirm server-assigned slots 1–3; a fourth must fail without mutation.
4. Reject invalid names, impossible dates, underage/overage identities, inactive backgrounds, inactive sessions, and foreign character UUIDs.
5. Repeat identical draft and activation operations; confirm one operation and one result. Reuse either UUID with changed semantic content and confirm `CONFLICT`.
6. Activate a draft and confirm one unique active state identification card plus `character.activated` and `document.issued` audits.
7. Confirm activation does not itself select, bind, customize, or spawn the character.

## Wave 1 character selection, appearance, and controlled spawn

1. Remove the default `basic-gamemode` from the active CNR txAdmin recipe, start `spawnmanager` before `cnr_ui`, connect with an ACTIVE account and FULL session, and verify the English character selection view opens automatically. Confirm the server prints no conflicting-gamemode warning.
2. Confirm only ACTIVE characters owned by the source-resolved account are listed. Submit a foreign, DRAFT, or malformed character UUID and confirm no binding or routing change occurs.
3. Select an ACTIVE character and confirm exactly one ACTIVE row in `cnr_character_session_bindings`, an isolated routing bucket for first-time appearance, and a `character.selected` audit with request/correlation IDs.
4. Repeat the same selection operation and payload; confirm the existing binding is returned. Reuse the operation UUID with another character or session and confirm `CONFLICT`.
5. In the customization editor, confirm the separate local preview ped remains visible to the left of the NUI while the real player ped stays hidden and frozen. Confirm both freemode models have a complete starter T-shirt, trousers, and shoes without missing body sections. Change heritage blends, facial sliders, hair, and eyes with both the sliders and their `−` / `+` buttons. Confirm every stepper clamps at its documented minimum and maximum, live preview works in isolation, and invalid ranges or unexpected account/session/spawn fields are rejected server-side.
6. Save appearance twice with the same operation UUID and content; confirm one appearance operation, one current appearance row, and the same pending spawn. Reuse that UUID with changed appearance and confirm `CONFLICT`.
7. Confirm the server chooses `LAST_SAFE` when a safe location exists and otherwise uses the configured `CENTRAL_DEFAULT`; the client request must contain no coordinates, heading, routing bucket, or spawn state.
8. Confirm the player remains frozen, invincible, collision-disabled, and unable to close the lifecycle view until the matching server-issued spawn UUID is acknowledged. A wrong or stale token must not release controls.
9. Reconnect and confirm the stored appearance is applied without creating a duplicate appearance row. Confirm the new session receives a new binding and the prior binding is `ENDED`.
10. Restart the character resource after ending a session and confirm stale bindings recover to `ENDED`. Verify `character.appearance_saved` and `character.spawned` audits contain UUIDs and correlation data but no raw platform identifiers or appearance JSON.

## Wave 1 loadscreen and complete lifecycle NUI

1. Stop every other loadscreen resource, keep `cnr_ui` enabled, clear the FiveM client cache after deployment, and reconnect. Confirm the CNR English loadscreen replaces the default presentation without external media requests.
2. Confirm resource progress advances before client scripts start, then changes to the server-derived session phase. The client must not submit an account, session, access state, character, binding, routing bucket, or destination.
3. Use a new account and confirm the loadscreen hands off to registration only after an ONBOARDING snapshot. Complete registration and confirm the same NUI moves through server refresh into character creation or selection without exposing the world or releasing controls.
4. Use a hybrid/manual account with `LIMITED` access and confirm `Access Review Pending` appears. `Check Again` must be rate-limited and must not permit character or world access.
5. Reconnect with no characters, with an active character, during required appearance, and with a pending controlled spawn. Confirm the server derives the corresponding creation, selection, appearance, or spawn phase each time.
6. Stop `cnr_characters` during a FULL-session refresh and confirm the correlated `Lifecycle Unavailable` view appears after bounded recovery. Restart the resource, select `Retry`, and confirm the server derives the next state without reconnecting.
7. Confirm the loading NUI shuts down during the validated handoff, while the interactive NUI remains unclosable until the matching controlled spawn is confirmed. No default spawn, visible real player ped, cursor-only blank screen, or world-control interval is permitted.
8. Confirm the browser scenarios render independently with `?phase=registration`, `access`, `creation`, `selection`, `appearance`, `spawn`, and `error`, and run the production build that emits both HTML entries.

## Wave 2 items and personal inventory

1. Migrate through `20260716000800`, start `cnr_items` and `cnr_inventory` before `cnr_ui`, and confirm both resources report `ready`.
2. Complete a controlled spawn, press F2, and confirm the English 24-slot grid shows two Water Bottles, two Sandwiches, and the existing State Identification Card with deterministic image-key fallbacks.
3. Close and reopen the inventory, reconnect, and restart `cnr_inventory`; confirm one inventory, one referenced State ID instance, three entries, and one starter transaction remain.
4. Confirm the snapshot request contains only `request_id` and `contract_version`. Submit unexpected account, session, character, definition, instance, metadata, weight, capacity, version, or cross-inventory target-slot fields and confirm rejection without mutation. Confirm reposition accepts only the source-owned inventory UUID, source slot, target slot, request ID, operation UUID, and contract version.
5. Seed a local `PERSONAL_STORAGE` inventory and use the server transfer export to verify partial and full stack movement, stack merging, unique-instance movement, server-selected target slots, weight limits, slot limits, and inventory version increments.
6. Repeat a transfer operation UUID with identical content and confirm the stored result. Change source, target, slot, quantity, action, account, or character and confirm `CONFLICT` without item movement.
7. Stop `cnr_items`, `cnr_characters`, and `cnr_database` separately and confirm snapshots and transfers fail closed with correlation IDs. Restart each dependency and confirm inventory readiness recovers without reconnecting or duplicating the starter package.
8. Inspect audit/security logs and confirm they contain stable object references and quantities but no raw platform identifier, item metadata, document content, or secret.
9. Drag an occupied slot onto an empty slot and another occupied slot. Confirm the server performs an atomic move or swap, increments the inventory and entry versions, persists the layout after reconnect, returns the stored result for an identical operation UUID, and rejects changed reuse without mutation. Repeat with selection plus destination activation to verify the accessible fallback.
10. Open `http://localhost:5173/?view=inventory` and confirm the browser mock renders all 24 slots, starter entries, image-key fallbacks, English loading/error states, drag/drop movement, slot capacity, and weight capacity.
