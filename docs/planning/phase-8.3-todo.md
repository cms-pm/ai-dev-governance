---
phase: 8.3
stage_produced: plan
---

# Phase 8.3 — Running TO-DO

Linked to: `docs/planning/chunks/phase-8.3-chunks.md`,
`docs/planning/pool_questions/phase-8.3-bootstrap.md`,
`docs/planning/phase-8.3-risks.md`.

Each chunk ticks down its rows on merge. Evidence annotations are
appended in `(parens)` after each box is checked.

## SCN-8.3.0 — Bootstrap

- [x] Pool-questions doc on disk at
      `docs/planning/pool_questions/phase-8.3-bootstrap.md`
      (Q1..Q4, gate score `0.0341` ≤ `0.20`, conf `4.0` ≥ `4.0`).
- [x] Chunk plan on disk at
      `docs/planning/chunks/phase-8.3-chunks.md`.
- [x] Risk log on disk at `docs/planning/phase-8.3-risks.md`
      (R-8.3-01..04 + R-8.2-02..05 carry-forward).
- [x] This TO-DO on disk.
- [x] Traceability rows for SCN-8.3.0..SCN-8.3.5 appended to
      `docs/planning/traceability.md` (all 10 rows pending).
- [x] Phase 8.3 sign-off row appended to
      `docs/planning/signoffs.md` (status `pending`, score `0.0341`,
      conf `4.00`).
- [x] `.astaire/astaire scan --root .` + lint 0/0; chunk plan and
      pool-question docs registered (verified via
      `query -t chunk-plan` and `query -t pool-question`).

## SCN-8.3.1 — R-8.2-05 cross-phase closure-request packet

- [ ] `docs/planning/cross-phase/r-8.2-05-closure-request.md` on disk.
- [ ] Cites SHA `5d47359` and §Cross-Phase In-Flight Coordination
      clause verbatim.
- [ ] Restates closure criterion identical to R-8.2-05 row in
      `phase-8.2-risks.md`.
- [ ] Astaire scan + lint 0/0.
- [ ] R-8.2-05 closure status re-read in next sprint critique.

## SCN-8.3.2 — Validator factor-out

- [x] `scripts/validators/governance_gates.py` on disk; callable as
      `python -m scripts.validators.governance_gates --manifest <path>`.
- [x] `scripts/validate_governance.sh` delegates per-manifest verdict
      logic to the new validator; retains orchestration.
- [x] `validation/fixtures/validators/` populated with embedded-profile
      present/absent matrix (5 fixtures + `run.sh` exits 0). Agency-string
      fixtures intentionally omitted — sweep retired (see below).
- [x] `scripts/validate_governance.sh` full pass preserved for all
      non-retired checks; embedded-profile `[PASS]` line still emitted.
      The two agency-string `[PASS]` lines are gone by design
      (SCN-8.3.2 retired the sweep per OPP-8.2-004 closure).
- [x] Negative fixture `validation/fixtures/embedded-missing-evidence/`
      still rejected by both the shell wrapper and the stand-alone
      validator.
- [x] `validation/CONSISTENCY_RULES.md` §14 points to the new module
      (rule text unchanged); §15 rewritten as a SHOULD-level review-time
      policy noting the SCN-8.3.2 retirement.
- [x] Agency-string sweep retired: `scripts/check_agency_strings.sh`
      deleted; `--agency-strings` flag removed from
      `governance_gates.py`; per-pass invocation removed from
      `validate_governance.sh`.

## SCN-8.3.3 — Astaire upstream enhancement bundle

- [ ] Submodule commit in `astaire/` adds fractional `phase` tag
      support.
- [ ] Submodule commit adds `docs/planning/evaluations/` →
      `evaluation` type entry.
- [ ] Submodule commit adds `adapters/profiles/` →
      `adapter-profile` type entry.
- [ ] Pin bump in this repo's submodule SHA.
- [ ] Post-bump scan registers
      `docs/planning/evaluations/p10-and-cockpitvm-style-eval.md` as
      `evaluation`.
- [ ] Post-bump scan registers `CockpitVM_Embedded_Style.md`,
      `EMBEDDED_PROFILE.md`, `STRICT_BASELINE.md` as
      `adapter-profile`.
- [ ] `.astaire/astaire query --tag phase=8.3` returns Phase 8.3 docs
      distinct from `phase=8`.
- [ ] Phase 8.2 §Follow-ups items 3–5 marked closed (cross-link).

## SCN-8.3.4 — Analyzer-capability schema

- [ ] `contracts/governance-manifest.schema.json` carries
      `analyzerDeclaration` with `legacyString` and `structured`
      subfields.
- [ ] `validation/CONSISTENCY_RULES.md` §16 enforces exactly-one-of and
      all-four-booleans-true.
- [ ] `contracts/governance-manifest.example.yaml` updated with a
      `structured` example.
- [ ] `validation/fixtures/analyzer-capability/` populated with positive
      + negative cases (`false` capability, both-fields-present).
- [ ] R-8.2-02 status update: schema landed; closure waits on first
      downstream consumer adoption.

## SCN-8.3.5 — Board review + sign-off

- [ ] `docs/planning/board/committee-review-packet-<DATE>-scn-8-3-5.md`
      on disk (Accountability Review).
- [ ] `docs/planning/board/committee-virtual-meeting-scn-8-3-5-phase-signoff-<DATE>.md`
      on disk (decisions recorded).
- [ ] `docs/planning/signoffs.md` Phase 8.3 row dated.
- [ ] `docs/planning/traceability.md` SCN-8.3.5-01 row closed.
- [ ] R-8.2-05 disposition recorded (closed if Phase 8.1 reciprocal
      landed; carry-forward to Phase 8.4 otherwise).
- [ ] R-8.3-01..04 disposition recorded.

## Follow-ups (deferred past Phase 8.3)

- Wider language style coverage (Rust, Go, Python) — Phase 9+ scope.
- Agency-string guard surface expansion (OPP-8.2-004 — **closed without
  action** at Phase 8.3 bootstrap; one-time sweep judged sufficient).
- R-8.2-05 final closure if Phase 8.1 reciprocal entry has not landed
  by Phase 8.3 sign-off (carries to Phase 8.4 monitoring).
- R-8.2-02 final closure on first downstream consumer adoption of the
  `structured` analyzer-capability declaration.
