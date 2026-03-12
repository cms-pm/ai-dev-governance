# Governance Consistency Rules

## Cross-Document Rules

1. Core docs must not contain contradictory merge gate statements.
2. Core planning and TDR docs must both require measurable non-functional validation.
3. Git strategy must require pre-merge CI checks.
4. Hotfix policy must exist and require post-incident backfill.
5. Human accountability must be present for merge/release approval.

## Contract Rules

1. `contracts/governance-manifest.schema.json` must exist.
2. `contracts/governance-manifest.example.yaml` must include required keys.
3. `VERSION` must be valid SemVer without leading `v`.

## Release Rules

1. `CHANGELOG.md` has entry for current version.
2. `runbooks/COMPATIBILITY_MATRIX.md` includes current major/minor line.
3. `runbooks/RELEASE_PROCESS.md` includes migration-note requirement for breaking changes.
