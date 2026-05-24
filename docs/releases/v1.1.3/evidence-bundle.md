# v1.1.3 Release Evidence Bundle

Generated on: 2026-05-24
Release type: patch release for declared-CodeGraph consumer usability

## Published Surfaces

- Governance release tag: `v1.1.3`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.1.3`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0`
- Validated source branch: `SCN-10.5`
- Release commit: tag target for `v1.1.3`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- CodeGraph image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.1.3/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.1.3/health-report.md`
- CockpitVM CodeGraph remediation evidence: `docs/validation/scn-10.13/cockpitvm-codegraph-remediation.md`
- CodeGraph MCP direct shape smoke: `docs/validation/scn-10.11/mcp-direct-shape.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `bash scripts/validate_governance.sh` - pass, with existing deferred analyzer-path warnings.
- `ADG_CODEGRAPH_MCP_SHAPE_SMOKE=1 bash scripts/validate_governance.sh` - pass.
- `.astaire/astaire startup --root .` - pass.
- `.astaire/astaire lint` - pass, 0 warnings, 0 errors.
- `scripts/emit_release_evidence.sh v1.1.3` - pass.
- Astaire health report - 0 warnings, 0 errors.

## Release Notes

- Downstream declared-CG consumers should pin to the immutable `v1.1.3` tag.
- `v1.1.3` is a patch over the `v1.1.0` bootstrap line; the consumer bootstrap
  branch remains `consumer/bootstrap-v1.1.0`.
- The CodeGraph wrapper now prepares named volume ownership before launching
  the hardened non-root MCP container.
- CodeGraph wiring validation now accepts locally loaded SHA-256 image IDs
  without RepoDigests when they match `.codegraph/image.digest`.
- Declared-CG validation now fails live `codegraph status` output with zero
  indexed files or zero nodes.
- Bootstrap validation now detects consumer `governanceVersion` drift against
  the installed ADG submodule version unless a local exception documents it.
