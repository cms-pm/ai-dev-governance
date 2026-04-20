#!/usr/bin/env bash
# Consumer-side bootstrap completeness check.
# Run from the consumer repo root (or set CONSUMER_ROOT env var).
set -euo pipefail

CONSUMER_ROOT="${CONSUMER_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$CONSUMER_ROOT"

GOVERNANCE_MOUNT="${GOVERNANCE_MOUNT:-.governance/ai-dev-governance}"

fail() { echo "[FAIL] $1" >&2; FAILURES=$((FAILURES + 1)); }
pass() { echo "[PASS] $1"; }
warn() { echo "[WARN] $1"; }

FAILURES=0

# ── 1. Astaire wrapper ──────────────────────────────────────────────────────
[[ -f ".astaire/astaire" ]] || fail ".astaire/astaire does not exist"
[[ -x ".astaire/astaire" ]] || fail ".astaire/astaire is not executable"
pass ".astaire/astaire present and executable"

# ── 2. Database gitignored ──────────────────────────────────────────────────
if [[ -f ".gitignore" ]]; then
  grep -qF ".astaire/memory_palace.db" .gitignore \
    || fail ".astaire/memory_palace.db not in .gitignore"
  pass ".astaire/memory_palace.db gitignored"
else
  fail ".gitignore not found"
fi

# ── 3. Governance manifest ──────────────────────────────────────────────────
[[ -f "governance.yaml" ]] || fail "governance.yaml not found"
for key in apiVersion governanceVersion profile adapters evidence automation boardReview; do
  grep -q "^${key}:" governance.yaml || fail "governance.yaml missing key: ${key}"
done
pass "governance.yaml present with required keys"

# ── 4. Agent bootstrap block ────────────────────────────────────────────────
BOOTSTRAP_FILE=""
for f in AGENTS.md CLAUDE.md; do
  if [[ -f "$f" ]]; then
    BOOTSTRAP_FILE="$f"
    break
  fi
done

if [[ -z "$BOOTSTRAP_FILE" ]]; then
  fail "Neither AGENTS.md nor CLAUDE.md found"
else
  grep -q "ai-dev-governance:bootstrap:start" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing bootstrap start marker"
  grep -q "ai-dev-governance:bootstrap:end" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing bootstrap end marker"
  grep -q ".astaire/astaire" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE does not reference .astaire/astaire"
  grep -q "port-of-first-resort" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing port-of-first-resort clause"
  pass "$BOOTSTRAP_FILE contains bootstrap block with Astaire surface"
fi

# ── 5. Directory structure ──────────────────────────────────────────────────
for d in docs/planning docs/releases docs/governance; do
  [[ -d "$d" ]] || fail "Missing directory: $d"
done
pass "Required directory structure present"

# ── 6. Governance submodule ─────────────────────────────────────────────────
if [[ -d "$GOVERNANCE_MOUNT" ]]; then
  [[ -f "$GOVERNANCE_MOUNT/VERSION" ]] || fail "$GOVERNANCE_MOUNT/VERSION not found (submodule uninitialized?)"
  pass "Governance submodule initialized at $GOVERNANCE_MOUNT"
else
  fail "Governance submodule not found at $GOVERNANCE_MOUNT"
fi

# ── 7. Astaire DB initialized (soft check) ──────────────────────────────────
if [[ -f ".astaire/memory_palace.db" ]]; then
  pass ".astaire/memory_palace.db exists (Astaire initialized)"
else
  warn ".astaire/memory_palace.db not found — run: .astaire/astaire startup --root ."
fi

# ── 8. Tentacle pin verification ─────────────────────────────────────────────
MATRIX="$GOVERNANCE_MOUNT/runbooks/COMPATIBILITY_MATRIX.md"
if [[ -f "$MATRIX" ]]; then
  # Extract expected astaire SHA from matrix (looks for pattern: astaire @ <sha>)
  EXPECTED_ASTAIRE_SHA="$(sed -n 's/.*astaire` @ `\([a-f0-9]*\).*/\1/p' "$MATRIX" | head -1 || true)"
  if [[ -n "$EXPECTED_ASTAIRE_SHA" && -d "$GOVERNANCE_MOUNT/astaire/.git" ]]; then
    ACTUAL_SHA="$(git -C "$GOVERNANCE_MOUNT/astaire" rev-parse --short HEAD 2>/dev/null || true)"
    if [[ "${ACTUAL_SHA}" == "${EXPECTED_ASTAIRE_SHA}"* ]] || \
       [[ "${EXPECTED_ASTAIRE_SHA}" == "${ACTUAL_SHA}"* ]]; then
      pass "Astaire submodule pinned to expected SHA ($ACTUAL_SHA)"
    else
      warn "Astaire pin mismatch: matrix expects $EXPECTED_ASTAIRE_SHA, got $ACTUAL_SHA"
    fi
  fi
fi

# ── 9. Astaire wiring (provider-aware) ──────────────────────────────────────
WIRING_SCRIPT="$GOVERNANCE_MOUNT/scripts/validate_astaire_wiring.sh"
if [[ -x "$WIRING_SCRIPT" ]]; then
  if bash "$WIRING_SCRIPT" --root "$CONSUMER_ROOT"; then
    pass "Astaire wiring validated (provider-aware)"
  else
    fail "Astaire wiring check failed — run $WIRING_SCRIPT --root . for details"
  fi
else
  warn "validate_astaire_wiring.sh not found at $WIRING_SCRIPT — skipping provider-aware wiring check"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
if [[ $FAILURES -eq 0 ]]; then
  echo "Bootstrap validation passed."
else
  echo "$FAILURES check(s) failed." >&2
  exit 1
fi
