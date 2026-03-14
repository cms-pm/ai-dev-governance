# Changelog

All notable changes to this governance repository are documented in this file.

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
