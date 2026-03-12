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
  "core/EXCEPTIONS_AND_WAIVERS.md"
  "core/SECURITY_CONTROLS.md"
  "core/EVIDENCE_CONTRACT.md"
  "contracts/governance-manifest.schema.json"
  "contracts/governance-manifest.example.yaml"
  "runbooks/RELEASE_PROCESS.md"
  "runbooks/SUBMODULE_CONSUMER_RUNBOOK.md"
  "runbooks/COMPATIBILITY_MATRIX.md"
  "validation/CONSISTENCY_RULES.md"
)

for f in "${required_files[@]}"; do
  [[ -f "$f" ]] || fail "Missing required file: $f"
done
pass "Required files present"

version="$(tr -d '[:space:]' < VERSION)"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "VERSION is not SemVer (expected x.y.z)"
pass "VERSION format"

rg -q "pre-merge" core/GIT_BRANCH_STRATEGY.md || fail "Git strategy must require pre-merge checks"
! rg -q "main only" core/GIT_BRANCH_STRATEGY.md || fail "Git strategy must not allow main-only CI gating"
rg -q "Hotfixes are allowed" core/GIT_BRANCH_STRATEGY.md || fail "Controlled hotfix policy missing"
pass "Git strategy consistency"

rg -q "Non-functional requirements .* MUST" core/PLANNING_METHODOLOGY.md || fail "Planning non-functional requirement mapping missing"
rg -q "Performance \(timing bounds\)" core/AI_ASSISTED_TDR_METHODOLOGY.md || fail "TDR non-functional validation missing"
pass "Planning/TDR consistency"

required_manifest_keys=(
  "apiVersion:"
  "governanceVersion:"
  "profile:"
  "adapters:"
  "evidence:"
  "exceptions:"
  "approval:"
)
for k in "${required_manifest_keys[@]}"; do
  rg -q "^${k}" contracts/governance-manifest.example.yaml || fail "Manifest example missing key: ${k}"
done
pass "Manifest example keys"

rg -q "\[${version}\]" CHANGELOG.md || fail "CHANGELOG missing current version entry"
pass "CHANGELOG includes current version"

echo "All governance validation checks passed."
