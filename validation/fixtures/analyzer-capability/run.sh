#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

python3 -m scripts.validators.governance_gates \
  --manifest validation/fixtures/analyzer-capability/positive-structured.yaml
python3 -m scripts.validators.governance_gates \
  --manifest validation/fixtures/analyzer-capability/positive-legacy.yaml

both_output="$(mktemp)"
if python3 -m scripts.validators.governance_gates \
  --manifest validation/fixtures/analyzer-capability/negative-both-fields.yaml \
  2>"$both_output"; then
  echo "[FAIL] negative-both-fields.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "analyzerDeclaration.legacyString and analyzerDeclaration.structured" "$both_output" >/dev/null

false_output="$(mktemp)"
if python3 -m scripts.validators.governance_gates \
  --manifest validation/fixtures/analyzer-capability/negative-false-capability.yaml \
  2>"$false_output"; then
  echo "[FAIL] negative-false-capability.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "analyzerDeclaration.structured.capabilitiesDetected.dynamicAllocationPostInit" "$false_output" >/dev/null

echo "[PASS] analyzer-capability fixtures"
