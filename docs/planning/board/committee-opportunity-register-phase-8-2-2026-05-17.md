# Committee Opportunity Register — Phase 8.2 — 2026-05-17

Adopted opportunities arising from the SCN-8.2.2 board review packet
(`docs/planning/board/committee-review-packet-2026-05-17-scn-8-2-2.md`).
Each adopted opportunity maps to a chunk in
`docs/planning/chunks/phase-8.2-chunks.md` and closes when that chunk's
acceptance evidence lands.

## Register Entries

| ID | Source Meeting | Severity | Opportunity / Gap | Required Adjustment | Owner | Target Window | Closure Evidence | Status |
|---|---|---|---|---|---|---|---|---|
| OPP-8.2-001 | MTG-0002 / SCN-8.2.2 board review 2026-05-17 (packet `committee-review-packet-2026-05-17-scn-8-2-2.md`, Q4) | High | Phase 8.1 in-flight cohort (branches `chunk-8.1.0-*` through `chunk-8.1.3-*`) and Phase 8.2 share `core/` acceptance-bar surface without a coordinated grandfathering protocol or bidirectional risk-log cross-reference. The new Power of 10 clauses introduced under SCN-8.2.2 (`5d47359`) silently raise the acceptance bar for any Phase 8.1 production code touched on or after the adoption commit. | Author a new chunk SCN-8.2.6 that (a) extends `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Grandfathering with a Cross-Phase In-Flight Coordination clause anchored to SHA `5d47359`; (b) opens R-8.2-05 in the Phase 8.2 risk log with a closure criterion requiring a reciprocal entry in the Phase 8.1 risk log; (c) adds a Cross-Phase Risk References appendix formalising the bidirectional protocol for future phases. | Accountable Delivery Lead | Before SCN-8.2.5 sign-off | SCN-8.2.6 landed at `01d3f00`; clause present in core file; R-8.2-05 + appendix present in `docs/planning/phase-8.2-risks.md`; `scripts/validate_governance.sh` exits 0; Astaire lint 0/0. | closed |

## Machine-Readable Register (JSON)

```json
[
  {
    "opportunityId": "OPP-8.2-001",
    "sourceMeetingId": "MTG-0002",
    "sourceMeetingAlias": "SCN-8.2.2-board-review-2026-05-17",
    "sourceMeetingRecord": "docs/planning/board/committee-virtual-meeting-scn-8-2-2-p10-adoption-2026-05-17.md",
    "sourcePacket": "docs/planning/board/committee-review-packet-2026-05-17-scn-8-2-2.md",
    "sourceQuestion": "Q4",
    "severity": "High",
    "gap": "Phase 8.1 in-flight cohort (branches chunk-8.1.0-* through chunk-8.1.3-*) and Phase 8.2 share core/ acceptance-bar surface without a coordinated grandfathering protocol or bidirectional risk-log cross-reference.",
    "requiredAdjustment": "Author SCN-8.2.6 chunk extending core grandfathering with Cross-Phase In-Flight Coordination clause anchored to SHA 5d47359; open R-8.2-05 with reciprocal-entry closure criterion; add Cross-Phase Risk References appendix.",
    "owner": "Accountable Delivery Lead",
    "targetWindow": "before SCN-8.2.5 sign-off",
    "closureEvidence": "SCN-8.2.6 landed at 01d3f00; validate_governance.sh exit 0; Astaire lint 0/0; reciprocal Phase 8.1 entry tracked under R-8.2-05.",
    "outcome": "Adopted",
    "status": "closed",
    "linkedChunk": "SCN-8.2.6",
    "linkedRisk": "R-8.2-05",
    "barShiftAnchorSha": "5d47359",
    "closureCommit": "01d3f00"
  }
]
```

## Closure Summary

- Closed this cycle: 1 (OPP-8.2-001 closed by SCN-8.2.6 commit `01d3f00`;
  residual reciprocal Phase 8.1 tracking remains open under R-8.2-05).
- Deferred this cycle: 0.
- Rejected this cycle: 0.
- Open critical blockers: 0.
- Open high opportunities awaiting closure: 0.
