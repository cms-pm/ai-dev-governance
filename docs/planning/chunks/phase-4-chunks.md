# Phase 4 — Chunk Plans (Board and agentic integration)

Precondition: SCN-3.3 promoted and L0 surfaces a routing hint.

---

## SCN-4.0 — Routing contract

- **Scope.** Document the L0 hand-off grammar agents use when Astaire routes
  them onward. Define the routing-hint payload (tentacle name, target address,
  token budget, expected return shape), the vocabulary of tentacle names
  (`astaire.l1`, `astaire.l2`, `graphify.report`, `graphify.query`,
  `graphify.mcp`, `rtk.shell`), and a parser fixture so every consumer can
  verify their agent reads it correctly. Captured in
  `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md` (generalized), plus an
  addition to Astaire's plugin contract upstream.
- **Acceptance IDs.** SCN-4.0-01.
- **Acceptance criteria.**
  - Routing-hint grammar documented with BNF or equivalent precise form.
  - Fixture file `tests/fixtures/routing_hints.md` in Astaire parses
    unambiguously.
  - Adapter doc lists the tentacle vocabulary with canonical semantics.
- **Validation method.** Automated — fixture parser tests.
- **Risks.** Grammar too rigid blocks future tentacles; too loose erodes
  routing reliability (R-5). Mitigation: grammar includes `tentacle=<name>`
  registry semantics so adding a tentacle is additive, not breaking.
- **Rollback.** Revert grammar spec; routing hints become free-text
  (documented regression).
- **Owner.** Methodology Steward.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-4.0`.

---

## SCN-4.1 — Board packet template amendment

- **Scope.** Add a "Structural Context" section to
  `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`. Required subsections: god-nodes
  list (from graphify), surprising connections (ranked), open AMBIGUOUS-edge
  backlog, open contradictions (from Astaire lint). Pre-read generation step
  documented in `runbooks/BOARD_REVIEW_OPERATIONS.md`.
- **Acceptance IDs.** SCN-4.1-01.
- **Acceptance criteria.**
  - Template contains the new section with required subsection headers.
  - Runbook shows the command sequence to populate the section
    (`astaire context --tag board-packet=<id>` + `graphify query` snippets).
  - Existing board packet examples in `worked/` or `validation/` still match
    the template or are explicitly marked as pre-amendment.
- **Validation method.** Manual — diff review; runbook dry-run.
- **Risks.** Consumers running older board cadence miss the section.
  Mitigation: MIGRATION.md entry for v0.6.0.
- **Rollback.** Revert template and runbook changes.
- **Owner.** Methodology Steward.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-4.1`.

---

## SCN-4.2 — Chunk-context assembler pattern

- **Scope.** Document a standard recipe in `runbooks/BOARD_REVIEW_OPERATIONS.md`
  and the Astaire adapter guide: agents begin with `astaire startup` + L0,
  call `astaire context --tag chunk=<SCN>` for chunk-level assembly, and shell
  to `graphify query "..."` when L0 routes them there — all within a shared
  token budget that aligns with `core/PLANNING_METHODOLOGY.md` §Context
  Management.
- **Acceptance IDs.** SCN-4.2-01.
- **Acceptance criteria.**
  - Recipe documented with budget math (default: 12K tokens total, 2K L0, 4K
    L1, 6K graphify).
  - Example trace committed at `docs/validation/scn-4.2/chunk-context-trace.md`
    showing a real assembly for SCN-3.3.
- **Validation method.** Manual — trace inspected, budgets verified.
- **Risks.** Recipe drift across provider adapters (Claude vs Codex).
  Mitigation: recipe lives in provider-agnostic runbook with provider-specific
  notes in each `adapters/providers/` doc.
- **Rollback.** Revert docs.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-4.2`.
