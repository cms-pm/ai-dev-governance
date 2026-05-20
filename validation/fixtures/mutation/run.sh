#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

# Positive: structurally valid block — exits 0 (may emit WARN about
# reportPath not yet existing; that is acceptable in advisory mode).
python3 -m scripts.validators.mutation_threshold \
  --manifest validation/fixtures/mutation/positive-valid.yaml

missing_tool_output="$(mktemp)"
if python3 -m scripts.validators.mutation_threshold \
  --manifest validation/fixtures/mutation/negative-missing-tool.yaml \
  2>"$missing_tool_output"; then
  echo "[FAIL] negative-missing-tool.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required key 'tool'" "$missing_tool_output" >/dev/null

missing_tier_output="$(mktemp)"
if python3 -m scripts.validators.mutation_threshold \
  --manifest validation/fixtures/mutation/negative-missing-threshold-tier.yaml \
  2>"$missing_tier_output"; then
  echo "[FAIL] negative-missing-threshold-tier.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required tier 'critical'" "$missing_tier_output" >/dev/null

echo "[PASS] mutation-threshold fixtures"
