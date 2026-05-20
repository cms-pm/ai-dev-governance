---
phase: 9
stage_produced: plan
---

# Phase 9 — Running TO-DO

Linked to: `docs/planning/chunks/phase-9-chunks.md`,
`docs/planning/pool_questions/phase-9-tdr-hardening.md`,
`docs/planning/phase-9-risks.md`.

Each chunk ticks down its rows on merge. Evidence annotations are
appended in `(parens)` after each box is checked.

## SCN-9.0 — Bootstrap

- [x] Pool-questions doc on disk at
      `docs/planning/pool_questions/phase-9-tdr-hardening.md`
      (Q1..Q5, gate score `0.0307` ≤ `0.20`, conf `4.0` ≥ `4.0`).
- [x] Chunk plan on disk at `docs/planning/chunks/phase-9-chunks.md`.
- [x] Risk log on disk at `docs/planning/phase-9-risks.md`
      (R-9-01..05 + R-8.2-02 / R-8.2-05 / R-8.3-03 carry-forward).
- [x] This TO-DO on disk.
- [x] Traceability rows for SCN-9.0..SCN-9.7 appended to
      `docs/planning/traceability.md` (all `pending`).
- [x] Phase 9 sign-off row appended to `docs/planning/signoffs.md`
      (status `pending`, score `0.0307`, conf `4.00`).
- [x] `.astaire/astaire scan --root .` + lint 0/0; chunk plan, pool
      questions, risks, and TO-DO registered (verify via
      `query -t chunk-plan --tag phase=9` etc.).

## SCN-9.1 — Core policy authoring (new docs + amendments)

- [x] `core/MODULARITY_GOVERNANCE.md` on disk (ports + adapters,
      dependency-direction rule, "domain has no I/O imports",
      fitness-function format).
      (registered as `core-policy` by Astaire scan; SCN-9.1 commit)
- [x] `core/DOMAIN_LANGUAGE_GOVERNANCE.md` on disk (glossary spec,
      per-context authoring authority, naming-correspondence rule,
      evolution + deprecation protocol).
      (registered as `core-policy`; SCN-9.1 commit)
- [x] `core/MUTATION_EVIDENCE.md` on disk (operator policy, **advisory**
      tier threshold table, survivor triage protocol, equivalent-mutant
      exception process, evidence URI contract).
      (registered as `core-policy`; advisory marker grep-verifiable at
      `core/MUTATION_EVIDENCE.md:13`, `:15`, `:45`, `:151`)
- [x] `core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM subsection
      authored; cross-links `MUTATION_EVIDENCE.md` and the test-design
      board lens.
- [x] `core/PLANNING_METHODOLOGY.md` §Find-Gaps Loop and §Chunk
      Splitting subsections authored.
- [x] `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` test-design lens
      registered as the eighth required lens; Farley scorecard template
      referenced.
      (lens added under §Expert-Agent Board Selection; Farley
      8-property scorecard rubric authored inline)
- [x] `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor
      Plan amended to require seam map + characterisation suite at
      rubric score ≥ 2.
- [x] `core/EVIDENCE_CONTRACT.md` adds `mutationReportURI`,
      `farleyScorecardURI`, `glossaryCoverageURI` per-acceptance fields.
- [x] Astaire scan + lint 0/0; advisory marker in `MUTATION_EVIDENCE.md`
      grep-verifiable.
      (lint 0/0 at 2026-05-20T01:08:31Z after startup-driven L0 refresh)

## SCN-9.2 — Contracts + validators + Astaire collection extensions

- [x] `contracts/governance-manifest.schema.json` carries
      `analyzers.mutation`, `analyzers.domainGlossary`,
      `analyzers.architectureFitness` (all OPTIONAL at v1).
- [x] `contracts/governance-manifest.example.yaml` updated with all
      three blocks populated.
- [x] `validation/CONSISTENCY_RULES.md` §17 / §18 / §19 authored
      (tier-gated required-presence).
- [x] `scripts/validators/mutation_threshold.py`,
      `glossary_coverage.py`, `architecture_fitness.py` on disk;
      callable as modules.
- [x] `scripts/validate_governance.sh` invokes the three new validators
      and emits `[PASS]` lines.
- [x] `validation/fixtures/{mutation,glossary,architecture}/` populated
      with positive + negative cases.
- [x] Astaire submodule commit adds three new path-to-type entries
      (`docs/evidence/mutation/` → `mutation-report`, `docs/evidence/farley/`
      → `farley-scorecard`, `docs/glossary/` → `domain-glossary`).
- [x] Submodule pin bump in this repo; `.astaire/astaire startup --root .`
      succeeds locally before the bump merges.
- [ ] R-9-04 review window opens (first downstream adoption watch).

## SCN-9.3 — Claude adapter skills

- [x] Nine `SKILL.md` files on disk under
      `adapters/providers/claude/skills/{tdd, mutation-testing,
      test-design-reviewer, find-gaps, hexagonal-architecture,
      domain-driven-design, finding-seams, characterisation-tests,
      story-splitting}/`.
      (registered as `provider-skill` by Astaire scan; SCN-9.3 commit;
      `query -t provider-skill` returns 9)
- [x] Each `SKILL.md` opens with its core-policy source-of-truth
      pointer (Q4 authority boundary).
- [x] `grep -nE '\\b(MUST|SHOULD|MAY)\\b' adapters/providers/claude/skills/`
      returns only quoted references back to `core/` documents
      (no skill-authored normative rules — R-9-03 mitigation).
      (grep returns no matches; quoted directives reproduce the
      source-of-truth lowercase prose, so the all-caps modal verbs do
      not appear in any skill file)
- [x] Optional slash commands under `adapters/providers/claude/commands/`
      authored (`/farley-review`, `/find-gaps`, `/mutate`).
- [x] Astaire `governance_authoring` plugin path-to-type entry for
      `adapters/providers/claude/skills/` → `provider-skill` (lands in
      same submodule bundle as SCN-9.2 or as a follow-on).
      (submodule commit `c14b7e5` on branch `scn-9.2-path-types`;
      pin bump lands in this SCN-9.3 commit; remote push deferred per
      session handoff)
- [x] Smoke test per skill: load the skill and produce one artifact it
      describes against `astaire/` or a fixture; attach to evidence
      bundle.
      (results summarised in
      `docs/evidence/scn-9-3-skills-smoke/README.md`; full Cosmic Ray,
      Farley scorecard, seam map, and characterisation suite runs land
      in SCN-9.4 / SCN-9.5)

## SCN-9.4 — Self-application Part A (glossary + seam map + claims/projection refactor)

- [x] `docs/glossary/governance-authoring.md` on disk and registered
      as `domain-glossary`.
      (registered by Astaire scan; `docs/glossary/` path-to-type entry
      landed in SCN-9.2 submodule bundle)
- [x] `docs/glossary/memory-palace.md` on disk and registered.
- [x] `docs/glossary/validation.md` on disk and registered.
- [x] `docs/glossary/adapters.md` on disk and registered.
- [x] `docs/evidence/seam-maps/astaire-seam-map.md` on disk and
      registered.
- [x] `astaire/` claims/projection core refactored against
      `core/MODULARITY_GOVERNANCE.md`: domain types in I/O-free
      package, port Protocols for SQLite + FTS, adapter modules
      implement them.
      (`astaire/src/domain/claims/{models,ports}.py` I/O-free;
      adapters live under `astaire/src/adapters/sqlite/`; submodule
      commit `8eeb71c`)
- [x] Existing `pytest` suite inside `astaire/` green at every
      intermediate commit.
      (372 tests green after refactor, including 9 new domain tests
      in `astaire/tests/test_domain_claims.py` using port fakes)
- [x] `scripts/validators/architecture_fitness.py` exit 0 against the
      refactored claims/projection core (no `sqlite3` / `astaire.db` /
      `astaire.fts` imports under the protected domain directory).
      (`--audit` mode added; rules at
      `validation/architecture-fitness.yaml`; `validate_governance.sh`
      emits `[PASS] Architecture-fitness audit (SCN-9.4 forbidden-import
      check)`)
- [x] This repo's `governance.yaml` carries `analyzers.domainGlossary.path`
      pointing at `docs/glossary/`; §18 gate passes.
      (`analyzers.domainGlossary` + `analyzers.architectureFitness`
      blocks added; full `validate_governance.sh` exits 0)

## SCN-9.5 — Self-application Part B (mutation + Farley + characterisation suite)

- [x] `astaire/cosmic-ray.toml` on disk; full Cosmic Ray pass produces
      `docs/evidence/mutation/astaire-claims-projection-<DATE>.md`
      (registered as `mutation-report`).
      (`docs/evidence/mutation/astaire-claims-projection-2026-05-20.md`;
      Cosmic Ray 8.4.6 baseline: 70 total, 37 killed, 33 equivalent
      candidates; raw score 52.86%, equivalent-adjusted 100.00% if
      SCN-9.5-EQ-001 is accepted)
- [x] `astaire/mutmut.ini` (or equivalent) on disk; mutmut inner-loop
      documented in `mutation-testing` skill.
      (`astaire/pyproject.toml` carries active `[tool.mutmut]`;
      `astaire/mutmut.ini` mirrors it; skill updated for Cosmic Ray
      8.4.6 `dump` flow and mutmut 3.5.0 tool-compatibility note)
- [x] `docs/evidence/farley/astaire-pytest-<DATE>.md` on disk and
      registered as `farley-scorecard`.
      (`docs/evidence/farley/astaire-pytest-2026-05-20.md`; Farley
      average 4.00/5)
- [x] `docs/evidence/seam-maps/astaire-characterisation-suite.md` on
      disk; characterisation tests marked with
      `@pytest.mark.characterisation` and pass under pytest.
      (`astaire/tests/test_characterisation_phase9.py`; marker
      registered in `astaire/pyproject.toml`; 3 characterisation tests
      green, 24 focused domain+characterisation tests green)
- [x] `docs/planning/board/threshold-ratification-proposal-scn-9-7.md`
      on disk; cites SCN-9.5 baseline numbers; recommends adoption /
      revision / deferral.
      (DEC-0005 candidate recommends adopt-as-proposed with
      SCN-9.5-EQ-001 equivalent-mutant bundle acceptance)
- [x] `validate_governance.sh` runs `mutation_threshold.py` in WARN
      mode (advisory per Q3); no fail-close until SCN-9.7.
      (`governance.yaml` now declares `analyzers.mutation`; validator
      remains structurally validating/WARN-mode per §17 until SCN-9.7)

## SCN-9.6 — Runbooks + templates + consumer migration note

- [x] `runbooks/MUTATION_TESTING.md` on disk and registered.
      (operational guide; cites `core/MUTATION_EVIDENCE.md`)
- [x] `runbooks/GLOSSARY_AUTHORING.md` on disk and registered.
      (operational guide; cites `core/DOMAIN_LANGUAGE_GOVERNANCE.md`)
- [x] `runbooks/TEST_DESIGN_REVIEW.md` on disk and registered.
      (operational guide; cites
      `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`)
- [x] `templates/MIGRATION_PHASE_9.md` on disk and registered.
- [x] `templates/` stub blocks for the three new `analyzers` entries
      and a stub `docs/glossary/<context>.md` on disk.
      (`templates/ANALYZERS_PHASE_9_TEMPLATE.yaml`;
      `templates/DOMAIN_GLOSSARY_CONTEXT_TEMPLATE.md`)
- [x] `README.md` §Governance Principles updated with cross-references
      to the new runbooks.
      (cross-links the three SCN-9.6 runbooks)
- [x] Migration note dry-run against this repo's `governance.yaml`
      passes `validate_governance.sh` exit 0.
      (`bash scripts/validate_governance.sh` exits 0; expected Phase 9
      WARN-mode analyzer messages remain non-failing)

## SCN-9.7 — Phase 9 board review + sign-off (ratifies thresholds)

- [ ] `docs/planning/board/committee-review-packet-<DATE>-scn-9-7.md`
      on disk (Accountability Review; chair continuity with MTG-0004);
      links threshold-ratification proposal as DEC-0005 candidate.
- [ ] `docs/planning/board/committee-virtual-meeting-scn-9-7-phase-signoff-<DATE>.md`
      on disk; DEC-0005 recorded (adopt-as-proposed / revise / defer).
- [ ] On adoption: `core/MUTATION_EVIDENCE.md` advisory marker removed
      and threshold table flipped to normative in the same commit.
- [ ] On adoption: `validation/CONSISTENCY_RULES.md` §17 flipped from
      WARN to fail-close at the ratified tiers;
      `validate_governance.sh` exit 0 against this repo's
      `governance.yaml` with §17 active.
- [ ] `docs/planning/signoffs.md` Phase 9 row dated.
- [ ] `docs/planning/traceability.md` SCN-9.7-01 row closed.
- [ ] R-8.2-05 disposition recorded (closed if Phase 8.1 reciprocal
      landed; carry-forward to Phase 10 otherwise).
- [ ] R-9-01..05 disposition recorded.

## Follow-ups (deferred past Phase 9)

- **Phase 10 — full-repo hexagonal refactor of `astaire/`** (ingest,
  FTS, CLI modules), gated by the SCN-9.5 characterisation suite.
- **Phase 10 — Codex adapter parity** for the nine new Claude skills
  (skills re-implemented in Codex's native idiom; no `core/` change).
- **R-9-04 final closure** on first downstream consumer adoption of each
  of the three new manifest blocks (mutation, glossary,
  architecture-fitness) — analogous cadence to R-8.2-02.
- **R-8.2-05 final closure** if Phase 8.1 reciprocal entry has not
  landed by Phase 9 sign-off (carries to Phase 10 monitoring).
- **Wider language style coverage** (Rust, Go) — still deferred from
  Phase 8.3 §Follow-ups; Phase 10+ scope.
