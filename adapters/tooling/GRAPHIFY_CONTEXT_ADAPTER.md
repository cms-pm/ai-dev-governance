# Graphify Context Adapter

## Purpose

Defines governance guardrails for teams using **graphify** — the
knowledge-graph tentacle that extracts entity/relationship structure from
source repositories and emits `EXTRACTED | INFERRED | AMBIGUOUS`-tagged
graph artifacts for board-review pre-reads and agent context assembly.

Graphify sits behind Astaire's L0 per the **port-of-first-resort**
principle: agents never call graphify directly; they reach it when L0
routes a structural query to it.

## Applicability

- Strict-baseline consumers that use graphify to index this repo or any
  consumed repo MUST declare a `graphify` object in the governance
  manifest.
- Consumers that do NOT use graphify MAY omit the `graphify` object.
- If declared, `tooling/rtk` MUST also be declared in `adapters` so that
  graphify's CLI output benefits from RTK compression.

## Required Setup

- Pin the graphify submodule at a named tag in `.gitmodules`. Current
  pinned tag: `v1.0.0` (commit `0a31c08`).
- Wrap all graphify invocations through `scripts/run_graphify.sh` (added
  in SCN-1.6). Never invoke the upstream `graphify` CLI directly.
- Wire graphify outputs to land in Astaire under the collection namespace
  declared by `graphify.collectionStrategy` (see below).

## Collection Strategies

Set `graphify.collectionStrategy` in the governance manifest:

- **`split`** — graphify writes to its own Astaire collection
  (`graphify-outputs`), keeping structural-graph artifacts separate from
  governance SDLC artifacts. Recommended for repos whose graph is large
  or evolves on a different cadence than governance artifacts.
- **`unified`** — graphify writes into the consumer repo's primary
  collection (e.g. `ai-dev-governance`) with `doc_type = graphify-export`.
  Recommended for small repos where the graph is tightly coupled to the
  SDLC artifacts it describes.

## Security Modes

Set `graphify.securityMode`:

| Mode | What graphify may ingest | LLM extraction | Use when |
|---|---|---|---|
| `full` | every file matching `allowlist` minus the `.graphifyignore` denylist | yes | NEVER without a matching exception in `docs/governance/exceptions.yaml` |
| `restricted` | only paths in `allowlist`; a curated denylist removes secret patterns | yes | default for repos containing any non-public content |
| `code-only` | only source-code extensions (`*.py *.ts *.rs *.go *.java *.md`) | disabled (structural extraction only) | public repos where LLM-powered extraction is a cost or exfiltration concern |

`full` mode is **fail-closed by default**: `scripts/run_graphify.sh` exits
non-zero if the manifest declares `full` without a matching exception
entry. This is enforced in SCN-1.6.

## Required Invariant

- Every node and edge emitted by graphify MUST carry a `source_repo` tag
  identifying the repository the artifact came from. This invariant
  preserves provenance when multiple repos feed the same Astaire
  instance.
- Set `graphify.sourceRepoTag` in the manifest to the canonical tag
  (default: repo directory name).

## MCP Sidecar (optional)

Graphify ships an MCP stdio server that lets an agent query the graph
interactively. Enable by setting `graphify.mcpSidecar: true`. When enabled:

- The runbook at `runbooks/GRAPHIFY_MCP_SIDECAR.md` (to be added in
  SCN-3.5) MUST be the canonical operations reference.
- MCP queries MUST route through Astaire L0 first; the sidecar is a
  tentacle, not a bypass.

## Release Evidence

Per `core/EVIDENCE_CONTRACT.md` §Release Evidence (amended in SCN-1.6),
release bundles for repos using graphify MUST include:

- `graphify.securityMode` (verbatim from manifest).
- `graphify.allowlistHash` — SHA-256 of the sorted `allowlist`.
- `graphify` CLI version + commit SHA (from the pinned submodule).
- A sample L0 projection showing at least one `source_repo`-tagged node
  to demonstrate the invariant is observed.

## Non-Weakening Invariant

Local governance overlays (per
`templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md`) MAY tighten graphify
controls — e.g. downgrade `restricted` to `code-only`, shrink the
allowlist, disable the MCP sidecar. Overlays MUST NOT relax them. In
particular, no overlay may upgrade `securityMode` toward `full` without
an exception entry.

## Required Mapping

- Declare the `graphify` object in `governance.yaml`.
- Register `scripts/run_graphify.sh` in the release-evidence path declared
  by `evidence.releasePath`.
- Downstream consumers of the graph (e.g. Astaire L0 projections, board
  pre-read packets) MUST cite `graphify.sourceRepoTag` when rendering
  graph-derived claims.
