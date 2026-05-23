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
    case "$digest" in
      *@sha256:*) image_ref="$digest" ;;
      sha256:*) image_ref="${ADG_CODEGRAPH_IMAGE:-localhost/codegraph-mcp}@$digest" ;;
      *) image_ref="" ;;
    esac
    if [[ -n "$image_ref" ]] && inspect_output="$("$runtime" image inspect "$image_ref" 2>&1)"; then
      if grep -F "$digest" <<<"$inspect_output" >/dev/null || grep -F "$image_ref" <<<"$inspect_output" >/dev/null; then
        pass "CodeGraph image is present and matches .codegraph/image.digest"
      else
        fail "CodeGraph image inspect did not report the digest from .codegraph/image.digest"
      fi
    else
      fail "CodeGraph image is not present for digest from .codegraph/image.digest"
    fi
  fi
fi

if [[ -f ".codegraphignore" ]]; then
  if grep -Eq '(^|/)(adg|ai-dev-governance|vendor/ai-dev-governance|submodules/ai-dev-governance)/\*\*' ".codegraphignore"; then
    pass ".codegraphignore denies the ADG submodule path"
  else
    fail ".codegraphignore must deny the ADG submodule path (for example: adg/**)"
  fi
else
  fail ".codegraphignore missing"
fi

if [[ -d ".codegraph" ]]; then
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
else
  fail ".codegraph/ index directory missing"
fi

if [[ -f ".codegraph/evidence/sbom.spdx.json" ]]; then
  pass ".codegraph/evidence/sbom.spdx.json present"
else
  fail ".codegraph/evidence/sbom.spdx.json missing"
fi

echo ""
if [[ $FAILED -ne 0 ]]; then
  echo "CodeGraph wiring validation FAILED. Fix the items above, then re-run this script."
  exit 1
fi
echo "All CodeGraph wiring checks passed."
