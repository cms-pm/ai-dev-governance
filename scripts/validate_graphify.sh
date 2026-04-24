#!/usr/bin/env bash
# SCN-1.6 — read-side validator for graphify output against governance.yaml.
#
# Checks that:
#   - graphify-out/graph.json exists and is well-formed JSON
#   - pinnedNodes entries from governance.yaml resolve against graph.json
#   - crossRepoAuthority namespace patterns resolve against graph.json
#   - inferredEdgeThreshold / annotateApprovalStatus modes are reported
#
# Resolves the consumer repo root via git-toplevel so submodule consumers
# invoking the script from .governance/ai-dev-governance/scripts/ validate
# artifacts at the product repo root, not the governance submodule root.

set -euo pipefail

die() { echo "[validate_graphify] FAIL: $*" >&2; exit 1; }
pass() { echo "[PASS] $*"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="${GOVERNANCE_ROOT:-$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || cd "${SCRIPT_DIR}/.." && pwd)}"
MANIFEST="${GOVERNANCE_MANIFEST:-${ROOT_DIR}/governance.yaml}"
GRAPH_JSON="${GRAPHIFY_GRAPH:-${ROOT_DIR}/graphify-out/graph.json}"

[[ -f "$MANIFEST" ]] || die "manifest not found: $MANIFEST"
[[ -f "$GRAPH_JSON" ]] || die "graph.json not found: $GRAPH_JSON (run scripts/run_graphify.sh first)"

python3 - "$MANIFEST" "$GRAPH_JSON" <<'PY'
import json, sys, re, fnmatch
from pathlib import Path

manifest_path, graph_path = sys.argv[1], sys.argv[2]

try:
    import yaml
except ImportError:
    sys.stderr.write("[validate_graphify] FAIL: PyYAML not available\n")
    sys.exit(2)

with open(manifest_path) as f:
    manifest = yaml.safe_load(f) or {}
graphify_cfg = manifest.get("graphify", {}) or {}

with open(graph_path) as f:
    graph = json.load(f)
node_ids = {n.get("id") for n in graph.get("nodes", []) if n.get("id")}
print(f"[PASS] graphify query mode detected: {graph_path}")

pinned = graphify_cfg.get("pinnedNodes", []) or []
missing = [p for p in pinned if p not in node_ids]
if missing:
    sys.stderr.write(f"[validate_graphify] FAIL: pinnedNodes missing from graph: {missing}\n")
    sys.exit(1)
print("[PASS] pinnedNodes entries resolve against current graph")

patterns = graphify_cfg.get("crossRepoAuthority", []) or []
for pat in patterns:
    if not any(fnmatch.fnmatch(nid, pat) for nid in node_ids):
        sys.stderr.write(f"[validate_graphify] FAIL: crossRepoAuthority pattern matches nothing: {pat}\n")
        sys.exit(1)
print("[PASS] crossRepoAuthority namespace patterns resolve against current graph")

thr = graphify_cfg.get("inferredEdgeThreshold")
print(f"[PASS] inferredEdgeThreshold {'disabled' if not thr else f'= {thr}'}")
aas = graphify_cfg.get("annotateApprovalStatus")
print(f"[PASS] annotateApprovalStatus {'disabled' if not aas else 'enabled'}")
PY
