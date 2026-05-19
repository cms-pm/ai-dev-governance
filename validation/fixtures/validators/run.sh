#!/usr/bin/env bash
# SCN-8.3.2 fixture sweep for scripts/validators/governance_gates.py.
# Asserts the per-fixture expected verdict against the stand-alone
# validator. Run from repo root.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

VALIDATOR=(python3 -m scripts.validators.governance_gates)
FIXTURE_DIR="validation/fixtures/validators"

passed=0
failed=0

assert_exit() {
  local expected="$1"
  local label="$2"
  shift 2
  set +e
  "$@" >/dev/null 2>&1
  local actual=$?
  set -e
  if [[ "$actual" -eq "$expected" ]]; then
    echo "[PASS] $label (exit=$actual)"
    passed=$((passed + 1))
  else
    echo "[FAIL] $label (expected exit=$expected, got $actual)" >&2
    failed=$((failed + 1))
  fi
}

# Embedded-profile matrix. Agency-string fixtures are intentionally not
# included — OPP-8.2-004 (agency-string guard surface expansion) was
# closed without action at Phase 8.3 bootstrap; the one-time repo-wide
# sweep is sufficient and per-fixture cases would re-open that scope.
assert_exit 0 "embedded-present-valid" \
  "${VALIDATOR[@]}" --manifest "$FIXTURE_DIR/embedded-present-valid/governance.yaml"
assert_exit 1 "embedded-present-missing-key" \
  "${VALIDATOR[@]}" --manifest "$FIXTURE_DIR/embedded-present-missing-key/governance.yaml"
assert_exit 1 "embedded-present-missing-file" \
  "${VALIDATOR[@]}" --manifest "$FIXTURE_DIR/embedded-present-missing-file/governance.yaml"
assert_exit 0 "embedded-absent-clean" \
  "${VALIDATOR[@]}" --manifest "$FIXTURE_DIR/embedded-absent-clean/governance.yaml"
assert_exit 1 "embedded-absent-with-key" \
  "${VALIDATOR[@]}" --manifest "$FIXTURE_DIR/embedded-absent-with-key/governance.yaml"

echo "---"
echo "Summary: $passed passed, $failed failed"
[[ "$failed" -eq 0 ]]
