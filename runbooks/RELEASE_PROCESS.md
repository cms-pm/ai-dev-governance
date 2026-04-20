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
