# Validator unit fixtures (SCN-8.3.2)

Fixtures that exercise `scripts/validators/governance_gates.py` in
isolation from the orchestrating `scripts/validate_governance.sh`.

Run the full sweep:

```bash
bash validation/fixtures/validators/run.sh
```

## Embedded-profile fail-closed gate matrix

The validator must accept or reject each manifest as listed. Each
manifest carries only the fields the gate parses (`adapters` list and
optionally `evidence.embeddedVerificationChecklistPath`); the rest of
the strict-baseline manifest keys are deliberately omitted because
they are out of the gate's scope.

| Fixture | Embedded adapter? | Checklist key? | Checklist file exists? | Expected verdict |
|---|---|---|---|---|
| `embedded-present-valid/governance.yaml` | yes | yes | yes | PASS |
| `embedded-present-missing-key/governance.yaml` | yes | no | n/a | FAIL |
| `embedded-present-missing-file/governance.yaml` | yes | yes | no | FAIL |
| `embedded-absent-clean/governance.yaml` | no | no | n/a | PASS |
| `embedded-absent-with-key/governance.yaml` | no | yes | n/a | FAIL |

Sibling checklist files referenced by the PASS-shape fixtures live
under each fixture's directory.

## Agency-string CI guard — retired

OPP-8.2-004 (agency-string guard surface expansion) was closed without
action at Phase 8.3 bootstrap; the one-time repo-wide sweep at Phase
8.2 bootstrap is the audit baseline. SCN-8.3.2 retired the per-pass
sweep that previously ran from `scripts/validate_governance.sh` and
removed `scripts/check_agency_strings.sh`. The policy in
`validation/CONSISTENCY_RULES.md` §15 remains as a review-time
expectation, not an automated gate.
