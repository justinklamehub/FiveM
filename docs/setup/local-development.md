# Local development setup

## Prerequisites

- Git
- Docker with Compose v2
- Node.js 24.18.0
- Corepack
- Lua 5.4.8, LuaRocks 3.13.0, and Lua Language Server 3.18.2 for local Lua checks

## 1. Checkout and environment

```bash
git clone <repository>
cd FiveM
git switch agent/wave-0-technical-foundation
cp .env.example .env
```

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
