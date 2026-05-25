# v1.1.5 Release Evidence Bundle

Generated on: 2026-05-25
Release type: patch release for declared-CodeGraph wrapper tuning

## Published Surfaces

- Governance release tag: `v1.1.5`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.1.5`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0`
- Validated source branch: `SCN-10.5`
- Release commit: tag target for `v1.1.5`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- CodeGraph image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.1.5/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.1.5/health-report.md`
- CockpitVM CodeGraph remediation evidence: `docs/validation/scn-10.13/cockpitvm-codegraph-remediation.md`
- CodeGraph MCP direct shape smoke: `docs/validation/scn-10.11/mcp-direct-shape.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `bash scripts/validate_governance.sh` - pass, with existing deferred analyzer-path warnings.
- `ADG_CODEGRAPH_MCP_SHAPE_SMOKE=1 bash scripts/validate_governance.sh` - pass.
- `bash validation/fixtures/codegraph/run.sh` - pass.
- Strict-Docker temporary consumer with source only under `raw/` - pass; `init --index` indexed one C file.
- Strict-Docker lock-contention repro - pass; wrapper emitted a lock retry notice and `status` recovered successfully.
- `.astaire/astaire startup --root .` - pass.
- `.astaire/astaire lint` - pass, 0 warnings, 0 errors.
- `scripts/emit_release_evidence.sh v1.1.5` - pass.
- Astaire health report - 0 warnings, 0 errors.

## Release Notes

- Downstream declared-CG consumers should pin to the immutable `v1.1.5` tag.
- `v1.1.5` is a patch over the `v1.1.0` bootstrap line; the consumer bootstrap
  branch remains `consumer/bootstrap-v1.1.0`.
- The CodeGraph wrapper no longer excludes a top-level `raw/` directory from
  the sanitized `/workspace`; source or fixtures under `raw/` are indexable
  unless the consumer excludes them locally.
- The CodeGraph wrapper now waits for `.codegraph/codegraph.lock` before
  launch and retries non-stdio CLI calls on CodeGraph lock-contention output.
  Tune with `ADG_CODEGRAPH_LOCK_RETRIES` and
  `ADG_CODEGRAPH_LOCK_BACKOFF_SECONDS`.
- `serve --mcp` keeps stdout unbuffered for JSON-RPC and uses only the
  pre-launch lock wait, avoiding retry buffering on MCP stdio streams.
