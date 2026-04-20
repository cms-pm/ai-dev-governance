#!/usr/bin/env bash
# Bootstrap a consumer project with ai-dev-governance, Astaire, and RTK.
# Pure bash, idempotent.
#
# Usage:
#   bootstrap_project.sh --new <dir> --governance-url <url> [--with-board]
#   bootstrap_project.sh --retrofit [--force] [--with-board]
#   bootstrap_project.sh --verify
#
# Environment:
#   GOVERNANCE_MOUNT   submodule mount path (default: .governance/ai-dev-governance)
#   GOVERNANCE_URL     can substitute for --governance-url
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOVERNANCE_REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ── Defaults ─────────────────────────────────────────────────────────────────
MODE=""
TARGET_DIR=""
GOVERNANCE_URL="${GOVERNANCE_URL:-}"
GOVERNANCE_MOUNT="${GOVERNANCE_MOUNT:-.governance/ai-dev-governance}"
WITH_BOARD=false
FORCE=false

fail()  { echo "[FAIL] $1" >&2; exit 1; }
info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
check() { echo "[CHECK] $1"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --new)        MODE="new"; TARGET_DIR="${2:?'--new requires <dir>'}"; shift 2 ;;
    --retrofit)   MODE="retrofit"; shift ;;
    --verify)     MODE="verify"; shift ;;
    --governance-url) GOVERNANCE_URL="${2:?'--governance-url requires <url>'}"; shift 2 ;;
    --with-board) WITH_BOARD=true; shift ;;
    --force)      FORCE=true; shift ;;
    *) fail "Unknown argument: $1" ;;
  esac
done

[[ -n "$MODE" ]] || fail "Must specify --new <dir>, --retrofit, or --verify"

# ── Helpers ───────────────────────────────────────────────────────────────────

# Ensure a directory exists; create if --new or --force mode, otherwise report.
ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
      mkdir -p "$dir"
      info "Created: $dir"
    else
      check "Would create: $dir"
      DRIFT_FOUND=true
    fi
  fi
}

# Write a file only if it does not exist (never overwrites in any mode).
write_if_missing() {
  local path="$1"
  local content="$2"
  if [[ ! -f "$path" ]]; then
    if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
      printf '%s\n' "$content" > "$path"
      info "Created: $path"
    else
      check "Would create: $path"
      DRIFT_FOUND=true
    fi
  fi
}

# Ensure a line is present in a file. Appends if missing.
ensure_line() {
  local file="$1"
  local line="$2"
  if [[ -f "$file" ]]; then
    grep -qF "$line" "$file" && return 0
  fi
  if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
    echo "$line" >> "$file"
    info "Appended to $file: $line"
  else
    check "Would append to $file: $line"
    DRIFT_FOUND=true
  fi
}

# Read pins from COMPATIBILITY_MATRIX.md inside the governance submodule.
read_pins() {
  local matrix="${CONSUMER_ROOT}/${GOVERNANCE_MOUNT}/runbooks/COMPATIBILITY_MATRIX.md"
  EXPECTED_ASTAIRE_SHA=""
  if [[ -f "$matrix" ]]; then
    EXPECTED_ASTAIRE_SHA="$(sed -n 's/.*astaire` @ `\([a-f0-9]*\).*/\1/p' "$matrix" | head -1 || true)"
  fi
}

# Update (or insert) the managed bootstrap block in AGENTS.md / CLAUDE.md.
update_bootstrap_block() {
  local target_file="$1"
  local snippet_file="${GOVERNANCE_REPO_ROOT}/templates/AGENTS_BOOTSTRAP_TEMPLATE.md"

  # Extract just the content between the markers from the template
  local block
  block="$(awk '/<!-- ai-dev-governance:bootstrap:start -->/{found=1} found{print} /<!-- ai-dev-governance:bootstrap:end -->/{found=0}' "$snippet_file")"

  if [[ ! -f "$target_file" ]]; then
    if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
      printf '%s\n' "# Agent Instructions" "" "$block" > "$target_file"
      info "Created $target_file with bootstrap block"
    else
      check "Would create: $target_file"
      DRIFT_FOUND=true
    fi
    return
  fi

  if grep -q "ai-dev-governance:bootstrap:start" "$target_file"; then
    # Block already present — replace between markers
    if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
      local tmp
      tmp="$(mktemp)"
      awk -v replacement="$block" '
        /<!-- ai-dev-governance:bootstrap:start -->/{
          print replacement; skip=1; next
        }
        /<!-- ai-dev-governance:bootstrap:end -->/{skip=0; next}
        !skip{print}
      ' "$target_file" > "$tmp"
      mv "$tmp" "$target_file"
      info "Updated bootstrap block in $target_file"
    else
      check "Would update bootstrap block in: $target_file"
      DRIFT_FOUND=true
    fi
  else
    # Append block
    if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
      printf '\n%s\n' "$block" >> "$target_file"
      info "Appended bootstrap block to $target_file"
    else
      check "Would append bootstrap block to: $target_file"
      DRIFT_FOUND=true
    fi
  fi
}

# Write the Astaire repo-local wrapper.
write_astaire_wrapper() {
  local wrapper="${CONSUMER_ROOT}/.astaire/astaire"
  if [[ -f "$wrapper" ]]; then
    return 0
  fi
  if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
    cat > "$wrapper" << 'WRAPPER'
#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel)"
GOVERNANCE_MOUNT="${GOVERNANCE_MOUNT:-.governance/ai-dev-governance}"
UV_CACHE_DIR_DEFAULT="${REPO_ROOT}/.astaire/.uv-cache"
if ! command -v uv >/dev/null 2>&1; then
  echo "[astaire-wrapper] FAIL: 'uv' is required but was not found on PATH." >&2
  exit 127
fi
mkdir -p "${UV_CACHE_DIR_DEFAULT}"
export UV_CACHE_DIR="${UV_CACHE_DIR:-${UV_CACHE_DIR_DEFAULT}}"
export PYTHONPATH="${REPO_ROOT}/${GOVERNANCE_MOUNT}/astaire:${PYTHONPATH:-}"
cd "${REPO_ROOT}/${GOVERNANCE_MOUNT}/astaire"
exec uv run --no-project --with tiktoken python -m src.cli \
  --db "${REPO_ROOT}/.astaire/memory_palace.db" "$@"
WRAPPER
    chmod +x "$wrapper"
    info "Created .astaire/astaire wrapper"
  else
    check "Would create: .astaire/astaire"
    DRIFT_FOUND=true
  fi
}

write_governance_yaml() {
  local path="${CONSUMER_ROOT}/governance.yaml"
  [[ -f "$path" ]] && return 0
  local gov_version=""
  if [[ -f "${CONSUMER_ROOT}/${GOVERNANCE_MOUNT}/VERSION" ]]; then
    gov_version="v$(cat "${CONSUMER_ROOT}/${GOVERNANCE_MOUNT}/VERSION" | tr -d '[:space:]')"
  else
    gov_version="v0.6.0"
  fi
  if [[ "$MODE" == "new" ]] || [[ "$FORCE" == true ]]; then
    cat > "$path" << YAML
apiVersion: ai-dev-governance/v1
governanceVersion: ${gov_version}
profile: strict-baseline
adapters:
  - providers/claude
  - tooling/rtk
evidence:
  planningPath: docs/planning
  validationPath: docs/validation
  releasePath: docs/releases
exceptions:
  registryPath: docs/governance/exceptions.yaml
  reviewCadenceDays: 14
approval:
  accountableRole: lead-engineer
  requiredReviewers: 1
automation:
  mode: risk-tiered
  stateMachine:
    - ingest
    - plan
    - artifact-generation
    - implementation
    - validation
    - board-review
    - gate
    - release
  tiers:
    low:
      autoMerge: true
      requiredHumanApprovals: 0
      boardReviewRequired: false
    medium:
      autoMerge: false
      requiredHumanApprovals: 1
      boardReviewRequired: false
    high:
      autoMerge: false
      requiredHumanApprovals: 2
      boardReviewRequired: true
    critical:
      autoMerge: false
      requiredHumanApprovals: 2
      boardReviewRequired: true
  boardTriggerRules:
    highRequiresBoard: true
    criticalRequiresBoard: true
  humanInterventionRules:
    chairApprovalForHighCritical: true
    exceptionApprovalRequired: true
    compositionApprovalRequired: true
boardReview:
  enabled: true
  packetTemplatePath: ${GOVERNANCE_MOUNT}/templates/BOARD_REVIEW_PACKET_TEMPLATE.md
  meetingTemplatePath: ${GOVERNANCE_MOUNT}/templates/BOARD_REVIEW_MEETING_TEMPLATE.md
  opportunityTemplatePath: ${GOVERNANCE_MOUNT}/templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md
  sprintCritiqueCadenceDays: 7
  accountabilityCadenceDays: 28
  incidentReviewSlaHours: 24
  criticalFindingsBlockRelease: true
  selection:
    requiredLenses:
      - architecture
      - reliability
      - security
    minimumWeightedScore: 4.0
    minimumRoleFitScore: 4.0
    minimumEvidenceAccessibilityScore: 4.0
    refreshCadence: quarterly
    incidentTriggeredRefresh: true
  composition:
    rosterPath: docs/governance/board/board-composition.yaml
    approvalRecordPath: docs/governance/board/board-composition-approval.md
    minimumAlternatesPerSeat: 1
updateCadence: monthly
compatibility: strict
YAML
    info "Created governance.yaml"
  else
    check "Would create: governance.yaml"
    DRIFT_FOUND=true
  fi
}

write_evidence_bundle() {
  local iso_date
  iso_date="$(date -u +%Y-%m-%d)"
  local bundle_dir="${CONSUMER_ROOT}/docs/releases/bootstrap"
  local bundle_path="${bundle_dir}/${iso_date}-bundle.md"
  mkdir -p "$bundle_dir"
  cat > "$bundle_path" << BUNDLE
# Bootstrap Evidence Bundle — ${iso_date}

Generated by \`bootstrap_project.sh\` on $(date -u +"%Y-%m-%dT%H:%M:%SZ").

## Wire-up checks

| Check | Result | Timestamp |
|---|---|---|
| .astaire/astaire present | $([[ -x "${CONSUMER_ROOT}/.astaire/astaire" ]] && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| .astaire/memory_palace.db gitignored | $([[ -f "${CONSUMER_ROOT}/.gitignore" ]] && grep -qF ".astaire/memory_palace.db" "${CONSUMER_ROOT}/.gitignore" && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| governance.yaml present | $([[ -f "${CONSUMER_ROOT}/governance.yaml" ]] && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| AGENTS.md bootstrap block | $({ [[ -f "${CONSUMER_ROOT}/AGENTS.md" ]] || [[ -f "${CONSUMER_ROOT}/CLAUDE.md" ]]; } && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| docs/planning/ present | $([[ -d "${CONSUMER_ROOT}/docs/planning" ]] && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| docs/releases/ present | $([[ -d "${CONSUMER_ROOT}/docs/releases" ]] && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| docs/governance/ present | $([[ -d "${CONSUMER_ROOT}/docs/governance" ]] && echo PASS || echo FAIL) | $(date -u +"%H:%M:%SZ") |
| Astaire DB initialized | $([[ -f "${CONSUMER_ROOT}/.astaire/memory_palace.db" ]] && echo PASS || echo PENDING) | $(date -u +"%H:%M:%SZ") |
| Astaire wrapper runtime | $([[ -n "${BOOTSTRAP_ASTAIRE_STATUS:-}" ]] && echo "${BOOTSTRAP_ASTAIRE_STATUS}" || echo PENDING) | $(date -u +"%H:%M:%SZ") |

## Governance submodule

- Mount: \`${GOVERNANCE_MOUNT}\`
- Version: $(cat "${CONSUMER_ROOT}/${GOVERNANCE_MOUNT}/VERSION" 2>/dev/null | tr -d '[:space:]' || echo unknown)

## Next steps

1. Update \`governance.yaml\` with your project's actual values.
2. Run \`.astaire/astaire startup --root .\` to initialize the knowledge base.
3. Run \`scripts/validate_bootstrap.sh\` to verify completeness.
4. If using board review, re-run with \`--with-board\` or add board scaffolding manually.
BUNDLE
  info "Evidence bundle: $bundle_path"
}

# ── Mode: verify ──────────────────────────────────────────────────────────────
if [[ "$MODE" == "verify" ]]; then
  CONSUMER_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  exec "${CONSUMER_ROOT}/scripts/validate_bootstrap.sh"
fi

# ── Mode: new ─────────────────────────────────────────────────────────────────
if [[ "$MODE" == "new" ]]; then
  [[ -n "$GOVERNANCE_URL" ]] || fail "--new requires --governance-url <url> (or GOVERNANCE_URL env var)"

  info "Bootstrapping new project at: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
  CONSUMER_ROOT="$(cd "$TARGET_DIR" && pwd)"
  cd "$CONSUMER_ROOT"

  # Git init if needed
  if [[ ! -d ".git" ]]; then
    git init
    info "Initialized git repository"
  fi

  # Add governance submodule
  if [[ ! -d "$GOVERNANCE_MOUNT" ]]; then
    git submodule add "$GOVERNANCE_URL" "$GOVERNANCE_MOUNT"
    git submodule update --init --recursive
    info "Added governance submodule at $GOVERNANCE_MOUNT"
  else
    info "Governance submodule already present at $GOVERNANCE_MOUNT"
  fi

  # Read pins from matrix
  read_pins

  # Refuse to continue if tentacles are not pinned to a known SHA
  if [[ -n "$EXPECTED_ASTAIRE_SHA" ]] && [[ -d "${GOVERNANCE_MOUNT}/astaire" ]]; then
    ACTUAL_SHA="$(git -C "${GOVERNANCE_MOUNT}/astaire" rev-parse --short HEAD 2>/dev/null || true)"
    if [[ -n "$ACTUAL_SHA" ]] && \
       [[ "${ACTUAL_SHA}" != "${EXPECTED_ASTAIRE_SHA}"* ]] && \
       [[ "${EXPECTED_ASTAIRE_SHA}" != "${ACTUAL_SHA}"* ]]; then
      fail "Astaire tentacle pin mismatch: COMPATIBILITY_MATRIX expects ${EXPECTED_ASTAIRE_SHA}, got ${ACTUAL_SHA}. Pin tentacle before bootstrapping."
    fi
  fi

  # Directory structure
  ensure_dir ".astaire"
  ensure_dir "docs/planning/pool_questions"
  ensure_dir "docs/releases"
  ensure_dir "docs/governance/amendments"

  if [[ "$WITH_BOARD" == true ]]; then
    ensure_dir "docs/governance/board"
    ensure_dir "docs/governance/board/members"
  else
    warn "Board scaffolding skipped (strict-baseline). Re-run with --with-board to add board directories."
  fi

  # Astaire wrapper
  write_astaire_wrapper

  # .gitignore entries
  ensure_line ".gitignore" ".astaire/memory_palace.db"
  ensure_line ".gitignore" ".astaire/*.db-shm"
  ensure_line ".gitignore" ".astaire/*.db-wal"
  ensure_line ".gitignore" ".astaire/.uv-cache/"

  # governance.yaml
  write_governance_yaml

  # Bootstrap block — write to provider-appropriate file
  AGENT_FILE="AGENTS.md"
  if [[ -f "governance.yaml" ]] && grep -q "providers/claude" governance.yaml; then
    AGENT_FILE="CLAUDE.md"
  fi
  update_bootstrap_block "$AGENT_FILE"
  if [[ -f "governance.yaml" ]] && grep -q "providers/codex" governance.yaml && \
     grep -q "providers/claude" governance.yaml; then
    # Both providers declared — also write AGENTS.md
    update_bootstrap_block "AGENTS.md"
  fi

  # Initialize Astaire
  BOOTSTRAP_ASTAIRE_STATUS="PENDING"
  if [[ -x ".astaire/astaire" ]]; then
    info "Running .astaire/astaire startup --root ."
    if .astaire/astaire startup --root . 2>&1 | grep -v "^INFO"; then
      BOOTSTRAP_ASTAIRE_STATUS="PASS"
    else
      BOOTSTRAP_ASTAIRE_STATUS="FAIL"
      fail "Astaire bootstrap failed. Resolve wrapper/runtime issues before treating bootstrap as complete."
    fi
  fi

  # Evidence bundle
  write_evidence_bundle

  echo ""
  info "Bootstrap complete. Run 'scripts/validate_bootstrap.sh' to verify."
  info "Edit governance.yaml with your project's values before starting SCN work."
fi

# ── Mode: retrofit ────────────────────────────────────────────────────────────
if [[ "$MODE" == "retrofit" ]]; then
  CONSUMER_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || fail "Not inside a git repository")"
  cd "$CONSUMER_ROOT"
  DRIFT_FOUND=false

  if [[ "$FORCE" == false ]]; then
    info "Retrofit dry-run. Pass --force to apply changes."
    echo ""
  else
    info "Retrofit --force mode. Writing changes."
    echo ""
  fi

  read_pins

  # Check tentacle pin before writing anything under --force
  if [[ "$FORCE" == true ]] && [[ -n "$EXPECTED_ASTAIRE_SHA" ]] && \
     [[ -d "${GOVERNANCE_MOUNT}/astaire" ]]; then
    ACTUAL_SHA="$(git -C "${GOVERNANCE_MOUNT}/astaire" rev-parse --short HEAD 2>/dev/null || true)"
    if [[ -n "$ACTUAL_SHA" ]] && \
       [[ "${ACTUAL_SHA}" != "${EXPECTED_ASTAIRE_SHA}"* ]] && \
       [[ "${EXPECTED_ASTAIRE_SHA}" != "${ACTUAL_SHA}"* ]]; then
      fail "Astaire tentacle pin mismatch: COMPATIBILITY_MATRIX expects ${EXPECTED_ASTAIRE_SHA}, got ${ACTUAL_SHA}. Pin tentacle before retrofitting."
    fi
  fi

  ensure_dir ".astaire"
  ensure_dir "docs/planning/pool_questions"
  ensure_dir "docs/releases"
  ensure_dir "docs/governance/amendments"

  if [[ "$WITH_BOARD" == true ]]; then
    ensure_dir "docs/governance/board"
    ensure_dir "docs/governance/board/members"
  fi

  write_astaire_wrapper
  ensure_line ".gitignore" ".astaire/memory_palace.db"
  ensure_line ".gitignore" ".astaire/*.db-shm"
  ensure_line ".gitignore" ".astaire/*.db-wal"
  ensure_line ".gitignore" ".astaire/.uv-cache/"

  # governance.yaml: only create if missing, never overwrite
  if [[ ! -f "governance.yaml" ]]; then
    write_governance_yaml
  else
    info "governance.yaml already exists — not overwritten"
  fi

  # Bootstrap block — write to provider-appropriate file
  AGENT_FILE=""
  if [[ -f "governance.yaml" ]] && grep -q "providers/claude" governance.yaml; then
    AGENT_FILE="CLAUDE.md"
  elif [[ -f "governance.yaml" ]] && grep -q "providers/codex" governance.yaml; then
    AGENT_FILE="AGENTS.md"
  else
    for f in AGENTS.md CLAUDE.md; do
      [[ -f "$f" ]] && { AGENT_FILE="$f"; break; }
    done
    [[ -n "$AGENT_FILE" ]] || AGENT_FILE="AGENTS.md"
  fi
  update_bootstrap_block "$AGENT_FILE"
  if [[ -f "governance.yaml" ]] && grep -q "providers/codex" governance.yaml && \
     grep -q "providers/claude" governance.yaml; then
    update_bootstrap_block "AGENTS.md"
  fi

  echo ""
  if [[ "$DRIFT_FOUND" == true ]] && [[ "$FORCE" == false ]]; then
    info "Drift detected. Re-run with --force to apply."
  elif [[ "$FORCE" == true ]]; then
    BOOTSTRAP_ASTAIRE_STATUS="PENDING"
    if [[ -x ".astaire/astaire" ]]; then
      info "Running .astaire/astaire startup --root ."
      if .astaire/astaire startup --root . 2>&1 | grep -v "^INFO"; then
        BOOTSTRAP_ASTAIRE_STATUS="PASS"
      else
        BOOTSTRAP_ASTAIRE_STATUS="FAIL"
        fail "Astaire bootstrap failed. Resolve wrapper/runtime issues before treating retrofit as complete."
      fi
    fi
    write_evidence_bundle
    info "Retrofit complete. Run 'scripts/validate_bootstrap.sh' to verify."
  else
    info "No drift detected."
  fi
fi
