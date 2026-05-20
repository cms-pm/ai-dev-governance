#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

# Positive: structurally valid block — exits 0 (WARN expected because
# the path does not resolve relative to the fixture; SCN-9.4 lands the
# directory).
python3 -m scripts.validators.glossary_coverage \
  --manifest validation/fixtures/glossary/positive-valid.yaml

missing_path_output="$(mktemp)"
if python3 -m scripts.validators.glossary_coverage \
  --manifest validation/fixtures/glossary/negative-missing-path.yaml \
  2>"$missing_path_output"; then
  echo "[FAIL] negative-missing-path.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required key 'path'" "$missing_path_output" >/dev/null

missing_protected_output="$(mktemp)"
if python3 -m scripts.validators.glossary_coverage \
  --manifest validation/fixtures/glossary/negative-missing-protected-paths.yaml \
  2>"$missing_protected_output"; then
  echo "[FAIL] negative-missing-protected-paths.yaml unexpectedly passed" >&2
  exit 1
fi
grep -F "missing required key 'protectedPaths'" "$missing_protected_output" >/dev/null

echo "[PASS] glossary-coverage fixtures"
