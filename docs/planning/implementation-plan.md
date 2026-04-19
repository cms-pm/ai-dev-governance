# Implementation Plan — ai-dev-governance integration with Astaire, graphify, and RTK

Target release: **v0.6.0**.
Pool resolution: `docs/planning/pool_questions/phase-1-integration-pool.md`.
Risk log: `docs/planning/phase-1-risks.md`.
Traceability: `docs/planning/traceability.md`.
Board selection: `docs/planning/board/board-selection-dossier-2026-04-18.md`.

## Motto (promoted to core guidance in SCN-1.7)

> **Port-of-first-resort.** Every agent call begins at Astaire's L0. L0 answers
> the majority directly; otherwise it routes — to a deeper Astaire projection
> (L1/L2), to graphify for structural traversal, to RTK-gated shell inspection,
> or further out. Agents never bypass the router; tentacles extend the reach
> without fragmenting the memory.

## Phases

1. **Phase 1 — Foundations.** Self-governance manifest, submodule pinning,
   graphify contract + security surface, motto promotion. Exit when all SCN-1.x
   chunks are merged with green checks and release evidence seed committed.
2. **Phase 2 — Astaire memory palace.** Governance-authoring collection,
   repo-local hooks, raw corpus, release-evidence wiring. Exit when Astaire
   startup produces a non-empty L0 for this repo.
3. **Phase 3 — Graphify tentacle.** Spike and board gate, outputs collection,
   skeleton promotion importer, dogfood policy graph, MCP sidecar runbook.
   Exit when L0 surfaces a routing hint that a functioning agent can follow.
4. **Phase 4 — Board and agentic integration.** Routing contract, packet
   template amendment, chunk-context assembler pattern. Exit when a board
   pre-read packet is generated end-to-end using the new routing grammar.
5. **Phase 5 — Release.** Cut v0.6.0 with migration notes, compatibility
   matrix, full evidence bundle.

## Critical path

```
SCN-1.1 → SCN-1.5 → SCN-1.6 → SCN-2.1 → SCN-3.1 (board gate)
       → SCN-3.3 → SCN-4.0 → SCN-4.1 → SCN-5.1
```

Parallel tracks:

- **Foundations parallel:** SCN-1.2, SCN-1.3, SCN-1.4, SCN-1.7.
- **Astaire parallel:** SCN-2.2, SCN-2.3, SCN-2.4.
- **Graphify parallel:** SCN-3.2, SCN-3.4, SCN-3.5 (against mocks until
  SCN-3.1 adopts a bridge shape).
- **Integration parallel:** SCN-4.2.
- **Board-composition pre-staging:** runs now, in parallel with Phase 1
  execution, per recommendation (1)+(3).

## Risk-tier summary

| Tier | SCNs |
|---|---|
| low | 1.1, 1.2, 1.3, 1.4, 1.7, 2.2, 2.3, 2.4, 3.4, 3.5, 4.2 |
| medium | 1.5, 1.6, 2.1, 3.2, 4.0, 4.1, 5.1 |
| high | 3.1 (board gate), 3.3 |
| critical | none |

## Autonomous-delivery hand-off

Each chunk emits a machine-readable implementation-handoff record per
`contracts/implementation-handoff.schema.json` at transition into `gate` state.
High-tier chunks (3.1, 3.3) MUST include board linkage IDs from the selection
dossier. Risk-tier assignments, acceptance mappings, and evidence pointers are
defined in `docs/planning/chunks/phase-{1..5}-chunks.md` and
`docs/planning/traceability.md`.

## Exit conditions for Phase 1 planning gate

Already satisfied:

- [x] Pool questions resolved (score 0.0187 ≤ 0.10; confidence 4.54 ≥ 4.5).
- [x] Acceptance criteria defined per chunk.
- [x] Risks and mitigations logged.
- [x] Chunk-readiness criteria documented (tier, acceptance, validation, rollback, owner, SCN scope).

Pending:

- [ ] Human approver sign-off recorded in `docs/planning/signoffs.md`.
- [ ] Board composition approval (pre-staging active in parallel).
