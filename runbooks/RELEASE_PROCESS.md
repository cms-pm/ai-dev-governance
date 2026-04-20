# Release Process

## Versioning

- Use SemVer tags: `vMAJOR.MINOR.PATCH`
- MAJOR for breaking policy/interface changes
- MINOR for backward-compatible additions
- PATCH for clarifications and non-breaking fixes

## Release Checklist

For a consumer-facing release branch, first scrub source-repo delivery artifacts:

```bash
scripts/prepare_release_branch.sh --apply
```

That branch should keep the reusable product and tentacle submodules, but it
should not ship this repository's own planning packets, release evidence,
validation logs, dogfood raw inputs, or generated graph outputs.

1. Run `scripts/validate_governance.sh`
2. Verify compatibility matrix updates
3. Confirm migration notes for breaking changes
4. Confirm exception registry status (no expired critical waivers)
5. Confirm required CI checks are green
6. Confirm unresolved critical board findings are zero or covered by approved exceptions
7. Confirm high/critical tier items have required human signoffs
8. Confirm structured board and implementation handoff artifacts are present for high/critical changes
9. For strict Claude/Codex releases, confirm RTK setup and usage evidence is present (`scripts/rtk-local.sh init --show`, `scripts/rtk-local.sh gain -p`, `scripts/rtk-local.sh discover`, `rtk init --show`, `rtk gain`, `rtk discover`, or documented no-op)
10. If `graphify` is enabled, run:
    ```bash
    scripts/run_graphify.sh --preflight
    scripts/validate_graphify.sh
    ```
    Supported local fallback bootstrap path:
    ```bash
    uv venv .venv
    .venv/bin/python -m pip install -e ./graphify
    scripts/run_graphify.sh --preflight
    ```
    If semantic document/image extraction is required, set `GRAPHIFY` to the
    external runner and continue to invoke graphify only through
    `scripts/run_graphify.sh`.
    Report-only posture is valid when `graphify-out/GRAPH_REPORT.md` exists and
    `graphify-out/graph.json` is intentionally absent.
11. Emit Astaire release evidence bundle:
    ```bash
    scripts/emit_release_evidence.sh <version>
    ```
    This writes `docs/releases/<version>/startup.log`,
    `docs/releases/<version>/l0-snapshot.md`,
    `docs/releases/<version>/health-report.md`, and
    `docs/releases/<version>/graphify-validation.md` when graphify is enabled.
    The health report must show zero blocking findings before tagging.
12. For a full public release rehearsal, run:
    ```bash
    scripts/rehearse_v0_6_0_release.sh <version>
    ```
13. Update `CHANGELOG.md`
14. For consumer-facing releases, create the dedicated `consumer/bootstrap-*`
    branch from the validated tabula-rasa branch state
15. Create annotated tag and release notes from the consumer bootstrap branch

## Release Branch Expectations

- Consumer-facing release branches are clean baselines, not source-repo
  diaries.
- Consumer-facing GitHub releases should target the dedicated
  `consumer/bootstrap-*` branch that points at the validated clean baseline.
- Consumer repos create their own `docs/planning/`, `docs/releases/`,
  `docs/validation/`, and `docs/governance/board/` artifacts outside the
  governance submodule.
- Keep `astaire/` and other tentacle dependencies as nested submodules so
  consumers can bootstrap with `git submodule update --init --recursive`.

## Required Release Artifacts

- Changelog entry
- Compatibility statement
- Migration notes (if MAJOR)
- Evidence summary
- Board critical closure summary
- Risk-tier gate summary
- RTK evidence summary for strict Claude/Codex consumers
- Graphify validation summary (`scripts/validate_graphify.sh`) when graphify is enabled
- Graphify execution mode statement: semantic external runner or local structural fallback
- Astaire startup convergence log (`docs/releases/<version>/startup.log`)
- Astaire L0 snapshot (`docs/releases/<version>/l0-snapshot.md`)
- Astaire health report (`docs/releases/<version>/health-report.md`) — zero blocking findings
- Graphify validation report (`docs/releases/<version>/graphify-validation.md`) when graphify is enabled
