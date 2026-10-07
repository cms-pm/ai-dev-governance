# v1.3.1 Release Evidence Bundle

Generated on: 2026-10-07
Release type: patch — repository presentation (Phase 12, SCN-12.8)

## Published Surfaces

- Governance release tag: `v1.3.1`
- Consumer bootstrap branch: `consumer/bootstrap-v1.1.0` (unchanged)
- Astaire: `v0.6.3` (`e6a7737`), unchanged from v1.3.0

## Validation Summary

- `scripts/validate_governance.sh`: pass.
- `scripts/validate_astaire_wiring.sh --root .`: pass.
- `.astaire/astaire lint`: 0 errors (advisory `tag_vocabulary_drift`
  warnings unchanged from v1.3.0).
- `git archive HEAD`: no files from `docs/planning`, `docs/validation`,
  `docs/evidence`, `docs/governance`, `docs/glossary`, `artifacts/`,
  `.astaire/`, `.claude/`, `.codegraph/` or `.rtk/`. `docs/releases/` is
  retained.
- README badges render `license: MIT`, the latest release, and
  `governance-consistency: passing`.

## Checklist

No doctrine, contract, validator, or tentacle change. No migration. No
exceptions. Production-code changes: none.
