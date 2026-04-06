#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

required_files=(
  "README.md"
  "LICENSE"
  "VERSION"
  "CHANGELOG.md"
  "core/PLANNING_METHODOLOGY.md"
  "core/AI_ASSISTED_TDR_METHODOLOGY.md"
  "core/GIT_BRANCH_STRATEGY.md"
  "core/AUTONOMOUS_DELIVERY_GOVERNANCE.md"
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
  "templates/RTK_INSTRUCTIONS_TEMPLATE.md"
  "scripts/validate_chunk_scope.sh"
  "validation/CONSISTENCY_RULES.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || fail "Missing required file: $f"
done
pass "Required files present"

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

rg -q "rtk init -g" adapters/providers/CLAUDE_CONTEXT_ADAPTER.md || fail "Claude adapter must document RTK hook install"
rg -q "rtk init -g --codex" adapters/providers/CODEX_CONTEXT_ADAPTER.md || fail "Codex adapter must document RTK install"
rg -q "tooling/rtk" adapters/tooling/RTK_CONTEXT_ADAPTER.md || fail "RTK tooling adapter must define manifest mapping"
rg -q "rtk gain" runbooks/RTK_ADOPTION_RUNBOOK.md || fail "RTK runbook must include gain evidence workflow"
rg -q "rtk discover" runbooks/RTK_ADOPTION_RUNBOOK.md || fail "RTK runbook must include discover workflow"
rg -q "@RTK.md" templates/AGENTS_RTK_SNIPPET_TEMPLATE.md || fail "AGENTS template must reference RTK.md"
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

rg -q "\[${version}\]" CHANGELOG.md || fail "CHANGELOG missing current version entry"
pass "CHANGELOG includes current version"

echo "All governance validation checks passed."
