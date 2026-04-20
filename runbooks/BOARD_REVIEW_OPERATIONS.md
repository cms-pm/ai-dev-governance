# Board Review Operations Runbook

## Purpose

Operational procedure for running board review governance in consuming repositories.

## Required Inputs

- Governance manifest with `boardReview` configured
- Current risk log
- Current traceability and evidence status
- Prior meeting action closure report
- Current approved board composition and member profiles

## Operating Cadence

1. Weekly sprint critique during active delivery.
2. Monthly accountability review.
3. Incident review within 24 hours of critical governance breach.
4. Quarterly composition refresh (or incident-triggered refresh).

## Board Selection and Composition Workflow

1. Define seat roles and required lenses.
2. Prepare candidate longlist and corpus sources.
3. Score candidates (`Prominence`, `CorpusDepth`, `RoleFit`, `EvidenceAccessibility`, `RecencyRelevance`).
4. Propose composition with primary and alternate per seat.
5. Run conflict checks and coverage checks.
6. Obtain human chair approval.
7. Publish composition artifacts.

## Execution Steps

1. Create packet from `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`.
2. If the consumer repository has a local overlay in `docs/governance/amendments/`, load any project-local board addenda after the upstream template.
3. Assemble structural context before the meeting:
   - `.astaire/astaire context --tag board-packet=<id> --budget 12000`
   - `scripts/rtk-local.sh read graphify-out/GRAPH_REPORT.md`
   - `scripts/rtk-local.sh read graphify-out/graph.json`
   - `.astaire/astaire lint`
4. Populate the `Structural Context` section:
   - `God Nodes` from `GRAPH_REPORT.md`
   - `Surprising Connections` from `GRAPH_REPORT.md`
   - `AMBIGUOUS-Edge Backlog` from `graphify-out/graph.json`
   - `Open Contradictions` from `.astaire/astaire lint`
5. Run meeting using `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`.
6. Update opportunity register using `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`.
7. Emit structured findings and decision artifacts.
8. During the review itself, compose immediate implementation directives in the packet:
   - PR/workstream scope
   - file ownership
   - validation/evidence expectations
   - release-blocking posture
9. Emit implementation handoff artifact for adopted actions.
10. Integrate adopted actions into planning/TDR/risk artifacts.
11. Update validation traceability and closure evidence.

## Chunk-Context Assembler Pattern

Default shared budget: `12K` tokens total.

- `2K` — L0 router (`.astaire/astaire status` or cached L0)
- `4K` — Astaire chunk context (`.astaire/astaire context --tag chunk=<SCN> --budget 4000`)
- `6K` — Graphify traversal or report reads (`graphify query`, `GRAPH_REPORT.md`, or MCP)

Recipe:

1. `.astaire/astaire startup --root .`
2. `.astaire/astaire context --tag chunk=<SCN> --budget 4000`
3. Follow any `route:` lines in L0.
4. Use `scripts/rtk-local.sh` for shell-visible graphify or evidence commands.
5. Record the final assembly trace under `docs/validation/scn-4.2/`.

## Release Gate Implication

- Release is blocked if unresolved critical board findings exist and no approved exception covers them.

## Artifacts Checklist

- Board packet
- Meeting record
- Opportunity register update
- Structured finding records
- Structured decision records
- Structured implementation handoff
- Risk update
- Traceability update
- Sign-off record
- Composition approval record
