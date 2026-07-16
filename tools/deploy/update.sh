#!/usr/bin/env bash
# Updates the Cops'N'Robbers RP project on a Debian FXServer host.
# The script intentionally avoids automatic database rollbacks because migrations may contain data changes.

set -Eeuo pipefail

# Run from a temporary copy so git pull cannot modify the script while it is executing.
if [[ "${CNR_UPDATE_TEMP_COPY:-0}" != 1 ]]; then
    temporary_script="$(mktemp /tmp/cnr-update.XXXXXX)"
    cp -- "${BASH_SOURCE[0]}" "${temporary_script}"
    chmod 700 "${temporary_script}"
    exec env \
        CNR_UPDATE_TEMP_COPY=1 \
        CNR_UPDATE_TEMP_FILE="${temporary_script}" \
        bash "${temporary_script}" "$@"
fi

cleanup_temporary_script() {
    if [[ -n "${CNR_UPDATE_TEMP_FILE:-}" ]]; then
        rm -f -- "${CNR_UPDATE_TEMP_FILE}" || true
    fi
}
trap cleanup_temporary_script EXIT

PROJECT_DIR="${CNR_PROJECT_DIR:-/opt/fivem/project}"
APP_USER="${CNR_APP_USER:-fivem}"
SERVICE_NAME="${CNR_SERVICE_NAME:-fivem}"
COMPOSE_FILE="${CNR_COMPOSE_FILE:-compose.server.yaml}"
ENV_FILE="${CNR_ENV_FILE:-.env}"
FIVEM_PORT="${CNR_FIVEM_PORT:-30120}"
LOCK_FILE="${CNR_UPDATE_LOCK_FILE:-/var/lock/cnr-update.lock}"
FOLLOW_LOGS=0

CURRENT_STEP="initialization"
SERVICE_WAS_ACTIVE=0
SERVICE_STOPPED=0
REPOSITORY_UPDATED=0
MIGRATION_STARTED=0
OLD_COMMIT=""
CURRENT_BRANCH=""

print_header() {
    printf '\n\033[1;36m==> %s\033[0m\n' "$1"
}

print_success() {
    printf '\033[1;32m[OK]\033[0m %s\n' "$1"
}

print_warning() {
    printf '\033[1;33m[WARN]\033[0m %s\n' "$1" >&2
}

print_error() {
    printf '\033[1;31m[ERROR]\033[0m %s\n' "$1" >&2
}

show_usage() {
    cat <<'EOF'
Usage: cnr-update [--follow-logs] [--help]

Options:
  --follow-logs  Follow the FXServer journal after a successful update.
  --help         Show this help text.

Optional environment overrides:
  CNR_PROJECT_DIR       Project checkout path.
  CNR_APP_USER          Linux user that owns the project.
  CNR_SERVICE_NAME      systemd service name.
  CNR_COMPOSE_FILE      Docker Compose file relative to the project.
  CNR_ENV_FILE          Environment file relative to the project.
  CNR_FIVEM_PORT        FXServer port checked after stopping the service.
  CNR_UPDATE_LOCK_FILE  Lock file used to prevent concurrent updates.
EOF
}

for argument in "$@"; do
    case "$argument" in
        --follow-logs)
            FOLLOW_LOGS=1
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown argument: ${argument}"
            show_usage
            exit 2
            ;;
    esac
done

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        print_error "Run this update as root so systemd and Docker can be managed safely."
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        print_error "Required command not found: $1"
        exit 1
    fi
}

run_as_app() {
    runuser -u "${APP_USER}" -- "$@"
}

run_project_shell() {
    local project_command="$1"
    runuser -u "${APP_USER}" -- env \
        PROJECT_DIR="${PROJECT_DIR}" \
        CNR_PROJECT_COMMAND="${project_command}" \
        bash -lc 'cd "$PROJECT_DIR" && bash -lc "$CNR_PROJECT_COMMAND"'
}

restore_service_after_failure() {
    if [[ "${SERVICE_STOPPED}" -ne 1 || "${SERVICE_WAS_ACTIVE}" -ne 1 ]]; then
        return
    fi

    print_warning "Attempting to start the previous FXServer service state."
    if systemctl start "${SERVICE_NAME}"; then
        print_success "The ${SERVICE_NAME} service was started after the failed update."
    else
        print_error "The ${SERVICE_NAME} service could not be restarted."
    fi
}

rollback_code_before_migration() {
    if [[ "${REPOSITORY_UPDATED}" -ne 1 || "${MIGRATION_STARTED}" -eq 1 || -z "${OLD_COMMIT}" ]]; then
        return
    fi

    print_warning "Rolling tracked project files back to ${OLD_COMMIT} because migrations did not start."
    if run_as_app git -C "${PROJECT_DIR}" reset --hard "${OLD_COMMIT}"; then
        print_success "Tracked project files were restored."
    else
        print_error "Automatic code rollback failed. Inspect the repository before restarting."
    fi
}

on_error() {
    local exit_code="$1"
    local line_number="$2"
    trap - ERR

    print_error "Update failed during '${CURRENT_STEP}' at line ${line_number} (exit ${exit_code})."
    rollback_code_before_migration
    restore_service_after_failure

    print_warning "Database migrations are never rolled back automatically."
    journalctl -u "${SERVICE_NAME}" -n 40 --no-pager 2>/dev/null || true
    exit "${exit_code}"
}

trap 'on_error $? $LINENO' ERR

require_root
for command in git runuser systemctl docker flock ss journalctl; do
    require_command "${command}"
done

if ! id "${APP_USER}" >/dev/null 2>&1; then
    print_error "Linux user does not exist: ${APP_USER}"
    exit 1
fi

if [[ ! -d "${PROJECT_DIR}/.git" ]]; then
    print_error "Git repository not found at ${PROJECT_DIR}."
    exit 1
fi

for required_file in \
    "${PROJECT_DIR}/${ENV_FILE}" \
    "${PROJECT_DIR}/${COMPOSE_FILE}" \
    "${PROJECT_DIR}/package.json" \
    "${PROJECT_DIR}/tools/materialize-lockfile.sh"; do
    if [[ ! -f "${required_file}" ]]; then
        print_error "Required project file is missing: ${required_file}"
        exit 1
    fi
done

mkdir -p "$(dirname "${LOCK_FILE}")"
exec 9>"${LOCK_FILE}"
if ! flock -n 9; then
    print_error "Another CNR update is already running."
    exit 1
fi

print_header "Preflight checks"
CURRENT_BRANCH="$(run_as_app git -C "${PROJECT_DIR}" branch --show-current)"
OLD_COMMIT="$(run_as_app git -C "${PROJECT_DIR}" rev-parse HEAD)"

if [[ -z "${CURRENT_BRANCH}" ]]; then
    print_error "The repository is in detached HEAD state. Switch to a branch before updating."
    exit 1
fi

if ! run_as_app git -C "${PROJECT_DIR}" diff --quiet || \
    ! run_as_app git -C "${PROJECT_DIR}" diff --cached --quiet; then
    print_error "Tracked local changes exist. Commit or revert them before updating."
    run_as_app git -C "${PROJECT_DIR}" status --short
    exit 1
fi

printf 'Project: %s\n' "${PROJECT_DIR}"
printf 'Branch:  %s\n' "${CURRENT_BRANCH}"
printf 'Commit:  %s\n' "${OLD_COMMIT}"

if systemctl is-active --quiet "${SERVICE_NAME}"; then
    SERVICE_WAS_ACTIVE=1
fi

print_header "Stopping FXServer"
CURRENT_STEP="stopping FXServer"
systemctl stop "${SERVICE_NAME}"
SERVICE_STOPPED=1

if ss -lntup | grep -Eq ":${FIVEM_PORT}([[:space:]]|$)"; then
    print_error "Port ${FIVEM_PORT} is still in use. A manually started FXServer may still be running."
    print_warning "Stop the process using port ${FIVEM_PORT} and run the update again."
    ss -lntup | grep -E ":${FIVEM_PORT}([[:space:]]|$)" || true
    false
fi
print_success "FXServer is stopped and port ${FIVEM_PORT} is free."

print_header "Updating repository"
CURRENT_STEP="fetching repository"
run_as_app git -C "${PROJECT_DIR}" fetch --prune origin
run_as_app git -C "${PROJECT_DIR}" pull --ff-only origin "${CURRENT_BRANCH}"
NEW_COMMIT="$(run_as_app git -C "${PROJECT_DIR}" rev-parse HEAD)"

if [[ "${NEW_COMMIT}" == "${OLD_COMMIT}" ]]; then
    print_success "Repository is already at the latest commit."
else
    REPOSITORY_UPDATED=1
    print_success "Repository updated from ${OLD_COMMIT:0:7} to ${NEW_COMMIT:0:7}."
fi

print_header "Installing dependencies"
CURRENT_STEP="materializing lockfile and installing dependencies"
run_project_shell './tools/materialize-lockfile.sh && pnpm install --frozen-lockfile'
print_success "Pinned dependencies are installed."

print_header "Verifying project"
CURRENT_STEP="running project verification"
run_project_shell 'pnpm verify'
print_success "Formatting, linting, tests, contracts, and NUI build passed."

print_header "Starting MariaDB"
CURRENT_STEP="starting MariaDB"
docker compose \
    --env-file "${PROJECT_DIR}/${ENV_FILE}" \
    -f "${PROJECT_DIR}/${COMPOSE_FILE}" \
    up -d mariadb
print_success "MariaDB container is running."

print_header "Applying database migrations"
CURRENT_STEP="applying database migrations"
MIGRATION_STARTED=1
run_project_shell 'pnpm db:migrate && pnpm db:status'
print_success "Database migrations are current."

print_header "Starting FXServer"
CURRENT_STEP="starting FXServer"
systemctl start "${SERVICE_NAME}"

for ((attempt = 1; attempt <= 30; attempt++)); do
    if systemctl is-active --quiet "${SERVICE_NAME}"; then
        print_success "The ${SERVICE_NAME} service is active."
        break
    fi
    sleep 1
done

if ! systemctl is-active --quiet "${SERVICE_NAME}"; then
    print_error "The ${SERVICE_NAME} service did not become active."
    journalctl -u "${SERVICE_NAME}" -n 80 --no-pager || true
    false
fi

CURRENT_STEP="completed"
SERVICE_STOPPED=0

printf '\n'
run_as_app git -C "${PROJECT_DIR}" log -1 --oneline
systemctl status "${SERVICE_NAME}" --no-pager --lines=5

print_header "Update completed successfully"
printf 'Recent logs:\n'
journalctl -u "${SERVICE_NAME}" -n 30 --no-pager

if [[ "${FOLLOW_LOGS}" -eq 1 ]]; then
    print_header "Following FXServer logs"
    journalctl -u "${SERVICE_NAME}" -f
else
    printf '\nUse this command for live logs:\n  journalctl -u %s -f\n' "${SERVICE_NAME}"
fi
