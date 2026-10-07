# v1.3.0 Release Evidence Bundle

Generated on: 2026-10-07
Release type: minor — launch readiness (Phase 12)

## Published Surfaces

- Governance release tag: `v1.3.0`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.3.0`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0` (unchanged)
- Validated source branch: `SCN-12.7`
- Astaire release tag: `v0.6.3` (`e6a7737`), GitHub release published

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.3.0/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.3.0/health-report.md` — 0 errors
- Stranded-work rescue: `docs/validation/scn-12.1/archive-refs.md`
- Validator planted-violation runs: `docs/validation/scn-12.3/`
- Book citation cross-check: `docs/validation/scn-12.7/book-citations.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md` `[1.3.0]`

## Validation Summary

- `scripts/validate_governance.sh` — pass.
- `scripts/validate_astaire_wiring.sh --root .` — pass.
- `.astaire/astaire startup --root .` after the v0.6.3 repin — pass, no
  migration needed.
- `.astaire/astaire lint` — 0 errors; 93 pre-existing `tag_vocabulary_drift`
  warnings (advisory, carried since v1.2.3). L0 generation 247.6ms, under
  the 300ms threshold (R-11-11 monitor).
- `scripts/validate_bootstrap.sh` on scratch consumers — healthy exit 0
  (13 checks); missing tentacle exit 1; missing wrapper exit 1 with no
  contradicting `[PASS]`.
- Astaire `uv run pytest` at v0.6.3 — 480 passed.

## Checklist (`runbooks/RELEASE_PROCESS.md`)

| Item | Status |
|---|---|
| Compatibility matrix updated | `v1.3.0` row |
| Migration notes | Not MAJOR; upgrade steps in CHANGELOG `[1.3.0]` |
| Exception registry | No active critical waivers. EXC-0002 (Phase 11) expired 2026-08-09, was never adopted on `main`, and is not renewed |
| Required CI | `governance-consistency` green on every merged Phase 12 PR (#42–#46) |
| Board critical findings | None open for Phase 12 scope |
| Human sign-off | `docs/planning/signoffs.md` Phase 12 row, pending |
| Implementation complexity | Production-code change limited to `scripts/validate_bootstrap.sh` (one helper plus six guarded PASS calls); covered by planted-violation evidence |
| CodeGraph Tier-2 gate | Not declared by this repository; not applicable |

## RTK Evidence

`rtk 0.43.0`. Aggregate figures only; per-command rows reference paths
outside this repository and are omitted.

- `rtk gain` (global): 20,239 commands, 100.7M tokens saved (93.5%).
- `rtk discover` (last 30 days, 4 sessions, 448 Bash commands): 1.8%
  already routed through RTK. The largest missed categories are `git -C`
  (59), `grep -n` (32), `cat -n` (30) and `gh pr` (23). These bypass the hook
  because of argument shapes, which is a known gap for path-qualified git
  calls.
