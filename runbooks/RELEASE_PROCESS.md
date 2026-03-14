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
9. Update `CHANGELOG.md`
10. Create annotated tag and release notes

## Required Release Artifacts

- Changelog entry
- Compatibility statement
- Migration notes (if MAJOR)
- Evidence summary
- Board critical closure summary
- Risk-tier gate summary
