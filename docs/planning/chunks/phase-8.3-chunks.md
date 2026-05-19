---
phase: 8.3
stage_produced: plan
---

# Phase 8.3 — Chunk Plans (Validator Hardening + Cross-Phase Closure)

Precondition: Phase 8.2 sign-off landed on `main` at commit `e504985`
(branch `SCN-8.2.5`). Phase 8.3 runs on the same trunk. R-8.2-05 remains
open from Phase 8.2 and is owned for closure-driving (not unilateral
closure) by Phase 8.3 per OPP-8.2-003.

Phase 8.3 hardens the Phase 8.2 deliverables: factors the inline
fail-closed gate into a stand-alone validator, tightens the analyzer-
capability declaration schema, bundles three Astaire upstream
enhancements, and authors the cross-phase closure-request packet for
R-8.2-05. Closes with a board review + sign-off mirroring SCN-8.2.5.

---

## SCN-8.3.0 — Bootstrap (chunk plan + planning artifacts + Astaire ingest)

- **Scope.** Meta-chunk. Produces every Phase 8.3 planning artifact:
  - `docs/planning/pool_questions/phase-8.3-bootstrap.md` (already on
    disk — Q1..Q4 resolved, gate score `0.0341`, conf `4.0`).
  - This chunk plan (`docs/planning/chunks/phase-8.3-chunks.md`).
  - `docs/planning/phase-8.3-risks.md` enumerating R-8.3-01..04 plus
    carry-forward monitoring of R-8.2-02..05.
  - `docs/planning/phase-8.3-todo.md` — running TO-DO ticked by
    SCN-8.3.1–SCN-8.3.5.
  - Traceability rows for SCN-8.3.* IDs appended to
    `docs/planning/traceability.md`.
  - Phase 8.3 sign-off row appended to `docs/planning/signoffs.md`
    (status `pending`).
  - `.astaire/astaire scan --root .` + lint 0/0.
- **Acceptance IDs.** SCN-8.3.0-01 (chunk plan), SCN-8.3.0-02 (pool
  Q&A), SCN-8.3.0-03 (risks), SCN-8.3.0-04 (TO-DO), SCN-8.3.0-05
  (Astaire ingest verified).
- **Atomic PR scope.** SCN-8.3.0 lands as a single commit on
  branch `SCN-8.3.0`.

## SCN-8.3.1 — R-8.2-05 cross-phase closure-request packet

- **Scope.** Author
  `docs/planning/cross-phase/r-8.2-05-closure-request.md`:
  - Cite SHA `5d47359` and the §Cross-Phase In-Flight Coordination
    clause verbatim.
  - List illustrative Phase 8.1 branches (`chunk-8.1.0-*` through
    `chunk-8.1.3-*`).
  - Restate the closure criterion: (a) reciprocal entry in
    `docs/planning/phase-8.1-risks.md`; AND (b) each Phase 8.1 chunk
    branch merges to `main` with a clean analyzer pass on touched files
    or an explicit `core/EXCEPTIONS_AND_WAIVERS.md` entry.
  - Define the verification hook: every Phase 8.3 sprint critique reads
    `phase-8.1-risks.md` on `main`; R-8.2-05 flips to closed only when
    both halves of the protocol are satisfied.
- **Acceptance IDs.** SCN-8.3.1-01 (packet on disk),
  SCN-8.3.1-02 (Astaire registration as `cross-phase-request` or
  closest available type).
- **Acceptance criteria.** File exists; cites `5d47359` and clause name
  verbatim; closure criterion identical to the R-8.2-05 row in
  `phase-8.2-risks.md`; Astaire lint 0/0.
- **Atomic PR scope.** Single commit on branch `SCN-8.3.1`.

## SCN-8.3.2 — Factor inline fail-closed gate into stand-alone validator

- **Scope.** Extract the embedded-profile fail-closed gate and the
  agency-string guard invocation out of `scripts/validate_governance.sh`
  into `scripts/validators/governance_gates.py`, callable as
  `python -m scripts.validators.governance_gates --manifest <path>`.
  - `validate_governance.sh` retains directory walks, fixture
    iteration, and exit-code aggregation; delegates per-manifest verdict
    logic to the new validator.
  - Add unit fixtures under `validation/fixtures/validators/` for the
    embedded-profile present/absent matrix and the agency-string guard.
  - `validation/CONSISTENCY_RULES.md` updated to point Contract Rules
    §14–§15 at the new validator module (rule text unchanged).
- **Acceptance IDs.** SCN-8.3.2-01 (validator on disk + invocation
  contract), SCN-8.3.2-02 (existing 17/17 PASS preserved byte-identical),
  SCN-8.3.2-03 (negative-fixture rejection preserved),
  SCN-8.3.2-04 (new unit fixtures pass under the stand-alone validator).
- **Acceptance criteria.** `scripts/validate_governance.sh` exit 0 with
  17/17; `python -m scripts.validators.governance_gates` reports same
  verdicts; negative fixture (embedded profile + missing key) still
  rejected; Astaire lint 0/0.
- **Atomic PR scope.** Single commit on branch `SCN-8.3.2`.

## SCN-8.3.3 — Astaire upstream enhancement bundle

- **Scope.** Land three independent enhancements in the `astaire/`
  submodule as one coordinated commit, then bump the pin in this repo:
  1. Fractional `phase` tag support: `phase=8.3` parsed as a string/
     decimal first-class tag (no integer truncation).
  2. `docs/planning/evaluations/` path-to-type entry in the
     `ai_dev_governance` collection plugin (suggested type:
     `evaluation`).
  3. `adapters/profiles/` path-to-type entry in the
     `governance_authoring` collection plugin (suggested type:
     `adapter-profile`).
- **Acceptance IDs.** SCN-8.3.3-01 (submodule commit with three
  enhancements), SCN-8.3.3-02 (pin bump in `.gitmodules`/submodule SHA),
  SCN-8.3.3-03 (post-bump scan registers
  `p10-and-cockpitvm-style-eval.md` as `evaluation` and
  `CockpitVM_Embedded_Style.md` + `EMBEDDED_PROFILE.md` +
  `STRICT_BASELINE.md` as `adapter-profile`),
  SCN-8.3.3-04 (`query --tag phase=8.3` returns Phase 8.3 docs distinct
  from `phase=8`).
- **Acceptance criteria.** Three currently-unregistered files appear
  with their suggested types; `phase=8.3` returns Phase 8.3 sub-phase
  docs; Astaire lint 0/0.
- **Atomic PR scope.** Single coordinated submodule commit + pin bump
  on branch `SCN-8.3.3`. Phase 8.2 follow-ups items 3–5 closed by this
  chunk.

## SCN-8.3.4 — Analyzer-capability declaration schema

- **Scope.** Extend `contracts/governance-manifest.schema.json` with the
  `analyzerDeclaration` object (per pool Q4 resolution):
  - `legacyString` (transitional, mutually exclusive with `structured`).
  - `structured`: `analyzer`, `version`, `capabilitiesDetected` (4
    booleans: `recursion`, `unboundedLoops`,
    `dynamicAllocationPostInit`, `uncheckedReturnValues`),
    `selfAttestedBy`, `attestationDate`.
  - Add `validation/CONSISTENCY_RULES.md` §16 enforcing exactly-one-of
    rule and all-four-booleans-true when `structured` is present.
  - Update `contracts/governance-manifest.example.yaml` with a
    `structured` example.
  - Add positive + negative fixtures under
    `validation/fixtures/analyzer-capability/`.
- **Acceptance IDs.** SCN-8.3.4-01 (schema delta),
  SCN-8.3.4-02 (rule §16 text + validator wiring),
  SCN-8.3.4-03 (fixture sweep passes positive, rejects negative
  `false`-capability and `both-fields-present` cases),
  SCN-8.3.4-04 (example manifest under `structured` accepted; existing
  manifests under `legacyString` still accepted).
- **Acceptance criteria.** Schema validates; positive fixtures pass;
  negative fixtures rejected with explicit error message naming the
  missing capability or duplicate field; R-8.2-02 closure criterion
  partially satisfied (schema tightening landed; closure waits on
  first downstream consumer adoption per R-8.2-02 review window).
- **Atomic PR scope.** Single commit on branch `SCN-8.3.4`.

## SCN-8.3.5 — Phase 8.3 board review packet + sign-off

- **Scope.** Mirror SCN-8.2.5 shape:
  - `docs/planning/board/committee-review-packet-<DATE>-scn-8-3-5.md`
    (Accountability Review cadence; chair continuity with MTG-0003).
  - `docs/planning/board/committee-virtual-meeting-scn-8-3-5-phase-signoff-<DATE>.md`.
  - Flip `docs/planning/signoffs.md` Phase 8.3 row to dated.
  - Close `SCN-8.3.5-01` row in `docs/planning/traceability.md`.
  - Tick `phase-8.3-todo.md` SCN-8.3.5 section.
  - R-8.2-05 status check: closed if Phase 8.1 reciprocal landed;
    carried-forward to Phase 8.4 monitoring otherwise.
- **Acceptance IDs.** SCN-8.3.5-01 (packet + meeting + signoffs row +
  traceability + TO-DO closure).
- **Acceptance criteria.** Board adopts Phase 8.3; ambiguity score and
  confidence recorded; 0 open critical findings; Astaire lint 0/0;
  validator full pass.
- **Atomic PR scope.** Single commit on branch `SCN-8.3.5`.

---

## Sequencing

```
SCN-8.3.0  →  SCN-8.3.1  ┐
                         ├─→  SCN-8.3.5
              SCN-8.3.2  ┤
              SCN-8.3.3  ┤
              SCN-8.3.4  ┘
```

SCN-8.3.1..SCN-8.3.4 are independent and MAY run in parallel after
SCN-8.3.0 lands. SCN-8.3.5 waits on all four.
