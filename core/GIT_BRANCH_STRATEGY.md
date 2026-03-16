# Git Branch Strategy for Governed AI-Assisted Development

## Purpose

This core policy defines branch, review, and release controls. Adapter profiles can tighten rules but cannot weaken core gates.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Branch Model

- Work MUST be isolated in short-lived chunk branches.
- Default naming SHOULD follow `chunk-X.Y.Z-description`.
- Teams MAY adapt naming if traceability to planning artifacts is preserved.

## Chunk Size and Parallelism

- Chunks SHOULD target 1-4 hours of focused work.
- Larger chunks are allowed with explicit justification.
- Parallel chunks are allowed only when dependency and conflict analysis is documented.

## Atomic Scope Guardrails

- Each implementation PR/MR MUST map to exactly one acceptance target (`SCN-*`) or one approved SCN prefix (`SCN-X.Y-*`) for the same chunk.
- A PR/MR MUST NOT mix unrelated feature work across multiple chunk IDs.
- A chunk-scope CI check MUST run pre-merge and fail on mixed SCN scope.
- Exceptions MUST be recorded in the exceptions registry with expiry and compensating controls.
- Teams SHOULD keep per-PR changed-file count bounded (default <= 40) and justify any exceedance in review notes.

## Required Pre-Merge Gates

All pre-merge chunk checks for `main` MUST satisfy:

1. Acceptance criteria status: pass
2. Unit/integration checks: pass
3. Lint/static checks: pass
4. Performance checks: pass when applicable
5. Required human review: approved per risk tier

## Risk-Tiered Merge Policy

- `low`: auto-merge allowed when all checks pass.
- `medium`: one human reviewer required.
- `high`: board review completion + chair signoff + one reviewer.
- `critical`: board review completion + chair signoff + designated accountable approver.

Risk tier MUST be declared in planning artifacts and mirrored in implementation handoff.

## CI and Branch Protection

- Required checks MUST run before merge (PR/MR gate), not only on `main`.
- `main` MUST be protected from direct pushes.
- CODEOWNERS review enforcement SHOULD be enabled.

## Commit and Merge Policy

- Commit messages SHOULD include short summary and validation bullets.
- Merge commits MAY be required by adapter profile.
- Rebase/squash policy MAY vary by adapter, but audit traceability MUST be retained.

## Hotfix Policy (Controlled)

Hotfixes are allowed under strict controls:

1. Incident ticket or documented trigger
2. Human approver assignment
3. Minimal scoped fix
4. Mandatory post-incident backfill (tests/docs) within defined SLA

If backfill misses SLA, next release is blocked until closure.

## Release Tagging and SemVer

- Releases MUST use SemVer tags: `vMAJOR.MINOR.PATCH`.
- Optional convenience tags (for example `phase-<n>-complete`) MAY be added.
- Breaking governance changes MUST bump MAJOR and include migration notes.

## Rollback

- Revert-based rollback is default.
- Follow-up corrective chunk is required for root-cause and prevention controls.
