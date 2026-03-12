# AI-Assisted Test-Driven Requirements (TDR)

## Purpose

This core policy defines test-driven requirements for AI-assisted development. Requirements are complete only when behavior can be objectively validated.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Minimum Pre-Implementation Artifacts

Each chunk MUST have:

1. Planning reference (pool Q/A decision record)
2. Acceptance criteria at feature and chunk level
3. Validation plan (manual, automated, or hybrid)
4. Evidence destination path declared in governance manifest

## Acceptance Criteria Design

- Criteria MUST cover happy path, edge case, and failure case.
- Scenario count SHOULD remain focused; split chunks when scope is too broad.
- `Rule` sections MAY be used when they improve clarity.

## Tagging and Classification

Recommended minimum tags:

- Test type: `@unit`, `@integration`, `@system`
- Environment: `@hardware`, `@mock`
- Intent: `@functional`, `@performance`

Additional tags MAY be added by adapter profiles.

## IDs and Traceability

- Each acceptance item MUST have a stable ID.
- ID format defaults to `SCN-<phase>.<chunk>-<nn>` and MAY be adapted.
- IDs MUST map to implementation and evidence records.
- Trace table MUST include: ID, chunk, implementation path(s), evidence link, status.

## Non-Functional Requirements

The following MUST be explicitly validated where applicable:

- Performance (timing bounds)
- Memory/resource usage
- Reliability/uptime

Bounded timing MUST use measurable thresholds (for example: trigger every X ms, p95 latency below Y ms).

## Hardware-Dependent Validation

If behavior depends on hardware characteristics, acceptance criteria MUST include hardware-in-loop validation steps or a documented reason for temporary simulation-only validation.

## Scenario Lifecycle and Versioning

- Acceptance IDs MUST remain stable across revisions.
- Revisions MUST be tracked in change history with rationale.
- Deprecated criteria MUST be marked and linked to replacement criteria.

## Evidence Requirements

Evidence MUST be stored in declared paths and include:

- execution timestamp
- tool/test identifier
- environment profile
- pass/fail status
- artifact pointers (logs, metrics, captures)

## Human Accountability and AI Boundaries

- A human approver MUST own final acceptance and merge decisions.
- AI assistance MAY draft tests and criteria.
- AI-only approvals are prohibited for merge/release gates.

## Tooling

This policy is tool-agnostic. Projects choose frameworks and runners through adapters while preserving core policy requirements.
