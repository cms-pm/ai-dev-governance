# Acceptance Traceability — Phase 1 integration

Each acceptance ID maps to an implementation path, an evidence artifact, and a
status. Evidence paths resolve under `docs/releases/` or `docs/validation/`
per `governance.yaml` (SCN-1.1).

| ID | Chunk | Implementation Paths | Evidence Link | Status |
|----|-------|----------------------|---------------|--------|
| SCN-1.1-01 | SCN-1.1 | `governance.yaml`, `docs/governance/exceptions.yaml` | `docs/validation/scn-1.1/validate_governance.log` | pending |
| SCN-1.2-01 | SCN-1.2 | `runbooks/SUBMODULE_PINNING.md`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/validation/scn-1.2/matrix-diff.md` | pending |
| SCN-1.3-01 | SCN-1.3 | `.gitmodules`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/validation/scn-1.3/pin-evidence.md` | pending |
| SCN-1.4-01 | SCN-1.4 | `.rtk/`, `scripts/rtk-wrapper.sh`, `docs/releases/rtk/` | `docs/releases/rtk/v0.6.0-bundle.md` | pending |
| SCN-1.5-01 | SCN-1.5 | `contracts/governance-manifest.schema.json`, `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md` | `docs/validation/scn-1.5/schema-validate.log` | pending |
| SCN-1.6-01 | SCN-1.6 | `core/SECURITY_CONTROLS.md`, `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`, `scripts/run_graphify.sh`, `core/EVIDENCE_CONTRACT.md` | `docs/validation/scn-1.6/mode-switch-test.log` | pending |
| SCN-1.7-01 | SCN-1.7 | `README.md`, `core/PLANNING_METHODOLOGY.md`, `templates/` | `docs/validation/scn-1.7/motto-diff.md` | pending |
| SCN-2.1-01 | SCN-2.1 | upstream: `astaire/src/collections/governance_authoring.py` | `docs/validation/scn-2.1/collection-scan.log` | pending |
| SCN-2.2-01 | SCN-2.2 | `.claude/settings.json` | `docs/validation/scn-2.2/hook-trigger.log` | pending |
| SCN-2.3-01 | SCN-2.3 | `raw/`, `db/memory_palace.db` | `docs/validation/scn-2.3/first-ingest.log` | pending |
| SCN-2.4-01 | SCN-2.4 | `runbooks/RELEASE_PROCESS.md`, `docs/releases/` | `docs/releases/v0.6.0/evidence-bundle.md` | pending |
| SCN-3.1-01 | SCN-3.1 | `docs/planning/pool_questions/phase-3-graphify-spike.md`, `docs/planning/board/committee-review-packet-2026-04-20.md` | Board adopted 2026-04-20; all 7 decisions recorded in packet. Pending human sign-off commit. | board-adopted |
| SCN-3.2-01 | SCN-3.2 | upstream: `astaire/src/collections/graphify_outputs.py` | `docs/validation/scn-3.2/l0-routing-hint.log` | pending |
| SCN-3.3-01 | SCN-3.3 | upstream: `astaire/src/ingest_graphify.py`; manifest knobs: `promotionThreshold`, `promotionFloor`, `promotionCeiling`, `autoTune`, `pinnedNodes`, `inferredEdgeThreshold`, `crossRepoAuthority`, `annotateApprovalStatus`; `scripts/validate_graphify.sh` (stale-pin + pattern lint) | `docs/validation/scn-3.3/skeleton-promotion.log` | pending — unblocked by SCN-3.1 board gate |
| SCN-3.4-01 | SCN-3.4 | `.gitignore`, `graphify-out/` | `docs/validation/scn-3.4/dogfood-graph.md` | pending |
| SCN-3.5-01 | SCN-3.5 | `runbooks/GRAPHIFY_MCP_RUNBOOK.md` | `docs/validation/scn-3.5/mcp-handshake.log` | pending |
| SCN-4.0-01 | SCN-4.0 | `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`, routing grammar fixture | `docs/validation/scn-4.0/routing-parser.log` | pending |
| SCN-4.1-01 | SCN-4.1 | `templates/BOARD_REVIEW_PACKET_TEMPLATE.md` | `docs/validation/scn-4.1/packet-diff.md` | pending |
| SCN-4.2-01 | SCN-4.2 | `runbooks/BOARD_REVIEW_OPERATIONS.md` updates | `docs/validation/scn-4.2/chunk-context-trace.md` | pending |
| SCN-5.1-01 | SCN-5.1 | `CHANGELOG.md`, `VERSION`, `MIGRATION.md`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/releases/v0.6.0/` | pending |
