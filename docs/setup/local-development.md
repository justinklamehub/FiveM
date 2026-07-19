# Local development setup

## Prerequisites

- Git
- Docker with Compose v2
- Node.js 24.18.0
- Corepack
- Lua 5.4.8, LuaRocks 3.13.0, and Lua Language Server 3.18.2 for local Lua checks

## 1. Checkout and environment

For current Wave 1 work:

```bash
git clone <repository>
cd FiveM
git switch agent/wave-1-player-lifecycle
cp .env.example .env
```

Use `agent/wave-0-technical-foundation` only when reviewing or verifying the isolated Wave 0 pull request. Do not start a parallel Wave 1 branch while draft PR #2 is active.

Replace every `replace-with-local-*` value in `.env`. These values are local-only.

## 2. Materialize the lockfile and install JavaScript dependencies

The canonical pnpm lock is stored as deterministic text parts because repository connector transport does not preserve binary archives. The materializer verifies the reconstructed SHA-256 before installation.

```bash
./tools/materialize-lockfile.sh
corepack enable
corepack prepare pnpm@11.13.1 --activate
pnpm install --frozen-lockfile
```

## 3. Start MariaDB and migrate

```bash
docker compose up -d mariadb
pnpm db:migrate
pnpm db:status
```

The FXServer never runs migrations automatically. Deployment operators run dbmate with the migration
account before starting resources.

## 4. Install the reviewed database adapter

Download the official oxmysql **v2.14.1** release, verify the reviewed version, and place it at
`resources/[vendor]/oxmysql`. Do not commit the downloaded resource. Its pin and review metadata live
in `tools/vendor-lock.json`.

## 5. Build and verify

```bash
pnpm verify
luarocks --lua-version=5.4 install busted 2.3.0
pnpm test:lua
lua-language-server --check=. --checklevel=Error
```

The NUI build is written to `resources/[cnr]/cnr_ui/web/dist` and is intentionally ignored because CI
and release creation rebuild it from the lockfile.

## 6. FXServer configuration

Copy the relevant settings from `server/server.cfg.example`, replace the local connection string, and
ensure resources in the documented order. A migrated schema and a ready oxmysql resource are required
before `cnr_database` can become `ready`.

## Wave 1 connection settings

Before starting the account resources, configure a server-only identifier pepper with at least 32 random characters. Never replicate it to clients or commit the real value.

```cfg
set cnr_registration_enabled 1
set cnr_whitelist_mode "open"
set cnr_identifier_pepper "replace-with-at-least-32-random-characters"
```

The supported whitelist modes are `open`, `automatic`, `manual`, and `hybrid`. Wave 1 starts with `open` for local development; production policy is chosen separately.

Apply migration `20260716000400_registration_activation.sql` before ensuring `cnr_registration`. The seeded version 1 ruleset is a technical development baseline; publish later versions by retiring the current row and inserting exactly one new `CURRENT` row in an reviewed forward migration or administrative transaction.

Apply `20260716000500_character_lifecycle.sql` before ensuring `cnr_characters`. Slot limits, age limits, backgrounds, and document types are database-driven so a later control panel can change them without rebuilding resources. Player-visible runtime and NUI text is English.

Apply `20260716000600_character_selection_appearance.sql` before starting the current Wave 1 resources and set the minimum schema to `20260716000600`. The stock `spawnmanager` resource must start before `cnr_ui`; do not start the default `basic-gamemode` in the CNR production recipe because CNR owns spawn authorization.

Apply `20260716000700_items_inventory_foundation.sql` before starting the Wave 2 item resources and set the minimum schema to `20260716000700`. Start `cnr_items` after `cnr_characters`, then `cnr_inventory`, and keep `cnr_ui` last. Personal inventory defaults are 24 slots and 30 kilograms; both values are server convars and are never accepted from NUI requests.

For txAdmin, edit the active recipe `server.cfg` rather than the generated example and remove or comment out `ensure basic-gamemode`. A running stock gamemode can re-enable map spawnpoints before character selection is complete. `cnr_ui` also disables stock auto-spawn continuously while lifecycle authority is locked, keeps the real player ped hidden, and uses a separate non-networked ped for appearance preview. The real player is released only after the server accepts the matching controlled-spawn acknowledgement.

`cnr_ui` is also the only supported loadscreen resource. Its manifest packages `web/dist/loadscreen.html` with manual shutdown and hands off to `web/dist/index.html` only after the server derives a lifecycle snapshot from the active source-owned session. Disable any txAdmin recipe or third-party loading-screen resource that competes for this role. After changing the packaged NUI, rebuild it and clear the FiveM client cache before the runtime smoke test.

The browser development server supports English lifecycle scenarios without FiveM:

```text
http://localhost:5173/?phase=registration
http://localhost:5173/?phase=access
http://localhost:5173/?phase=creation
http://localhost:5173/?phase=selection
http://localhost:5173/?phase=appearance
http://localhost:5173/?phase=spawn
http://localhost:5173/?phase=error
http://localhost:5173/?view=inventory
```

Run `pnpm --filter @cnr/ui dev` to serve them. `loadscreen.html` is a separate non-interactive entry and accepts the same `phase` query for browser-only visual checks. Both documents are generated by `pnpm build:nui`.

The server chooses the controlled central fallback spawn. Clients cannot submit coordinates, routing buckets, session IDs, or spawn state.

```cfg
set cnr_schema_minimum "20260716000700"
set cnr_spawn_default_x "215.76"
set cnr_spawn_default_y "-810.12"
set cnr_spawn_default_z "30.73"
set cnr_spawn_default_heading "157.0"

ensure spawnmanager
ensure cnr_characters
ensure cnr_items
ensure cnr_inventory
ensure cnr_ui
```

After a controlled spawn, press F2 or run `cnr_inventory_open` in the client F8 console. The English personal inventory must show exactly two Water Bottles, two Sandwiches, and the existing State Identification Card on first provisioning. Reopening or reconnecting must not duplicate them.
