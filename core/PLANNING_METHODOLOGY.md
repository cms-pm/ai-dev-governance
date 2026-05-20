# Planning Methodology and Decision Framework

## Purpose

This core policy defines planning gates for AI-assisted development. It is provider-agnostic and applies to all repository types unless a stricter adapter profile is enabled.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Planning Exit Criteria

Planning for a phase is complete only when all are true:

1. Pool questions are resolved and archived.
2. Acceptance criteria are defined for planned chunks.
3. Risks and mitigations are recorded.
4. Required sign-offs are recorded with immutable references.
5. Required board-review actions are integrated or explicitly deferred with rationale.
6. Risk-tier assignment exists for each planned chunk.

## Pool Question Cycles

- Planning MUST run at phase level.
- Domain sub-pools MAY be used (for example, storage, timing, safety).
- All sub-pools MUST close before phase sign-off.
- Each domain SHOULD start with 4-6 high-impact questions.

## Artifacts

Default artifact paths (override via governance manifest):

- Pool Q/A: `docs/planning/pool_questions/`
- Sign-offs: `docs/planning/signoffs.md`
- Risk logs: `docs/planning/phase-<n>-risks.md`
- Board artifacts: `<planningPath>/board/`

Each pool question artifact MUST include:

- Goal
- Scope and non-goals
- Questions and answers
- Decision and rationale
- Remaining risks

## Ambiguity Model (Normalized)

A phase cannot pass planning if any unresolved questions remain.

For resolved questions, ambiguity MUST be scored as:

```
score = sum(P * U * M * I) / sum(I)
```

Domains:

- `P` (probability decision is wrong now): [0.0, 1.0]
- `U` (uncertainty): {0.0, 0.5, 1.0}
- `M` (momentum/critical path impact): [0.0, 1.0]
- `I` (importance weight): integer [1, 5]

Default gates:

- Ambiguity score MUST be <= 0.20
- Confidence average MUST be >= 4.0/5.0

Strict baseline adapter gate:

- Ambiguity score MUST be <= 0.10
- Confidence average MUST be >= 4.5/5.0

Confidence rubric:

- 5: verified by measurement/test/data
- 4: reasoned and peer-reviewed
- 3: plausible but unverified
- 2: weakly supported
- 1: speculative

## Pool Question Sub-Protocol — Find-Gaps Loop

When the pool question set for a phase scores at or near the ambiguity
gate but a reviewer suspects residual blind spots, agents MUST run the
Find-Gaps Loop before phase sign-off:

1. **One question at a time.** The agent (or human reviewer) poses a
   single question targeting a suspected gap. Multi-question batches
   defeat the loop's purpose.
2. **Write-back required.** Each answer MUST land in one of:
   - a new pool question entry with score and confidence, OR
   - an amendment to an existing pool question (with change history), OR
   - a new acceptance criterion ID on the relevant chunk, OR
   - a new risk-log entry with severity + mitigation.

   An answer that does not produce one of these artifacts is not yet
   resolved; the loop continues.
3. **Loop exit.** The loop exits when three consecutive questions
   return "no new artifact required" with a brief rationale recorded
   in the phase's planning notes.
4. **Auditability.** Every loop iteration MUST be reviewable: either a
   commit on the planning artifacts, a PR comment thread, or a board
   meeting record.

The Find-Gaps Loop is mandatory at risk-tier high and critical;
recommended at risk-tier medium. It MAY be skipped at low tier with a
short "skip rationale" recorded in the chunk plan.

## Chunk Splitting

When a chunk's acceptance-criterion count, cross-file edit count, or
ambiguity-score contribution exceeds the project's comfort threshold,
agents MUST split the chunk using one of the standard story-splitting
techniques. ADG canonically accepts:

1. **INVEST.** Independent / Negotiable / Valuable / Estimable / Small
   / Testable. A chunk failing any axis is a candidate for split.
2. **Hamburger.** Order the layers of work from "thinnest viable slice"
   to "fully garnished"; the split point is the smallest slice that
   delivers reviewable value end-to-end.
3. **SPIDR.** Spike / Path / Interface / Data / Rule — split along the
   axis that the chunk's biggest unknown sits on:
   - **Spike.** Time-boxed investigation chunk producing a finding
     report, not production code.
   - **Path.** Split happy path from edge or failure paths.
   - **Interface.** Split UI / CLI / API surface from underlying
     logic.
   - **Data.** Split read paths from write paths, or one entity type
     from another.
   - **Rule.** Split per business rule when multiple rules cluster in
     one chunk.

Each post-split chunk MUST independently satisfy the §Chunk Readiness
Gate. The split MAY happen at planning time (preferred) or at
implementation time when an unexpected scope expansion is discovered;
the latter case requires a planning-note amendment.

## Acceptance Criteria Mapping

- Functional/behavioral requirements MUST map to executable acceptance criteria.
- Non-functional requirements (performance, memory, reliability) MUST include measurable acceptance checks.
- Acceptance checks MAY be encoded as Gherkin, executable test suites, or both.

## Board Review Integration

- Strict baseline projects MUST run board review using `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md`.
- Adopted board opportunities MUST map to planning chunks, risk updates, and acceptance IDs.
- Open critical board actions MUST block release unless approved exception exists.

## Autonomous Delivery Integration

- Risk-tier assignment MUST be produced during planning.
- High/critical tier chunks MUST declare board trigger expectations.
- Planning artifacts MUST include machine-readable handoff metadata for automation state transitions.

## Sign-off and Auditability

- Every phase MUST have a named accountable human approver.
- LLM chat can assist, but cannot serve as sole approval authority.
- Sign-off records MUST include date, approver, and immutable trace (commit, PR, or signed review record).

## Chunk Readiness Gate

Before implementation starts, each chunk MUST have:

- Mapped acceptance criteria
- Defined validation method (manual or automated)
- Risks and rollback approach
- Ownership and review assignment
- Implementation-complexity applicability and evidence destination
- Risk tier and automation path
- Declared atomic PR scope target (`SCN-*` or chunk SCN prefix)

## Context Management

- Keep active context lean and linked.
- Archive completed phase details.
- Keep provider-specific guidance in adapter docs, not core policy.
- Follow the **port-of-first-resort** principle (see `README.md`
  §Governance Principles): every agent call begins at Astaire's L0 and
  routes outward to tentacles (L1/L2, graphify, RTK) rather than fanning
  out in parallel. This is the canonical context-assembly shape for
  agentic work under this governance.
- The Astaire CLI surface MUST be in every agent's working context at
  all times. Canonical reference: `runbooks/ASTAIRE_ACCESS.md`. Consumer
  bootstrap: `templates/ASTAIRE_CLI_SNIPPET.md`.
- **Astaire-first read discipline.** Before reading any
  `docs/planning/**`, `docs/releases/**`, board artifact, or governance
  core policy, an agent MUST query Astaire first (for example,
  `.astaire/astaire query`, `.astaire/astaire context`, or `.astaire/astaire status`). Direct
  file reads via native tools (`Read`, `cat`, editor open) are
  permitted only when:
  1. Astaire has no projection for the target (new artifacts being
     authored), or
  2. The read is in service of an edit the agent will immediately
     perform with `Edit` or `Write`.
  Strict-baseline provider adapters MUST carry this rule in their own
  adapter documentation, adapted to the provider's instruction format.
