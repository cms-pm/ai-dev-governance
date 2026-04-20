# Phase 3 — Chunk Plans (Graphify tentacle)

Precondition: Phase 2 gate signed off and L0 non-empty for this repo. Phase 3
includes the highest-tier work in the plan; SCN-3.1 is a board-gated spike and
blocks SCN-3.3.

---

## SCN-3.1 — Graphify bridge/threshold spike (board gate)

- **Scope.** Timeboxed one-day spike producing an ADR in
  `docs/planning/pool_questions/phase-3-graphify-spike.md`. Compares actual
  behavior of three bridge variants on this repo's policy graph:
  (i) document-only registration, (ii) full claim-store promotion, (iii) the
  approved curated skeleton promotion (top-10% god-nodes + `EXTRACTED` edges).
  Measures: promoted claim count, false contradiction rate, token cost,
  L0-regeneration latency. Exits with a concrete threshold (percentile or
  absolute node count) and a confidence interval.
- **Acceptance IDs.** SCN-3.1-01.
- **Acceptance criteria.**
  - ADR exists and records the three variant runs on the same graph snapshot.
  - Spike evidence bundle attached to a board review packet.
  - Board adopts a threshold and, if warranted, exposes it as a manifest knob
    (`graphify.promotionThreshold`).
- **Validation method.** Manual — board-review adoption decision; ADR
  checked-in.
- **Risks.** Over/under promotion (R-6); importer version drift (R-1);
  board-cadence lead time (R-2).
- **Rollback.** If spike fails to converge, default remains document-only
  registration (SCN-3.2) and SCN-3.3 is deferred pending re-spike.
- **Owner.** Accountable Delivery Lead; Chairperson gates adoption.
- **Risk tier.** **high. Board review mandatory per
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Risk-Tiered Autonomy.**
- **Atomic PR scope.** `SCN-3.1`.

---

## SCN-3.2 — `graphify-outputs` collection with routing hint

- **Scope.** Upstream Astaire PR adding
  `src/collections/graphify_outputs.py`. Registers `GRAPH_REPORT.md` and
  `graph.json` with `source_repo`, `graph_version`, `run_date`, and
  `routing_hint` tags. On registration, invalidates `scope_key=global` so L0
  regenerates with a routing-hint line like:
  `"graphify: policy-graph available at graphify-out/ — use \`graphify query\` for path traversal"`.
- **Acceptance IDs.** SCN-3.2-01.
- **Acceptance criteria.**
  - After scanning a repo containing `graphify-out/`, `.astaire/astaire status` shows
    the routing hint in L0 output.
  - `.astaire/astaire query -c graphify-outputs --tag source_repo=<repo>` returns the
    registered artifacts.
  - Upstream Astaire tests cover both `split` and `unified`
    collectionStrategy variants.
- **Validation method.** Automated — Astaire tests + integration scan.
- **Risks.** Collision if two repos share the same `source_repo` tag.
  Mitigation: plugin normalizes tag to the git remote URL hash.
- **Rollback.** Revert upstream PR.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-3.2`.

---

## SCN-3.3 — Skeleton promotion importer

- **Scope.** Upstream Astaire PR adding `src/ingest_graphify.py`. Maps
  graphify nodes → entities, `EXTRACTED` edges → relationships with
  `epistemic_tag='confirmed'`. Only promotes top-10% god-nodes (or the
  threshold adopted by the SCN-3.1 board review). `INFERRED` and `AMBIGUOUS`
  edges are NOT imported. Deduplicates against existing entities via canonical
  name + alias fuzzy match. Writes `source_type='graphify'` on every imported
  claim. Per-graph L1 cache scoped `graph_version:<hash>`.
- **Acceptance IDs.** SCN-3.3-01.
- **Acceptance criteria.**
  - Running the importer on this repo's graphify output produces N claims
    where N equals the god-node count at the adopted threshold.
  - No `INFERRED` edges appear in the claim store after import.
  - Re-running the importer on an unchanged graph is a no-op (idempotence).
  - Re-running on a changed graph produces a clean diff: added/removed/updated
    claim counts logged.
- **Validation method.** Automated — upstream unit tests + integration test on
  a fixture graph.
- **Risks.** Importer drift (R-1); threshold mis-tuning (R-6). Mitigation:
  schema version tag on every import; threshold is a manifest knob.
- **Rollback.** Delete all `source_type='graphify'` claims via a one-shot
  script; DB retains structure for non-graphify claims.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** **high.** Requires board sign-off per the autonomous-delivery
  matrix.
- **Atomic PR scope.** `SCN-3.3`.

---

## SCN-3.4 — Dogfood policy graph

- **Scope.** Install `graphify hook install` in this repo (post-commit +
  post-checkout). Run graphify under the `restricted` security mode with an
  allowlist covering `core/**/*.md`, `adapters/**/*.md`, `runbooks/**/*.md`,
  `templates/**/*.md`, `README.md`. Commit `graphify-out/` excluding
  `graphify-out/cache/` via `.gitignore`. Import into Astaire via SCN-3.3
  importer.
- **Acceptance IDs.** SCN-3.4-01.
- **Acceptance criteria.**
  - `graphify-out/GRAPH_REPORT.md` committed.
  - `graphify-out/cache/` gitignored.
  - `.astaire/astaire query -c graphify-outputs --tag source_repo=ai-dev-governance`
    returns artifacts.
  - L0 shows a routing hint referring to the policy graph.
- **Validation method.** Manual — inspect committed artifacts; run `.astaire/astaire
  status` and verify routing line.
- **Risks.** Security-mode misconfiguration leaks content (R-4). Mitigation:
  `scripts/run_graphify.sh` enforcement wrapper from SCN-1.6.
- **Rollback.** `graphify hook uninstall`; remove `graphify-out/`.
- **Owner.** Methodology Steward.
- **Risk tier.** low (dogfood of previously-approved surface).
- **Atomic PR scope.** `SCN-3.4`.

---

## SCN-3.5 — MCP sidecar runbook (optional tentacle)

- **Scope.** `runbooks/GRAPHIFY_MCP_RUNBOOK.md` covering `python -m
  graphify.serve graphify-out/graph.json` setup, registration in an
  `.mcp.json`, and the agent-facing mental model ("Astaire L0 routes; MCP
  exposes graph tools when an agent needs direct traversal"). No core-policy
  change; purely adapter-level.
- **Acceptance IDs.** SCN-3.5-01.
- **Acceptance criteria.**
  - Runbook contains working examples for Claude Code, Codex, and a generic
    MCP-capable client.
  - Steps match graphify's current CLI; validated against graphify v1.0.0.
  - Runbook cross-referenced from `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`.
- **Validation method.** Manual — execute the steps on a fresh workspace.
- **Risks.** Graphify CLI changes break runbook examples (R-1). Mitigation:
  runbook pinned to the compatibility matrix row.
- **Rollback.** Remove runbook.
- **Owner.** Methodology Steward.
- **Risk tier.** low.
- **Atomic PR scope.** `SCN-3.5`.
