# SCN-10.13 CockpitVM CodeGraph Consumer Remediation

Generated: 2026-05-24

## Bulletin Mapping

| Bulletin issue | ADG response |
|---|---|
| ADG-CG-001 manifest still `v1.1.0` while submodule is `v1.1.2` | `scripts/validate_bootstrap.sh` now compares consumer `governanceVersion` with the installed ADG submodule `VERSION` and fails unless a local `docs/governance/exceptions.yaml` documents the drift. |
| ADG-CG-002 MCP starts but index is empty | `scripts/validate_codegraph_wiring.sh` now runs the configured CodeGraph wrapper `status` command by default and fails if live status reports zero indexed files or zero nodes. |
| ADG-CG-003 named Docker volume blocks first init | `templates/codegraph/scripts/codegraph-mcp` and `codegraph-mcp.cmd` now run a one-shot volume ownership preparation container before launching the hardened non-root container. |
| ADG-CG-004 local image ID digest without RepoDigests | `scripts/validate_codegraph_wiring.sh` now accepts both `image@sha256:<hex>` RepoDigests and locally loaded `sha256:<hex>` image IDs that match `.codegraph/image.digest`. |
| ADG-CG-005 WASM SQLite fallback | `templates/CODEGRAPH_CONTRACT_TEMPLATE.md` documents `Backend: wasm` as acceptable for consumer MCP operation when indexing and tool execution are otherwise healthy. |

## Focused Checks

- `bash -n templates/codegraph/scripts/codegraph-mcp` - pass.
- `bash -n scripts/validate_codegraph_wiring.sh` - pass.
- `bash -n scripts/validate_bootstrap.sh` - pass.
- `bash validation/fixtures/codegraph/run.sh` - pass, including RepoDigest-rejection fallback.
- Temporary consumer with `governanceVersion: v1.1.0` and installed ADG
  `v1.1.3` - fail as expected.
- Temporary consumer with matching `governanceVersion: v1.1.3` - pass.
- Temporary live CodeGraph status with `Files indexed: 3` and `Total nodes: 7`
  - pass.
- Temporary live CodeGraph status with `Files indexed: 0` and `Total nodes: 0`
  - fail as expected.
- `/bin/echo` wrapper dry-run - pass; main container invocation remains
  hardened and the prep invocation is suppressed from dry-run output.
- `bash scripts/validate_governance.sh` - pass.
- `ADG_CODEGRAPH_MCP_SHAPE_SMOKE=1 bash scripts/validate_governance.sh` -
  pass with Docker access.

## Consumer Guidance

CockpitVM should update to the ADG release containing these fixes and align
`governance.yaml` to that installed tag (`v1.1.3`), or add an explicit local
exception. After pulling these ADG fixes, rerun:

```bash
.governance/ai-dev-governance/scripts/validate_bootstrap.sh
.governance/ai-dev-governance/scripts/validate_codegraph_wiring.sh --root .
./scripts/codegraph-mcp init --index
./scripts/codegraph-mcp status
```

The declared-CG path is healthy only when status reports nonzero indexed files
and nodes for the product-code path scope.
