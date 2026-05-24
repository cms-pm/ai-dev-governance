#!/usr/bin/env bash
set -euo pipefail

# validate_codegraph_wiring.sh - verify CodeGraph is safely wired in a consumer repo.
#
# Usage:
#   scripts/validate_codegraph_wiring.sh [--root <path>]
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
warn() { echo "[WARN] $1"; }

mtime() {
  if stat -f %m "$1" >/dev/null 2>&1; then
    stat -f %m "$1"
  else
    stat -c %Y "$1"
  fi
}

max_mtime_from_stdin() {
  local file
  local max=0
  while IFS= read -r -d '' file; do
    [[ -f "$file" ]] || continue
    local current
    current="$(mtime "$file")"
    if (( current > max )); then
      max="$current"
    fi
  done
  if (( max > 0 )); then
    printf '%s\n' "$max"
  fi
}

find_runtime() {
  if [[ -n "${ADG_CONTAINER_RUNTIME:-}" ]]; then
    command -v "$ADG_CONTAINER_RUNTIME" >/dev/null 2>&1 || return 1
    printf '%s\n' "$ADG_CONTAINER_RUNTIME"
    return 0
  fi

  local runtime
  for runtime in podman docker nerdctl; do
    if command -v "$runtime" >/dev/null 2>&1; then
      printf '%s\n' "$runtime"
      return 0
    fi
  done
  return 1
}

inspect_image_matches_digest() {
  local runtime="$1"
  local digest="$2"
  shift 2

  local candidate
  for candidate in "$@"; do
    [[ -n "$candidate" ]] || continue
    if inspect_output="$("$runtime" image inspect "$candidate" 2>&1)"; then
      if [[ "$candidate" == "$digest" ]] || grep -F "$digest" <<<"$inspect_output" >/dev/null; then
        return 0
      fi
    fi
  done
  return 1
}

check_live_codegraph_status() {
  if [[ "${ADG_CODEGRAPH_SKIP_LIVE_STATUS:-0}" == "1" ]]; then
    pass "CodeGraph live status check skipped by ADG_CODEGRAPH_SKIP_LIVE_STATUS"
    return 0
  fi

  python3 - <<'PY'
import json
import os
import re
import subprocess
import sys
from pathlib import Path

config = Path(".mcp.json")
try:
    data = json.loads(config.read_text(encoding="utf-8"))
except Exception as exc:
    print(f"[FAIL] unable to parse .mcp.json for live CodeGraph status: {exc}")
    raise SystemExit(1)

server = data.get("mcpServers", {}).get("codegraph", {})
command = server.get("command")
if not isinstance(command, str) or not command:
    print("[FAIL] .mcp.json missing mcpServers.codegraph.command for live status")
    raise SystemExit(1)

env = os.environ.copy()
server_env = server.get("env", {})
if isinstance(server_env, dict):
    env.update({str(key): str(value) for key, value in server_env.items()})

def run_status(args):
    return subprocess.run(
        [command, *args],
        cwd=Path.cwd(),
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=float(os.environ.get("ADG_CODEGRAPH_STATUS_TIMEOUT", "60")),
    )

def strip_ansi(text):
    return re.sub(r"\x1b\[[0-9;]*[A-Za-z]", "", text)

def parse_text_status(text):
    clean = strip_ansi(text)
    files_match = re.search(r"(?:\*\*)?(?:Files indexed|Files):(?:\*\*)?\s*([0-9][0-9,]*)", clean, re.IGNORECASE)
    nodes_match = re.search(r"(?:\*\*)?(?:Total nodes|Nodes):(?:\*\*)?\s*([0-9][0-9,]*)", clean, re.IGNORECASE)
    if not files_match:
        return None, None
    files_value = int(files_match.group(1).replace(",", ""))
    nodes_value = int(nodes_match.group(1).replace(",", "")) if nodes_match else None
    return files_value, nodes_value

try:
    proc = run_status(["status", "--json"])
except Exception as exc:
    print(f"[FAIL] CodeGraph live status command failed to start: {exc}")
    raise SystemExit(1)

output = (proc.stdout or "") + (proc.stderr or "")
files = None
nodes = None
if proc.returncode == 0:
    try:
        status = json.loads(proc.stdout or "{}")
        if status.get("initialized") is False:
            print(proc.stdout.rstrip())
            print("[FAIL] CodeGraph live status reports project is not initialized")
            raise SystemExit(1)
        files = int(status["fileCount"])
        nodes = int(status["nodeCount"])
    except (KeyError, TypeError, ValueError, json.JSONDecodeError):
        files, nodes = parse_text_status(output)

if proc.returncode != 0 or files is None:
    try:
        fallback = run_status(["status"])
    except Exception as exc:
        print(f"[FAIL] CodeGraph live status command failed to start: {exc}")
        raise SystemExit(1)
    output = (fallback.stdout or "") + (fallback.stderr or "")
    if fallback.returncode != 0:
        print(output.rstrip())
        print(f"[FAIL] CodeGraph live status exited {fallback.returncode}")
        raise SystemExit(1)
    files, nodes = parse_text_status(output)

if files is not None:
    if files <= 0:
        print(output.rstrip())
        print("[FAIL] CodeGraph live status reports zero indexed files")
        raise SystemExit(1)
    if nodes is not None and nodes <= 0:
        print(output.rstrip())
        print("[FAIL] CodeGraph live status reports zero nodes")
        raise SystemExit(1)
    print(f"[PASS] CodeGraph live status reports indexed files ({files})")
    raise SystemExit(0)

print(output.rstrip())
print("[FAIL] CodeGraph live status output did not expose a parseable indexed file count")
raise SystemExit(1)
PY
}

codegraph_command="$(
  if [[ -f ".mcp.json" ]]; then
    python3 - <<'PY' 2>/dev/null || true
import json
from pathlib import Path

data = json.loads(Path(".mcp.json").read_text())
server = data.get("mcpServers", {}).get("codegraph", {})
command = server.get("command", "")
if isinstance(command, str):
    print(command)
PY
  fi
)"

mcp_config_text="$(
  if [[ -f ".mcp.json" ]]; then
    python3 - <<'PY' 2>/dev/null || true
import json
from pathlib import Path

raw = Path(".mcp.json").read_text()
print(raw)

try:
    data = json.loads(raw)
except json.JSONDecodeError:
    raise SystemExit(0)

values = []

def collect(value):
    if isinstance(value, str):
        values.append(value)
    elif isinstance(value, list):
        for item in value:
            collect(item)
    elif isinstance(value, dict):
        for item in value.values():
            collect(item)

collect(data.get("mcpServers", {}).get("codegraph", {}))
print(" ".join(values))
PY
  fi
)"

deny_mcp_pattern() {
  local pattern="$1"
  local message="$2"
  if [[ -n "$mcp_config_text" ]] && grep -E "$pattern" <<<"$mcp_config_text" >/dev/null; then
    fail "$message"
  else
    pass "$message not present"
  fi
}

if [[ -z "$codegraph_command" ]]; then
  fail ".mcp.json missing mcpServers.codegraph.command"
elif [[ "$codegraph_command" == *"npx"* || "$codegraph_command" != *"codegraph-mcp"* ]]; then
  fail ".mcp.json codegraph server must invoke the codegraph-mcp wrapper, not raw npx"
else
  pass ".mcp.json invokes CodeGraph through codegraph-mcp wrapper"
fi

deny_mcp_pattern '(^|[[:space:]"'\'',\[])--privileged([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --privileged"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])--network=host([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --network=host"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])--pid=host([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --pid=host"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])--ipc=host([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --ipc=host"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])--cap-add([=[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --cap-add"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])--security-opt[=[:space:]][^[:space:]"'\'',\]]*seccomp=unconfined([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use --security-opt seccomp=unconfined"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])/var/run/docker\.sock([:/[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not mount /var/run/docker.sock"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])/run/docker\.sock([:/[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not mount /run/docker.sock"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])[^[:space:]"'\'',@]+:latest([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not use :latest image refs"
deny_mcp_pattern '(^|[[:space:]"'\'',\[])npx[[:space:]]+codegraph([[:space:]"'\'',\]]|$)' \
  ".mcp.json CodeGraph wiring must not invoke raw npx codegraph"

digest_file=".codegraph/image.digest"
digest=""
if [[ -f "$digest_file" ]]; then
  digest="$(tr -d '[:space:]' < "$digest_file")"
  if [[ "$digest" =~ ^sha256:[0-9a-fA-F]{64}$ || "$digest" =~ ^[^[:space:]]+@sha256:[0-9a-fA-F]{64}$ ]]; then
    pass ".codegraph/image.digest exists and is digest-pinned"
  else
    fail ".codegraph/image.digest must contain sha256:<hex> or image@sha256:<hex>"
  fi
else
  fail ".codegraph/image.digest missing"
fi

if [[ -n "$digest" ]]; then
  runtime="$(find_runtime || true)"
  if [[ -z "$runtime" ]]; then
    fail "No supported container runtime found for CodeGraph image inspect"
  else
    if [[ "$digest" == *@sha256:* ]]; then
      digest_id="${digest##*@}"
      image_ref="$digest"
    elif [[ "$digest" == sha256:* ]]; then
      digest_id="$digest"
      image_ref="${ADG_CODEGRAPH_IMAGE:-localhost/codegraph-mcp}@$digest"
    else
      digest_id=""
      image_ref=""
    fi
    if inspect_image_matches_digest "$runtime" "$digest_id" "$image_ref" "$digest_id"; then
      pass "CodeGraph image is present and matches .codegraph/image.digest"
    else
      fail "CodeGraph image is not present for digest from .codegraph/image.digest"
    fi
  fi
fi

if [[ -f ".codegraphignore" ]]; then
  if grep -Eq '(^|/)(adg|ai-dev-governance|vendor/ai-dev-governance|submodules/ai-dev-governance)/\*\*' ".codegraphignore"; then
    pass ".codegraphignore legacy boundary includes the ADG submodule path"
  else
    fail ".codegraphignore legacy boundary must deny the ADG submodule path (for example: adg/**)"
  fi
else
  pass ".codegraphignore legacy boundary file absent; wrapper source staging enforces the default ADG boundary"
fi

if [[ -d ".codegraph" ]]; then
  if [[ "${ADG_CODEGRAPH_SKIP_LIVE_STATUS:-0}" != "1" && "$codegraph_command" == *"codegraph-mcp"* ]]; then
    pass ".codegraph/ metadata directory present; index freshness enforced by live CodeGraph status"
  else
    index_time="$(mtime ".codegraph")"
    source_time="$(
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git ls-files -z -- . \
          ':(exclude).codegraph/**' \
          ':(exclude).git/**' \
          ':(exclude)docs/**' \
          2>/dev/null \
          | max_mtime_from_stdin
      fi
    )"
    if [[ -z "$source_time" ]]; then
      source_time="$(find . \
        -path './.git' -prune -o \
        -path './.codegraph' -prune -o \
        -path './docs' -prune -o \
        -type f -print0 \
        | max_mtime_from_stdin)"
    fi
    if [[ -z "$source_time" ]]; then
      pass "No tracked source files found for CodeGraph freshness comparison"
    elif (( index_time >= source_time )); then
      pass ".codegraph/ index timestamp is current with tracked source"
    else
      fail ".codegraph/ index timestamp is older than tracked source"
    fi
  fi
else
  fail ".codegraph/ index directory missing"
fi

if [[ -f ".codegraph/evidence/sbom.spdx.json" ]]; then
  pass ".codegraph/evidence/sbom.spdx.json present"
else
  fail ".codegraph/evidence/sbom.spdx.json missing"
fi

check_live_codegraph_status

echo ""
if [[ $FAILED -ne 0 ]]; then
  echo "CodeGraph wiring validation FAILED. Fix the items above, then re-run this script."
  exit 1
fi
echo "All CodeGraph wiring checks passed."
