# Phase 8.2 — Chunk Plans (P10 Universal Adoption + CockpitVM Embedded Style)

Precondition: Phase 8.2 may run in parallel with — or directly after — Phase
8.1. If Phase 8.1 also amends
`core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`, Phase 8.2 follows Phase
8.1; otherwise the two phases run on parallel branches.

Phase 8.2 amends the complexity core contract (adopted in `8b65071`) with a
language-agnostic Power of 10 discipline and adds an authoritative
project-owned C/C++ embedded style guide branded **CockpitVM Embedded Style**.
All external agency / institutional affiliations are stripped from policy
bodies; only minimal publication citations appear in the evaluation memo
Sources footer.

---

## SCN-8.2.0 — Bootstrap (chunk plan + planning artifacts + Astaire ingest)

- **Scope.** Meta-chunk. Produces every planning artifact that the remaining
  Phase 8.2 chunks consume, and ingests them into Astaire so the rest of the
  phase runs under standard ADG retrieval discipline. Concretely:
  - Create `docs/planning/chunks/phase-8.2-chunks.md` (this file) matching the
    format of `docs/planning/chunks/phase-3-chunks.md` and
    `docs/planning/chunks/phase-5-chunks.md`.
  - Create `docs/planning/pool_questions/phase-8.2-style-adoption.md` with
    pool Q&A driving the verdicts (LOC-cap conflict resolution;
    static-analyzer minimum capability; opt-in profile discoverability;
    CockpitVM rebrand lineage discoverability). Each question scored per
    `core/PLANNING_METHODOLOGY.md` §Ambiguity Model.
  - Create `docs/planning/phase-8.2-risks.md` enumerating the four risks
    identified in the overlap analysis. Phase-risk files are per-phase.
  - Create `docs/planning/phase-8.2-todo.md` — running TO-DO that
    SCN-8.2.1–SCN-8.2.5 each tick down. The TO-DO is the workflow's source
    of truth for in-flight chunk state.
  - Append rows to `docs/planning/traceability.md` for SCN-8.2.* IDs
    (implementation paths + evidence pointers left blank, populated by later
    chunks).
  - Append the Phase 8.2 sign-off row to `docs/planning/signoffs.md` (status
    `pending`, owner Accountable Delivery Lead, board Chairperson as
    approver — critical tier per `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`).
  - Run `.astaire/astaire scan --root .` so every new artifact is registered.
    NOTE: Astaire's collection plugin parses phase as an integer, so Phase
    8.2 artifacts register under `phase=8` rather than `phase=8.2`. Sub-phase
    distinction is carried in the document title (e.g. "Phase 8.2 Chunks").
    Verify with `.astaire/astaire context --tag phase=8 --budget 6000` that
    the full Phase 8 / 8.2 surface is retrievable, and with
    `.astaire/astaire query -t chunk-plan --tag phase=8` that the new chunk
    plan is listed alongside earlier phases. A fractional-phase tag is
    listed as a Phase 8.2 follow-up (see `phase-8.2-todo.md`).
- **Acceptance IDs.** SCN-8.2.0-01 (chunk plan), SCN-8.2.0-02 (pool Q&A),
  SCN-8.2.0-03 (risks), SCN-8.2.0-04 (TO-DO), SCN-8.2.0-05 (Astaire ingest
  verified).
- **Acceptance criteria.**
  - `docs/planning/chunks/phase-8.2-chunks.md` exists and matches the format
    of phase-3 / phase-5 chunk plans.
  - Pool Q&A contains ≥ 4 questions covering the overlap analysis decisions,
    all resolved, with an ambiguity score ≤ 0.20 and average confidence
    ≥ 4.0 per `core/PLANNING_METHODOLOGY.md` §Ambiguity Model.
  - `phase-8.2-risks.md` enumerates the four risks (assertion-density
    retroactivity; static-analyzer choice; opt-in confusion; CockpitVM
    rebrand discoverability) with mitigation + owner.
  - `phase-8.2-todo.md` lists every SCN-8.2.* chunk with checkbox status and
    acceptance-ID linkage.
  - `traceability.md` and `signoffs.md` carry SCN-8.2.* rows.
  - `.astaire/astaire context --tag phase=8 --budget 6000` returns every
    artifact created in this chunk (filterable by "Phase 8.2" in the title);
    `.astaire/astaire lint` returns 0/0.
- **Validation method.** Automated — Astaire lint + context query. Manual —
  Accountable Delivery Lead confirms chunk-plan format match.
- **Risks.** Astaire scan misclassifies new artifacts (mitigation: re-run
  scan with explicit `--collection` if needed); pool questions insufficient
  to reach gate score (mitigation: extend with domain-specific sub-pool
  before exit).
- **Rollback.** Revert the chunk-creation commit; Astaire scan is idempotent
  and the removal will be reflected on next scan.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-8.2.0`.

---

## SCN-8.2.1 — Evaluation memo (P10 + CockpitVM Style adoption)

- **Scope.** Author
  `docs/planning/evaluations/p10-and-cockpitvm-style-eval.md` with:
  (1) scope and non-goals; (2) P10 rule-by-rule matrix (verdict per rule:
  amend / supplement / embedded-only) with existing-clause references and
  draft clause text; (3) LOC-cap resolution memo (existing 25/40 stays,
  P10's ~60 documented as ancestor); (4) CockpitVM Embedded Style gap walk
  against the YAML's eight section groups, with all agency strings flagged
  for removal during rendering; (5) recommendation; (6) Sources footer
  with minimal publication citations (author + year + venue; URLs allowed;
  no agency banners).
- **Acceptance IDs.** SCN-8.2.1-01.
- **Acceptance criteria.**
  - Memo present at the path above; ten P10 rules each have a verdict.
  - Sources footer ≤ 5 lines; no agency name in body text.
    `grep -niE "nasa|jpl|goddard"` on the memo file matches only inside
    the Sources footer.
  - Memo references the pool Q&A artifact from SCN-8.2.0.
- **Validation method.** Manual — Accountable Delivery Lead review +
  Astaire lint.
- **Risks.** Reviewer fatigue if the matrix grows beyond ten rules
  (mitigation: keep matrix scoped to P10 only; defer wider style questions
  to Phase 8.3+).
- **Rollback.** Revert memo file.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-8.2.1`.

---

## SCN-8.2.2 — Complexity core amendment (Universal P10)

- **Scope.** Amend `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` in
  place:
  - Insert **§Power of 10 Discipline (Universal)** between §Mandatory
    Design Invariants and §Naming Rules. Holds normative clauses for P10
    rules 1, 2, 3 (generic), 5, 7, 8 (generic), 10 (positive form).
    `MUST`/`SHOULD`/`MAY` keywords. Cite rule numbers.
  - **§Component Size Limits** footnote: keep 25/40 LOC; document as
    stricter than the Power of 10 function-size guideline.
  - **§Forbidden Patterns Without Human Exception** add: recursion (direct
    or indirect), unbounded loops, dynamic allocation after init, return
    value not checked / parameter not validated at the boundary.
  - **§Required Validation Evidence** add: clean compile under
    all-warnings + ≥ 1 static analyzer with zero findings; analyzer choice
    declared in governance manifest.
  - **§Required Pre-Implementation Checklist** add a "Return-value and
    parameter validation" row.
  - Cross-link to the CockpitVM Embedded Style at section end.
- **Acceptance IDs.** SCN-8.2.2-01.
- **Acceptance criteria.**
  - All edits land; `MUST`/`SHOULD`/`MAY` discipline preserved.
  - `grep -niE "nasa|jpl|goddard"` on the file returns zero hits.
  - `grep -n "Power of 10"` returns ≥ 1 hit per universal rule (rules 1,
    2, 3, 5, 7, 8, 10 — rules 4 and 6 are subsumed by existing clauses;
    rule 9 lives in the embedded style).
  - `grep -n "25 LOC" core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
    still shows the existing 25/40 cap.
  - `scripts/validate_governance.sh` exits 0.
  - `.astaire/astaire scan --root .` re-registers the file with a new hash;
    `.astaire/astaire query -t core-policy` lists the amended file.
- **Validation method.** Automated — governance validator + grep invariants
  + Astaire lint. Manual — Chairperson review.
- **Risks.** Conflict with Phase 8.1 if 8.1 also edits the same sections
  (mitigation: serialize after 8.1 if so).
- **Rollback.** Revert amendment commit; complexity core returns to
  `8b65071` baseline.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** **critical** (core-policy amendment per
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Risk-Tiered Autonomy). Board
  review mandatory.
- **Atomic PR scope.** `SCN-8.2.2`.

---

## SCN-8.2.3 — CockpitVM Embedded Style (authoritative artifact)

- **Scope.** Create `adapters/profiles/CockpitVM_Embedded_Style.md`.
  Internalize the scratch YAML's eleven section groups (preamble; ABI
  boundary; allowed C++ features; forbidden C++ features; determinism
  requirements with cross-links to core §Power of 10; required type-safety
  patterns `Result<T,E>`, `Span<T>`, `RingBuffer<T,N>` in `cockpit::core::`
  namespace; pointer-use rule (P10 #9 lives here); verification checklist;
  tooling integration; header/implementation organization; Sources footer).
  All identifiers, examples, and headers are CockpitVM-owned; **zero agency
  strings in body text**.
- **Acceptance IDs.** SCN-8.2.3-01.
- **Acceptance criteria.**
  - File present; `MUST`/`SHOULD`/`MAY` keywords declared normative in the
    preamble.
  - `grep -niE "nasa|jpl|goddard"` on the file returns zero hits; Sources
    footer (if present) uses publication-only citations.
  - `grep -n "raw/"` on the file returns zero hits.
  - All eleven YAML section groups are represented; pointer rule (P10 #9)
    appears here and *not* in the core.
  - `scripts/validate_governance.sh` exits 0.
  - `.astaire/astaire scan --root .` registers the file under the
    `adapters` collection.
- **Validation method.** Automated — grep invariants + governance validator
  + Astaire lint. Manual — Chairperson review.
- **Risks.** Implementation snippets accidentally retain agency identifiers
  (mitigation: grep-driven CI guard in SCN-8.2.4).
- **Rollback.** Revert file-creation commit.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** **high** (new authoritative project-owned style guide).
  Board review mandatory.
- **Atomic PR scope.** `SCN-8.2.3`.

---

## SCN-8.2.4 — Embedded profile wiring + validation gate

- **Scope.**
  - Extend `adapters/profiles/EMBEDDED_PROFILE.md` (preserve existing
    preamble): require adoption of
    `adapters/profiles/CockpitVM_Embedded_Style.md` in full when the
    governance manifest declares the embedded profile; add fail-closed
    release gate requiring the CockpitVM Embedded Style §Verification
    Checklist evidence.
  - Add a `validation/` consistency rule (path TBC during execution) that
    enforces the gate.
  - Add a CI guard (lightweight grep) preventing agency strings from
    leaking into `core/` and `adapters/profiles/` policy bodies.
- **Acceptance IDs.** SCN-8.2.4-01 (profile wiring), SCN-8.2.4-02
  (validation rule), SCN-8.2.4-03 (CI guard).
- **Acceptance criteria.**
  - Embedded profile cites the CockpitVM Embedded Style as required.
  - Fixture manifest without embedded profile passes
    `scripts/validate_governance.sh`; fixture manifest with embedded profile
    but missing verification evidence fails.
  - CI guard rejects any PR that introduces an agency string under `core/`
    or `adapters/profiles/`.
- **Validation method.** Automated — fixture-driven validator runs + CI
  guard dry-run.
- **Risks.** Validation rule false positives (mitigation: scope the rule to
  the embedded profile only).
- **Rollback.** Revert wiring + validation rule + CI guard.
- **Owner.** Accountable Delivery Lead.
- **Risk tier.** medium.
- **Atomic PR scope.** `SCN-8.2.4`.

---

## SCN-8.2.5 — Board review + sign-off

- **Scope.** Produce a committee review packet under `docs/planning/board/`
  summarizing memo + diff + risk delta + draft sign-off record. Run board
  review per `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`. Record the
  chair + designated accountable approver signatures in
  `docs/planning/signoffs.md` and update `docs/planning/phase-8.2-todo.md`
  to closed.
- **Acceptance IDs.** SCN-8.2.5-01.
- **Acceptance criteria.**
  - Committee packet contains every field required by
    `core/EVIDENCE_CONTRACT.md` §Board Review Evidence.
  - Sign-off recorded with immutable trace (commit / PR / signed review)
    per `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability.
  - `.astaire/astaire lint` returns 0/0; `.astaire/astaire context --tag
    phase=8.2 --budget 6000` returns the closed bundle.
- **Validation method.** Manual — board review meeting + Chairperson
  signoff. Automated — Astaire lint.
- **Risks.** Board cadence delays (mitigation: include packet in next
  scheduled committee review; do not request out-of-cycle review).
- **Rollback.** N/A (sign-off chunk; rollback would mean reverting
  SCN-8.2.2 / SCN-8.2.3 themselves).
- **Owner.** Chairperson.
- **Risk tier.** **critical**. Board review mandatory.
- **Atomic PR scope.** `SCN-8.2.5`.
