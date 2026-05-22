#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

export ADG_CONTAINER_RUNTIME="$ROOT_DIR/validation/fixtures/codegraph/fake-runtime"

# Keep the fixture index fresher than source files while running in an
# uncommitted working tree.
touch validation/fixtures/codegraph/positive/.codegraph

bash scripts/validate_codegraph_wiring.sh \
  --root validation/fixtures/codegraph/positive

check_negative() {
  local fixture="$1"
  local expected="$2"
  local output
  output="$(mktemp)"
  if bash scripts/validate_codegraph_wiring.sh \
    --root "validation/fixtures/codegraph/$fixture" \
    >"$output" 2>&1; then
    echo "[FAIL] $fixture unexpectedly passed" >&2
    exit 1
  fi
  grep -F "$expected" "$output" >/dev/null
}

check_negative "negative-missing-mcp" ".mcp.json missing mcpServers.codegraph.command"
check_negative "negative-raw-npx" ".mcp.json codegraph server must invoke the codegraph-mcp wrapper, not raw npx"
check_negative "negative-missing-digest" ".codegraph/image.digest missing"
check_negative "negative-missing-ignore" ".codegraphignore missing"
check_negative "negative-stale-index" ".codegraph/ index timestamp is older than tracked source"
check_negative "negative-missing-sbom" ".codegraph/evidence/sbom.spdx.json missing"

echo "[PASS] CodeGraph wiring fixtures"
