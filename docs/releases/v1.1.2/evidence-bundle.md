# v1.1.2 Release Evidence Bundle

Generated on: 2026-05-24
Release type: patch release for the v1.1.x consumer baseline

## Published Surfaces

- Governance release tag: `v1.1.2`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.1.2`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0`
- Validated source branch: `SCN-10.5`
- Release commit: tag target for `v1.1.2`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- CodeGraph image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.1.2/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.1.2/health-report.md`
- CodeGraph consumer contract visibility: `docs/validation/scn-10.12/codegraph-contract-visibility.md`
- CodeGraph MCP direct shape smoke: `docs/validation/scn-10.11/mcp-direct-shape.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `bash scripts/validate_governance.sh` - pass, with existing deferred analyzer-path warnings.
- `.astaire/astaire startup --root .` - pass.
- `.astaire/astaire lint` - pass, 0 warnings, 0 errors.
- `scripts/emit_release_evidence.sh v1.1.2` - pass.
- Astaire health report - 0 warnings, 0 errors.

## Release Notes

- Downstream consumers should pin to the immutable `v1.1.2` tag.
- `v1.1.2` is a patch over the `v1.1.0` bootstrap line; the consumer bootstrap
  branch remains `consumer/bootstrap-v1.1.0`.
- Bootstrap and retrofit now surface
  `docs/governance/codegraph-contract.md` so consumers explicitly decide
  whether CodeGraph remains undeclared or is activated.
- Non-CG consumers remain compliant when both CG evidence URIs are absent.
- CG-declared consumers must declare both CG evidence URIs and pass
  `scripts/validate_codegraph_wiring.sh --root .` before release evidence can
  cite CodeGraph.
