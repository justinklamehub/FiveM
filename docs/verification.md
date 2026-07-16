# Wave 0 verification

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
- dbmate reports every ordered migration through `20260716000300_technical_roles_permissions.sql` as applied.
- formatting, manifest validation, secret scan, lint, type checking, Vitest, and NUI build pass.
- Busted passes all pure Lua core and Wave 1 tests.
- no vehicles, character jobs, oil, or crime features exist.

For a destructive local migration rehearsal only:

```bash
pnpm db:rollback
pnpm db:migrate
```

## Wave 1 connection foundation

- Connect with a Rockstar `license` or Cfx.re `fivem` identifier and verify that an account is created once.
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
