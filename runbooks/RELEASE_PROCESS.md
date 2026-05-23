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
9. Confirm production-code changes include implementation complexity evidence or documented not-applicable rationale
10. For strict Claude/Codex releases, confirm RTK setup and usage evidence is present (`scripts/rtk-local.sh init --show`, `scripts/rtk-local.sh gain -p`, `scripts/rtk-local.sh discover`, `rtk init --show`, `rtk gain`, `rtk discover`, or documented no-op)
11. Emit Astaire release evidence bundle:
    ```bash
    scripts/emit_release_evidence.sh <version>
    ```
    This writes `docs/releases/<version>/l0-snapshot.md` (live L0 at cut time)
    and `docs/releases/<version>/health-report.md` (`.astaire/astaire lint` output).
    The health report must show zero blocking findings before tagging.
12. If the release manifest declares CodeGraph Tier-2 capability, confirm the
    release evidence bundle also includes the SCN-10.1 URIs:
    - `codegraphIndexFreshnessURI`
    - `codegraphImageDigestURI`
    - declared CG path scope and checker identifier
    Treat this as fail-closed for declared CG releases only; consumers that do
    not declare CG remain on the standard checklist.
13. Update `CHANGELOG.md`
14. Create annotated tag and release notes

## CodeGraph Tier-2 Release Gate

When a consumer declares CodeGraph Tier-2 capability in `governance.yaml`,
its release evidence must include the SCN-10.1 CodeGraph URIs from
`core/EVIDENCE_CONTRACT.md`:

- `codegraphIndexFreshnessURI`
- `codegraphImageDigestURI`
- declared CG path scope
- declared checker identifier

The gate is intentionally consumer-scoped. Non-CG releases continue to use the
standard checklist above and do not need CG-specific evidence.

For declared CG releases, run the consumer wiring validator before tagging:

```bash
scripts/validate_codegraph_wiring.sh --root <consumer-root>
```

The release is blocked if the validator fails or if either CG evidence URI is
present in `governance.yaml` without the matching local evidence artifact.

## CockpitVM Pilot Evidence Contract

For the CockpitVM monitor lane, capture tool-call delta evidence in the format
expected by `R-10-04` reviews:

- release version and release date
- repository or corpus identifier
- baseline and pilot token counts
- baseline and pilot tool-call counts
- computed deltas and percentage changes
- notes on corpus shape, runtime, and exclusions

This section defines the capture format only. It does not require the pilot
evidence itself for SCN-10.9.

## Required Release Artifacts

- Changelog entry
- Compatibility statement
- Migration notes (if MAJOR)
- Evidence summary
- Board critical closure summary
- Risk-tier gate summary
- Implementation complexity evidence summary for production-code changes
- RTK evidence summary for strict Claude/Codex consumers
- Astaire L0 snapshot (`docs/releases/<version>/l0-snapshot.md`)
- Astaire health report (`docs/releases/<version>/health-report.md`) — zero blocking findings
