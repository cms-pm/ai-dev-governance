#!/usr/bin/env bash
# Consumer-side bootstrap completeness check.
# Run from the consumer repo root (or set CONSUMER_ROOT env var).
set -euo pipefail

CONSUMER_ROOT="${CONSUMER_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$CONSUMER_ROOT"

GOVERNANCE_MOUNT="${GOVERNANCE_MOUNT:-.governance/ai-dev-governance}"
IS_GOVERNANCE_SOURCE=false
if [[ ! -d "$GOVERNANCE_MOUNT" && -f "VERSION" && -d "scripts" && -d "templates" ]]; then
  IS_GOVERNANCE_SOURCE=true
  GOVERNANCE_MOUNT="."
fi

fail() { echo "[FAIL] $1" >&2; FAILURES=$((FAILURES + 1)); }
pass() { echo "[PASS] $1"; }
warn() { echo "[WARN] $1"; }

FAILURES=0
ASTAIRE_WRAPPER="./.astaire/astaire"

# ── 1. Astaire wrapper ──────────────────────────────────────────────────────
[[ -f ".astaire/astaire" ]] || fail ".astaire/astaire does not exist"
[[ -x ".astaire/astaire" ]] || fail ".astaire/astaire is not executable"
pass ".astaire/astaire present and executable"

# ── 2. Database gitignored ──────────────────────────────────────────────────
if [[ -f ".gitignore" ]]; then
  grep -qF ".astaire/memory_palace.db" .gitignore \
    || fail ".astaire/memory_palace.db not in .gitignore"
  grep -qF ".astaire/.uv-cache/" .gitignore \
    || warn ".astaire/.uv-cache/ not in .gitignore (recommended for repo-local uv cache)"
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
  if [[ "$IS_GOVERNANCE_SOURCE" == true ]]; then
    warn "AGENTS.md / CLAUDE.md bootstrap markers not required in governance source repo mode"
  else
    fail "Neither AGENTS.md nor CLAUDE.md found"
  fi
else
  if [[ "$IS_GOVERNANCE_SOURCE" == true ]]; then
    if grep -q ".astaire/astaire" "$BOOTSTRAP_FILE"; then
      pass "$BOOTSTRAP_FILE references the Astaire wrapper in governance source repo mode"
    elif [[ "$BOOTSTRAP_FILE" == "AGENTS.md" || "$BOOTSTRAP_FILE" == "CLAUDE.md" ]]; then
      pass "$BOOTSTRAP_FILE present in governance source repo mode; consumer bootstrap markers not required"
    else
      warn "$BOOTSTRAP_FILE does not inline the consumer bootstrap block in governance source repo mode"
    fi
  else
    bootstrap_ok=true
    grep -q "ai-dev-governance:bootstrap:start" "$BOOTSTRAP_FILE" \
      || { fail "$BOOTSTRAP_FILE missing bootstrap start marker"; bootstrap_ok=false; }
    grep -q "ai-dev-governance:bootstrap:end" "$BOOTSTRAP_FILE" \
      || { fail "$BOOTSTRAP_FILE missing bootstrap end marker"; bootstrap_ok=false; }
    grep -q ".astaire/astaire" "$BOOTSTRAP_FILE" \
      || { fail "$BOOTSTRAP_FILE does not reference .astaire/astaire"; bootstrap_ok=false; }
    grep -q "port-of-first-resort" "$BOOTSTRAP_FILE" \
      || { fail "$BOOTSTRAP_FILE missing port-of-first-resort clause"; bootstrap_ok=false; }
    if [[ "$bootstrap_ok" == true ]]; then
      pass "$BOOTSTRAP_FILE contains bootstrap block with Astaire surface"
    fi
  fi
fi

# ── 5. Directory structure ──────────────────────────────────────────────────
for d in docs/planning docs/releases docs/governance; do
  [[ -d "$d" ]] || fail "Missing directory: $d"
done
pass "Required directory structure present"

# ── 6. Governance submodule ─────────────────────────────────────────────────
if [[ -d "$GOVERNANCE_MOUNT" ]]; then
  [[ -f "$GOVERNANCE_MOUNT/VERSION" ]] || fail "$GOVERNANCE_MOUNT/VERSION not found (submodule uninitialized?)"
  if [[ "$IS_GOVERNANCE_SOURCE" == true ]]; then
    pass "Governance source repo detected"
  else
    pass "Governance submodule initialized at $GOVERNANCE_MOUNT"
  fi
else
  fail "Governance submodule not found at $GOVERNANCE_MOUNT"
fi

# ── 7. Astaire DB initialized (soft check) ──────────────────────────────────
if [[ -f ".astaire/memory_palace.db" ]]; then
  pass ".astaire/memory_palace.db exists (Astaire initialized)"
else
  warn ".astaire/memory_palace.db not found — run: .astaire/astaire startup --root ."
fi

# ── 8.5 Live Astaire wrapper probe ───────────────────────────────────────────
if [[ -x "$ASTAIRE_WRAPPER" ]]; then
  if "$ASTAIRE_WRAPPER" status >/tmp/ai_dev_gov_validate_bootstrap_astaire.txt 2>&1; then
    pass "Astaire wrapper executes successfully"
  else
    fail "Astaire wrapper failed to run — inspect /tmp/ai_dev_gov_validate_bootstrap_astaire.txt"
  fi
fi

# ── 8.6 Graphify preflight (when enabled) ────────────────────────────────────
if grep -q '^graphify:' governance.yaml; then
  GRAPHIFY_PREFLIGHT_SCRIPT="$GOVERNANCE_MOUNT/scripts/run_graphify.sh"
  if [[ -x "$GRAPHIFY_PREFLIGHT_SCRIPT" ]]; then
    if "$GRAPHIFY_PREFLIGHT_SCRIPT" --preflight >/tmp/ai_dev_gov_validate_bootstrap_graphify.txt 2>&1; then
      pass "Graphify preflight executes successfully"
    else
      fail "Graphify preflight failed — inspect /tmp/ai_dev_gov_validate_bootstrap_graphify.txt"
    fi
  else
    warn "graphify preflight script not found at $GRAPHIFY_PREFLIGHT_SCRIPT — skipping graphify runtime probe"
  fi
fi

# ── 9. Tentacle pin verification ─────────────────────────────────────────────
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

# ── 10. Astaire wiring (provider-aware) ─────────────────────────────────────
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
