#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
parts_dir="${root_dir}/tools/lockfile-parts"
lockfile="${root_dir}/pnpm-lock.yaml"
expected_sha256="105b7ca759a54fea97314cd2c43fc02522bd2598f82d205d77652434e868bda7"

if [[ ! -d "${parts_dir}" ]]; then
  echo "Lockfile parts directory is missing: ${parts_dir}" >&2
  exit 1
fi

cat "${parts_dir}"/part-* > "${lockfile}"
echo "${expected_sha256}  ${lockfile}" | sha256sum --check --status

echo "Materialized pnpm-lock.yaml (${expected_sha256})."
