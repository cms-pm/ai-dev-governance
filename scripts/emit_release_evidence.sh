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

[[ -x "${REPO_ROOT}/.astaire/astaire" ]] || fail ".astaire/astaire not found or not executable"

# ── L0 snapshot ──────────────────────────────────────────────────────────────
info "Capturing L0 snapshot -> ${OUT_DIR}/l0-snapshot.md"
{
  echo "# Astaire L0 Snapshot — ${VERSION}"
  echo ""
  echo "Captured at release tag cut: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""
  "${REPO_ROOT}/.astaire/astaire" status
} > "${OUT_DIR}/l0-snapshot.md"

# ── Health report ─────────────────────────────────────────────────────────────
info "Running lint -> ${OUT_DIR}/health-report.md"
{
  echo "# Astaire Health Report — ${VERSION}"
  echo ""
  echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo ""
  "${REPO_ROOT}/.astaire/astaire" lint 2>&1 || true
} > "${OUT_DIR}/health-report.md"

# ── Blocking findings check ───────────────────────────────────────────────────
if grep -qi "\[BLOCK\]\|\[ERROR\]" "${OUT_DIR}/health-report.md"; then
  fail "Blocking findings in health report — resolve before tagging"
fi

info "Release evidence written to ${OUT_DIR}/"
info "  l0-snapshot.md"
info "  health-report.md"
