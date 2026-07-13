#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INVOCATION_DIR="$(pwd)"
cd "$ROOT_DIR"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

command -v rg >/dev/null 2>&1 || fail "validate_governance.sh requires ripgrep ('rg') on PATH. Install: https://github.com/BurntSushi/ripgrep#installation"

required_files=(
  "README.md"
  "LICENSE"
  "VERSION"
  "CHANGELOG.md"
  "core/PLANNING_METHODOLOGY.md"
  "core/AI_ASSISTED_TDR_METHODOLOGY.md"
  "core/GIT_BRANCH_STRATEGY.md"
  "core/AUTONOMOUS_DELIVERY_GOVERNANCE.md"
  "core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md"
  "core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md"
  "core/EXCEPTIONS_AND_WAIVERS.md"
  "core/SECURITY_CONTROLS.md"
  "core/EVIDENCE_CONTRACT.md"
  "contracts/governance-manifest.schema.json"
  "contracts/governance-manifest.example.yaml"
  "contracts/board-member-profile.schema.json"
  "contracts/board-composition.schema.json"
  "contracts/board-finding.schema.json"
  "contracts/board-decision.schema.json"
  "contracts/implementation-handoff.schema.json"
  "runbooks/RELEASE_PROCESS.md"
  "runbooks/BOARD_REVIEW_OPERATIONS.md"
  "runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md"
  "runbooks/SUBMODULE_CONSUMER_RUNBOOK.md"
  "runbooks/RTK_ADOPTION_RUNBOOK.md"
  "runbooks/COMPATIBILITY_MATRIX.md"
  "adapters/tooling/RTK_CONTEXT_ADAPTER.md"
  "templates/BOARD_SELECTION_DOSSIER_TEMPLATE.md"
  "templates/BOARD_MEMBER_PROFILE_TEMPLATE.md"
  "templates/BOARD_COMPOSITION_APPROVAL_TEMPLATE.md"
  "templates/BOARD_REVIEW_PACKET_TEMPLATE.md"
  "templates/BOARD_REVIEW_MEETING_TEMPLATE.md"
  "templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md"
  "templates/AGENTS_RTK_SNIPPET_TEMPLATE.md"
  "templates/CODEGRAPH_CONTRACT_TEMPLATE.md"
  "templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md"
  "templates/RTK_INSTRUCTIONS_TEMPLATE.md"
  "templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh"
  "scripts/validate_chunk_scope.sh"
  "scripts/validate_astaire_wiring.sh"
  "scripts/validate_codegraph_wiring.sh"
  "templates/ASTAIRE_CLI_SNIPPET.md"
  "runbooks/ASTAIRE_ACCESS.md"
  "CLAUDE.md"
  "validation/CONSISTENCY_RULES.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || fail "Missing required file: $f"
done
pass "Required files present"

bash "$ROOT_DIR/scripts/validate_astaire_wiring.sh" --root "$ROOT_DIR" \
  || fail "Astaire wiring check failed (run scripts/validate_astaire_wiring.sh for details)"
pass "Astaire wiring (governance source self-check)"

version="$(tr -d '[:space:]' < VERSION)"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "VERSION is not SemVer (expected x.y.z)"
pass "VERSION format"

for s in contracts/*.schema.json; do
  python3 -m json.tool "$s" >/dev/null || fail "Invalid JSON schema: $s"
done
pass "Schema files parse as valid JSON"

rg -q "pre-merge" core/GIT_BRANCH_STRATEGY.md || fail "Git strategy must require pre-merge checks"
! rg -q "main only" core/GIT_BRANCH_STRATEGY.md || fail "Git strategy must not allow main-only CI gating"
rg -q "Hotfixes are allowed" core/GIT_BRANCH_STRATEGY.md || fail "Controlled hotfix policy missing"
rg -q "exactly one acceptance target" core/GIT_BRANCH_STRATEGY.md || fail "Atomic SCN scope policy missing"
rg -q "chunk-scope CI check MUST run pre-merge" core/GIT_BRANCH_STRATEGY.md || fail "Chunk-scope CI requirement missing"
pass "Git strategy consistency"

rg -q "chunk-scope" runbooks/BRANCH_PROTECTION_BASELINE.md || fail "Branch protection must require chunk-scope check"
rg -q "Fork-Based Contribution Model" runbooks/SUBMODULE_CONSUMER_RUNBOOK.md || fail "Submodule fork contribution guidance missing"
rg -q "tooling/rtk" runbooks/SUBMODULE_CONSUMER_RUNBOOK.md || fail "Submodule runbook must require tooling/rtk for strict Claude/Codex consumers"
pass "Branch protection and submodule runbook consistency"

rg -q "Non-functional requirements .* MUST" core/PLANNING_METHODOLOGY.md || fail "Planning non-functional requirement mapping missing"
rg -q "Performance \(timing bounds\)" core/AI_ASSISTED_TDR_METHODOLOGY.md || fail "TDR non-functional validation missing"
pass "Planning/TDR consistency"

rg -q "Cadence Model" core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md || fail "Board review cadence section missing"
rg -q "Constructive Criticism Protocol" core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md || fail "Board constructive critique section missing"
rg -q "Expert-Agent Board Selection" core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md || fail "Board expert-agent selection section missing"
rg -q "board findings" runbooks/RELEASE_PROCESS.md || fail "Release process must include board finding gate"
rg -q "rtk gain" runbooks/RELEASE_PROCESS.md || fail "Release process must require RTK evidence for strict Claude/Codex consumers"
pass "Board governance consistency"

rg -q "Automation State Machine" core/AUTONOMOUS_DELIVERY_GOVERNANCE.md || fail "Autonomous state machine section missing"
rg -q "Deterministic Stop Rules" core/AUTONOMOUS_DELIVERY_GOVERNANCE.md || fail "Autonomous stop rules missing"
rg -q "Risk-Tiered Autonomy" core/AUTONOMOUS_DELIVERY_GOVERNANCE.md || fail "Risk-tier autonomy section missing"
pass "Autonomous delivery consistency"

rg -q "Code Implementation Complexity Governance" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code implementation complexity core policy missing title"
rg -q "Change amplification" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing change-amplification rubric"
rg -q "Cognitive load" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing cognitive-load rubric"
rg -q "Unknown unknowns" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing unknown-unknown rubric"
rg -q "Component Size Limits" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing component size limits"
rg -q "Naming Rules" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing naming rules"
rg -q "Component Placement Rules" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md || fail "Code complexity policy missing placement rules"
rg -q "implementationComplexity" contracts/implementation-handoff.schema.json || fail "Implementation handoff schema missing implementationComplexity"
rg -q "Code implementation complexity governance is mandatory" adapters/profiles/STRICT_BASELINE.md || fail "Strict baseline must require code complexity governance"
pass "Code implementation complexity consistency"

required_manifest_keys=(
  "apiVersion:"
  "governanceVersion:"
  "profile:"
  "adapters:"
  "evidence:"
  "exceptions:"
  "approval:"
  "automation:"
  "boardReview:"
)
for k in "${required_manifest_keys[@]}"; do
  rg -q "^${k}" contracts/governance-manifest.example.yaml || fail "Manifest example missing key: ${k}"
done

rg -q "enabled:" contracts/governance-manifest.example.yaml || fail "Manifest boardReview.enabled missing"
rg -q "criticalFindingsBlockRelease:" contracts/governance-manifest.example.yaml || fail "Manifest boardReview.criticalFindingsBlockRelease missing"
rg -q "selection:" contracts/governance-manifest.example.yaml || fail "Manifest boardReview.selection missing"
rg -q "composition:" contracts/governance-manifest.example.yaml || fail "Manifest boardReview.composition missing"
rg -q "stateMachine:" contracts/governance-manifest.example.yaml || fail "Manifest automation.stateMachine missing"
rg -q "tiers:" contracts/governance-manifest.example.yaml || fail "Manifest automation.tiers missing"
pass "Manifest example keys"

python3 - <<'PY' || fail "Manifest schema required-key checks failed"
import json
from pathlib import Path

schema = json.loads(Path("contracts/governance-manifest.schema.json").read_text())
required = set(schema.get("required", []))
for k in ("automation", "boardReview"):
    if k not in required:
        raise SystemExit(f"missing top-level required key: {k}")

board_review_props = schema["properties"]["boardReview"]
board_required = set(board_review_props.get("required", []))
for k in ("selection", "composition"):
    if k not in board_required:
        raise SystemExit(f"missing boardReview required key: {k}")
PY
pass "Manifest schema keys"

# Real JSON Schema validation (Draft 2020-12) of the canonical manifest
# example and every top-level fixture manifest against
# contracts/governance-manifest.schema.json. Nested fixture manifests
# (validation/fixtures/codegraph/**, validation/fixtures/validators/**)
# are intentionally partial documents that exercise individual gates,
# so they are excluded by design.
#
# Preflight (same pattern as the rg check above): prefer a python3 that
# can already import jsonschema + PyYAML; otherwise fall back to a
# uv-provisioned ephemeral environment (uv is already relied on by
# scripts/bootstrap_project.sh); fail loudly if neither is available.
if python3 -c "import jsonschema, yaml" >/dev/null 2>&1; then
  schema_validation_python() { python3 "$@"; }
elif command -v uv >/dev/null 2>&1; then
  schema_validation_python() {
    uv run --quiet --no-project --with jsonschema --with pyyaml python "$@"
  }
else
  fail "validate_governance.sh requires a JSON Schema validator: install the python3 packages 'jsonschema' and 'pyyaml' (e.g. python3 -m pip install jsonschema pyyaml), or install 'uv' (https://docs.astral.sh/uv/) so an ephemeral validator environment can be provisioned"
fi

schema_validation_python - <<'PY' || fail "Manifest JSON Schema validation failed (violations listed above)"
import json
import sys
from pathlib import Path

import jsonschema
import yaml

SCHEMA_PATH = Path("contracts/governance-manifest.schema.json")


class ManifestLoader(yaml.SafeLoader):
    """SafeLoader minus implicit timestamp resolution.

    JSON Schema validates against the JSON data model, where dates are
    strings. PyYAML would otherwise load unquoted dates (e.g.
    attestationDate: 2026-05-19) as datetime.date objects and fail
    "type": "string" checks spuriously.
    """


ManifestLoader.yaml_implicit_resolvers = {
    key: [(tag, regexp) for tag, regexp in resolvers
          if tag != "tag:yaml.org,2002:timestamp"]
    for key, resolvers in yaml.SafeLoader.yaml_implicit_resolvers.items()
}

schema = json.loads(SCHEMA_PATH.read_text())
validator_cls = jsonschema.validators.validator_for(schema)
validator_cls.check_schema(schema)
validator = validator_cls(schema)

targets = [Path("contracts/governance-manifest.example.yaml")]
targets += sorted(Path("validation/fixtures").glob("*/governance.yaml"))

violations = 0
for target in targets:
    document = yaml.load(target.read_text(), Loader=ManifestLoader)
    for error in sorted(validator.iter_errors(document),
                        key=lambda e: list(e.absolute_path)):
        location = "/".join(str(p) for p in error.absolute_path) or "<root>"
        print(f"[SCHEMA-VIOLATION] {target}: {location}: {error.message}",
              file=sys.stderr)
        violations += 1

if violations:
    print(f"[SCHEMA-VIOLATION] {violations} violation(s) against "
          f"{SCHEMA_PATH} (Draft 2020-12)", file=sys.stderr)
    raise SystemExit(1)
PY
pass "Manifest JSON Schema validation (example + fixtures, Draft 2020-12)"

if rg -n "^graphify:" contracts validation governance.yaml >/tmp/adg_graphify_manifest_hits.txt; then
  cat /tmp/adg_graphify_manifest_hits.txt >&2
  fail "Graphify manifest blocks are not supported in ADG"
fi
pass "Graphify manifest blocks absent"

rg -q "rtk init -g" adapters/providers/CLAUDE_CONTEXT_ADAPTER.md || fail "Claude adapter must document RTK hook install"
rg -q "rtk init -g --codex" adapters/providers/CODEX_CONTEXT_ADAPTER.md || fail "Codex adapter must document RTK install"
rg -q "tooling/rtk" adapters/tooling/RTK_CONTEXT_ADAPTER.md || fail "RTK tooling adapter must define manifest mapping"
rg -q "rtk gain" runbooks/RTK_ADOPTION_RUNBOOK.md || fail "RTK runbook must include gain evidence workflow"
rg -q "rtk discover" runbooks/RTK_ADOPTION_RUNBOOK.md || fail "RTK runbook must include discover workflow"
rg -q "@RTK.md" templates/AGENTS_RTK_SNIPPET_TEMPLATE.md || fail "AGENTS template must reference RTK.md"
rg -q "RTK_DB_PATH" runbooks/RTK_ADOPTION_RUNBOOK.md || fail "RTK runbook must document RTK_DB_PATH portable tracking"
rg -q "RTK_LOCAL_WRAPPER_TEMPLATE.sh" runbooks/SUBMODULE_CONSUMER_RUNBOOK.md || fail "Submodule runbook must reference RTK wrapper template"
rg -q "scripts/rtk-local.sh" templates/RTK_INSTRUCTIONS_TEMPLATE.md || fail "RTK instructions template must mention repo-local wrapper"
rg -q "scripts/rtk-local.sh" templates/AGENTS_RTK_SNIPPET_TEMPLATE.md || fail "AGENTS template must mention repo-local wrapper"
pass "RTK documentation consistency"

python3 - "$version" <<'PY' || fail "Manifest RTK policy checks failed"
import json
import re
import sys
from pathlib import Path

version = f"v{sys.argv[1]}"
schema = json.loads(Path("contracts/governance-manifest.schema.json").read_text())
adapter_enum = set(schema["properties"]["adapters"]["items"]["enum"])
if "tooling/rtk" not in adapter_enum:
    raise SystemExit("schema adapter enum missing tooling/rtk")

manifest_paths = [
    Path("contracts/governance-manifest.example.yaml"),
    Path("validation/fixtures/prototype/governance.yaml"),
    Path("validation/fixtures/mvp/governance.yaml"),
    Path("validation/fixtures/production/governance.yaml"),
]

provider_ids = {"providers/claude", "providers/codex"}

def parse_manifest(path: Path) -> dict:
    data = {
        "governanceVersion": None,
        "profile": None,
        "adapters": [],
    }
    in_adapters = False
    for line in path.read_text().splitlines():
        version_match = re.match(r"^governanceVersion:\s*(\S+)", line)
        if version_match:
            data["governanceVersion"] = version_match.group(1)
        profile_match = re.match(r"^profile:\s*(\S+)", line)
        if profile_match:
            data["profile"] = profile_match.group(1)
        if line.startswith("adapters:"):
            in_adapters = True
            continue
        if re.match(r"^\S", line):
            in_adapters = False
        if in_adapters:
            item_match = re.match(r"^\s*-\s*(\S+)", line)
            if item_match:
                data["adapters"].append(item_match.group(1))
    return data

for path in manifest_paths:
    manifest = parse_manifest(path)
    if manifest["governanceVersion"] != version:
        raise SystemExit(f"{path} governanceVersion {manifest['governanceVersion']} != {version}")
    profile = manifest["profile"] or ""
    adapters = set(manifest["adapters"])
    if profile.startswith("strict-baseline") and adapters.intersection(provider_ids) and "tooling/rtk" not in adapters:
        raise SystemExit(f"{path} missing tooling/rtk for strict Claude/Codex manifest")
PY
pass "Manifest RTK policy"

for provider_adapter in adapters/providers/CLAUDE_CONTEXT_ADAPTER.md adapters/providers/CODEX_CONTEXT_ADAPTER.md; do
  [[ -f "$provider_adapter" ]] || fail "Missing provider adapter: $provider_adapter"
  rg -q "port-of-first-resort" "$provider_adapter" || fail "$provider_adapter missing port-of-first-resort clause"
  rg -q "runbooks/ASTAIRE_ACCESS.md" "$provider_adapter" || fail "$provider_adapter must reference runbooks/ASTAIRE_ACCESS.md"
  rg -q "Astaire" "$provider_adapter" || fail "$provider_adapter missing Astaire integration section"
done
rg -q "Astaire-first read discipline" core/PLANNING_METHODOLOGY.md || fail "PLANNING_METHODOLOGY must declare Astaire-first read discipline"
[[ -f runbooks/ASTAIRE_ACCESS.md ]] || fail "runbooks/ASTAIRE_ACCESS.md must exist"
[[ -f templates/ASTAIRE_CLI_SNIPPET.md ]] || fail "templates/ASTAIRE_CLI_SNIPPET.md must exist"
pass "Astaire-first provider adapter carriage"

rg -q "agents MUST check CG before token-heavy native" core/CODE_INTELLIGENCE_GOVERNANCE.md \
  || fail "Code intelligence policy must require CG before token-heavy native spidering"
rg -q "CodeGraph impact check" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md \
  || fail "Code complexity policy must require a CodeGraph impact check for refactors"
rg -q "source-code discovery MUST start with" templates/AGENTS_BOOTSTRAP_TEMPLATE.md \
  || fail "Agent bootstrap template must expose CodeGraph-first source discovery"
rg -q "strict Docker/container wrapper path" templates/CODEGRAPH_CONTRACT_TEMPLATE.md \
  || fail "CodeGraph contract template must expose strict Docker/container wrapper contract"
rg -q "Upgrade Decision" templates/CODEGRAPH_CONTRACT_TEMPLATE.md \
  || fail "CodeGraph contract template must expose pre-v1.1.0 upgrade decision"
rg -q "docs/governance/codegraph-contract.md" runbooks/SUBMODULE_CONSUMER_RUNBOOK.md \
  || fail "Submodule runbook must expose CodeGraph contract during v1.1.0+ upgrades"
rg -q "CodeGraph contract doc present" scripts/bootstrap_project.sh \
  || fail "Bootstrap evidence must report CodeGraph contract visibility"
rg -q "CodeGraph consumer contract visible" scripts/validate_bootstrap.sh \
  || fail "Bootstrap validator must check CodeGraph contract visibility"
rg -q "governanceVersion matches installed ADG" scripts/validate_bootstrap.sh \
  || fail "Bootstrap validator must detect consumer governanceVersion drift"
rg -q "ADG_CODEGRAPH_PREPARE_VOLUME" templates/codegraph/scripts/codegraph-mcp \
  || fail "CodeGraph wrapper must expose named-volume ownership preparation"
rg -q "ADG_CODEGRAPH_STAGE_SOURCE" templates/codegraph/scripts/codegraph-mcp \
  || fail "CodeGraph wrapper must expose sanitized source staging"
rg -q "ADG_CODEGRAPH_LOCK_RETRIES" templates/codegraph/scripts/codegraph-mcp \
  || fail "CodeGraph wrapper must expose lock-contention retry tuning"
if rg -q 'ai-dev-governance|raw|docs' templates/codegraph/scripts/codegraph-mcp; then
  rg -q 'ai-dev-governance|docs' templates/codegraph/scripts/codegraph-mcp \
    || fail "CodeGraph wrapper must retain ADG/docs staging exclusions"
  ! rg -q '[|]raw[|]' templates/codegraph/scripts/codegraph-mcp \
    || fail "CodeGraph wrapper must not exclude raw/ by default"
fi
rg -q "CodeGraph itself treats a file named .codegraphignore as a directory marker" templates/codegraph/.codegraphignore \
  || fail "CodeGraph ignore template must document marker semantics"
rg -q "locally loaded.*image IDs" templates/CODEGRAPH_CONTRACT_TEMPLATE.md \
  || fail "CodeGraph contract must document local SHA-256 image ID acceptance"
rg -q "CodeGraph live status reports zero indexed files" scripts/validate_codegraph_wiring.sh \
  || fail "CodeGraph validator must fail empty live indexes"
rg -q "Files indexed|Files" scripts/validate_codegraph_wiring.sh \
  || fail "CodeGraph validator must parse both MCP and CLI status file counts"
rg -q "Before refactoring production code" adapters/providers/CLAUDE_CONTEXT_ADAPTER.md \
  || fail "Claude context adapter must require CodeGraph before refactoring"
rg -q "Before refactoring production code" adapters/providers/CODEX_CONTEXT_ADAPTER.md \
  || fail "Codex context adapter must require CodeGraph before refactoring"
rg -q "source navigation before broad" adapters/providers/claude/CODEGRAPH.md \
  || fail "Claude CodeGraph adapter must require CG before broad source discovery"
rg -q "source navigation before broad" adapters/providers/codex/CODEGRAPH.md \
  || fail "Codex CodeGraph adapter must require CG before broad source discovery"
rg -q "CodeGraph-first refactor check" adapters/providers/claude/skills/hexagonal-architecture/SKILL.md \
  || fail "Hexagonal architecture skill must expose CodeGraph-first refactor check"
rg -q "mcp__codegraph__impact" adapters/providers/claude/skills/finding-seams/SKILL.md \
  || fail "Finding-seams skill must require a CodeGraph impact/call query before spidering"
rg -q "Before selecting fixtures or reading broadly" adapters/providers/claude/skills/characterisation-tests/SKILL.md \
  || fail "Characterisation skill must require CodeGraph before broad legacy reads"
rg -q "CodeGraph-declared consumer" adapters/providers/claude/skills/tdd/SKILL.md \
  || fail "TDD skill must require CodeGraph before production refactor edits"
pass "CodeGraph-first agent wiring"

rg -q "\[${version}\]" CHANGELOG.md || fail "CHANGELOG missing current version entry"
pass "CHANGELOG includes current version"

# Embedded-profile fail-closed gate — orchestration here, per-manifest
# verdict delegated to scripts/validators/governance_gates.py. The
# agency-string CI guard (formerly invoked here) was retired at
# SCN-8.3.2 per OPP-8.2-004 closure: the one-time repo-wide sweep at
# Phase 8.2 bootstrap is sufficient; ongoing per-pass enforcement is
# not required.
embedded_manifests=(
  "contracts/governance-manifest.example.yaml"
  "validation/fixtures/prototype/governance.yaml"
  "validation/fixtures/mvp/governance.yaml"
  "validation/fixtures/production/governance.yaml"
)
for m in "${embedded_manifests[@]}"; do
  python3 -m scripts.validators.governance_gates --manifest "$m" \
    || fail "Embedded-profile fail-closed gate violated for $m"
done
pass "Embedded-profile fail-closed gate"

bash validation/fixtures/analyzer-capability/run.sh \
  || fail "Analyzer-capability declaration fixtures failed"
pass "Analyzer-capability declaration gate"

# Phase 9 analyzer-block validators. Mutation block presence is
# fail-closed after DEC-0005; glossary and architecture checks still
# emit non-failing WARN messages where their structural validators
# intentionally defer full project-specific coverage/audit checks.
scn92_manifests=(
  "contracts/governance-manifest.example.yaml"
  "validation/fixtures/prototype/governance.yaml"
  "validation/fixtures/mvp/governance.yaml"
  "validation/fixtures/production/governance.yaml"
)
for m in "${scn92_manifests[@]}"; do
  python3 -m scripts.validators.mutation_threshold --manifest "$m" \
    || fail "mutation_threshold validator failed for $m"
  python3 -m scripts.validators.glossary_coverage --manifest "$m" \
    || fail "glossary_coverage validator failed for $m"
  python3 -m scripts.validators.architecture_fitness --manifest "$m" \
    || fail "architecture_fitness validator failed for $m"
done
pass "Phase 9 analyzer-block validators (mutation/glossary/architecture)"

bash validation/fixtures/mutation/run.sh \
  || fail "Mutation-threshold fixtures failed"
pass "Mutation-threshold fixtures"

bash validation/fixtures/glossary/run.sh \
  || fail "Glossary-coverage fixtures failed"
pass "Glossary-coverage fixtures"

# Phase 9 SCN-9.4 — forbidden-import audit against the protected
# domain tree. Rules file declares one or more protectedPath blocks;
# the audit walks each path and flags every top-level `import X` or
# `from X import …` that names a forbidden symbol. Fails closed.
if [[ -f validation/architecture-fitness.yaml ]]; then
  python3 -m scripts.validators.architecture_fitness --audit \
    --rules validation/architecture-fitness.yaml --root . \
    || fail "architecture_fitness --audit failed (see stderr above)"
  pass "Architecture-fitness audit (SCN-9.4 forbidden-import check)"
fi

bash validation/fixtures/architecture/run.sh \
  || fail "Architecture-fitness fixtures failed"
pass "Architecture-fitness fixtures"

bash validation/fixtures/codegraph/run.sh \
  || fail "CodeGraph wiring fixtures failed"
pass "CodeGraph wiring fixtures"

if [[ "${ADG_CODEGRAPH_MCP_SHAPE_SMOKE:-0}" == "1" ]]; then
  bash "$ROOT_DIR/scripts/validation/run_codegraph_mcp_shape_smoke.sh" \
    || fail "CodeGraph MCP direct shape smoke failed"
  pass "CodeGraph MCP direct shape smoke"
else
  pass "CodeGraph MCP direct shape smoke skipped"
fi

negative_fixture="validation/fixtures/embedded-missing-evidence/governance.yaml"
[[ -f "$negative_fixture" ]] || fail "Negative fixture missing: $negative_fixture"
if python3 - "$negative_fixture" <<'PY'
import re
import sys
from pathlib import Path

CHECKLIST_KEY = "embeddedVerificationChecklistPath"
EMBEDDED_ADAPTER = "profiles/embedded"

path = Path(sys.argv[1])
adapters: list[str] = []
checklist_path = None
in_adapters = False
in_evidence = False
for raw_line in path.read_text().splitlines():
    line = raw_line.split("#", 1)[0].rstrip()
    if re.match(r"^\S", line):
        in_adapters = line.startswith("adapters:")
        in_evidence = line.startswith("evidence:")
        continue
    if in_adapters:
        m = re.match(r"^\s*-\s*(\S+)", line)
        if m:
            adapters.append(m.group(1))
    if in_evidence and re.match(rf"^\s+{re.escape(CHECKLIST_KEY)}:", line):
        checklist_path = line
if EMBEDDED_ADAPTER not in adapters:
    raise SystemExit("negative fixture must declare profiles/embedded")
if checklist_path is not None:
    raise SystemExit(
        f"negative fixture must NOT declare evidence.{CHECKLIST_KEY}"
    )
PY
then
  pass "Negative fixture proves gate fail-path"
else
  fail "Negative fixture is not shaped as required (embedded profile + no key)"
fi

consumer_root="${GOVERNANCE_CONSUMER_ROOT:-$INVOCATION_DIR}"
if [[ -n "$consumer_root" && "$consumer_root" != "$ROOT_DIR" && -d "$consumer_root" ]]; then
  consumer_manifest="$consumer_root/governance.yaml"
  if [[ -f "$consumer_manifest" ]] \
    && rg -q "codegraphIndexFreshnessURI:" "$consumer_manifest" \
    && rg -q "codegraphImageDigestURI:" "$consumer_manifest"; then
    bash "$ROOT_DIR/scripts/validate_codegraph_wiring.sh" --root "$consumer_root" \
      || fail "CodeGraph wiring check failed for consumer root $consumer_root"
    pass "CodeGraph wiring (consumer manifest declares CG)"
  else
    pass "CodeGraph wiring consumer check skipped"
  fi

  overlay_dir="$consumer_root/docs/governance/amendments"
  if [[ -d "$overlay_dir" ]]; then
    [[ -f "$overlay_dir/README.md" ]] || fail "Optional consumer overlay exists but is missing docs/governance/amendments/README.md"
    pass "Optional consumer overlay detected"
  else
    pass "Optional consumer overlay not present"
  fi
else
  pass "Optional consumer overlay check skipped"
fi

echo "All governance validation checks passed."
