# Changelog

All notable changes to this governance repository are documented in this file.

## [0.5.0] - 2026-04-05

### Added
- Standalone RTK tooling adapter: `adapters/tooling/RTK_CONTEXT_ADAPTER.md`.
- RTK adoption runbook: `runbooks/RTK_ADOPTION_RUNBOOK.md`.
- Repo-local RTK bootstrap templates:
  - `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`
  - `templates/RTK_INSTRUCTIONS_TEMPLATE.md`

### Changed
- Extended governance manifest contract to support `tooling/rtk`.
- Updated strict Claude/Codex examples and fixtures to require RTK alongside provider adapters.
- Added RTK release evidence requirements to strict Claude/Codex workflows.
- Expanded governance validation to enforce RTK adapter coverage, manifest version alignment, and RTK documentation consistency.
- Updated README, migration, compatibility, release, and submodule runbooks for RTK-enabled consumer rollout.

## [0.4.0] - 2026-03-16

### Added
- Atomic-scope policy guardrails requiring one acceptance target (`SCN-*`) or one chunk SCN prefix per implementation PR/MR.
- Executable chunk-scope validator: `scripts/validate_chunk_scope.sh`.
- Branch protection baseline now includes required `chunk-scope` check.
- Submodule consumer runbook guidance for fork-first upstream sync and backport workflow.

### Changed
- Planning methodology chunk-readiness gate now requires declared atomic PR scope target.
- Governance consistency rules and validator script now enforce chunk-scope policy and runbook requirements.

## [0.3.0] - 2026-03-14

### Added
- Core autonomous delivery policy: `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`.
- Autonomous delivery runbook: `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`.
- Expert-agent board selection process and scoring rubric in board governance policy.
- New schema contracts:
  - `contracts/board-member-profile.schema.json`
  - `contracts/board-composition.schema.json`
  - `contracts/board-finding.schema.json`
  - `contracts/board-decision.schema.json`
  - `contracts/implementation-handoff.schema.json`
- New board selection templates:
  - `templates/BOARD_SELECTION_DOSSIER_TEMPLATE.md`
  - `templates/BOARD_MEMBER_PROFILE_TEMPLATE.md`
  - `templates/BOARD_COMPOSITION_APPROVAL_TEMPLATE.md`

### Changed
- Extended governance manifest contract with `automation`, `boardReview.selection`, and `boardReview.composition`.
- Upgraded board templates to include machine-readable sections.
- Integrated risk-tier autonomy and board selection requirements into planning, TDR, evidence, strict baseline, and release procedures.
- Expanded validator and fixture manifests for autonomous + board-selection controls.

## [0.2.0] - 2026-03-14

### Added
- Core board review governance policy: `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`.
- Board review operations runbook: `runbooks/BOARD_REVIEW_OPERATIONS.md`.
- Board packet and opportunity register templates.
- Manifest contract support for board review configuration (`boardReview`).

### Changed
- Integrated board-review outcomes into planning, TDR, evidence, strict baseline, and release procedures.
- Added release gate check for unresolved critical board findings.
- Expanded governance validation script to enforce board governance artifacts and manifest keys.

## [0.1.0] - 2026-03-11

### Added
- Standalone governance repository structure (`core`, `adapters`, `contracts`, `runbooks`, `validation`, `scripts`).
- Normalized planning ambiguity scoring and calibration guidance.
- Core exception/waiver protocol with expiry and accountable approvers.
- Security controls for AI-assisted development workflows.
- Governance manifest schema and example.
- Required evidence contract and validation script.
- Submodule consumer and release runbooks.

### Changed
- Reconciled cross-document contradictions between planning, TDR, and Git strategy.
- Replaced main-only CI statement with pre-merge protection requirements.
- Replaced no-hotfix policy with controlled hotfix policy plus mandatory backfill.
