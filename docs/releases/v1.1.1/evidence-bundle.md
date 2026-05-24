# v1.1.1 Release Evidence Bundle

Generated on: 2026-05-24
Release type: patch release for the v1.1.x consumer baseline

## Published Surfaces

- Governance release tag: `v1.1.1`
- Governance GitHub release: `https://github.com/cms-pm/ai-dev-governance/releases/tag/v1.1.1`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0`
- Validated source branch: `SCN-10.5`
- Release commit: tag target for `v1.1.1`

- Astaire release tag: `v0.5.0`
- Final Astaire release commit: `ed16f6d91a4d0759e10b4f375b1a47f1c77cb7ed`
- CodeGraph image digest: `sha256:8755b3e13adb17159e0154e750f0af56d2159ffb7847818c6871c2c3ddc3ded1`

## Evidence Artifacts

- Astaire L0 snapshot: `docs/releases/v1.1.1/l0-snapshot.md`
- Astaire health report: `docs/releases/v1.1.1/health-report.md`
- CodeGraph MCP direct shape smoke: `docs/validation/scn-10.11/mcp-direct-shape.md`
- CodeGraph fixture matrix: `docs/validation/scn-10.8/fixture-matrix.md`
- Compatibility matrix: `runbooks/COMPATIBILITY_MATRIX.md`
- Changelog: `CHANGELOG.md`

## Validation Summary

- `python3 -m py_compile scripts/validation/codegraph_mcp_jsonrpc_client.py` - pass.
- `bash -n scripts/validation/run_codegraph_mcp_shape_smoke.sh` - pass.
- `python3 -m json.tool templates/codegraph/.mcp.json.fragment` - pass.
- `scripts/validate_governance.sh` - pass, with existing deferred analyzer-path warnings.
- `ADG_CODEGRAPH_MCP_SHAPE_SMOKE=1 scripts/validate_governance.sh` - pass.
- `.astaire/astaire startup --root .` - pass.
- `.astaire/astaire lint` - pass, 0 warnings, 0 errors.
- `scripts/emit_release_evidence.sh v1.1.1` - pass.
- Astaire health report - 0 warnings, 0 errors.

## Release Notes

- Downstream consumers should pin to the immutable `v1.1.1` tag.
- `v1.1.1` is a patch over the `v1.1.0` bootstrap line; the consumer bootstrap
  branch remains `consumer/bootstrap-v1.1.0`.
- The CodeGraph MCP fragment now invokes the pinned CodeGraph v0.8.0 image with
  `serve --mcp --no-watch`.
- The SCN-10.11 strict Docker smoke now loads the published MCP fragment
  command, args, and env before exercising the direct MCP JSON-RPC shape.
- Non-CG consumers remain on Astaire-first governance reads plus native source
  discovery tools.
