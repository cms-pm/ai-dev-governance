# v1.1.0 Release Evidence Bundle

Generated on: 2026-05-24
Release type: consumer-facing governance baseline

## Published Surfaces

- Governance release tag: `v1.1.0`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.1.0`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0`
- Validated source branch: `SCN-10.5`
- Release commit: tag target for `v1.1.0`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- CodeGraph image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.1.0/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.1.0/health-report.md`
- CodeGraph MCP direct shape smoke: `docs/validation/scn-10.11/mcp-direct-shape.md`
- CodeGraph fixture matrix: `docs/validation/scn-10.8/fixture-matrix.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `uv run pytest -q` in `astaire/` - pass, 388 tests.
- `scripts/validate_governance.sh` - pass, with deferred analyzer-path warnings already emitted by the Phase 9 validators.
- `ADG_CODEGRAPH_MCP_SHAPE_SMOKE=1 scripts/validate_governance.sh` - pass.
- `bash validation/fixtures/codegraph/run.sh` - pass.
- `scripts/emit_release_evidence.sh v1.1.0` - pass.
- Astaire health report - 0 warnings, 0 errors.
- Fresh local consumer smoke at
  `/private/tmp/adg-v1.1.0-consumer-smoke.Z2awQJ` - pass:
  `bootstrap_project.sh --retrofit --force`, `.astaire/astaire startup --root .`,
  then `validate_bootstrap.sh`.

## Release Notes

- Downstream consumers should use the immutable `v1.1.0` tag or
  `consumer/bootstrap-v1.1.0`.
- ADG keeps Astaire pinned to the final `v0.5.0` release commit.
- CodeGraph is optional Tier-2 code intelligence. Consumers that declare CG
  must provide image-digest and index-freshness evidence and run
  `scripts/validate_codegraph_wiring.sh --root <consumer-root>` before release.
- Non-CG consumers remain on Astaire-first governance reads plus native source
  discovery tools.
- Graphify is removed from the active ADG integration surface. Consumers with
  older Graphify manifest blocks or wrapper usage should remove them during the
  v1.1.0 bump.
- R-10-02, R-10-03, and R-10-04 remain monitor-lane risks for downstream CG
  adoption, removed-Graphify fallback monitoring, and CockpitVM pilot evidence.
