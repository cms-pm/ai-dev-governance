# Migration Guide

## From Flat Methodology Layout to Structured Layout

Legacy files remain at repository root for compatibility:

- `PLANNING_METHODOLOGY.md`
- `AI_ASSISTED_TDR_METHODOLOGY.md`
- `GIT-BRANCH-STRATEGY.md`

Canonical content now lives in `core/`.

## Consumer Action

1. Update internal links to `core/` paths.
2. Add governance manifest in consuming repository root.
3. Add evidence and exceptions registries using templates.
