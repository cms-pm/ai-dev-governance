# Board Opportunity Register Template

Copy target naming convention:
- `<planningPath>/board/committee-opportunity-register-<topic>-<YYYY-MM-DD>.md`

## Register Entries

| ID | Source Meeting | Severity | Opportunity / Gap | Required Adjustment | Owner | Target Window | Closure Evidence | Status (`Adopted/Deferred/Rejected`) |
|---|---|---|---|---|---|---|---|---|
| COM-001 | `<meeting-id>` | `<Critical|High|Medium|Low>` | `<gap>` | `<change request>` | `<owner>` | `<window>` | `<artifact/test>` | `<status>` |

## Machine-Readable Register (JSON)

```json
[
  {
    "opportunityId": "COM-001",
    "sourceMeetingId": "MTG-0001",
    "severity": "High",
    "gap": "...",
    "requiredAdjustment": "...",
    "owner": "...",
    "targetWindow": "YYYY-MM-DD",
    "closureEvidence": "...",
    "status": "Adopted"
  }
]
```

## Closure Summary

- Closed this cycle: `<count>`
- Deferred this cycle: `<count>`
- Rejected this cycle: `<count>`
- Open critical blockers: `<count>`
