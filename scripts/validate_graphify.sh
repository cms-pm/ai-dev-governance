#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${GOVERNANCE_MANIFEST:-${ROOT_DIR}/governance.yaml}"
GRAPH_PATH="${GRAPHIFY_GRAPH_PATH:-${ROOT_DIR}/graphify-out/graph.json}"
REPORT_PATH="${GRAPHIFY_REPORT_PATH:-${ROOT_DIR}/graphify-out/GRAPH_REPORT.md}"
CONTEXT_JSON="$(
  python3 "${ROOT_DIR}/scripts/export_governance_context.py" \
    --root "${ROOT_DIR}" \
    --manifest "${MANIFEST}"
)"

warn() { echo "[WARN] $*"; }
pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*" >&2; exit 1; }

[[ -f "$MANIFEST" ]] || fail "manifest not found: $MANIFEST"
[[ -f "$GRAPH_PATH" || -f "$REPORT_PATH" ]] || fail "graphify artifacts not found: expected $GRAPH_PATH or $REPORT_PATH"

if [[ -f "$GRAPH_PATH" ]]; then
  pass "graphify query mode detected: $GRAPH_PATH"
else
  pass "graphify report-only mode detected: $REPORT_PATH"
fi

GOVERNANCE_CONTEXT_JSON="$CONTEXT_JSON" python3 - "$ROOT_DIR" "$MANIFEST" "$GRAPH_PATH" "$REPORT_PATH" <<'PY'
import json
import os
import re
import sys
import time
from pathlib import Path


def warn(message: str) -> None:
    print(f"[WARN] {message}")


def passed(message: str) -> None:
    print(f"[PASS] {message}")


def fail(message: str) -> None:
    print(f"[FAIL] {message}", file=sys.stderr)
    raise SystemExit(1)


root = Path(sys.argv[1])
manifest_path = Path(sys.argv[2])
graph_path = Path(sys.argv[3])
report_path = Path(sys.argv[4])
context = json.loads(os.environ["GOVERNANCE_CONTEXT_JSON"])
config = context.get("graphify", {})

graph_data: dict = {}
nodes: set[str] = set()
namespaces: list[str] = []

if graph_path.is_file():
    try:
        graph_data = json.loads(graph_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"graph.json could not be parsed: {exc}")
    nodes = {
        str(node.get("id"))
        for node in graph_data.get("nodes", [])
        if isinstance(node, dict) and node.get("id")
    }
    for node in graph_data.get("nodes", []):
        if not isinstance(node, dict):
            continue
        source_file = str(node.get("source_file") or "")
        if source_file:
            namespaces.append(source_file)

    missing_pins = [str(node_id) for node_id in config.get("pinnedNodes") or [] if str(node_id) not in nodes]
    if missing_pins:
        for missing in missing_pins:
            warn(f"pinnedNodes entry absent from current graph: {missing}")
    else:
        passed("pinnedNodes entries resolve against current graph")

    missing_patterns = []
    for entry in config.get("crossRepoAuthority") or []:
        repo = str(entry.get("repo") or "")
        if repo == "*":
            continue
        for pattern in entry.get("namespaces") or []:
            regex = "^" + re.escape(str(pattern)).replace(r"\*", ".*") + "$"
            if not any(re.match(regex, namespace) for namespace in namespaces):
                missing_patterns.append(f"{repo}:{pattern}")
    if missing_patterns:
        for missing in missing_patterns:
            warn(f"crossRepoAuthority pattern matched zero graph namespaces: {missing}")
    else:
        passed("crossRepoAuthority namespace patterns resolve against current graph")
else:
    passed(f"report-only routing artifact present: {report_path}")
    if config.get("pinnedNodes"):
        warn("pinnedNodes configured but graph.json is absent; graph-dependent validation skipped in report-only mode")
    else:
        passed("no pinnedNodes configured for report-only mode")
    if config.get("crossRepoAuthority"):
        warn("crossRepoAuthority configured but graph.json is absent; namespace validation skipped in report-only mode")
    else:
        passed("no crossRepoAuthority namespace rules configured for report-only mode")

inferred_threshold = config.get("inferredEdgeThreshold")
if inferred_threshold is not None:
    value = float(inferred_threshold)
    if value < 0.80:
        warn(f"inferredEdgeThreshold below recommended safety floor: {value:.2f}")
    else:
        passed(f"inferredEdgeThreshold within warning floor: {value:.2f}")
else:
    passed("inferredEdgeThreshold disabled")

if config.get("annotateApprovalStatus"):
    registry = context.get("contractRegistryPath")
    if not registry:
        warn("annotateApprovalStatus enabled but no contract registry resolved from manifest conventions")
    else:
        age_days = (time.time() - os.path.getmtime(registry)) / 86400
        if age_days > 30:
            warn(f"contract registry older than 30 days: {age_days:.1f} days ({registry})")
        else:
            passed(f"contract registry freshness within 30-day window: {age_days:.1f} days ({registry})")
else:
    passed("annotateApprovalStatus disabled")
PY
