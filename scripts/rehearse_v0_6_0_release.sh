#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-v0.6.0}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { echo "[rehearse] $*"; }
fail() { echo "[rehearse] FAIL: $*" >&2; exit 1; }
run_clean() {
  env -u LC_ALL -u LANG -u LC_CTYPE "$@"
}

[[ -x "${ROOT_DIR}/.astaire/astaire" ]] || fail ".astaire/astaire not found or not executable"
[[ -x "${ROOT_DIR}/scripts/rtk-local.sh" ]] || fail "scripts/rtk-local.sh not found or not executable"
[[ -x "${ROOT_DIR}/scripts/run_graphify.sh" ]] || fail "scripts/run_graphify.sh not found or not executable"
[[ -x "${ROOT_DIR}/scripts/validate_graphify.sh" ]] || fail "scripts/validate_graphify.sh not found or not executable"

info "RTK Codex reinforcement"
run_clean "${ROOT_DIR}/scripts/rtk-local.sh" init --show --codex

info "RTK discovery snapshot"
run_clean "${ROOT_DIR}/scripts/rtk-local.sh" discover

info "RTK gain snapshot"
run_clean "${ROOT_DIR}/scripts/rtk-local.sh" gain

info "RTK history proof"
run_clean "${ROOT_DIR}/scripts/rtk-local.sh" gain --history

info "Graphify dogfood build"
(
  cd "${ROOT_DIR}"
  run_clean "${ROOT_DIR}/scripts/run_graphify.sh" .
)

info "Graphify validation"
run_clean "${ROOT_DIR}/scripts/validate_graphify.sh"

info "Astaire graphify import"
run_clean "${ROOT_DIR}/.astaire/astaire" graphify-import --root "${ROOT_DIR}"

info "Astaire startup convergence"
run_clean "${ROOT_DIR}/.astaire/astaire" startup --root "${ROOT_DIR}"

info "Release evidence emission"
run_clean "${ROOT_DIR}/scripts/emit_release_evidence.sh" "${VERSION}"

info "Release rehearsal complete for ${VERSION}"
