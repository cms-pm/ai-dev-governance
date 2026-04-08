# Migration Guide

## From Flat Methodology Layout to Structured Layout

Legacy files remain at repository root for compatibility:

- `PLANNING_METHODOLOGY.md`
- `AI_ASSISTED_TDR_METHODOLOGY.md`
- `GIT-BRANCH-STRATEGY.md`
- `BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`
- `AUTONOMOUS_DELIVERY_GOVERNANCE.md`

Canonical content now lives in `core/`.

## Consumer Action

1. Update internal links to `core/` paths.
2. Add governance manifest in consuming repository root.
3. Add evidence and exceptions registries using templates.

## v0.2.x Board Review Integration

If upgrading from v0.1.x:

1. Add `boardReview` section to governance manifest.
2. Adopt board templates:
   - `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`
   - `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`
   - `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`
3. Wire board critical-closure checks into release readiness process.

## v0.3.x Autonomous + Selection Integration

If upgrading from v0.2.x:

1. Add `automation` section to governance manifest.
2. Extend `boardReview` with `selection` policy and `composition` references.
3. Publish board selection artifacts:
   - `templates/BOARD_SELECTION_DOSSIER_TEMPLATE.md`
   - `templates/BOARD_MEMBER_PROFILE_TEMPLATE.md`
   - `templates/BOARD_COMPOSITION_APPROVAL_TEMPLATE.md`
4. Emit machine-readable board findings/decisions and implementation handoff artifacts.
5. Enforce risk-tier gate behavior in release readiness process.

## v0.5.x RTK Token-Governance Integration

If upgrading from v0.4.x:

1. Add `tooling/rtk` to strict baseline manifests that use `providers/claude` or `providers/codex`.
2. Install RTK and run the appropriate global setup:
   - `rtk init -g` for Claude Code
   - `rtk init -g --codex` for Codex
3. Verify setup with `rtk init --show`.
4. Add repo-local RTK reinforcement only if needed using:
   - `templates/AGENTS_RTK_SNIPPET_TEMPLATE.md`
   - `templates/RTK_INSTRUCTIONS_TEMPLATE.md`
5. Capture RTK release evidence with `rtk gain` and `rtk discover` outputs or a documented no-op result.
6. Record any excluded commands or temporary RTK bypasses through the exceptions process.

## v0.5.1 Portable RTK Tracking Guidance

If upgrading from v0.5.0:

1. Add `.rtk/` to the consumer repo `.gitignore` if you want repo-local RTK tracking.
2. Copy `templates/RTK_LOCAL_WRAPPER_TEMPLATE.sh` to `scripts/rtk-local.sh`.
3. Keep the wrapper default database path at `./.rtk/history.db`.
4. Prefer `scripts/rtk-local.sh init --show`, `scripts/rtk-local.sh gain -p`, and `scripts/rtk-local.sh discover` for release evidence in sandboxed or portable workflows.

## v0.5.2 Optional Consumer Overlay Support

If upgrading from v0.5.1:

1. Keep using the shared submodule as the generic baseline.
2. When project-specific tightening is needed, place it in `docs/governance/amendments/` in the consumer repository rather than modifying the shared submodule.
3. Add `docs/governance/amendments/README.md` using `templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md` when the overlay is present.
4. Run the validator from the consumer root, or set `GOVERNANCE_CONSUMER_ROOT`, so optional overlay checks can execute.
