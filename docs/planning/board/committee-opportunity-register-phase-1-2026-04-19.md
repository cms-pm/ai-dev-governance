# Committee Opportunity Register — Phase 1 — 2026-04-19

Scope: Phase 1 (Foundations) of the Astaire/graphify/RTK integration. Seeded
at board composition approval; populated by sprint-critique, accountability
review, and incident lanes per `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`.

## Register Entries

| ID | Source Meeting | Severity | Opportunity / Gap | Required Adjustment | Owner | Target Window | Closure Evidence | Status |
|---|---|---|---|---|---|---|---|---|
| OPP-001 | SCN-3.1 board gate 2026-04-20 | Medium | Betweenness centrality not captured by degree-based god-node selection — architectural bridge nodes (e.g. API gateways with low edge count but high topological importance) are invisible to the current threshold. | Evaluate betweenness centrality as an optional supplement to degree centrality in a future SCN. Benchmark computational cost on 500+ node graphs before committing. Until then, consumers may use `pinnedNodes` as a manual escape hatch. | Accountable Delivery Lead | Phase 4 or post-v0.6.0 | Future SCN ADR benchmarking betweenness on ≥3 production repos | deferred |
| OPP-002 | SCN-3.1 board gate 2026-04-20 | High | No validation tooling exists to detect stale `pinnedNodes` entries (ghost nodes) or stale `crossRepoAuthority` namespace patterns after graph evolution. Without lint coverage, these misconfigurations silently degrade L0 quality. | Add `scripts/validate_graphify.sh` with two lint rules: (1) warn on `pinnedNodes` entries absent from current graph; (2) warn on `crossRepoAuthority` patterns matching zero nodes (excluding `*` wildcard). Integrate into CI and pre-release gate. | Methodology Steward | SCN-3.3 implementation scope | `validate_graphify.sh` test coverage in SCN-3.3 evidence bundle | open |
| OPP-003 | SCN-3.1 board gate 2026-04-20 | Medium | Cross-repo entity identity relies on fuzzy name matching. As multi-repo complexity grows, same-named entities in different repos may be genuinely distinct (two teams independently naming a class `EventPublisher`), leading to spurious merges that pollute the claim store. | Investigate globally unique contract IDs as an optional tagging scheme (`graphify.contractIdTag`). Deferred for now — `crossRepoAuthority` + `source_repo` tag provide adequate short-term protection. Revisit when any consumer repo reports a spurious merge incident. | Accountable Delivery Lead | Post-v0.6.0, incident-triggered or Phase 4 review | Incident report or architectural spike ADR | deferred |
| OPP-004 | SCN-3.1 board gate 2026-04-20 | Low | `annotateApprovalStatus` depends on the manifest contract registry being current. No freshness enforcement exists — a stale registry silently marks approved contracts as `unapproved`, causing agents to misread architectural hygiene state. | Add contract registry freshness check to `validate_graphify.sh`: warn if registry mtime > 30 days when `annotateApprovalStatus: true`. Document pairing requirement in the graphify context adapter. | Methodology Steward | SCN-3.3 implementation scope (if `annotateApprovalStatus` adopted by any consumer) | Lint rule present in `validate_graphify.sh`; context adapter updated | open |
| OPP-005 | SCN-3.1 board gate 2026-04-20 | Medium | `inferredEdgeThreshold` at low values (< 0.80) re-introduces false contradictions at rates comparable to full promotion. No recommended floor is currently enforced or documented in the context adapter. | Add recommended minimum floor of 0.85 to `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`. Consider adding a `validate_graphify.sh` warning when the configured value falls below 0.80. | Accountable Delivery Lead | SCN-3.3 documentation scope | Context adapter updated; optional lint rule added | open |

## Machine-Readable Register (JSON)

```json
[
  {
    "id": "OPP-001",
    "source": "SCN-3.1 board gate 2026-04-20",
    "severity": "medium",
    "status": "deferred",
    "owner": "Accountable Delivery Lead",
    "targetWindow": "Phase 4 or post-v0.6.0"
  },
  {
    "id": "OPP-002",
    "source": "SCN-3.1 board gate 2026-04-20",
    "severity": "high",
    "status": "open",
    "owner": "Methodology Steward",
    "targetWindow": "SCN-3.3"
  },
  {
    "id": "OPP-003",
    "source": "SCN-3.1 board gate 2026-04-20",
    "severity": "medium",
    "status": "deferred",
    "owner": "Accountable Delivery Lead",
    "targetWindow": "Post-v0.6.0 or incident-triggered"
  },
  {
    "id": "OPP-004",
    "source": "SCN-3.1 board gate 2026-04-20",
    "severity": "low",
    "status": "open",
    "owner": "Methodology Steward",
    "targetWindow": "SCN-3.3"
  },
  {
    "id": "OPP-005",
    "source": "SCN-3.1 board gate 2026-04-20",
    "severity": "medium",
    "status": "open",
    "owner": "Accountable Delivery Lead",
    "targetWindow": "SCN-3.3 documentation"
  }
]
```

## Closure Summary

- Closed this cycle: 0
- Deferred this cycle: 2 (OPP-001, OPP-003)
- Rejected this cycle: 0
- Open critical blockers: 0
- Open high items: 1 (OPP-002 — validate_graphify.sh lint coverage)
- Open medium items: 1 (OPP-005 — inferredEdgeThreshold floor guidance)
- Open low items: 1 (OPP-004 — annotateApprovalStatus freshness check)

## Linkage

- Board composition approval: `docs/planning/board/board-composition-approval-2026-04-19.md`
- Planning signoffs: `docs/planning/signoffs.md`
- Phase-1 risk log: `docs/planning/phase-1-risks.md`
- Traceability matrix: `docs/planning/traceability.md`
