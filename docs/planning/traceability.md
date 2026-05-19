# Acceptance Traceability — Phase 1 integration

Each acceptance ID maps to an implementation path, an evidence artifact, and a
status. Evidence paths resolve under `docs/releases/` or `docs/validation/`
per `governance.yaml` (SCN-1.1).

| ID | Chunk | Implementation Paths | Evidence Link | Status |
|----|-------|----------------------|---------------|--------|
| SCN-1.1-01 | SCN-1.1 | `governance.yaml`, `docs/governance/exceptions.yaml` | `docs/validation/scn-1.1/validate_governance.log` | pending |
| SCN-1.2-01 | SCN-1.2 | `runbooks/SUBMODULE_PINNING.md`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/validation/scn-1.2/matrix-diff.md` | pending |
| SCN-1.3-01 | SCN-1.3 | `.gitmodules`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/validation/scn-1.3/pin-evidence.md` | pending |
| SCN-1.4-01 | SCN-1.4 | `.rtk/`, `scripts/rtk-local.sh`, `docs/releases/rtk/` | `docs/releases/rtk/v0.6.0-bundle.md` | released |
| SCN-1.5-01 | SCN-1.5 | `contracts/governance-manifest.schema.json`, `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md` | `docs/validation/scn-1.5/schema-validate.log` | pending |
| SCN-1.6-01 | SCN-1.6 | `core/SECURITY_CONTROLS.md`, `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`, `scripts/run_graphify.sh`, `core/EVIDENCE_CONTRACT.md` | `docs/validation/scn-1.6/mode-switch-test.log` | pending |
| SCN-1.7-01 | SCN-1.7 | `README.md`, `core/PLANNING_METHODOLOGY.md`, `templates/` | `docs/validation/scn-1.7/motto-diff.md` | pending |
| SCN-2.1-01 | SCN-2.1 | upstream: `astaire/src/collections/governance_authoring.py` | `docs/validation/scn-2.1/collection-scan.log` | pending |
| SCN-2.2-01 | SCN-2.2 | `.claude/settings.json` | `docs/validation/scn-2.2/hook-trigger.log` | pending |
| SCN-2.3-01 | SCN-2.3 | `raw/`, `db/memory_palace.db` | `docs/validation/scn-2.3/first-ingest.log` | pending |
| SCN-2.4-01 | SCN-2.4 | `runbooks/RELEASE_PROCESS.md`, `docs/releases/` | `docs/releases/v0.6.0/evidence-bundle.md` | released |
| SCN-3.1-01 | SCN-3.1 | `docs/planning/pool_questions/phase-3-graphify-spike.md`, `docs/planning/board/committee-review-packet-2026-04-20.md` | Board adopted 2026-04-20; all 7 decisions recorded in packet. Pending human sign-off commit. | board-adopted |
| SCN-3.2-01 | SCN-3.2 | upstream: `astaire/src/collections/graphify_outputs.py` | `docs/releases/astaire/v0.3.0-bundle.md` | released |
| SCN-3.3-01 | SCN-3.3 | upstream: `astaire/src/ingest_graphify.py`; manifest knobs: `promotionThreshold`, `promotionFloor`, `promotionCeiling`, `autoTune`, `pinnedNodes`, `inferredEdgeThreshold`, `crossRepoAuthority`, `annotateApprovalStatus`; `scripts/validate_graphify.sh` (stale-pin + pattern lint) | `docs/releases/astaire/v0.3.0-bundle.md` | released |
| SCN-3.4-01 | SCN-3.4 | `.gitignore`, `graphify-out/` | `docs/releases/v0.6.0/evidence-bundle.md` | released |
| SCN-3.5-01 | SCN-3.5 | `runbooks/GRAPHIFY_MCP_RUNBOOK.md` | `docs/releases/v0.6.0/evidence-bundle.md` | released |
| SCN-4.0-01 | SCN-4.0 | `adapters/tooling/GRAPHIFY_CONTEXT_ADAPTER.md`, routing grammar fixture | `docs/releases/astaire/v0.3.0-bundle.md` | released |
| SCN-4.1-01 | SCN-4.1 | `templates/BOARD_REVIEW_PACKET_TEMPLATE.md` | `docs/planning/board/committee-review-packet-2026-04-20-release-closeout.md` | released |
| SCN-4.2-01 | SCN-4.2 | `runbooks/BOARD_REVIEW_OPERATIONS.md` updates | `docs/planning/board/committee-review-packet-2026-04-20-release-closeout.md` | released |
| SCN-5.1-01 | SCN-5.1 | `CHANGELOG.md`, `VERSION`, `MIGRATION.md`, `runbooks/COMPATIBILITY_MATRIX.md` | `docs/releases/v0.6.0/evidence-bundle.md` | released |
| SCN-8.2.0-01 | SCN-8.2.0 | `docs/planning/chunks/phase-8.2-chunks.md` | — | pending |
| SCN-8.2.0-02 | SCN-8.2.0 | `docs/planning/pool_questions/phase-8.2-style-adoption.md` | — | pending |
| SCN-8.2.0-03 | SCN-8.2.0 | `docs/planning/phase-8.2-risks.md` | — | pending |
| SCN-8.2.0-04 | SCN-8.2.0 | `docs/planning/phase-8.2-todo.md` | — | pending |
| SCN-8.2.0-05 | SCN-8.2.0 | `.astaire/memory_palace.db` (Phase 8.2 ingest) | Astaire context/query/lint logs | pending |
| SCN-8.2.1-01 | SCN-8.2.1 | `docs/planning/evaluations/p10-and-cockpitvm-style-eval.md` | memo on disk; agency-string grep zero outside §Sources; Astaire lint 0/0 | drafted |
| SCN-8.2.2-01 | SCN-8.2.2 | `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` | Board adopted 2026-05-17 in `docs/planning/board/committee-virtual-meeting-scn-8-2-2-p10-adoption-2026-05-17.md`; packet outcome recorded in `docs/planning/board/committee-review-packet-2026-05-17-scn-8-2-2.md`. | board-adopted |
| SCN-8.2.3-01 | SCN-8.2.3 | `adapters/profiles/CockpitVM_Embedded_Style.md` | File on disk with all 11 section groups; pointer rule (P10 #9) present here and absent from `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`; `grep -niE "nasa\|jpl\|goddard"` and `grep -n "raw/"` both return 0; `scripts/validate_governance.sh` exits 0 (17/17 PASS); `.astaire/astaire lint` 0/0. Astaire auto-registration deferred to follow-up (`adapters/profiles/` not in `governance_authoring` plugin path-to-type table). | drafted |
| SCN-8.2.4-01 | SCN-8.2.4 | `adapters/profiles/EMBEDDED_PROFILE.md` | §Required Style + §Fail-Closed Release Gate added; manifest key `evidence.embeddedVerificationChecklistPath` named; `scripts/validate_governance.sh` exits 0. | drafted |
| SCN-8.2.4-02 | SCN-8.2.4 | `validation/CONSISTENCY_RULES.md` (Contract Rules §14); `scripts/validate_governance.sh` (Python gate block); fixtures `validation/fixtures/{production,mvp,embedded-missing-evidence}/` + `contracts/governance-manifest.example.yaml` | Positive gate iterates example + prototype + mvp + production manifests and rejects embedded-profile manifests missing the key OR non-embedded manifests carrying it; negative fixture shape (embedded profile + key absent) proven by a dedicated check; stub checklist files present under each embedded-profile manifest's directory. | drafted |
| SCN-8.2.4-03 | SCN-8.2.4 | `scripts/check_agency_strings.sh` + `validation/CONSISTENCY_RULES.md` (Contract Rules §15) | rg `-i 'nasa\|jpl\|goddard'` over `core/` and `adapters/profiles/`; invoked from `scripts/validate_governance.sh`. **Superseded:** retired at SCN-8.3.2 per OPP-8.2-004 closure — the script and per-pass sweep are removed; §15 now read as SHOULD-level review-time policy. The one-time repo-wide sweep at SCN-8.2.4 sign-off remains the audit baseline. | superseded |
| SCN-8.2.5-01 | SCN-8.2.5 | `docs/planning/board/committee-review-packet-2026-05-18-scn-8-2-5.md`; `docs/planning/board/committee-virtual-meeting-scn-8-2-5-phase-signoff-2026-05-18.md`; `docs/planning/signoffs.md` (Phase 8.2 row dated) | Board adopted 2026-05-18 at MTG-0003 (DEC-0003/DEC-0004 Adopted); Will Larson session chair (BM-012, expert-informed simulation); 0 open critical findings; FND-0007/0009/0010 deferred to Phase 8.3+; FND-0008 (R-8.2-05) carried forward; `.astaire/astaire lint` 0/0; immutable trace = signoff commit SHA on `main`. | board-signed-off |
| SCN-8.2.6-01 | SCN-8.2.6 | `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` | Commit `01d3f00`; grep `5d47359` / `Cross-Phase In-Flight Coordination` / `chunk-8.1.[0-3]` returns expected hits | closed |
| SCN-8.2.6-02 | SCN-8.2.6 | `docs/planning/phase-8.2-risks.md` (R-8.2-05 + Cross-Phase Risk References appendix) | Commit `01d3f00`; grep `R-8.2-05` / `Cross-Phase Risk References` returns expected hits | closed |
| SCN-8.2.6-03 | SCN-8.2.6 | `docs/planning/board/committee-opportunity-register-phase-8-2-2026-05-17.md` (OPP-8.2-001) | Commit `01d3f00`; opportunity status `closed`; meeting record `docs/planning/board/committee-virtual-meeting-scn-8-2-2-p10-adoption-2026-05-17.md` | closed |
| SCN-8.2.6-04 | SCN-8.2.6 | `docs/planning/phase-8.2-todo.md`, `docs/planning/traceability.md` | Commit `01d3f00`; all SCN-8.2.6 checkboxes ticked with evidence annotations; this row present | closed |
| SCN-8.3.0-01 | SCN-8.3.0 | `docs/planning/chunks/phase-8.3-chunks.md` | — | pending |
| SCN-8.3.0-02 | SCN-8.3.0 | `docs/planning/pool_questions/phase-8.3-bootstrap.md` | Gate score `0.0341` ≤ `0.20`; conf `4.0` ≥ `4.0` | pending |
| SCN-8.3.0-03 | SCN-8.3.0 | `docs/planning/phase-8.3-risks.md` | R-8.3-01..04 + R-8.2-02..05 carry-forward | pending |
| SCN-8.3.0-04 | SCN-8.3.0 | `docs/planning/phase-8.3-todo.md` | — | pending |
| SCN-8.3.0-05 | SCN-8.3.0 | `.astaire/memory_palace.db` (Phase 8.3 ingest) | Astaire scan + lint 0/0 | pending |
| SCN-8.3.1-01 | SCN-8.3.1 | `docs/planning/cross-phase/r-8.2-05-closure-request.md` | — | pending |
| SCN-8.3.2-01 | SCN-8.3.2 | `scripts/validators/governance_gates.py`, `scripts/validate_governance.sh` | Existing 17/17 PASS preserved; negative-fixture rejection preserved | pending |
| SCN-8.3.3-01 | SCN-8.3.3 | `astaire/` submodule (fractional phase tag + `evaluations/` + `adapters/profiles/` path-to-type entries), submodule pin bump | `query --tag phase=8.3` returns sub-phase docs; three previously-unregistered files appear with new types | pending |
| SCN-8.3.4-01 | SCN-8.3.4 | `contracts/governance-manifest.schema.json`, `validation/CONSISTENCY_RULES.md` (§16), `contracts/governance-manifest.example.yaml`, `validation/fixtures/analyzer-capability/` | Positive + negative fixtures pass; R-8.2-02 schema portion landed | pending |
| SCN-8.3.5-01 | SCN-8.3.5 | `docs/planning/board/committee-review-packet-<DATE>-scn-8-3-5.md`; `docs/planning/board/committee-virtual-meeting-scn-8-3-5-phase-signoff-<DATE>.md`; `docs/planning/signoffs.md` (Phase 8.3 row dated) | — | pending |
