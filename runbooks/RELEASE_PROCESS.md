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
6. Update `CHANGELOG.md`
7. Create annotated tag and release notes

## Required Release Artifacts

- Changelog entry
- Compatibility statement
- Migration notes (if MAJOR)
- Evidence summary
