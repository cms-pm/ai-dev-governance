# Release Process

## Versioning

- Use SemVer tags: `vMAJOR.MINOR.PATCH`
- MAJOR for breaking policy/interface changes
- MINOR for backward-compatible additions
- PATCH for clarifications and non-breaking fixes

## Release Checklist

1. Run `scripts/validate_governance.sh`
2. Verify compatibility matrix updates
3. Confirm migration notes for breaking changes
4. Confirm exception registry status (no expired critical waivers)
5. Confirm required CI checks are green
6. Confirm unresolved critical board findings are zero or covered by approved exceptions
7. Confirm high/critical tier items have required human signoffs
8. Confirm structured board and implementation handoff artifacts are present for high/critical changes
9. For strict Claude/Codex releases, confirm RTK setup and usage evidence is present (`scripts/rtk-local.sh init --show`, `scripts/rtk-local.sh gain -p`, `scripts/rtk-local.sh discover`, `rtk init --show`, `rtk gain`, `rtk discover`, or documented no-op)
10. Emit Astaire release evidence bundle:
    ```bash
    scripts/emit_release_evidence.sh <version>
    ```
    This writes `docs/releases/<version>/l0-snapshot.md` (live L0 at cut time)
    and `docs/releases/<version>/health-report.md` (`.astaire/astaire lint` output).
    The health report must show zero blocking findings before tagging.
11. Update `CHANGELOG.md`
12. Create annotated tag and release notes

## Graphify Install Paths

The release and evidence steps above invoke `graphify` via
`scripts/run_graphify.sh`. If `graphify` is not on `PATH`, install from
source using the path that matches your consumer layout:

- **Monorepo / authoring checkout** (this repo, or any checkout where the
  governance source tree is the repo root):
  ```bash
  pip install -e ./graphify
  ```
- **Submodule consumer** (graphify lives inside the pinned governance
  submodule at `.governance/ai-dev-governance/graphify`):
  ```bash
  pip install -e ./.governance/ai-dev-governance/graphify
  ```
- **Optional heavy extras** (Leiden / community detection only):
  `pip install -e '<path>[cluster]'`.

`scripts/run_graphify.sh` emits both paths in its "graphify not on PATH"
failure message; follow the one that matches the layout.

## Graphify Lightweight Fallback Install

The default graphify install lists `graspologic` as a top-level dependency,
which pulls in `numba` / `llvmlite` and requires a system LLVM toolchain.
The restricted / structural fallback path used for governance graph
generation does not exercise community detection, so consumers can skip
the heavy stack:

```bash
scripts/install_graphify_fallback.sh [venv-python]
```

This installs the minimal runtime subset (`networkx` + tree-sitter bindings)
and then installs graphify from source with `--no-deps`. `graspologic` is
left out; calling the community-detection path will raise ImportError.

A permanent fix — moving `graspologic` into an opt-in `[cluster]` extra —
needs to land in the upstream graphify project
(`https://github.com/safishamsi/graphify`). Track the corresponding upstream
contribution and re-pin the submodule once it ships.

## Required Release Artifacts

- Changelog entry
- Compatibility statement
- Migration notes (if MAJOR)
- Evidence summary
- Board critical closure summary
- Risk-tier gate summary
- RTK evidence summary for strict Claude/Codex consumers
- Astaire L0 snapshot (`docs/releases/<version>/l0-snapshot.md`)
- Astaire health report (`docs/releases/<version>/health-report.md`) — zero blocking findings
