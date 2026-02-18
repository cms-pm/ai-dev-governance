# Planning Methodology and Decision Framework

## Overview
This document defines a project-agnostic planning framework for AI-assisted embedded development. The goal is to eliminate ambiguity before implementation and create an auditable trail of decisions, risks, and acceptance criteria.

## Definitions
- **Phase**: A major delivery milestone composed of multiple chunks.
- **Chunk**: A small, testable unit of work (see Git strategy for size limits).
- **Pool Question**: A high-impact question used to remove ambiguity in a decision domain.
- **Functional/Behavioral**: Observable system behavior that can be tested with acceptance criteria.

## Planning Complete (Exit Criteria)
Planning is complete only when all of the following are true:
1. **Pool questions answered and archived** for the phase.
2. **Gherkin scenarios exist for each planned chunk** (feature- and chunk-level).
3. **Architecture risks are logged with mitigations** in the phase risk file.

## Pool Question Cycles (Per Phase)
Each phase must complete pool question cycles before implementation begins.

### Cycle Scope
- **Primary scope**: Phase-level pool.
- **Sub-pools**: Allowed per domain (e.g., storage, timing, sync). All sub-pools must be resolved before phase sign-off.

### Minimum Cycle Expectations
- Use 4-6 carefully crafted questions per decision domain.
- Continue cycles until ambiguity is resolved (see Ambiguity Framework).

## Pool Question Artifacts

### Location and Naming
- **Directory**: `docs/planning/pool_questions/`
- **File naming**: `phase-X-domain-topic.md`

### Mandatory Fields in Each Pool Question File
- **Goal**
- **Scope / Non-goals**
- **Questions + Answers**
- **Decisions + Rationale**

## Ambiguity Framework
Ambiguity is considered resolved only when **all** of the following are true:
1. **No unresolved questions remain**.
2. **Ambiguity score < 0.02**.
3. **Average confidence score >= 4.9**.

### Ambiguity Score Formula
If any unresolved questions exist, ambiguity fails automatically.

Otherwise:
```
Ambiguity = Σ(P × I × U × M) / Σ(I)
```

**Definitions**:
- **P (Probability)**: Likelihood the decision is wrong if implemented now.
- **I (Importance)**: Technical-debt/lock-in impact.
  - 1 = reversible later
  - 3 = expensive to change
  - 5 = near-irreversible
- **U (Uncertainty)**:
  - 0 = fully answered
  - 0.5 = partially answered
  - 1 = unknown
- **M (Momentum)**: Critical-path impact.
  - 1 = not blocking
  - 3 = affects near-term sequencing
  - 5 = critical-path gate

### Confidence Scale (1-5)
- **5** = Verified by data, test, or measurement
- **4** = Reasoned but unverified

## Mapping to Acceptance Criteria
Pool questions must map to Gherkin **only** when they are functional/behavioral (observable and acceptance-testable). Non-functional or purely exploratory questions may be documented without Gherkin mapping.

## Sign-off
- **Stakeholder**: Lead engineer
- **Record**: `docs/planning/signoffs.md` (phase, date, interaction reference)
- Sign-off occurs during interaction with the LLM agent (chat or gated response).

## Risk Management
- **Per-phase risk log**: `docs/planning/phase-<n>-risks.md`
- Must include all architecture risks and associated mitigations before planning is considered complete.

## Chunk “Done” Definition (Planning Gate)
A chunk is “done” only when all applicable criteria are met:
- All acceptance criteria pass (manual or automated)
- Code review completed
- Performance budgets met
- Hardware validation complete **when applicable**

## Context Management Principles
- **Keep last two phases active**; archive older material.
- Archive historical content in `docs/` after phase completion.
- Balance KISS with extensibility.
- Keep CLAUDE.md (or GEMINI.md or provider-specific main context file) updated with last phase, current phase (with chunks), and next phase.
- Keep CLAUDE.md or similar file optimized for context window size, linking files rather than repeating contents.

