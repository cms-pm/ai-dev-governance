# The AI-Assisted TDR Engineering Methodology

## 1. Overview
This document defines a project-agnostic, AI-assisted Test-Driven Requirements (TDR) workflow. The core principle: **a requirement is not complete until it is testable**.

## 2. Required Artifacts (Before Implementation)
Every chunk must have these artifacts before implementation begins:
- **Pool question document** (per Planning Methodology)
- **Gherkin scenarios** (feature- and chunk-level)
- **Test plan** (manual steps acceptable)

## 3. Gherkin Standards

### 3.1 Scenario Granularity
- **Feature-level** scenarios describe the full behavior.
- **Chunk-level** scenarios refine feature-level scenarios.
- **Rule sections are not allowed** (keep features simple and explicit).

### 3.2 Scenario Count
- **Minimum**: 3 scenarios per chunk
- **Maximum**: 7 scenarios per chunk
- More than 7 indicates the chunk should be split.

### 3.3 Coverage Minimum
Each chunk must include at least:
- 1 happy path
- 1 edge case
- 1 failure case

### 3.4 Required Tags (Minimum Set)
**Test type tags**:
- `@unit`, `@integration`, `@system`

**Hardware dependency tags**:
- `@hardware`, `@mock`

**Functional/performance tags**:
- `@functional`, `@performance`

**Best practices**:
- Use lowercase tags with hyphens as needed.
- Apply high-level tags on the Feature line so scenarios inherit them.
- Use two blank lines between Features.
- Place tags immediately above Feature/Scenario keywords.

### 3.5 Scenario IDs
- Required format: `SCN-<phase>.<chunk>-<nn>` (e.g., `SCN-1.2-03`)
- Scenario IDs must appear in code comments/tests for traceability.

## 4. Performance and Non-Functional Requirements

### 4.1 Performance Criteria
- Critical paths **must** be represented in Gherkin with measurable thresholds inline.
  - Example: `Then latency p95 < 40ms`

### 4.2 Required Non-Functional Coverage
- **Performance**
- **Memory**
- **Reliability/Uptime (bounded timing)**

**Bounded timing** means meeting real-time requirements (e.g., firing once every X ms).

## 5. Hardware Acceptance
- Hardware-bound behavior must be captured with **explicit hardware-in-loop steps** in Gherkin.

## 6. Test Data and Fixtures
- Refer to test data paths **directly in Gherkin steps**.

## 7. Scenario Versioning
- When requirements change:
  - Duplicate scenario with a version tag (e.g., `@v2`).
  - Add a change log entry in the relevant doc.
- Deprecated scenarios remain in place and are **marked in the title**.

## 8. Traceability
- Maintain `docs/validation/traceability.md` with required columns:
  - Scenario ID
  - Chunk ID
  - File path(s)
  - Test type tag(s)
  - Evidence link
  - Status (pass/fail/pending)

## 9. Evidence Storage
Store validation evidence in **both** locations:
- `artifacts/validation/<phase>/<chunk>/`
- `docs/validation/<phase>/<chunk>.md`

## 10. Acceptance Test Stubs
If automation is not ready:
- Provide a **pending scenario**
- Include **manual steps** in Gherkin

## 11. Criticality and Verification Boundaries

### 11.1 What Counts as Critical
Any requirement that is:
- Safety, real-time, thermal, or memory critical
- In MVP scope
- Affects data integrity or persistence

### 11.2 LLM vs Human Verification
- LLM may approve **non-critical** items.
- Humans must verify **critical** items.
- Automated tooling is acceptable where it can verify behavior (e.g., memory inspection).

## 12. Tooling
This methodology is **tool-agnostic**. Select the testing framework that best fits the specific project.

