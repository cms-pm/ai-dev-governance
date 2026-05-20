---
phase: 9
stage_produced: implementation
context: governance-authoring
authoring_authority: Accountable Delivery Lead
created: 2026-05-19
last_review: 2026-05-19
---

# Governance-Authoring — Bounded-Context Glossary

The vocabulary of pool questions, chunk plans, risks, sign-offs, and
board artifacts as authored under `docs/planning/` and consumed by the
`core/PLANNING_METHODOLOGY.md` lifecycle.

Per `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Per-Context Authoring
Authority, the Accountable Delivery Lead accepts proposals, approves
amendments and deprecations, and resolves homograph disputes with peer
contexts (`memory-palace`, `validation`, `adapters`).

## Terms

### Phase

- **Definition.** The largest unit of governance planning, scoped by a
  single pool-question set and a single sign-off row.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/PLANNING_METHODOLOGY.md` §Phase Lifecycle
  - `docs/planning/signoffs.md`
- **Synonyms (deprecated).** none.
- **Notes.** A phase contains one or more SCNs; never the reverse.

### SCN (Sub-Chunk Number)

- **Definition.** The atomic delivery unit inside a phase, identified
  by the literal `SCN-<phase>.<index>` token and bound to one branch
  plus one merge commit.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/GIT_BRANCH_STRATEGY.md` §Chunk Branches
  - `docs/planning/chunks/phase-<n>-chunks.md`
  - `docs/planning/traceability.md`
- **Synonyms (deprecated).** "chunk" used informally; the formal token
  is `SCN-<phase>.<index>`.
- **Notes.** Homograph: `chunk` is also used to denote a Hamburger/SPIDR
  slice during planning — see `core/PLANNING_METHODOLOGY.md` §Chunk
  Splitting.

### Chunk Plan

- **Definition.** The document enumerating every SCN in a phase with
  scope, acceptance IDs, risk tier, validation method, and atomic PR
  scope.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `docs/planning/chunks/phase-<n>-chunks.md`
  - `core/PLANNING_METHODOLOGY.md` §Chunk Plan Structure
- **Synonyms (deprecated).** none.

### Acceptance ID

- **Definition.** A `<SCN>-<NN>` token that names a single verifiable
  outcome of a chunk; appears in the chunk plan, traceability row, and
  PR description.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/AI_ASSISTED_TDR_METHODOLOGY.md` §Acceptance Tracing
  - `docs/planning/traceability.md`
- **Synonyms (deprecated).** "AC" was used informally pre-Phase 5;
  retired in favour of "acceptance ID".

### Ambiguity Score

- **Definition.** The weighted sum `Σ(P·U·M·I) / ΣI` produced by the
  pool-question gate; gate clears at ≤ 0.20 and average confidence ≥
  4.0.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/PLANNING_METHODOLOGY.md` §Ambiguity Gate
  - `docs/planning/pool_questions/phase-<n>-*.md`
- **Synonyms (deprecated).** none.

### Pool Question

- **Definition.** A single ambiguity entry resolved in the
  pool-questions document, scored by the ambiguity formula and closed
  by a written resolution and rationale.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/PLANNING_METHODOLOGY.md` §Pool Question Sub-Protocol —
    Find-Gaps Loop
  - `docs/planning/pool_questions/`
- **Synonyms (deprecated).** none.

### Risk Log

- **Definition.** The phase-scoped register of open and carried-forward
  risks with severity, likelihood, trigger SCN, mitigation, owner, and
  review window.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `docs/planning/phase-<n>-risks.md`
  - `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Risk Tier Coupling
- **Synonyms (deprecated).** none.

### Sign-off

- **Definition.** The dated row in `docs/planning/signoffs.md` that
  closes a phase under the autonomous-delivery state machine and
  records ambiguity score, confidence, and board-decision IDs.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability
  - `docs/planning/signoffs.md`
- **Synonyms (deprecated).** none.

### Board Finding

- **Definition.** A discrete observation emitted by a board lens during
  review, identified `FND-<NNNN>`, with severity, status, and remedy
  pointer.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Finding Lifecycle
  - `docs/planning/board/`
- **Synonyms (deprecated).** none.
- **Notes.** Homograph: `finding` in adapters-land refers to lint
  output; the board sense is the canonical governance meaning.

### Sprint Critique

- **Definition.** The weekly board review cadence focused on in-flight
  chunks; lighter than an Accountability Review.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Sprint Critique
  - `docs/planning/board/`
- **Synonyms (deprecated).** none.

### Accountability Review

- **Definition.** The phase-closing board cadence chaired with
  continuity, gating sign-off and adopting DEC-<NNNN> decisions.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Accountability
    Review
  - `docs/planning/board/committee-virtual-meeting-*.md`
- **Synonyms (deprecated).** none.

### Opportunity

- **Definition.** A board-emitted improvement candidate captured in the
  opportunity register; non-blocking, unlike a finding.
- **Owning context.** governance-authoring
- **Canonical references.**
  - `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`
- **Synonyms (deprecated).** none.

## Deprecations

(none at v1)
