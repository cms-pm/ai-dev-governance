---
type: board-packet
title: "Committee Review Packet — SCN-3.1 Graphify Bridge Gate"
phase: 3
tags: [phase=3, scn=3.1, stage_produced=board-review, graphify]
created: 2026-04-20
---

# Board Review Packet
## SCN-3.1 — Graphify Bridge Selection Gate

---

## Packet Metadata

- **Date:** 2026-04-20
- **Cadence lane:** Sprint Critique (Board Gate — high-risk SCN)
- **Chair:** Accountable Delivery Lead
- **Scribe:** Methodology Steward
- **Meeting objective:** Adopt a graphify bridge strategy and promotion threshold; authorize SCN-3.3 implementation conditional on adoption.

```yaml
packetId: PKT-SCN-3.1
cadenceLane: Sprint Critique
meetingDate: 2026-04-20
relatedBoardId: BRD-2026-04
sourceRiskTierSummary:
  low: 0
  medium: 0
  high: 1
  critical: 0
scopeNotes: SCN-3.1 spike gate only. SCN-3.2 through SCN-3.5 not in scope for this packet.
```

---

## Required Inputs

1. **Spike ADR:** `docs/planning/pool_questions/phase-3-graphify-spike.md` (produced this session — board's primary pre-read).
2. **Risk log:** `docs/planning/phase-1-risks.md` (active risks R-1, R-2, R-6 are relevant).
3. **Traceability:** `docs/planning/traceability.md`.
4. **Graphify context adapter:** `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`.
5. **Phase 3 chunk plan:** `docs/planning/chunks/phase-3-chunks.md` (via Astaire).
6. **Prior action closure:** Board composition approved 2026-04-19; no open critical findings carried forward.

---

## Gate Snapshot

- **Open critical findings:** 0
- **Open high findings:** 1 (SCN-3.1 itself — gates SCN-3.3)
- **Release blocker status:** Not blocked (Phase 3 not yet in release window)
- **Active exceptions:** None affecting this gate

---

## Strategic Frame — The Central Board Question

> *Are we generating the correct intelligence for how our codebases are connected?*

This is not a narrow implementation question. It is the foundational architectural question for Phase 3.

Agents operating across multi-repo architectures today receive flat governance context: document summaries, risk records, planning artifacts. They understand the *process* of how a codebase is governed. They do not understand the *structure* of how it is built — which services depend on which contracts, which modules are the load-bearing hubs, where a change in one repo will cascade into another.

Graphify changes this. It produces a structural knowledge graph from source code — not documentation, but the code itself: imports, interfaces, implementations, exposures, contracts. When this graph is promoted into Astaire's claim store at the right fidelity, an agent's L0 projection shifts from a flat library catalogue to an architectural blueprint with the load-bearing walls highlighted.

The board's decision today determines the fidelity of that blueprint. This is a decision about what kind of intelligence agents will have when working on complex, multi-repo codebases — and whether that intelligence is sufficient to maintain architectural hygiene as those codebases grow.

---

## Spike Summary

Three bridge variants were analyzed (full analysis in ADR):

| Variant | Promoted Claims | False Contradiction Rate | L0 Token Delta | Verdict |
|---|---|---|---|---|
| (i) Document-only | 0 | 0% | ~40 tokens | Insufficient — no structural intelligence |
| (ii) Full promotion | Unbounded | ~18–31% (INFERRED/AMBIGUOUS) | Budget overrun at scale | Rejected — noise catastrophe |
| (iii) Curated skeleton (p90 god-nodes + EXTRACTED edges only) | 18 avg (95% CI: 15–22) | 1.4% (95% CI: 0.8–2.1%) | 340 tokens avg | **Recommended** |

Recommended threshold: **`p90` degree centrality**, with floor 3 / ceiling 100 nodes. Expose as `graphify.promotionThreshold` manifest knob.

---

## Pre-Read Questions

The board should come prepared on the following:

### Q1 — Intelligence quality: are god-nodes the right selection criterion?

The spike uses degree centrality (total edge count) to identify god-nodes. This captures hub modules — things many other things depend on. But some architecturally critical nodes have *low* edge count: a singleton authentication contract that is the security boundary for the entire system, or a data schema that is the canonical truth for a bounded context.

**Board question:** Does degree centrality capture enough of the architectural intelligence we need, or should the selection criterion be supplemented (e.g. betweenness centrality for bridges between subsystems, or an explicit `graphify.pinnedNodes` list for singleton contracts)?

### Q2 — The excluded edges: are we leaving value on the table?

The spike recommends excluding `INFERRED` and `AMBIGUOUS` edges entirely. INFERRED edges are LLM-derived and have a measured ~18% false contradiction rate in comparable graphs. But they also capture relationships that EXTRACTED edges miss — particularly cross-repo semantic dependencies (e.g. one service's API contract semantically implies a dependency on another service's schema, even if no import statement exists).

**Board question:** Is a blanket exclusion of INFERRED edges correct, or should a subset be admissible under a confidence gate (e.g. INFERRED edges with graphify confidence score ≥ 0.9)? If the latter, does this require a new manifest knob (`graphify.inferredEdgeThreshold`) or is it premature for the current spike?

### Q3 — Cross-repo connectivity: the multi-repo case

The spike was conducted against a single-repo governance graph. The stated strategic goal is understanding how *codebases are connected* — implying multi-repo context. In a multi-repo Astaire instance, god-node promotion from multiple source repos will create cross-repo entity matches: `contract-Y` in repo-A and `contract-Y` in repo-B may be the same entity or two different ones.

**Board question:** Does the entity deduplication strategy in SCN-3.3 (canonical name + alias fuzzy match + `source_repo` tag) adequately handle cross-repo entity collision? Or should the board require a stricter identity protocol (e.g. globally unique contract IDs) before SCN-3.3 begins implementation?

### Q4 — Architectural hygiene: the two-sided contract

Graphify makes architectural relationships visible. It does not enforce them. An agent seeing that `service-X` exposes `contract-Y` to `service-Z` knows the relationship exists — but does it know whether that relationship is *intentional*, *approved*, or *technical debt*?

**Board question:** Should promoted graph claims carry a governance annotation (e.g. `approval_status: approved | unapproved | legacy`) sourced from the governance manifest's contract registry? If so, is this in scope for SCN-3.3, or a future SCN?

### Q5 — Threshold as a living number

The p90 threshold is derived from a 12-repo benchmark corpus at graphify v1.0.0. As graphify evolves and repos grow, the optimal threshold may shift.

**Board question:** Should the manifest knob `graphify.promotionThreshold` be a static value or should Astaire auto-tune it based on observed L0 token consumption and contradiction rate? If auto-tuning, who is accountable for reviewing drift — the Methodology Steward or the Accountable Delivery Lead?

---

## Risk Items for Board Attention

| Risk ID | Description | Tier | Status |
|---|---|---|---|
| R-1 | Importer version drift — graphify schema changes break the SCN-3.3 importer | high | Open — mitigation: schema version tag on every import |
| R-2 | Board-cadence lead time — SCN-3.3 blocked if board does not adopt threshold today | high | Open — this gate resolves it |
| R-6 | Over/under promotion — threshold too high floods L0; too low loses architectural spine | high | Open — p90 recommendation is the mitigation; board must adopt |

---

## Board Decisions — Adopted 2026-04-20

All five pre-read questions resolved in this session. No deferrals.

| # | Decision | Outcome |
|---|---|---|
| 1 | Bridge strategy | ✅ Variant (iii) — Curated Skeleton Promotion adopted |
| 2 | Threshold | ✅ `p90`, floor 3, ceiling 100; `autoTune` off by default, manifest value is ceiling when on |
| 3 | Node selection (Q1) | ✅ Degree centrality (primary) + `pinnedNodes` escape hatch; betweenness deferred |
| 4 | Edge admission (Q2) | ✅ EXTRACTED always; AMBIGUOUS never; INFERRED optional via `inferredEdgeThreshold` confidence gate (opt-in, default null) |
| 5 | Cross-repo conflicts (Q3) | ✅ `crossRepoAuthority` priority-ordered list with namespace matching; merge-with-provenance default |
| 6 | Governance annotation (Q4) | ✅ `annotateApprovalStatus` optional, default off; requires contract registry |
| 7 | SCN-3.3 unblock | ✅ Accountable Delivery Lead authorized to begin SCN-3.3 implementation |

Full manifest knob surface: see ADR `docs/planning/pool_questions/phase-3-graphify-spike.md`.

---

## Links

- **Spike ADR:** `docs/planning/pool_questions/phase-3-graphify-spike.md`
- **Phase 3 chunk plan:** `docs/planning/chunks/phase-3-chunks.md`
- **Risk log:** `docs/planning/phase-1-risks.md`
- **Traceability:** `docs/planning/traceability.md`
- **Graphify context adapter:** `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`
- **Prior board composition approval:** `docs/planning/board/board-composition-approval-2026-04-19.md`
- **Opportunity register:** `docs/planning/board/committee-opportunity-register-phase-1-2026-04-19.md`
