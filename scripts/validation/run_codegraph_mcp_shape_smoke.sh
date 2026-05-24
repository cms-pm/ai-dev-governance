#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

log() {
  echo "[codegraph-mcp-shape] $1"
}

WRAPPER="$ROOT_DIR/templates/codegraph/scripts/codegraph-mcp"
FRAGMENT="$ROOT_DIR/templates/codegraph/.mcp.json.fragment"
CLIENT="$ROOT_DIR/scripts/validation/codegraph_mcp_jsonrpc_client.py"
CORPUS_SOURCE="$ROOT_DIR/raw/codegraph"
DIGEST_FILE="$ROOT_DIR/.codegraph/image.digest"
EVIDENCE_DIR="$ROOT_DIR/docs/validation/scn-10.11"
EVIDENCE_JSON="$EVIDENCE_DIR/mcp-direct-shape.json"
EVIDENCE_MD="$EVIDENCE_DIR/mcp-direct-shape.md"
INDEX_LOG="$EVIDENCE_DIR/mcp-direct-shape-index.log"

[[ -x "$WRAPPER" ]] || fail "CodeGraph Docker wrapper is not executable: $WRAPPER"
[[ -f "$FRAGMENT" ]] || fail "CodeGraph MCP fragment is missing: $FRAGMENT"
[[ -x "$CLIENT" ]] || fail "MCP JSON-RPC client is not executable: $CLIENT"
[[ -d "$CORPUS_SOURCE" ]] || fail "larger corpus missing: $CORPUS_SOURCE"
[[ -f "$DIGEST_FILE" ]] || fail "image digest missing: $DIGEST_FILE"
command -v docker >/dev/null 2>&1 || fail "strict Docker smoke requires docker on PATH"

tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/adg-codegraph-mcp-shape.XXXXXX")"
corpus="$tmp_root/corpus"
volume="adg_codegraph_mcp_shape_$(date +%Y%m%d%H%M%S)_$$"

cleanup() {
  if [[ "${ADG_CODEGRAPH_MCP_SHAPE_KEEP:-0}" != "1" ]]; then
    rm -rf "$tmp_root"
    docker volume rm "$volume" >/dev/null 2>&1 || true
  else
    log "keeping temp corpus: $tmp_root"
    log "keeping Docker volume: $volume"
  fi
}
trap cleanup EXIT

mkdir -p "$EVIDENCE_DIR"
cp -R "$CORPUS_SOURCE" "$corpus"
mkdir -p "$corpus/.codegraph"
cp "$DIGEST_FILE" "$corpus/.codegraph/image.digest"
mkdir -p "$corpus/adg/templates/codegraph/scripts"
cp "$WRAPPER" "$corpus/adg/templates/codegraph/scripts/codegraph-mcp"
chmod +x "$corpus/adg/templates/codegraph/scripts/codegraph-mcp"

export ADG_CONTAINER_RUNTIME=docker
export ADG_CODEGRAPH_SOURCE="$corpus"
export ADG_CODEGRAPH_DIGEST="$DIGEST_FILE"
export ADG_CODEGRAPH_VOLUME="$volume"

digest="$(tr -d '[:space:]' < "$DIGEST_FILE")"
[[ "$digest" == sha256:* || "$digest" == *@sha256:* ]] || fail "invalid image digest shape: $digest"
case "$digest" in
  *@sha256:*) image_ref="$digest" ;;
  sha256:*)
    if docker image inspect "$digest" >/dev/null 2>&1; then
      image_ref="$digest"
    else
      image_ref="${ADG_CODEGRAPH_IMAGE:-localhost/codegraph-mcp}@$digest"
    fi
    ;;
esac

docker volume create "$volume" >/dev/null
# Fresh Docker named volumes are root-owned. Prepare the empty cache volume
# once, then run all CodeGraph commands through the non-root hardened wrapper.
docker run --rm \
  --network=none \
  --entrypoint sh \
  --user 0:0 \
  --mount "type=volume,src=$volume,dst=/workspace/.codegraph" \
  "$image_ref" \
  -c "chown -R $(id -u):$(id -g) /workspace/.codegraph"

log "corpus: raw/codegraph copied to $corpus"
log "runtime: docker only, digest pinned by $DIGEST_FILE"
log "indexing corpus through hardened wrapper"
if ! "$WRAPPER" init --index >"$INDEX_LOG" 2>&1; then
  tail -n 80 "$INDEX_LOG" >&2 || true
  fail "CodeGraph Docker init/index failed; see $INDEX_LOG"
fi
log "clearing any stale index lock before MCP serve"
"$WRAPPER" unlock /workspace

log "calling MCP server directly over JSON-RPC stdio"
"$CLIENT" \
  --project-root "$corpus" \
  --tool-project-path /workspace \
  --mcp-fragment "$FRAGMENT" \
  --server-cwd "$corpus" \
  --evidence-json "$EVIDENCE_JSON" \
  --

generated_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
tool_calls="$(
  python3 - "$EVIDENCE_JSON" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text())
print(", ".join(data["summary"]["toolCalls"]))
PY
)"

cat > "$EVIDENCE_MD" <<EOF
# SCN-10.11 CodeGraph MCP Direct Shape Smoke

- Generated: $generated_at
- Corpus: \`raw/codegraph\` copied to an isolated temp tree
- Runtime: strict Docker only through \`templates/codegraph/scripts/codegraph-mcp\`
- MCP server command source: \`templates/codegraph/.mcp.json.fragment\`
- Image digest: \`$digest\`
- Evidence JSON: \`docs/validation/scn-10.11/mcp-direct-shape.json\`
- Index log: \`docs/validation/scn-10.11/mcp-direct-shape-index.log\`

## Result

PASS. The smoke initialized a digest-pinned Docker CodeGraph index for the
larger CodeGraph corpus, loaded the published MCP fragment command/env, started
\`serve --mcp --no-watch\`, and exercised the MCP JSON-RPC stdio surface
directly without npm, local node, SDK, or host fallback.

## Representative Native-Tool Churn Covered

- Index health: \`codegraph_status\` instead of manual \`.codegraph\` inspection.
- Project layout: \`codegraph_files\` instead of recursive \`find\` / \`ls\` tree walking.
- Function/type definition lookup: \`codegraph_search\` + \`codegraph_node\` instead of \`rg\` plus targeted reads.
- Compact task context: \`codegraph_context\` instead of recursive grep plus multi-file reads.
- Refactor blast radius: \`codegraph_callers\`, \`codegraph_callees\`, and \`codegraph_impact\` instead of manual caller/callee reconstruction.
- Seam/refactor survey: \`codegraph_explore\` instead of broad related-file read loops.

## Tool Calls

\`$tool_calls\`

## ADG Compliance Yardstick

The call matrix tracks the Code Intelligence Governance and provider skill
guidance that CodeGraph-declared consumers should query CG before token-heavy
native spidering for seams, refactors, function definitions, impact analysis,
and compact task context. This test is intentionally opt-in because it requires
a local Docker runtime and the pinned image digest.
EOF

log "wrote $EVIDENCE_MD"
