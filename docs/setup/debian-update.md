# Debian server updates

The production checkout includes `tools/deploy/update.sh` for repeatable updates of the standalone FXServer installation.

## Responsibilities

The update script:

1. requires root privileges and prevents concurrent updates;
2. rejects tracked local changes and detached Git states;
3. stops the `fivem` systemd service and confirms port `30120` is free;
4. updates the currently checked-out branch with a fast-forward-only pull;
5. reconstructs the pinned pnpm lockfile and installs dependencies;
6. runs the full repository verification and production NUI build;
7. starts MariaDB and applies pending dbmate migrations;
8. starts the FXServer service and displays its status and recent logs.

Tracked code is restored to the previous commit when an update fails before database migrations start. Database migrations are never rolled back automatically because future migrations may contain irreversible data changes.

## Install the command wrapper

Run once as root after pulling the update script:

```bash
cat > /usr/local/bin/cnr-update <<'EOF'
#!/usr/bin/env bash
exec /usr/bin/bash /opt/fivem/project/tools/deploy/update.sh "$@"
EOF

chmod 755 /usr/local/bin/cnr-update
```

The project script creates a temporary copy of itself before pulling Git changes, so it cannot be overwritten during its own execution.

## Run an update

```bash
cnr-update
```

To keep following the FXServer journal after a successful update:

```bash
cnr-update --follow-logs
```

## Important operational notes

- Run FXServer through `fivem.service`, not from a separate manual console, before using this command.
- The current Git branch is updated. The script does not switch between development, staging, or production branches.
- `.env`, `compose.server.yaml`, `server.cfg`, oxmysql, and MariaDB data remain local and are not replaced by Git.
- Tracked local changes cause the update to stop before the service is touched.
- A migration failure requires manual inspection; do not use `docker compose down -v`.

## Configuration overrides

The defaults match the documented Debian installation. They can be overridden for a single run:

```bash
CNR_SERVICE_NAME=fivem \
CNR_PROJECT_DIR=/opt/fivem/project \
CNR_FIVEM_PORT=30120 \
cnr-update
```
