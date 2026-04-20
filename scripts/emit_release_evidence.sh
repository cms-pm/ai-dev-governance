#!/usr/bin/env bash
# Emit Astaire release evidence: L0 snapshot + health report.
# Usage: scripts/emit_release_evidence.sh <version>   e.g. v0.6.0
set -euo pipefail

VERSION="${1:?'Usage: emit_release_evidence.sh <version>'}"
REPO_ROOT="$(git rev-parse --show-toplevel)"
OUT_DIR="${REPO_ROOT}/docs/releases/${VERSION}"
mkdir -p "$OUT_DIR"

fail() { echo "[FAIL] $1" >&2; exit 1; }
info() { echo "[INFO] $1"; }
run_clean() {
  env -u LC_ALL -u LANG -u LC_CTYPE "$@" 2>&1 | awk '
    /warning: setlocale: LC_ALL: cannot change locale/ { next }
    /^perl: warning: Setting locale failed\.$/ { next }
    /^perl: warning: Please check that your locale settings:$/ { skip=1; next }
    skip && /are supported and installed on your system\.$/ { skip=0; next }
    skip { next }
    /^perl: warning: Falling back to the standard locale/ { next }
    { print }
  '
}

[[ -x "${REPO_ROOT}/.astaire/astaire" ]] || fail ".astaire/astaire not found or not executable"

# ── Startup convergence ──────────────────────────────────────────────────────
info "Running Astaire startup -> ${OUT_DIR}/startup.log"
if ! run_clean "${REPO_ROOT}/.astaire/astaire" startup --root "${REPO_ROOT}" > "${OUT_DIR}/startup.log"; then
  fail "Astaire startup failed — resolve before tagging"
fi

# ── L0 snapshot ──────────────────────────────────────────────────────────────
info "Capturing L0 snapshot -> ${OUT_DIR}/l0-snapshot.md"
{
  echo "# Astaire L0 Snapshot — ${VERSION}"
  echo ""
  echo "Captured at release tag cut: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""
  run_clean "${REPO_ROOT}/.astaire/astaire" status
} > "${OUT_DIR}/l0-snapshot.md"

# ── Health report ─────────────────────────────────────────────────────────────
info "Running lint -> ${OUT_DIR}/health-report.md"
{
  echo "# Astaire Health Report — ${VERSION}"
  echo ""
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""
  run_clean "${REPO_ROOT}/.astaire/astaire" lint || true
} > "${OUT_DIR}/health-report.md"

# ── Graphify validation ──────────────────────────────────────────────────────
graphify_status=0
if grep -q '^graphify:' "${REPO_ROOT}/governance.yaml" && [[ -x "${REPO_ROOT}/scripts/validate_graphify.sh" ]]; then
  info "Running graphify validation -> ${OUT_DIR}/graphify-validation.md"
  {
    echo "# Graphify Validation — ${VERSION}"
    echo ""
    echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo ""
  } > "${OUT_DIR}/graphify-validation.md"
  if ! run_clean "${REPO_ROOT}/scripts/validate_graphify.sh" >> "${OUT_DIR}/graphify-validation.md"; then
    graphify_status=1
  fi
fi

# ── Blocking findings check ───────────────────────────────────────────────────
if [[ "${graphify_status}" -ne 0 ]]; then
  fail "Graphify validation failed — resolve before tagging"
fi

if grep -Eqi '\[(block|error)\]|Total: .* [1-9][0-9]* errors?' "${OUT_DIR}/health-report.md"; then
  fail "Blocking findings in health report — resolve before tagging"
fi

if grep -q "Orphan entity" "${OUT_DIR}/health-report.md"; then
  fail "Orphan entities remain in health report — resolve before tagging"
fi

if grep -Eq 'graphify import: .*relationships_created=0 .*claims_created=0' "${OUT_DIR}/l0-snapshot.md"; then
  fail "Graphify import is structurally empty (0 relationships and 0 claims) — resolve before tagging"
fi

info "Release evidence written to ${OUT_DIR}/"
info "  startup.log"
info "  l0-snapshot.md"
info "  health-report.md"
if [[ -f "${OUT_DIR}/graphify-validation.md" ]]; then
  info "  graphify-validation.md"
fi
