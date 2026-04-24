#!/usr/bin/env bash
# SCN-1.6 — fail-closed wrapper around graphify CLI.
#
# Reads governance.yaml, enforces:
#   - full mode requires a matching exception in docs/governance/exceptions.yaml
#   - allowlist entries must not match the secret-pattern denylist
#   - code-only mode disables LLM extractors (or pre-filters to code extensions)
# Emits .graphifyignore before invoking graphify.
#
# Release-evidence fields (graphify.securityMode, graphify.allowlistHash) are
# printed to stdout for capture by the release pipeline.

set -euo pipefail

die() { echo "[run_graphify] FAIL: $*" >&2; exit 1; }
info() { echo "[run_graphify] $*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve the consumer repo root. For submodule consumers the script lives at
# .governance/ai-dev-governance/scripts/run_graphify.sh; git-toplevel gives the
# product repo. Fall back to the script-relative parent for non-git checkouts.
ROOT_DIR="${GOVERNANCE_ROOT:-$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || cd "${SCRIPT_DIR}/.." && pwd)}"
MANIFEST="${GOVERNANCE_MANIFEST:-${ROOT_DIR}/governance.yaml}"
EXCEPTIONS="${GOVERNANCE_EXCEPTIONS:-${ROOT_DIR}/docs/governance/exceptions.yaml}"

[[ -f "$MANIFEST" ]] || die "manifest not found: $MANIFEST"

# ADG-BOOTSTRAP-05 — Python compatibility preflight. Graphify's dep stack is
# tested against 3.10–3.13; 3.14 breaks the heavy path (numba / llvmlite).
# Soft guard: override with GRAPHIFY_ALLOW_UNTESTED_PYTHON=1 when intentionally
# experimenting. See runbooks/COMPATIBILITY_MATRIX.md > Python Runtime.
PYTHON_BIN="${GRAPHIFY_PYTHON:-python3}"
if command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PY_VER="$("$PYTHON_BIN" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")' 2>/dev/null || true)"
  if [[ -n "$PY_VER" && "${GRAPHIFY_ALLOW_UNTESTED_PYTHON:-0}" != "1" ]]; then
    case "$PY_VER" in
      3.10|3.11|3.12|3.13) : ;;
      *)
        die "graphify tested on Python 3.10–3.13, got ${PY_VER}. Use a dedicated 3.12 venv (e.g. .graphify-venv) or set GRAPHIFY_ALLOW_UNTESTED_PYTHON=1 to bypass. See runbooks/COMPATIBILITY_MATRIX.md > Python Runtime."
        ;;
    esac
  fi
fi

# Naive YAML extractor for the graphify block. Keeps the wrapper
# dependency-free (no python/yq requirement at runtime).
extract_scalar() {
  local key="$1"
  awk -v k="$key" '
    /^graphify:/ { in_g=1; next }
    in_g && /^[^[:space:]]/ { in_g=0 }
    in_g && $1 == k":" { sub(/^[[:space:]]*[^:]+:[[:space:]]*/,""); print; exit }
  ' "$MANIFEST"
}

extract_allowlist() {
  awk '
    /^graphify:/ { in_g=1; next }
    in_g && /^[^[:space:]]/ { in_g=0 }
    in_g && /^[[:space:]]+allowlist:/ { in_a=1; next }
    in_a && /^[[:space:]]+-[[:space:]]*/ {
      sub(/^[[:space:]]+-[[:space:]]*/,"")
      gsub(/"/,"")
      print
      next
    }
    in_a && /^[[:space:]]+[a-zA-Z]/ { in_a=0 }
  ' "$MANIFEST"
}

MODE="$(extract_scalar securityMode)"
STRATEGY="$(extract_scalar collectionStrategy)"
SOURCE_REPO_TAG="$(extract_scalar sourceRepoTag)"
[[ -n "$MODE" ]] || die "graphify.securityMode not set in $MANIFEST"
[[ -n "$STRATEGY" ]] || die "graphify.collectionStrategy not set in $MANIFEST"

# Secret-pattern denylist. Conservative; extensible via release-evidence note.
DENYLIST=(
  "secrets/**"
  "**/secrets/**"
  ".env"
  "**/.env"
  ".env.*"
  "**/*.pem"
  "**/*.key"
  "**/id_rsa*"
  "**/credentials*"
  "**/*.kdbx"
)

mapfile -t ALLOWLIST < <(extract_allowlist)
[[ ${#ALLOWLIST[@]} -gt 0 ]] || die "graphify.allowlist empty"

# ADG-BOOTSTRAP-06 — reject brace-glob syntax. The underlying matcher is
# fnmatch-style (`*`, `**`, `?`) and does not expand `{a,b}` alternations;
# leaving them in place silently under-matches. Fail loudly so consumers
# expand to explicit per-extension entries instead.
for entry in "${ALLOWLIST[@]}"; do
  case "$entry" in
    *"{"*"}"*)
      die "allowlist entry contains unsupported brace glob: '${entry}'. Expand to explicit entries (e.g. '**/*.c' and '**/*.h' instead of '**/*.{c,h}'). See contracts/governance-manifest.example.yaml > graphify.allowlist for supported grammar."
      ;;
  esac
done

# Fail-closed: full mode requires an exception entry matching graphify.full.
if [[ "$MODE" == "full" ]]; then
  if ! grep -qE '^\s*-\s+(id:|name:).*graphify[._-]full' "$EXCEPTIONS" 2>/dev/null; then
    die "securityMode=full requires a 'graphify-full' exception in $EXCEPTIONS (fail-closed)"
  fi
  info "full mode authorised by exception"
fi

# Fail-closed: allowlist entries that overlap denylist patterns.
overlap=0
for entry in "${ALLOWLIST[@]}"; do
  for deny in "${DENYLIST[@]}"; do
    # Any literal overlap (substring match) on the high-value deny tokens
    # is enough to block; the denylist tokens are themselves highly
    # restrictive so substring matching gives a conservative check.
    case "$entry" in
      *secrets* | *.env* | *.pem* | *.key* | *id_rsa* | *credentials* | *.kdbx* )
        echo "[run_graphify] DENY: allowlist entry '$entry' overlaps denylist pattern '$deny'" >&2
        overlap=1
        break
        ;;
    esac
  done
done
(( overlap == 0 )) || die "allowlist contains denylisted patterns — fail-closed"

# Generate .graphifyignore — the union of the denylist plus a stable header.
GRAPHIFYIGNORE="${ROOT_DIR}/.graphifyignore"
{
  echo "# generated by scripts/run_graphify.sh for securityMode=${MODE}"
  echo "# DO NOT edit by hand; managed under SCN-1.6."
  for deny in "${DENYLIST[@]}"; do echo "$deny"; done
} > "$GRAPHIFYIGNORE"
info "wrote $GRAPHIFYIGNORE"

# allowlistHash — SHA-256 of the sorted, newline-joined allowlist.
ALLOWLIST_HASH="$(printf '%s\n' "${ALLOWLIST[@]}" | LC_ALL=C sort -u | shasum -a 256 | awk '{print $1}')"

# Flags by mode.
GRAPHIFY_FLAGS=()
case "$MODE" in
  full)
    GRAPHIFY_FLAGS+=(--no-restrict)
    ;;
  restricted)
    GRAPHIFY_FLAGS+=(--restrict)
    ;;
  code-only)
    GRAPHIFY_FLAGS+=(--restrict --no-llm)
    ;;
  *)
    die "unknown securityMode: $MODE"
    ;;
esac

[[ -n "$SOURCE_REPO_TAG" ]] && GRAPHIFY_FLAGS+=(--source-repo "$SOURCE_REPO_TAG")

# Release-evidence echo (captured by the release pipeline or evidence bundler).
cat <<EOF
graphify.securityMode: $MODE
graphify.collectionStrategy: $STRATEGY
graphify.allowlistHash: $ALLOWLIST_HASH
graphify.sourceRepoTag: ${SOURCE_REPO_TAG:-<unset>}
EOF

# If the user supplied extra flags, append them. Upstream graphify invocation:
GRAPHIFY_BIN="${GRAPHIFY:-graphify}"
if ! command -v "$GRAPHIFY_BIN" >/dev/null 2>&1; then
  cat >&2 <<MSG
[run_graphify] FAIL: '${GRAPHIFY_BIN}' not found on PATH.
Install from source at the path that matches your consumer layout:
  monorepo / authoring:   pip install -e ./graphify
  submodule consumer:     pip install -e ./.governance/ai-dev-governance/graphify
Optional heavy extras (Leiden / clustering): append '[cluster]' to the path.
See runbooks/RELEASE_PROCESS.md > Graphify Install Paths.
MSG
  exit 1
fi
exec "$GRAPHIFY_BIN" "${GRAPHIFY_FLAGS[@]}" "$@"
