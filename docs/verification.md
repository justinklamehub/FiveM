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
- dbmate reports `20260716000100_core_initialize.sql` as applied.
- formatting, manifest validation, secret scan, lint, type checking, Vitest, and NUI build pass.
- Busted passes all pure Lua core tests.
- no gameplay tables, accounts, vehicles, jobs, oil, or crime features exist.

For a destructive local migration rehearsal only:

```bash
pnpm db:rollback
pnpm db:migrate
```
