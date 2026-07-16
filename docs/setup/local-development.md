# Local development setup

## Prerequisites

- Git
- Docker with Compose v2
- Node.js 24.18.0
- Corepack
- Lua 5.4.8, LuaRocks 3.13.0, and Lua Language Server 3.18.2 for local Lua checks

## 1. Checkout and environment

```bash
git clone https://github.com/justinklamehub/FiveM.git
cd FiveM
git switch agent/wave-0-technical-foundation
cp .env.example .env
```

Replace every `replace-with-local-*` value in `.env`. These values are local-only.

## 2. Materialize the lockfile and install JavaScript dependencies

The canonical pnpm lock is stored as deterministic text parts because repository connector transport does not preserve binary archives. The materializer concatenates the parts in lexical order and verifies the reconstructed SHA-256 before installation.

```bash
./tools/materialize-lockfile.sh
corepack enable
corepack prepare pnpm@11.13.1 --activate
pnpm install --frozen-lockfile
```

Do not edit a generated `pnpm-lock.yaml` manually. Dependency updates must regenerate the canonical lock, refresh the text parts, and update the expected SHA-256 in the materializer within the same reviewed pull request.

## 3. Start MariaDB and migrate

```bash
docker compose up -d mariadb
pnpm db:migrate
pnpm db:status
```

The FXServer never runs migrations automatically. Deployment operators run dbmate with the migration account before starting resources.

## 4. Install the reviewed database adapter

Download official oxmysql v2.14.1, verify the reviewed tag, and place it at `resources/[vendor]/oxmysql`. Do not commit the downloaded resource. Pin metadata lives in `tools/vendor-lock.json`.

## 5. Build and verify

```bash
pnpm verify
luarocks --lua-version=5.4 install busted 2.3.0
pnpm test:lua
lua-language-server --check=. --checklevel=Error
```

The generated NUI build is written to `resources/[cnr]/cnr_ui/web/dist` and is ignored because CI rebuilds it from the verified lockfile.

## 6. FXServer configuration

Copy the relevant settings from `server/server.cfg.example`, replace local credentials, and ensure resources in the documented order. A migrated schema and ready oxmysql resource are required before `cnr_database` can become `ready`.
