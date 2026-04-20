# Phase 1 Pool — ai-dev-governance integration with Astaire, graphify, and RTK

## Goal

Integrate three named adapters into `ai-dev-governance` so the methodology repo
becomes self-governed, routes every agent call through a memory-palace
port-of-first-resort, and exposes structural-graph intelligence to board reviews
and chunk planning without fragmenting the knowledge surface.

## Scope

- Self-governance scaffolding for this repo (`governance.yaml`, exceptions
  registry, release evidence bundle).
- Submodule pinning and compatibility matrix seed for `astaire` and `graphify`.
- Contract and adapter surface for graphify (manifest schema block, adapter doc,
  security modes, enforcement wrapper).
- Astaire-side collection plugin covering governance-authoring artifacts plus
  repo-local hooks and raw-corpus scaffolding.
- Graphify tentacle routed through Astaire (skeleton promotion importer,
  routing-hint tags, MCP sidecar documentation).
- Board review integration (packet template amendment, routing contract,
  chunk-context assembler pattern).
- v0.6.0 release carrying the above with migration notes.

## Non-goals

- Shipping downstream-consumer reference implementations beyond the one already
  embodied by Astaire.
- Redesigning the claim store schema inside Astaire.
- Introducing new providers beyond `providers/claude` and `providers/codex`.
- Adding web UI or vector-database dependencies to any of the three repos.
- Changing the core state machine in `AUTONOMOUS_DELIVERY_GOVERNANCE.md`.

## Principles adopted

**Port-of-first-resort.** Every agent call begins at Astaire's L0. L0 answers
the majority directly; otherwise it routes — to a deeper Astaire projection
(L1/L2), to graphify for structural traversal, to RTK-gated shell inspection,
or further out. Agents never bypass the router; tentacles extend the reach
without fragmenting the memory.

This principle is promoted to `core/` guidance in SCN-1.7 and echoed in
`templates/` CLAUDE.md-pattern content for downstream consumers.

## Questions and Resolutions

Ambiguity scoring follows `core/PLANNING_METHODOLOGY.md`:

`score = sum(P * U * M * I) / sum(I)` with `P ∈ [0,1]`, `U ∈ {0, 0.5, 1.0}`,
`M ∈ [0,1]`, `I ∈ [1,5]`. Confidence `c ∈ [1,5]` per the standard rubric.

### Q1 — Topology and role of Astaire relative to this repo

**Resolution.** Option (a): Astaire is a one-way reference-implementation
tentacle. `ai-dev-governance` keeps `astaire/` as a submodule. Astaire drops
its own `ai-dev-governance` submodule (already merged upstream at commit
`c740232`) and instead pins ai-dev-governance as a version string declared in
its governance manifest plus a docs pointer.

**Rationale.** Clean dependency DAG; independent release cadence; Astaire
remains strict-baseline-governed via a pinned-version declaration rather than
an embedded submodule; dogfooding stays intact because every ai-dev-governance
consumer can see a canonical strict-baseline implementation.

**Score.** `P=0.05 U=0 M=0.9 I=5 c=5` — `P·U·M·I = 0`.

### Q2 — Graphify data bridge into Astaire

**Resolution.** Hybrid routing-first model: Astaire is always the port of
first resort. `graphify-outputs` is registered as an Astaire collection at
document-registry level (GRAPH_REPORT.md + graph.json). A curated skeleton
promotion importer lifts only god-nodes (top 10% by degree, starting
threshold) and `EXTRACTED` edges into the claim store; `INFERRED` and
`AMBIGUOUS` edges stay in graphify and are reachable via `graphify query` or
the MCP sidecar.

**Rationale.** Keeps claim-store high-signal while preserving full graph
fidelity in graphify's native format. Agents always begin at Astaire's L0
which contains a routing hint to the available graph. The threshold is tuned
during SCN-3.1 spike under board review.

**Score.** `P=0.10 U=0.5 M=0.8 I=5 c=4` — `P·U·M·I = 0.20`.

### Q3 — Graphify scope

**Resolution.** Option (c) split-by-default with a documented override to
option (d) unified. Manifest declares `graphify.collectionStrategy:
split|unified`. Strict-baseline default is `split`: separate
`graphify-policy-graph` and `graphify-consumer-graph` collections. Consumers
may declare `unified` when they have one authoritative source tree and no
policy-graph of their own; the invariant `source_repo` tag MUST be present
under either strategy, so this remains an adapter option rather than a
strictness relaxation.

**Rationale.** Default preserves clean routing for dogfood + downstream;
override accommodates single-tree consumers without violating the
non-weakening rule.

**Score.** `P=0.10 U=0 M=0.6 I=4 c=5` — `P·U·M·I = 0`.

### Q4 — Privacy and security surface for graphify

**Resolution.** Option (c) hybrid disclosure plus tiered security modes.
`core/SECURITY_CONTROLS.md` gains a one-paragraph hook for
"data-transmitting adapters" that points at the adapter doc; full threat
model lives in `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`. The adapter
defines three modes — `full`, `restricted`, `code-only` — and the strict
baseline defaults to `restricted` with an explicit allowlist. `full` requires
an exception entry; `code-only` is always permitted.

**Rationale.** Matches the pattern RTK already uses (named in core, detailed
in adapter). Tiered modes let regulated consumers disable LLM-backed
extraction entirely without forking the pipeline. Evidence contract is
updated to record the mode used at release time.

**Score.** `P=0.10 U=0 M=0.5 I=5 c=5` — `P·U·M·I = 0`.

### Q5 — Submodule pin targets and cadence

**Resolution.**

- `astaire`: commit SHA `c740232` as a short-lived bridge pin; swap to tag
  `v0.3.0` once cut upstream. Refresh quarterly after the swap; emergency
  patch lane for security fixes.
- `graphify`: tag `v1.0.0`. Refresh monthly given the active cadence
  observed across v0.4.x (23 patches); emergency-patch lane for CVE or
  regression.
- Compatibility matrix seed row: `ai-dev-governance v0.6.0 → astaire
  c740232 (pending v0.3.0), graphify v1.0.0`.

**Rationale.** `astaire v0.2.0` predates the topology decision (it still
carried the `ai-dev-governance` submodule) and the MIT→Apache 2.0 license
change; SHA pin is a time-bounded bridge. `graphify v1.0.0` is the latest
stable semver tag away from the `v4` branch tip.

**Score.** `P=0.05 U=0 M=0.5 I=3 c=5` — `P·U·M·I = 0`.

## Working assumptions carried (lower-weight items not escalated to questions)

| ID | Assumption | P | U | M | I | c |
|---|---|---|---|---|---|---|
| A4 | This repo is strict-baseline-governed by `governance.yaml` declared in SCN-1.1. | 0.1 | 0.5 | 0.7 | 4 | 5 |
| B1 | A new Astaire collection `governance-authoring` covers this repo's own policy/template/adapter/runbook artifacts. | 0.15 | 0.5 | 0.5 | 4 | 4 |
| B2 | `raw/` at repo root holds articles, papers, transcripts, notes for claim-pipeline ingest. | 0.1 | 0.5 | 0.4 | 3 | 5 |
| B3 | Astaire runs in-tree via `uv run` with UserPromptSubmit and post-commit hooks mirroring Astaire's own conventions. | 0.1 | 0.5 | 0.6 | 3 | 5 |
| B4 | Release bundle includes an L0 snapshot and lint health report alongside RTK evidence. | 0.1 | 0 | 0.3 | 2 | 5 |
| C3 | `graphify hook install` runs post-commit; `graphify-out/` committed (excluding `cache/`). | 0.1 | 0.5 | 0.4 | 3 | 5 |
| D1 | Graph insights enter board packets via template amendment only; no core policy change. | 0.15 | 0.5 | 0.6 | 4 | 4 |
| D2 | Chunk planning, board pre-reads, and implementation handoff all use `.astaire/astaire context` + `graphify query` under a shared token budget. | 0.15 | 0.5 | 0.6 | 4 | 4 |
| D3 | Structural/graph lens fits under the existing domain-specific lens allowance; no core-policy amendment required. | 0.1 | 0 | 0.4 | 3 | 5 |
| E1 | `governance.yaml`, `.rtk/` wrapper, and `docs/releases/rtk/` bundle satisfy the RTK adapter contract for this repo. | 0.05 | 0 | 0.5 | 3 | 5 |
| E2 | Standard RTK hook rewrites cover `uv run astaire` and `graphify` shell invocations; no custom rules required. | 0.1 | 0.5 | 0.3 | 3 | 4 |
| F1 | Risk tiers assigned per SCN in the chunk plan match the autonomous-delivery matrix. | 0.1 | 0.5 | 0.5 | 3 | 4 |

## Aggregate Ambiguity Score

Contributions:

| Item | P·U·M·I |
|---|---|
| Q1 | 0.000 |
| Q2 | 0.200 |
| Q3 | 0.000 |
| Q4 | 0.000 |
| Q5 | 0.000 |
| A4 | 0.140 |
| B1 | 0.150 |
| B2 | 0.060 |
| B3 | 0.090 |
| B4 | 0.000 |
| C3 | 0.060 |
| D1 | 0.180 |
| D2 | 0.180 |
| D3 | 0.000 |
| E1 | 0.000 |
| E2 | 0.045 |
| F1 | 0.075 |

Sum of `P·U·M·I` = **1.180**.
Sum of `I` = **63**.
Aggregate ambiguity = **1.180 / 63 ≈ 0.0187**.

Confidence weighted average = `sum(c·I) / sum(I)` = `286 / 63` ≈ **4.54**.

Both gates for the strict-baseline profile pass:

- Ambiguity ≤ 0.10: **PASS** (0.0187).
- Confidence ≥ 4.5: **PASS** (4.54).

## Remaining Risks

Captured in `docs/planning/phase-1-risks.md`. Highest residual items:

- **R-1** Graphify importer drift across upstream versions (C1/C2 carry the
  most residual uncertainty because the importer is novel and graphify is on
  an active release cadence).
- **R-2** Board cadence lead time for SCN-3.1 gate may extend Phase 3.
- **R-3** Astaire `v0.3.0` tag is an upstream dependency outside this repo's
  control; SHA bridge mitigates but does not eliminate exposure.

## Decision Record

- Status: **resolved**.
- Approver: **PENDING — accountable human approver required per
  `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability.**
- Decision timestamp: TBD on signoff.
- Immutable trace: this document's commit SHA once merged.

## Artifact Links

- Risk log: `docs/planning/phase-1-risks.md`
- Chunk plans: `docs/planning/chunks/phase-{1..5}-chunks.md`
- Traceability: `docs/planning/traceability.md`
- Implementation plan: `docs/planning/implementation-plan.md`
- Board selection dossier: `docs/planning/board/board-selection-dossier-2026-04-18.md`
