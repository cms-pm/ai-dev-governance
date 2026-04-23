#!/usr/bin/env bash
# ADG-BOOTSTRAP-04 — install graphify with the minimal dependency subset
# required for the restricted / structural fallback path only.
#
# The vendored graphify package currently lists `graspologic` as a top-level
# dependency, which drags in `numba` / `llvmlite` and a system LLVM toolchain.
# The restricted fallback (fail-closed governance graph) never touches the
# community-detection path that needs those, so consumers can run on the
# lighter subset documented below.
#
# A proper fix (moving `graspologic` into an optional `[cluster]` extra) must
# land in the external graphify project (safishamsi/graphify). Until that
# ships and this repo re-pins, use this helper.
#
# Usage:
#   scripts/install_graphify_fallback.sh [venv-python]
#
# Defaults to `python3`. Honours GRAPHIFY_SRC to override the source path;
# otherwise auto-detects between monorepo (./graphify) and submodule consumer
# (./.governance/ai-dev-governance/graphify) layouts.

set -euo pipefail

die() { echo "[install_graphify_fallback] FAIL: $*" >&2; exit 1; }
info() { echo "[install_graphify_fallback] $*" >&2; }

PY="${1:-python3}"
command -v "$PY" >/dev/null 2>&1 || die "python interpreter not found: $PY"

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if [[ -n "${GRAPHIFY_SRC:-}" ]]; then
  SRC="$GRAPHIFY_SRC"
elif [[ -f "${ROOT_DIR}/.governance/ai-dev-governance/graphify/pyproject.toml" ]]; then
  SRC="${ROOT_DIR}/.governance/ai-dev-governance/graphify"
elif [[ -f "${ROOT_DIR}/graphify/pyproject.toml" ]]; then
  SRC="${ROOT_DIR}/graphify"
else
  die "graphify source not found; set GRAPHIFY_SRC or run from a consumer repo"
fi
info "source: $SRC"

# Minimal runtime subset the restricted / structural fallback actually uses.
# Heavy community-detection stack (graspologic / numba / llvmlite) is deliberately
# excluded — install `graphifyy[cluster]` (once upstream ships the extra) or the
# full package for Leiden support.
MIN_DEPS=(
  setuptools wheel
  networkx
  tree-sitter
  tree-sitter-python
  tree-sitter-javascript
  tree-sitter-typescript
  tree-sitter-go
  tree-sitter-rust
  tree-sitter-java
  tree-sitter-c
  tree-sitter-cpp
  tree-sitter-ruby
  tree-sitter-c-sharp
  tree-sitter-kotlin
  tree-sitter-scala
  tree-sitter-php
)

info "installing minimal runtime subset"
"$PY" -m pip install --upgrade "${MIN_DEPS[@]}"

info "installing graphify --no-deps --no-build-isolation"
"$PY" -m pip install --no-deps --no-build-isolation -e "$SRC"

info "verifying import"
"$PY" -c 'import graphify; print("graphify:", getattr(graphify, "__version__", "unknown"))'

cat <<MSG

[install_graphify_fallback] done.
  - Restricted / structural graphify paths (code-only, --restrict) should now work.
  - Community detection (Leiden) is NOT installed; calling it will raise
    ImportError for 'graspologic'. Install with the full dep stack if needed.
  - Tested range: Python 3.11, 3.12. Python >=3.14 currently breaks the heavy stack.
MSG
