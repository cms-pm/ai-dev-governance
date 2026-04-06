# AI Dev Governance

`ai-dev-governance` is a standalone, internal governance repository for AI-assisted software development.

## Purpose

This repository provides a strict baseline that teams can reuse across projects via Git submodule, with provider, tooling, and project-specific adapters layered on top.

## Repository Layout

- `core/`: Mandatory, provider-agnostic governance policies
- `adapters/`: Provider, tooling, and project overlays (cannot weaken core requirements)
- `contracts/`: Machine-validated interfaces (manifest schema and examples)
- `runbooks/`: Release, branch protection, board review, autonomous delivery, and submodule operations
- `validation/`: Consistency rules and sample consumer fixtures
- `scripts/`: Local validation tooling
- `templates/`: Reusable governance report templates

## Versioning and Compatibility

- SemVer tags: `vMAJOR.MINOR.PATCH`
- Consumers pin to tags, not branches
- Breaking governance changes require:
  - Major version bump
  - Migration notes
  - Updated compatibility matrix

## Consumer Model

1. Add this repository as a submodule.
2. Add `governance.yaml` in the consuming repo root using `contracts/governance-manifest.example.yaml`.
3. Enable strict baseline profile.
4. Add `tooling/rtk` when the consuming repo uses `providers/claude` or `providers/codex`.
5. For portable repo-local RTK tracking, use `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` with `.rtk/history.db` ignored from version control.
6. Validate governance with `scripts/validate_governance.sh` from submodule root.

## Required Core Policies

- Planning gate and ambiguity reduction: `core/PLANNING_METHODOLOGY.md`
- Test-driven requirements and evidence: `core/AI_ASSISTED_TDR_METHODOLOGY.md`
- Branching and release controls: `core/GIT_BRANCH_STRATEGY.md`
- Autonomous delivery state machine and risk-tier policy: `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
- Board review governance, expert-agent selection, and integration lane: `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
- Exceptions and waivers: `core/EXCEPTIONS_AND_WAIVERS.md`
- AI-assisted security controls: `core/SECURITY_CONTROLS.md`
- Evidence contract: `core/EVIDENCE_CONTRACT.md`

## Publishing Baseline

- Default branch protected
- CODEOWNERS enforced
- Required CI checks enabled
- Releases cut only from protected `main`

See `runbooks/RELEASE_PROCESS.md`, `runbooks/BOARD_REVIEW_OPERATIONS.md`, `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`, `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md`, and `runbooks/RTK_ADOPTION_RUNBOOK.md`.
