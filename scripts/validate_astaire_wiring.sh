#!/usr/bin/env bash
set -euo pipefail

# validate_astaire_wiring.sh — verify Astaire is properly wired for agent sessions.
#
# Provider-aware: reads governance.yaml adapters when present.
#   providers/claude  → CLAUDE.md must exist and contain the snippet
#   providers/codex   → AGENTS.md must exist and contain the snippet
#   no governance.yaml → at least one of CLAUDE.md / AGENTS.md must contain it
#
# Usage:
#   scripts/validate_astaire_wiring.sh [--root <path>]
#
# Exit 0 = all checks pass. Exit 1 = one or more checks failed.

ROOT="."
while [[ $# -gt 0 ]]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

cd "$ROOT"

FAILED=0
fail() { echo "[FAIL] $1" >&2; FAILED=1; }
pass() { echo "[PASS] $1"; }

SNIPPET_MARKER=".astaire/astaire"

# --- 1. Wrapper ---
if [[ -x ".astaire/astaire" ]]; then
  pass ".astaire/astaire wrapper is executable"
else
  fail ".astaire/astaire wrapper missing or not executable — see SUBMODULE_CONSUMER_RUNBOOK.md §Wire Astaire Access"
fi

# --- 2. Provider detection and bootstrap file check ---
check_bootstrap() {
  local file="$1"
  local provider_label="$2"
  if [[ ! -f "$file" ]]; then
    fail "$file missing — $provider_label consumers must inline the Astaire CLI snippet here (see templates/ASTAIRE_CLI_SNIPPET.md)"
  elif ! grep -q "$SNIPPET_MARKER" "$file"; then
    fail "$file exists but does not contain '$SNIPPET_MARKER' — inline templates/ASTAIRE_CLI_SNIPPET.md into the file"
  else
    pass "$file contains Astaire CLI snippet ($provider_label)"
  fi
}

if [[ -f "governance.yaml" ]]; then
  checked=0
  if grep -q "providers/claude" governance.yaml; then
    check_bootstrap "CLAUDE.md" "Claude"
    checked=1
  fi
  if grep -q "providers/codex" governance.yaml; then
    check_bootstrap "AGENTS.md" "Codex"
    checked=1
  fi
  if [[ $checked -eq 0 ]]; then
    pass "No provider adapter in governance.yaml — bootstrap file check skipped"
  fi
else
  # No governance.yaml at root — accept either CLAUDE.md or AGENTS.md
  found=0
  if [[ -f "CLAUDE.md" ]] && grep -q "$SNIPPET_MARKER" "CLAUDE.md"; then
    pass "CLAUDE.md contains Astaire CLI snippet"
    found=1
  fi
  if [[ -f "AGENTS.md" ]] && grep -q "$SNIPPET_MARKER" "AGENTS.md"; then
    pass "AGENTS.md contains Astaire CLI snippet"
    found=1
  fi
  if [[ $found -eq 0 ]]; then
    fail "Neither CLAUDE.md nor AGENTS.md contains '$SNIPPET_MARKER' — inline templates/ASTAIRE_CLI_SNIPPET.md into the appropriate file"
  fi
fi

# --- 3. .gitignore excludes the runtime database ---
if [[ -f ".gitignore" ]] && grep -q "memory_palace.db" ".gitignore"; then
  pass ".gitignore excludes memory_palace.db"
else
  fail ".gitignore must contain 'memory_palace.db' — the database is runtime-generated and must not be committed"
fi

# --- Result ---
echo ""
if [[ $FAILED -ne 0 ]]; then
  echo "Astaire wiring validation FAILED. Fix the items above, then re-run this script."
  exit 1
fi
echo "All Astaire wiring checks passed."
