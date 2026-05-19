#!/usr/bin/env bash
# CI guard: no agency or institutional identifiers in core/ or
# adapters/profiles/ policy bodies. Publication citations belong in
# evaluation memos under docs/planning/evaluations/, not in normative
# policy. Failure exit code is non-zero with offending paths printed.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PATTERN='nasa|jpl|goddard'
SCAN_PATHS=("core" "adapters/profiles")

declare -a offenders=()
for p in "${SCAN_PATHS[@]}"; do
  [[ -d "$p" ]] || continue
  # rg returns 1 on no-matches under set -e; suppress with || true.
  matches="$(rg --no-heading --line-number --color never -i "$PATTERN" "$p" || true)"
  if [[ -n "$matches" ]]; then
    offenders+=("$matches")
  fi
done

if (( ${#offenders[@]} > 0 )); then
  echo "[FAIL] Agency-string CI guard: forbidden identifiers found under core/ or adapters/profiles/" >&2
  for m in "${offenders[@]}"; do
    echo "$m" >&2
  done
  exit 1
fi

echo "[PASS] Agency-string CI guard (core/ and adapters/profiles/ clean)"
