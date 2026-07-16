# Project verification

The automated pipeline covers the Wave 0 foundation and the implemented Wave 1 connection, technical-permissions, and registration slices. A real FXServer smoke test is still pending. Character lifecycle, character selection, spawn, and the complete loadscreen flow are not implemented yet and therefore are not claimed by this document.

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
- dbmate reports every ordered migration through `20260716000500_character_lifecycle.sql` as applied.
- formatting, manifest validation, secret scan, lint, type checking, Vitest, and NUI build pass.
- Busted passes all pure Lua core and implemented Wave 1 tests.
- no vehicles, characters, character jobs, oil, or crime features exist.

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

1. Connect with a new account and confirm the localized registration view opens only for the active ONBOARDING session.
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
7. Confirm no character selection, session binding, spawn, money, inventory, vehicle, or appearance state is created.
