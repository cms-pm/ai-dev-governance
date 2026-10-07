#!/usr/bin/env bash
# Consumer-side bootstrap completeness check.
# Run from the consumer repo root (or set CONSUMER_ROOT env var).
set -euo pipefail

CONSUMER_ROOT="${CONSUMER_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$CONSUMER_ROOT"

GOVERNANCE_MOUNT="${GOVERNANCE_MOUNT:-.governance/ai-dev-governance}"

fail() { echo "[FAIL] $1" >&2; FAILURES=$((FAILURES + 1)); CHECKS_RUN=$((CHECKS_RUN + 1)); }
pass() { echo "[PASS] $1"; CHECKS_RUN=$((CHECKS_RUN + 1)); }
warn() { echo "[WARN] $1"; CHECKS_RUN=$((CHECKS_RUN + 1)); }
# Emit PASS only if no fail() fired since the check began (R-11-09): a
# check that failed must never also print a PASS line for the same artifact.
pass_unless_failed() { if (( FAILURES == $1 )); then pass "$2"; fi; }

FAILURES=0
CHECKS_RUN=0
# Executed-check floor (R-11-08). Every check below MUST emit exactly one
# pass/fail/warn. A total under this floor means a branch went silent, which
# is the failure mode that let a consumer with no Astaire tentacle certify
# green. Calibrated against a healthy consumer: 13 parent-emitted checks
# (nested validator output is counted by the child, not here). Overridable
# for configurations that legitimately emit fewer.
MIN_CHECKS="${MIN_CHECKS:-13}"

# ── 1. Astaire wrapper ──────────────────────────────────────────────────────
F0=$FAILURES
[[ -f ".astaire/astaire" ]] || fail ".astaire/astaire does not exist"
[[ -x ".astaire/astaire" ]] || fail ".astaire/astaire is not executable"
pass_unless_failed "$F0" ".astaire/astaire present and executable"

# ── 2. Database gitignored ──────────────────────────────────────────────────
if [[ -f ".gitignore" ]]; then
  F0=$FAILURES
  grep -qF ".astaire/memory_palace.db" .gitignore \
    || fail ".astaire/memory_palace.db not in .gitignore"
  pass_unless_failed "$F0" ".astaire/memory_palace.db gitignored"
else
  fail ".gitignore not found"
fi

# ── 3. Governance manifest ──────────────────────────────────────────────────
F0=$FAILURES
[[ -f "governance.yaml" ]] || fail "governance.yaml not found"
for key in apiVersion governanceVersion profile adapters evidence automation boardReview; do
  grep -q "^${key}:" governance.yaml || fail "governance.yaml missing key: ${key}"
done
pass_unless_failed "$F0" "governance.yaml present with required keys"

if [[ -f "governance.yaml" && -f "$GOVERNANCE_MOUNT/VERSION" ]]; then
  MANIFEST_VERSION="$(sed -nE 's/^governanceVersion:[[:space:]]*([^[:space:]]+).*/\1/p' governance.yaml | head -1)"
  EXPECTED_GOVERNANCE_VERSION="v$(tr -d '[:space:]' < "$GOVERNANCE_MOUNT/VERSION")"
  if [[ -n "$MANIFEST_VERSION" && "$MANIFEST_VERSION" != "$EXPECTED_GOVERNANCE_VERSION" ]]; then
    EXCEPTION_FILE="docs/governance/exceptions.yaml"
    if [[ -f "$EXCEPTION_FILE" ]] && \
       grep -qF "$MANIFEST_VERSION" "$EXCEPTION_FILE" && \
       grep -qF "$EXPECTED_GOVERNANCE_VERSION" "$EXCEPTION_FILE" && \
       grep -qi "governanceVersion" "$EXCEPTION_FILE"; then
      warn "governanceVersion $MANIFEST_VERSION differs from installed ADG $EXPECTED_GOVERNANCE_VERSION; local exception documented"
    else
      fail "governanceVersion $MANIFEST_VERSION does not match installed ADG $EXPECTED_GOVERNANCE_VERSION; update governance.yaml or document a governanceVersion exception"
    fi
  else
    pass "governanceVersion matches installed ADG ($EXPECTED_GOVERNANCE_VERSION)"
  fi
fi

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
  F0=$FAILURES
  grep -q "ai-dev-governance:bootstrap:start" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing bootstrap start marker"
  grep -q "ai-dev-governance:bootstrap:end" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing bootstrap end marker"
  grep -q ".astaire/astaire" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE does not reference .astaire/astaire"
  grep -q "port-of-first-resort" "$BOOTSTRAP_FILE" \
    || fail "$BOOTSTRAP_FILE missing port-of-first-resort clause"
  pass_unless_failed "$F0" "$BOOTSTRAP_FILE contains bootstrap block with Astaire surface"
fi

# ── 5. Directory structure ──────────────────────────────────────────────────
F0=$FAILURES
for d in docs/planning docs/releases docs/governance; do
  [[ -d "$d" ]] || fail "Missing directory: $d"
done
pass_unless_failed "$F0" "Required directory structure present"

# ── 6. Governance submodule ─────────────────────────────────────────────────
if [[ -d "$GOVERNANCE_MOUNT" ]]; then
  F0=$FAILURES
  [[ -f "$GOVERNANCE_MOUNT/VERSION" ]] || fail "$GOVERNANCE_MOUNT/VERSION not found (submodule uninitialized?)"
  pass_unless_failed "$F0" "Governance submodule initialized at $GOVERNANCE_MOUNT"
else
  fail "Governance submodule not found at $GOVERNANCE_MOUNT"
fi

# ── 7. CodeGraph contract visibility ────────────────────────────────────────
CG_CONTRACT="docs/governance/codegraph-contract.md"
CG_DECLARED=false
CG_PARTIAL=false
if [[ -f "governance.yaml" ]] && \
   grep -q "codegraphIndexFreshnessURI:" governance.yaml && \
   grep -q "codegraphImageDigestURI:" governance.yaml; then
  CG_DECLARED=true
elif [[ -f "governance.yaml" ]] && \
     { grep -q "codegraphIndexFreshnessURI:" governance.yaml || \
       grep -q "codegraphImageDigestURI:" governance.yaml; }; then
  CG_PARTIAL=true
fi

if [[ -f "$CG_CONTRACT" ]]; then
  pass "CodeGraph consumer contract visible at $CG_CONTRACT"
else
  if [[ "$CG_DECLARED" == true || "$CG_PARTIAL" == true ]]; then
    fail "CodeGraph is declared but $CG_CONTRACT is missing"
  else
    warn "$CG_CONTRACT not found — v1.1.0+ consumers should retain this optional-CG decision record"
  fi
fi

if [[ "$CG_PARTIAL" == true ]]; then
  fail "CodeGraph declaration is incomplete — declare both codegraphIndexFreshnessURI and codegraphImageDigestURI, or remove both"
elif [[ "$CG_DECLARED" == true ]]; then
  CG_WIRING_SCRIPT="$GOVERNANCE_MOUNT/scripts/validate_codegraph_wiring.sh"
  if [[ -x "$CG_WIRING_SCRIPT" ]]; then
    if bash "$CG_WIRING_SCRIPT" --root "$CONSUMER_ROOT"; then
      pass "CodeGraph wiring validated (declared CG consumer)"
    else
      fail "CodeGraph wiring check failed — run $CG_WIRING_SCRIPT --root . for details"
    fi
  else
    fail "CodeGraph is declared but $CG_WIRING_SCRIPT is missing or not executable"
  fi
else
  pass "CodeGraph not declared; CG wiring validation not required"
fi

# ── 8. Astaire DB initialized (soft check) ──────────────────────────────────
if [[ -f ".astaire/memory_palace.db" ]]; then
  pass ".astaire/memory_palace.db exists (Astaire initialized)"
else
  warn ".astaire/memory_palace.db not found — run: .astaire/astaire startup --root ."
fi

# ── 9. Astaire tentacle presence (fail-closed) ──────────────────────────────
# The .astaire/astaire wrapper runs `uv sync --project $GOVERNANCE_MOUNT/astaire`.
# Without a populated tentacle there is no Astaire at all, so presence is a
# hard requirement in its own right — not merely a precondition for the
# optional pin check below. Testing pyproject.toml rather than the git dir
# affirms the submodule is *populated*: an initialized-but-empty checkout
# satisfies `git rev-parse` and still cannot run. See R-11-08.
ASTAIRE_DIR="$GOVERNANCE_MOUNT/astaire"
if [[ -f "$ASTAIRE_DIR/pyproject.toml" ]]; then
  pass "Astaire tentacle present and populated at $ASTAIRE_DIR"
  ASTAIRE_PRESENT=true
else
  fail "Astaire tentacle missing or uninitialized at $ASTAIRE_DIR — the .astaire/astaire wrapper cannot run. Fix: git submodule update --init --recursive"
  ASTAIRE_PRESENT=false
fi

# ── 9b. Tentacle pin verification ───────────────────────────────────────────
# Every branch emits a verdict. No path may leave this block silently — that
# is what R-11-08 was.
MATRIX="$GOVERNANCE_MOUNT/runbooks/COMPATIBILITY_MATRIX.md"
if [[ "$ASTAIRE_PRESENT" != true ]]; then
  warn "Astaire pin check skipped — tentacle absent (see failure above)"
elif [[ ! -f "$MATRIX" ]]; then
  fail "COMPATIBILITY_MATRIX.md missing at $MATRIX — cannot verify tentacle pin; the governance surface is incomplete"
else
  EXPECTED_ASTAIRE_SHA="$(sed -nE 's/.*`astaire` @ `[^`]+` \(`?([a-f0-9]{7,40})`?\).*/\1/p; s/.*`astaire` @ `([a-f0-9]{7,40})`.*/\1/p' "$MATRIX" | head -1 || true)"
  if [[ -z "$EXPECTED_ASTAIRE_SHA" ]]; then
    warn "Could not parse an expected astaire SHA from $MATRIX — pin unverified"
  else
    ACTUAL_SHA="$(git -C "$ASTAIRE_DIR" rev-parse --short HEAD 2>/dev/null || true)"
    if [[ -z "$ACTUAL_SHA" ]]; then
      fail "Astaire tentacle at $ASTAIRE_DIR is not a git checkout — cannot verify pin"
    elif [[ "${ACTUAL_SHA}" == "${EXPECTED_ASTAIRE_SHA}"* ]] || \
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
if (( CHECKS_RUN < MIN_CHECKS )); then
  echo "[FAIL] only $CHECKS_RUN checks executed, expected >= $MIN_CHECKS — a check branch went silent (R-11-08)" >&2
  FAILURES=$((FAILURES + 1))
fi

if [[ $FAILURES -eq 0 ]]; then
  echo "Bootstrap validation passed ($CHECKS_RUN checks executed)."
else
  echo "$FAILURES check(s) failed." >&2
  exit 1
fi
