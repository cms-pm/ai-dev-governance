# Governance Consistency Rules

## Cross-Document Rules

1. Core docs must not contain contradictory merge gate statements.
2. Core planning and TDR docs must both require measurable non-functional validation.
3. Git strategy must require pre-merge CI checks.
4. Hotfix policy must exist and require post-incident backfill.
5. Human accountability must be present for merge/release approval.
6. Board review policy must define cadence, critique protocol, and gate outcomes.
7. Release process must include board critical-closure checks.
8. Autonomous delivery policy must define state machine and deterministic stop rules.
9. Board policy must define expert-agent selection criteria and scoring rubric.
10. Git strategy and branch protection must require chunk-scope enforcement.

## Contract Rules

1. `contracts/governance-manifest.schema.json` must exist.
2. `contracts/governance-manifest.example.yaml` must include required keys.
3. Strict baseline examples must declare `automation`, `boardReview.selection`, and `boardReview.composition`.
4. Board member/composition/finding/decision/handoff schemas must exist.
5. `VERSION` must be valid SemVer without leading `v`.

## Release Rules

1. `CHANGELOG.md` has entry for current version.
2. `runbooks/COMPATIBILITY_MATRIX.md` includes current major/minor line.
3. `runbooks/RELEASE_PROCESS.md` includes migration-note requirement for breaking changes.
