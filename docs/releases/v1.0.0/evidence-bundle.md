# v1.0.0 Release Evidence Bundle

Generated on: 2026-05-20
Release type: consumer-facing governance baseline

## Published Surfaces

- Governance release tag: `v1.0.0`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.0.0`
- Consumer bootstrap branch: `consumer/bootstrap-v1.0.0`
- Validated source branch: `SCN-9.7`
- Release commit: tag target for `v1.0.0`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- Graphify release tag: `v1.0.0`
- Final Graphify release commit: `0a31c0862b600d0755b0b8da41d6cdf99df135df`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.0.0/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.0.0/health-report.md`
- Astaire release bundle: `docs/releases/astaire/v0.5.0-bundle.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `uv run pytest -q` in `astaire/` - pass, 388 tests.
- `bash scripts/validate_governance.sh` - pass, with deferred analyzer-path
  warnings already emitted by the Phase 9 validator.
- `scripts/emit_release_evidence.sh v1.0.0` - pass.
- Astaire health report - 0 warnings, 0 errors.
- Compatibility matrix Astaire SHA parser - pass, resolves `ed16f6d`.
- Fresh local consumer smoke at
  `/private/tmp/adg-consumer-smoke.ryiuKv` - pass:
  `bootstrap_project.sh --retrofit --force` then
  `validate_bootstrap.sh`.

## Release Notes

- Downstream consumers should use the immutable `v1.0.0` tag or
  `consumer/bootstrap-v1.0.0`.
- ADG pins Astaire to the final `v0.5.0` release commit.
- Astaire v0.5.0 documents the Phase 9 feature surface: expanded governance
  collection coverage, governance-authoring indexing, fractional phase/SCN tag
  extraction, claims/projection hexagonal pilot, and mutation baseline harness.
- Bootstrap pin verification accepts compatibility rows that publish a tag plus
  a locked SHA in parentheses.
