#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"

mkdir -p "${repo_root}/.rtk"
export RTK_DB_PATH="${repo_root}/.rtk/history.db"

exec rtk "$@"
