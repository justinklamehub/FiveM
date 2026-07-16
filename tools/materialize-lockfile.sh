#!/usr/bin/env bash
set -euo pipefail
gzip -dc pnpm-lock.yaml.gz > pnpm-lock.yaml
