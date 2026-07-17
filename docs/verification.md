# Project verification

The automated pipeline covers the Wave 0 foundation and the implemented Wave 1 connection, technical-permissions, registration, character lifecycle, selection, appearance, and controlled-spawn slices. A real FXServer smoke test for the new selection and appearance flow is still pending. The final loadscreen flow is not implemented and is not claimed by this document.

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
- dbmate reports every ordered migration through `20260716000600_character_selection_appearance.sql` as applied.
- formatting, manifest validation, secret scan, lint, type checking, Vitest, and NUI build pass.
- Busted passes all pure Lua core and implemented Wave 1 tests.
- no vehicles, character jobs, economy, inventory, oil, or crime features exist.

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
2. Fetch the current ruleset in German and English; verify its UUID and version come from MariaDB.
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
