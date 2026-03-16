#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[[ -n "$repo_root" ]] || fail "Not inside a git repository"
cd "$repo_root"

base_ref="${SCOPE_BASE_REF:-}"
head_ref="${SCOPE_HEAD_REF:-HEAD}"
max_files="${CHUNK_SCOPE_MAX_FILES:-40}"
target_scn="${TARGET_SCN:-}"

if [[ -z "$base_ref" ]]; then
  if git rev-parse --verify -q origin/main >/dev/null; then
    base_ref="origin/main"
  elif git rev-parse --verify -q main >/dev/null; then
    base_ref="main"
  elif git rev-parse --verify -q HEAD~1 >/dev/null; then
    base_ref="HEAD~1"
  else
    fail "Unable to infer SCOPE_BASE_REF; set SCOPE_BASE_REF explicitly"
  fi
fi

git rev-parse --verify -q "$base_ref" >/dev/null || fail "Base ref not found: $base_ref"
git rev-parse --verify -q "$head_ref" >/dev/null || fail "Head ref not found: $head_ref"

range="${base_ref}...${head_ref}"

mapfile -t changed_files < <(git diff --name-only "$range")
use_working_tree=0
if (( ${#changed_files[@]} == 0 )); then
  mapfile -t changed_files < <(
    {
      git diff --name-only
      git diff --cached --name-only
      git ls-files --others --exclude-standard
    } | sed '/^$/d' | sort -u
  )
  if (( ${#changed_files[@]} == 0 )); then
    fail "No changed files in range ${range} or working tree"
  fi
  use_working_tree=1
fi

if (( ${#changed_files[@]} > max_files )); then
  fail "Changed file count ${#changed_files[@]} exceeds CHUNK_SCOPE_MAX_FILES=${max_files}"
fi

if (( use_working_tree == 1 )); then
  mapfile -t scn_from_diff < <(
    {
      git diff --unified=0
      git diff --cached --unified=0
    } | rg -o "SCN-[0-9]+\\.[0-9]+-[0-9]{2}" | sort -u || true
  )
else
  mapfile -t scn_from_diff < <(git diff --unified=0 "$range" | rg -o "SCN-[0-9]+\\.[0-9]+-[0-9]{2}" | sort -u || true)
fi
mapfile -t scn_from_paths < <(printf '%s\n' "${changed_files[@]}" | rg -o "SCN-[0-9]+\\.[0-9]+-[0-9]{2}" | sort -u || true)

combined_scn="$(printf '%s\n' "${scn_from_diff[@]}" "${scn_from_paths[@]}" | sed '/^$/d' | sort -u)"
mapfile -t discovered_scns < <(printf '%s\n' "$combined_scn" | sed '/^$/d')

branch_name="$(git rev-parse --abbrev-ref HEAD)"
scn_prefix=""

if [[ "$branch_name" =~ ^chunk-([0-9]+)\.([0-9]+)\.[0-9]+- ]]; then
  scn_prefix="SCN-${BASH_REMATCH[1]}.${BASH_REMATCH[2]}-"
elif [[ "$branch_name" =~ ^(pc|fab)/scn-([0-9]+)\.([0-9]+)- ]]; then
  scn_prefix="SCN-${BASH_REMATCH[2]}.${BASH_REMATCH[3]}-"
fi

if [[ -z "$target_scn" ]]; then
  if (( ${#discovered_scns[@]} == 1 )); then
    target_scn="${discovered_scns[0]}"
  elif (( ${#discovered_scns[@]} > 1 )); then
    fail "Multiple SCN IDs discovered in diff: ${discovered_scns[*]}"
  elif [[ -n "$scn_prefix" ]]; then
    target_scn="${scn_prefix}*"
  else
    fail "Unable to infer TARGET_SCN; set TARGET_SCN=SCN-X.Y-NN"
  fi
fi

if [[ "$target_scn" =~ \*$ ]]; then
  prefix="${target_scn%\*}"
  for id in "${discovered_scns[@]}"; do
    [[ "$id" == "$prefix"* ]] || fail "Discovered SCN ${id} is outside branch chunk prefix ${prefix}"
  done
else
  [[ "$target_scn" =~ ^SCN-[0-9]+\.[0-9]+-[0-9]{2}$ ]] || fail "Invalid TARGET_SCN format: $target_scn"
  for id in "${discovered_scns[@]}"; do
    [[ "$id" == "$target_scn" ]] || fail "Discovered SCN ${id} does not match TARGET_SCN ${target_scn}"
  done
fi

chunk_key_pattern='docs/planning/chunks/phase-([0-9]+)-chunk-([0-9]+\.[0-9]+)-'
mapfile -t changed_chunk_keys < <(
  printf '%s\n' "${changed_files[@]}" \
    | sed -nE "s#${chunk_key_pattern}.*#\\1.\\2#p" \
    | sort -u
)
if (( ${#changed_chunk_keys[@]} > 1 )); then
  fail "Multiple chunk artifact families modified: ${changed_chunk_keys[*]}"
fi

pass "Chunk scope is atomic"
echo "  - range: ${range}"
echo "  - changed_files: ${#changed_files[@]}"
echo "  - target_scn: ${target_scn}"
if (( use_working_tree == 1 )); then
  echo "  - mode: working-tree"
fi
