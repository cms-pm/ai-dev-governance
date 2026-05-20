#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

# Positive: structurally valid block — exits 0 (WARN expected because
# rulesPath does not resolve relative to the fixture; SCN-9.4 lands
# the rules file).
python3 -m scripts.validators.architecture_fitness \
  --manifest validation/fixtures/architecture/positive-valid.yaml

missing_rules_output="$(mktemp)"
if python3 -m scripts.validators.architecture_fitness \
  --manifest validation/fixtures/architecture/negative-missing-rules-path.yaml \
  2>"$missing_rules_output"; then
  echo "[FAIL] negative-missing-rules-path.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required key 'rulesPath'" "$missing_rules_output" >/dev/null

missing_engine_output="$(mktemp)"
if python3 -m scripts.validators.architecture_fitness \
  --manifest validation/fixtures/architecture/negative-missing-engine.yaml \
  2>"$missing_engine_output"; then
  echo "[FAIL] negative-missing-engine.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required key 'engine'" "$missing_engine_output" >/dev/null

echo "[PASS] architecture-fitness fixtures"
