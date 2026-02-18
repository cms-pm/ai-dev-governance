# Git Branch Strategy - Chunk-Based Waterfall Development

## Overview
This document defines a project-agnostic, chunk-based development workflow. Each chunk is a small, validated unit that creates a stable foundation for subsequent work.

## Branch Naming Convention
**Format**: `chunk-X.Y.Z-description`
- `X` = Phase number
- `Y` = Feature/component within phase
- `Z` = Sub-chunk/incremental step
- `description` = brief kebab-case summary

## Chunk Size Limit
- **Hard limit**: 1-4 hours of work

## Parallel Work Policy
Parallel chunk development is allowed **only** when all are true:
- No shared files
- No shared components/interfaces
- No ordering dependencies and no merge conflicts

## Branch Protection
- Main must be protected with required reviews and checks.
- Enforcement can be automated depending on the project’s tooling.

## Chunk Development Workflow

### 1. Create Chunk Branch
```bash
git checkout main
git pull origin main
git checkout -b chunk-X.Y.Z-description
```

### 2. Implement Chunk
- Focus on a single logical unit
- Keep changes minimal and testable

### 3. Validate Chunk
**Required checks before merge**:
- Acceptance criteria pass
- Unit tests
- Integration tests
- Performance thresholds (if applicable)
- Lint/static analysis

### 4. Commit (After Validation)
**Commit format**: short single-line summary + bullets
```
Chunk X.Y.Z: <brief summary>

- <achievement 1>
- <achievement 2>
- Validation: <test results summary>
```

### 5. Merge to Main
- Merge commit only (`--no-ff`)
- **No rebasing** on chunk branches
- **One reviewer** required

```bash
git checkout main
git merge chunk-X.Y.Z-description --no-ff
git push origin main
```

### 6. Cleanup
- Delete chunk branch after merge

## CI Gating Policy
- CI must pass on **main only** before release tags.

## Documentation Policy
- Documentation updates are required **in the same chunk** when behavior changes.

## Rollback Strategy
- Default response for regression after merge: **revert commit**.
- **Hotfixes are not allowed** (no bypass of normal chunk rules).

## Release Tagging
- Phase completion: `phase-<n>-complete`
- MVP completion: `mvp-<date>`

## Tooling
This strategy is **tool-agnostic**. Use the project’s preferred Git hosting and CI platform.

