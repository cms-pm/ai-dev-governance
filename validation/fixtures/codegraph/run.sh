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
check_negative "negative-privileged" ".mcp.json CodeGraph wiring must not use --privileged"
check_negative "negative-network-host" ".mcp.json CodeGraph wiring must not use --network=host"
check_negative "negative-pid-host" ".mcp.json CodeGraph wiring must not use --pid=host"
check_negative "negative-ipc-host" ".mcp.json CodeGraph wiring must not use --ipc=host"
check_negative "negative-cap-add" ".mcp.json CodeGraph wiring must not use --cap-add"
check_negative "negative-seccomp-unconfined" ".mcp.json CodeGraph wiring must not use --security-opt seccomp=unconfined"
check_negative "negative-var-run-docker-sock" ".mcp.json CodeGraph wiring must not mount /var/run/docker.sock"
check_negative "negative-run-docker-sock" ".mcp.json CodeGraph wiring must not mount /run/docker.sock"
check_negative "negative-latest-image" ".mcp.json CodeGraph wiring must not use :latest image refs"
check_negative "negative-raw-npx-codegraph" ".mcp.json CodeGraph wiring must not invoke raw npx codegraph"

echo "[PASS] CodeGraph wiring fixtures"
