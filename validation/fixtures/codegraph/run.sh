#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT_DIR"

export ADG_CONTAINER_RUNTIME="$ROOT_DIR/validation/fixtures/codegraph/fake-runtime"
export ADG_CODEGRAPH_SKIP_LIVE_STATUS=1

# Keep the fixture index fresher than source files while running in an
# uncommitted working tree.
touch validation/fixtures/codegraph/positive/.codegraph

bash scripts/validate_codegraph_wiring.sh \
  --root validation/fixtures/codegraph/positive

ADG_FAKE_RUNTIME_REJECT_REPODIGEST=1 bash scripts/validate_codegraph_wiring.sh \
  --root validation/fixtures/codegraph/positive

check_live_status_variant() {
  local mode="$1"
  local expected="$2"
  local should_pass="${3:-pass}"
  local tmp
  local output
  tmp="$(mktemp -d)"
  output="$(mktemp)"
  mkdir -p "$tmp/.codegraph/evidence" "$tmp/scripts" "$tmp/src"
  printf 'sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1\n' > "$tmp/.codegraph/image.digest"
  printf '{}\n' > "$tmp/.codegraph/evidence/sbom.spdx.json"
  printf 'def indexed():\n    return 1\n' > "$tmp/src/app.py"
  cat > "$tmp/.mcp.json" <<'JSON'
{
  "mcpServers": {
    "codegraph": {
      "command": "./scripts/codegraph-mcp",
      "args": ["serve", "--mcp", "--no-watch"]
    }
  }
}
JSON
  cat > "$tmp/scripts/codegraph-mcp" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
mode="${ADG_FAKE_CODEGRAPH_STATUS_MODE:-json-positive}"
if [[ "${1:-}" == "status" && "${2:-}" == "--json" ]]; then
  case "$mode" in
    json-positive) printf '{"initialized":true,"fileCount":3,"nodeCount":7,"edgeCount":2,"backend":"wasm"}\n' ;;
    json-zero) printf '{"initialized":true,"fileCount":0,"nodeCount":0,"edgeCount":0,"backend":"wasm"}\n' ;;
    *) exit 2 ;;
  esac
  exit 0
fi
if [[ "${1:-}" == "status" ]]; then
  case "$mode" in
    cli-text) printf 'Index Statistics:\n  Files:     3\n  Nodes:     7\n  Edges:     2\n  Backend:   wasm\n' ;;
    mcp-text) printf '**Files indexed:** 3\n**Total nodes:** 7\n**Total edges:** 2\n**Backend:** wasm\n' ;;
    json-zero) printf '**Files indexed:** 0\n**Total nodes:** 0\n' ;;
    *) printf 'Files: 3\nNodes: 7\n' ;;
  esac
  exit 0
fi
exit 1
SH
  chmod +x "$tmp/scripts/codegraph-mcp"
  sleep 1
  touch "$tmp/.codegraph"

  if ADG_CODEGRAPH_SKIP_LIVE_STATUS=0 ADG_FAKE_CODEGRAPH_STATUS_MODE="$mode" \
    bash scripts/validate_codegraph_wiring.sh --root "$tmp" >"$output" 2>&1; then
    if [[ "$should_pass" != "pass" ]]; then
      echo "[FAIL] live status variant $mode unexpectedly passed" >&2
      cat "$output" >&2
      exit 1
    fi
  else
    if [[ "$should_pass" == "pass" ]]; then
      echo "[FAIL] live status variant $mode unexpectedly failed" >&2
      cat "$output" >&2
      exit 1
    fi
  fi
  grep -F "$expected" "$output" >/dev/null
  rm -rf "$tmp" "$output"
}

check_live_status_variant "json-positive" "CodeGraph live status reports indexed files (3)"
check_live_status_variant "cli-text" "CodeGraph live status reports indexed files (3)"
check_live_status_variant "mcp-text" "CodeGraph live status reports indexed files (3)"
check_live_status_variant "json-zero" "CodeGraph live status reports zero indexed files" "fail"

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
