# Migration Guide

## From Flat Methodology Layout to Structured Layout

Legacy files remain at repository root for compatibility:

- `PLANNING_METHODOLOGY.md`
- `AI_ASSISTED_TDR_METHODOLOGY.md`
- `GIT-BRANCH-STRATEGY.md`
- `BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`

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
