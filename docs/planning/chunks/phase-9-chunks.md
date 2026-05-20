---
phase: 9
stage_produced: plan
---

# Phase 9 — Chunk Plans (TDR Hardening: DDD + Hexagonal + Mutation + Test-Design)

Precondition: Phase 8.3 sign-off landed on `main` at commit `1864c1c`
(branch `SCN-8.3.5`). Phase 9 runs on the same trunk. R-8.2-02 (analyzer
capability — downstream adoption) and R-8.2-05 (Phase 8.1 reciprocal
entry) remain in monitor lane and are inherited unchanged.

Phase 9 hybridizes TDR with Domain-Driven Design, hexagonal architecture,
empirical mutation evidence, and Dave Farley's eight test-design
properties. Adoption is two-layered: **portable policy in `core/`**, and
**runtime ergonomics as Claude Code skills under
`adapters/providers/claude/skills/`**. Self-applies the new policies to
`astaire/` as the reference implementation. Closes with a board review +
sign-off mirroring SCN-8.2.5 / SCN-8.3.5.

The authoritative architectural plan for this phase is
`/Users/cms/.claude/plans/as-senior-architect-for-cosmic-kite.md`. The
SCNs below are the ADG-compliant execution of that plan.

---

## SCN-9.0 — Bootstrap (chunk plan + planning artifacts + Astaire ingest)

- **Scope.** Meta-chunk. Produces every Phase 9 planning artifact:
  - `docs/planning/pool_questions/phase-9-tdr-hardening.md` (Q1..Q5
    resolved; gate score `0.0307` ≤ `0.20`; confidence `4.0` ≥ `4.0`).
  - This chunk plan (`docs/planning/chunks/phase-9-chunks.md`).
  - `docs/planning/phase-9-risks.md` enumerating R-9-01..05 plus
    carry-forward monitoring of R-8.2-02, R-8.2-05, R-8.3-03.
  - `docs/planning/phase-9-todo.md` — running TO-DO ticked by
    SCN-9.1..SCN-9.7.
  - Traceability rows for SCN-9.0..SCN-9.7 appended to
    `docs/planning/traceability.md`.
  - Phase 9 sign-off row appended to `docs/planning/signoffs.md`
    (status `pending`).
  - `.astaire/astaire scan --root .` + lint 0/0.
- **Acceptance IDs.** SCN-9.0-01 (chunk plan), SCN-9.0-02 (pool Q&A),
  SCN-9.0-03 (risks), SCN-9.0-04 (TO-DO), SCN-9.0-05 (Astaire ingest
  verified), SCN-9.0-06 (signoffs + traceability rows appended).
- **Risk tier.** Low. Authoring only; no policy change.
- **Validation method.** Astaire `scan` + `lint` exit 0; `query --tag
  phase=9` returns the four new artifacts; signoffs row present with
  status `pending`.
- **Atomic PR scope.** Single commit on branch `SCN-9.0`.

## SCN-9.1 — Core policy authoring (new docs + amendments)

- **Scope.** Land three new core policy documents and amend five
  existing ones, all in one commit so the cross-references resolve
  atomically:
  - **New:** `core/MODULARITY_GOVERNANCE.md` (ports + adapters
    declaration, dependency-direction rule, "domain has no I/O imports"
    rule, fitness-function format).
  - **New:** `core/DOMAIN_LANGUAGE_GOVERNANCE.md` (glossary artifact
    spec, per-bounded-context authoring authority, naming-correspondence
    rule between glossary terms and types/functions/test names,
    glossary evolution + deprecation protocol).
  - **New:** `core/MUTATION_EVIDENCE.md` (operator policy, proposed
    tier threshold table marked **advisory until SCN-9.7**, survivor
    triage protocol, equivalent-mutant exception process, evidence URI
    contract).
  - **Amend** `core/AI_ASSISTED_TDR_METHODOLOGY.md` with a new "§TDR-RGM
    (Red-Green-Mutate)" subsection: RED-first acceptance test required
    at risk-tier ≥ medium; reference to `MUTATION_EVIDENCE.md` and
    Farley §8 board lens.
  - **Amend** `core/PLANNING_METHODOLOGY.md`: new "§Pool Question
    Sub-Protocol — Find-Gaps Loop" (one-question-at-a-time interrogation
    written back to AC/risks); new "§Chunk Splitting" (INVEST +
    Hamburger/SPIDR dimensions) as a chunk-decomposition aid.
  - **Amend** `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`: register
    "test design" as the eighth required board lens; add Farley
    scorecard template reference.
  - **Amend** `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`:
    §Refactor Plan now requires (a) seam map and (b) characterisation
    test suite landed before any production edits when the complexity
    rubric scores ≥ 2.
  - **Amend** `core/EVIDENCE_CONTRACT.md`: add three new per-acceptance
    evidence URIs (`mutationReportURI`, `farleyScorecardURI`,
    `glossaryCoverageURI`); each is REQUIRED at the risk tier where the
    corresponding analyzer block becomes required.
- **Acceptance IDs.** SCN-9.1-01 (three new docs), SCN-9.1-02 (five
  amendments, each cross-linking the relevant new doc), SCN-9.1-03
  (Astaire scan + lint 0/0; new docs registered).
- **Acceptance criteria.** All eight files on disk; every amendment
  references at least one of the three new documents; advisory marker on
  the mutation threshold table is unambiguous; Astaire lint 0/0.
- **Risk tier.** Medium (touches all core policy documents).
- **Validation method.** Manual review of each diff against the
  pool-question resolutions; Astaire scan + lint; grep for advisory
  marker in `MUTATION_EVIDENCE.md`.
- **Atomic PR scope.** Single commit on branch `SCN-9.1`.

## SCN-9.2 — Contracts + validators + Astaire collection extensions

- **Scope.**
  - Extend `contracts/governance-manifest.schema.json` with three new
    optional blocks under `analyzers`: `mutation` (`tool`,
    `commandTemplate`, `reportPath`, `threshold` schema),
    `domainGlossary` (`path`, `coverageRule`),
    `architectureFitness` (`rulesPath`, `engine`).
  - Update `contracts/governance-manifest.example.yaml` with all three
    blocks populated for the `production` profile.
  - Add `validation/CONSISTENCY_RULES.md` §17 (mutation block
    presence-by-tier), §18 (glossary block presence-by-tier),
    §19 (architecture-fitness block presence-by-tier). All three rules
    enforce required-presence at the risk tiers declared in SCN-9.1's
    `MUTATION_EVIDENCE.md`, `DOMAIN_LANGUAGE_GOVERNANCE.md`, and
    `MODULARITY_GOVERNANCE.md` respectively.
  - New validators under `scripts/validators/`:
    `mutation_threshold.py`, `glossary_coverage.py`,
    `architecture_fitness.py`. Each callable as a module
    (`python -m scripts.validators.<name> --manifest <path>`) and
    invoked from `scripts/validate_governance.sh`.
  - Add fixtures under `validation/fixtures/{mutation,glossary,architecture}/`
    with positive + negative cases per validator (low-tier omission
    permitted; medium/high-tier omission rejected).
  - Astaire submodule enhancement: add three new collection-plugin
    path-to-type entries: `docs/evidence/mutation/` → `mutation-report`,
    `docs/evidence/farley/` → `farley-scorecard`,
    `docs/glossary/` → `domain-glossary`. Pin bump in this repo's
    submodule SHA. Mirror the SCN-8.3.3 procedure (submodule commit
    first, local test of `.astaire/astaire startup --root .`, then pin
    bump).
- **Acceptance IDs.** SCN-9.2-01 (schema delta + example update),
  SCN-9.2-02 (§17–§19 rule text + validator wiring),
  SCN-9.2-03 (positive fixtures pass, negative fixtures rejected),
  SCN-9.2-04 (Astaire submodule pin bump + post-bump scan registers
  the three new collection types).
- **Acceptance criteria.** `scripts/validate_governance.sh` exit 0
  with `[PASS]` lines for the three new validators against the example
  manifest; fixture sweep exits 0; `query --tag phase=9 --type
  mutation-report` returns zero results (no reports yet — that is
  SCN-9.5) and the collection is registered; Astaire lint 0/0.
- **Risk tier.** Medium (schema changes affect downstream consumers).
- **Validation method.** `validate_governance.sh` full pass; fixture
  sweep; submodule rollback drill documented in evidence bundle.
- **Atomic PR scope.** Single commit on branch `SCN-9.2`.

## SCN-9.3 — Claude adapter skills (Python/pytest rewrites)

- **Scope.** Create `adapters/providers/claude/skills/` with one
  subdirectory per skill, each containing `SKILL.md` written in the
  upstream Claude Code skill format and complying with Q4's authority
  boundary (every skill names its core-policy source of truth in the
  first paragraph; no normative rules):
  1. `tdd/` — RED-GREEN-MUTATE-KILL cycle in pytest. Points at
     `core/AI_ASSISTED_TDR_METHODOLOGY.md` §TDR-RGM.
  2. `mutation-testing/` — Cosmic Ray (gate evidence, CI) and mutmut
     (inner loop). Points at `core/MUTATION_EVIDENCE.md`.
  3. `test-design-reviewer/` — Farley 8 properties scorecard
     (language-agnostic; pytest examples). Points at
     `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Test-Design Lens.
  4. `find-gaps/` — one-question-at-a-time interrogation loop writing
     back to AC/risks. Points at `core/PLANNING_METHODOLOGY.md`
     §Find-Gaps Loop.
  5. `hexagonal-architecture/` — Python-idiom ports + adapters (Protocol
     classes, dependency injection patterns). Points at
     `core/MODULARITY_GOVERNANCE.md`.
  6. `domain-driven-design/` — Python-idiom DDD (frozen dataclasses for
     value objects, typed aggregates, branded `NewType`). Points at
     `core/DOMAIN_LANGUAGE_GOVERNANCE.md`.
  7. `finding-seams/` — pytest seam catalog (fixtures, monkeypatch,
     dependency injection via constructor). Points at
     `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor
     Onramp.
  8. `characterisation-tests/` — pytest snapshot / golden-master
     patterns (syrupy, approvaltests-py, or hand-rolled). Points at
     `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor
     Onramp.
  9. `story-splitting/` — INVEST + Hamburger/SPIDR producing ADG chunk
     plans. Points at `core/PLANNING_METHODOLOGY.md` §Chunk Splitting.
  - Optional slash commands under `adapters/providers/claude/commands/`
    (e.g. `/farley-review`, `/find-gaps`, `/mutate`) that wrap the
    corresponding skill load and a templated invocation.
  - Astaire `governance_authoring` collection plugin: add
    `adapters/providers/claude/skills/` path-to-type entry (suggested
    type: `provider-skill`).
- **Acceptance IDs.** SCN-9.3-01 (nine `SKILL.md` files on disk, each
  with core-policy pointer in first paragraph), SCN-9.3-02 (no skill
  defines a normative MUST/SHOULD/MAY — verified by grep),
  SCN-9.3-03 (Astaire scan registers all nine as `provider-skill`),
  SCN-9.3-04 (each skill smoke-tested by loading and verifying it can
  produce the artifact it describes against the `astaire/` codebase or
  a fixture).
- **Acceptance criteria.** Each `SKILL.md` opens with the
  source-of-truth pointer; `grep -nE '\\b(MUST|SHOULD|MAY)\\b'
  adapters/providers/claude/skills/` returns only references to core
  policy (not skill-authored rules); Astaire lint 0/0; smoke artifacts
  attached to evidence bundle.
- **Risk tier.** Low (adapter-only; no governance impact).
- **Validation method.** Manual review for authority-boundary compliance
  + Astaire registration check.
- **Atomic PR scope.** Single commit on branch `SCN-9.3`. MAY proceed
  in parallel with SCN-9.4 / SCN-9.5 after SCN-9.2 lands.

## SCN-9.4 — Self-application Part A: ADG ubiquitous-language glossary + seam map

- **Scope.**
  - Author `docs/glossary/` with one file per bounded context resolved
    in Q1:
    - `docs/glossary/governance-authoring.md`
    - `docs/glossary/memory-palace.md`
    - `docs/glossary/validation.md`
    - `docs/glossary/adapters.md`
    Each file: term, definition, owning context, canonical references
    (file paths in `core/`, `astaire/`, `validation/`, `adapters/`),
    deprecation entries (none at v1).
  - Run the `finding-seams` Claude skill (from SCN-9.3) against the
    full `astaire/` codebase; produce `docs/evidence/seam-maps/astaire-seam-map.md`
    enumerating every seam by type (constructor injection, fixture,
    monkeypatch, module-level singleton) ranked by refactor cost.
  - Refactor the claims/projection core (the Q2 pilot scope) against
    `core/MODULARITY_GOVERNANCE.md`: extract domain types into an
    I/O-free package; introduce port Protocols for SQLite + FTS;
    implementations move into adapter modules. Existing pytest suite
    MUST continue to pass; new tests use the port fakes.
  - Wire `architecture_fitness.py` (from SCN-9.2) against the
    claims/projection refactor: rule = "no module under
    `astaire/src/domain/claims/` may import `sqlite3`, `astaire.db`,
    or `astaire.fts`". Fitness rule passes.
- **Acceptance IDs.** SCN-9.4-01 (four glossary files registered as
  `domain-glossary`), SCN-9.4-02 (seam map registered + linked from
  glossary), SCN-9.4-03 (claims/projection refactor merged; pytest
  green; fitness rule green), SCN-9.4-04 (consistency rule §18 enforced
  in this repo's manifest: `analyzers.domainGlossary.path` set; gate
  passes).
- **Acceptance criteria.** `pytest` green inside `astaire/`;
  `architecture_fitness.py` exit 0; `validate_governance.sh` exit 0
  with `[PASS]` for glossary and architecture-fitness checks; full repo
  Astaire scan + lint 0/0.
- **Risk tier.** High (refactors production `astaire/` code; touches the
  module that backs every other phase's evidence).
- **Validation method.** Pytest full pass before and after each
  intermediate commit; fitness rule wired into the existing
  `validate_governance.sh` chain; rollback = revert the
  claims/projection refactor commit (glossary + seam map are inert
  documentation and safe to keep).
- **Atomic PR scope.** Single commit on branch `SCN-9.4`. Requires
  SCN-9.2 (validators + Astaire collections).

## SCN-9.5 — Self-application Part B: mutation harness + Farley scorecard

- **Scope.**
  - Stand up Cosmic Ray on the refactored claims/projection core from
    SCN-9.4 with configuration under `astaire/cosmic-ray.toml`. Run a
    full mutation pass; publish report under
    `docs/evidence/mutation/astaire-claims-projection-<DATE>.md`
    (human-readable summary + survivor list with disposition column).
  - Add mutmut configuration for inner-loop developer use; document in
    the `mutation-testing` skill (from SCN-9.3).
  - Run the `test-design-reviewer` skill (from SCN-9.3) over the
    `astaire/` pytest suite. Publish Farley scorecard under
    `docs/evidence/farley/astaire-pytest-<DATE>.md` with the eight
    properties scored 1-5 and recommendations.
  - Produce `docs/evidence/seam-maps/astaire-characterisation-suite.md`:
    a characterisation-test suite for the non-pilot `astaire/` modules
    (ingest, FTS, CLI). These tests are temporary scaffolding for the
    Phase 10 full-repo hexagonal refactor and MUST be marked with the
    project's characterisation marker (TBD in SCN-9.3's skill — likely
    `@pytest.mark.characterisation`).
  - File a tier-threshold ratification proposal under
    `docs/planning/board/threshold-ratification-proposal-scn-9-7.md`
    citing the SCN-9.5 baseline numbers and recommending either
    adoption-as-proposed or revised thresholds. This is the input to
    SCN-9.7's board sign-off.
- **Acceptance IDs.** SCN-9.5-01 (Cosmic Ray report on disk, registered
  as `mutation-report`), SCN-9.5-02 (Farley scorecard registered),
  SCN-9.5-03 (characterisation suite + marker registered),
  SCN-9.5-04 (threshold-ratification proposal cites baseline data).
- **Acceptance criteria.** All three evidence files registered;
  characterisation suite runs green; proposal file references each
  baseline number with a citation back to the Cosmic Ray report; mutation
  threshold validator (`mutation_threshold.py`) WARNS but does not
  fail-close while thresholds are advisory (per Q3 resolution); Astaire
  lint 0/0.
- **Risk tier.** Medium (data quality of the baseline determines the
  final thresholds; bad data → bad gates).
- **Validation method.** Cosmic Ray + mutmut both runnable from the
  command line documented in the skill; Farley scorecard reviewable;
  threshold proposal reviewed against the pool-question Q3 resolution.
- **Atomic PR scope.** Single commit on branch `SCN-9.5`. Requires
  SCN-9.4 (refactored claims/projection core).

## SCN-9.6 — Runbooks + templates + consumer migration note

- **Scope.**
  - `runbooks/MUTATION_TESTING.md` — operating procedure for Cosmic
    Ray + mutmut in an ADG-governed repo (configuration, CI integration,
    survivor triage workflow, equivalent-mutant exception protocol).
  - `runbooks/GLOSSARY_AUTHORING.md` — how to author and evolve a
    domain glossary (Q1 pattern + naming-correspondence enforcement).
  - `runbooks/TEST_DESIGN_REVIEW.md` — Farley scorecard interpretation,
    board-lens integration.
  - `templates/MIGRATION_PHASE_9.md` — consumer-facing migration note
    explaining: manifest schema additions (Q5 tier-gated presence),
    glossary authoring quick-start, mutation harness adoption, Farley
    review cadence.
  - `templates/` template additions: stub `governance.yaml` blocks for
    each of the three new `analyzers` blocks; stub
    `docs/glossary/<context>.md`.
  - Wire the new runbooks into `README.md` §Governance Principles and
    `runbooks/ASTAIRE_ACCESS.md` cross-reference if relevant.
- **Acceptance IDs.** SCN-9.6-01 (three runbooks on disk, registered),
  SCN-9.6-02 (migration note + template additions on disk),
  SCN-9.6-03 (README + cross-reference updates).
- **Acceptance criteria.** Files on disk; Astaire lint 0/0; migration
  note copy-pasteable into a clean consumer manifest and accepted by
  `validate_governance.sh`.
- **Risk tier.** Low (documentation + templates only).
- **Validation method.** Dry-run the migration note against the
  existing `governance.yaml` in this repo (which is already a consumer
  of ADG); confirm `validate_governance.sh` exit 0.
- **Atomic PR scope.** Single commit on branch `SCN-9.6`.

## SCN-9.7 — Phase 9 board review packet + sign-off (ratifies thresholds)

- **Scope.** Mirror SCN-8.2.5 / SCN-8.3.5 shape, with the additional
  agenda item of ratifying the mutation tier thresholds from SCN-9.5:
  - `docs/planning/board/committee-review-packet-<DATE>-scn-9-7.md`
    (Accountability Review cadence; chair continuity with MTG-0004).
    Packet MUST link the SCN-9.5 threshold-ratification proposal as
    DEC-0005 candidate.
  - `docs/planning/board/committee-virtual-meeting-scn-9-7-phase-signoff-<DATE>.md`.
  - Board decision on thresholds recorded as DEC-0005; on adoption,
    `core/MUTATION_EVIDENCE.md` is amended in the SAME commit to flip
    the advisory marker to normative, and
    `validation/CONSISTENCY_RULES.md` §17 is flipped from WARN to
    fail-close at the ratified tiers.
  - Flip `docs/planning/signoffs.md` Phase 9 row to dated.
  - Close SCN-9.7-01 row in `docs/planning/traceability.md`.
  - Tick `phase-9-todo.md` SCN-9.7 section.
  - R-8.2-05 status check: closed if Phase 8.1 reciprocal landed;
    carried-forward to Phase 10 monitoring otherwise.
  - R-9 risks disposition (closed / carried-forward) recorded.
- **Acceptance IDs.** SCN-9.7-01 (packet + meeting + signoffs row +
  traceability + TO-DO closure + threshold ratification commit).
- **Acceptance criteria.** Board adopts Phase 9; ambiguity score and
  confidence recorded; 0 open critical findings; DEC-0005 records the
  ratified thresholds (or the revised ones); `MUTATION_EVIDENCE.md`
  advisory marker removed; §17 flipped to fail-close; Astaire lint
  0/0; validator full pass.
- **Risk tier.** High (sign-off; threshold ratification is a normative
  policy change).
- **Validation method.** Board meeting record + DEC-0005 referenced from
  signoffs row; post-sign-off `validate_governance.sh` exit 0 against
  this repo's `governance.yaml` with the now-normative §17 active.
- **Atomic PR scope.** Single commit on branch `SCN-9.7`.

---

## Sequencing

```
SCN-9.0  →  SCN-9.1  →  SCN-9.2  ┐
                                  ├─→  SCN-9.4  →  SCN-9.5  →  SCN-9.7
                       SCN-9.3  ──┤                            ↑
                                  └────────  SCN-9.6  ─────────┘
```

- SCN-9.1 follows SCN-9.0 (policy depends on bootstrap artifacts being
  ingested).
- SCN-9.2 depends on SCN-9.1 (contracts + validators reference the new
  policy documents).
- SCN-9.3 depends on SCN-9.1 (skills point at the new policy as source
  of truth) and MAY proceed in parallel with SCN-9.2.
- SCN-9.4 depends on SCN-9.2 (validators) and SCN-9.3 (`finding-seams`
  skill produces the seam map).
- SCN-9.5 depends on SCN-9.4 (refactored pilot is the mutation target)
  and SCN-9.3 (`mutation-testing` and `test-design-reviewer` skills).
- SCN-9.6 depends on SCN-9.2 (templates reference the schema) and
  SCN-9.3 (skill load instructions) and MAY proceed in parallel with
  SCN-9.4 / SCN-9.5.
- SCN-9.7 waits on all preceding chunks. Requires the SCN-9.5
  threshold-ratification proposal as DEC-0005 input.

## Cross-phase coordination

- **R-8.2-05** (Phase 8.1 reciprocal entry): Phase 9 inherits the
  bidirectional protocol unchanged. Sprint critique reads
  `phase-8.1-risks.md` on `main` each iteration. R-8.2-05 carries to
  Phase 10 if still open at SCN-9.7.
- **R-8.2-02** (analyzer-capability downstream adoption): Phase 9
  introduces three additional analyzer blocks (mutation, glossary,
  architecture-fitness). Downstream-adoption closure for the new blocks
  is tracked as R-9-04; closure cadence mirrors R-8.2-02 (first
  consumer adoption of each).
- **R-8.3-03** (schema rejection for downstream manifests): Q5
  resolution (optional-at-v1, tier-gated presence) inherits R-8.3-03's
  mitigation discipline; new R-9-04 tracks the new blocks specifically.
