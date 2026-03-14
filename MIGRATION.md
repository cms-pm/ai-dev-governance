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
