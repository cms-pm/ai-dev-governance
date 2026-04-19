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
