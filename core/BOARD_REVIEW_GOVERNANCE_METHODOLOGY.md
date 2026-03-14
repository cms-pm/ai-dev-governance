# Board Review Governance Methodology

## Purpose

Define a repeatable board/committee review process that produces high-signal critique, prioritized opportunities, and auditable integration into planning, implementation, and validation.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Scope

This methodology governs:

1. Board/committee cadence and triggers.
2. Pre-read packet requirements.
3. Constructive criticism and opportunity triage standards.
4. Decision/gate outcomes.
5. Integration into planning, TDR, risk, and evidence artifacts.
6. Expert-agent board selection and composition refresh.

This methodology complements core planning, TDR, and autonomous delivery policies.

## Governance Principles

1. Survivability-first: critical risk controls cannot be traded for speed.
2. Evidence over intuition: every recommendation maps to inspectable artifacts.
3. Constructive candor: critique systems and process, not people.
4. Closed-loop ownership: accepted opportunities require owner, due window, and closure evidence.
5. Fail-closed operations: unresolved critical issues block promotion unless covered by approved exception.
6. Corpus-grounded expertise: each board seat is backed by a machine-usable professional corpus relevant to that seat.

## Roles and Responsibilities

1. Chairperson
   - Owns agenda, timeboxing, and scope control.
   - Approves board composition and all high/critical board gates.
2. Review Panel
   - Produces severity-ranked findings with concrete adjustments.
3. Accountable Delivery Lead
   - Owns integration of adopted outcomes into planning/implementation artifacts.
4. Domain Owners
   - Provide acceptance/rebuttal input and closure evidence.
5. Scribe/Methodology Steward
   - Maintains traceability, links, and sign-off records.

## Cadence Model

All strict-baseline projects MUST support these lanes:

| Lane | Cadence | Trigger | Objective | Required Output |
|---|---|---|---|---|
| Sprint Critique | Weekly during active delivery | Open high-severity opportunities or major rollout | Fast corrective steering | Meeting record + action updates |
| Accountability Review | Every 4 weeks (minimum monthly) | Calendar-based | Verify commitments and evidence quality | Review packet + sign-off |
| Incident/Emergency Review | Within 24 hours of critical breach | P1 control failure, ungated promotion, major incident | Containment + policy correction | Incident addendum + risk/action updates |

## Standard Lifecycle

1. Prepare packet (T-2 days).
2. Distribute pre-read and collect written questions (T-1 day).
3. Run board session and classify outcomes (T).
4. Publish artifacts (T+1 day).
5. Integrate adopted outcomes into planning/TDR/chunk mapping (T+2 days).
6. Validate closure before next cadence checkpoint.

## Required Inputs (Pre-Read Packet)

Minimum packet contents:

1. Active spec and roadmap status.
2. Current phase risk log.
3. Ambiguity summaries and unresolved questions.
4. Validation traceability and recent evidence.
5. Runtime/operations health and incident summary.
6. Previous action closure status.

Use templates:

- `templates/BOARD_REVIEW_PACKET_TEMPLATE.md`
- `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`
- `templates/BOARD_OPPORTUNITY_REGISTER_TEMPLATE.md`

## Constructive Criticism Protocol

Each critique entry MUST include:

1. Observation (what is currently true).
2. Risk/Gap (why it matters).
3. Severity (`Critical | High | Medium | Low`).
4. Required Adjustment (concrete request).
5. Closure Evidence (exact artifact/test).
6. Owner and target window.

Quality bar:

- No vague criticism without mitigation.
- No mitigation without owner and due window.
- No accepted action without validation path.

## Opportunity Prioritization

Prioritize opportunities by:

1. Severity if unaddressed.
2. Reversibility cost.
3. Time-to-mitigate.
4. Dependency depth.
5. Evidence confidence.

Tracking rules:

- Every opportunity MUST have a stable ID.
- IDs MUST appear in the opportunity register, risk log, and planning chunk mapping.

## Expert-Agent Board Selection

### Required Lenses

Each board composition MUST cover these lenses:

- architecture
- reliability
- security
- performance
- operability
- cognitive-load
- domain-specific lens (project-defined)

### Candidate Eligibility

Candidates MUST satisfy all:

1. Prominent standing with inspectable renown/impact evidence.
2. Substantial published corpus (books/papers/talks/articles).
3. Direct role fit to assigned board seat.
4. Machine-usable corpus coverage enabling reproducible reasoning.

### Selection Scoring Rubric

Score each candidate 1-5 per criterion:

- `Prominence`
- `CorpusDepth`
- `RoleFit`
- `EvidenceAccessibility`
- `RecencyRelevance`

Default selection threshold:

- Weighted average MUST be >= 4.0
- `RoleFit` MUST be >= 4
- `EvidenceAccessibility` MUST be >= 4

### Selection Workflow

1. Define roles and required lenses.
2. Build candidate longlist.
3. Ingest/normalize candidate corpus references.
4. Score candidates and run conflict checks.
5. Build composition proposal (primary + alternate per seat).
6. Obtain human chair approval.
7. Refresh quarterly or incident-triggered.

Operational rule: board personas are expert-informed simulation profiles and MUST never be presented as endorsements.

## Decision and Gate Outcomes

Every meeting MUST classify outcomes as:

- `Adopted`
- `Deferred` (with revisit date)
- `Rejected` (with rationale)

Go/No-Go decisions MUST be explicit and include gate criteria.

## Mandatory Output Artifacts

Per meeting:

1. Meeting record
2. Opportunity register update
3. Risk log update
4. Planning/TDR integration updates
5. Validation traceability updates
6. Structured finding and decision artifacts
7. Structured implementation handoff artifact

Default paths are project-defined via governance manifest evidence fields.

## Integration with Core Policies

- Planning: adopted outcomes feed phase/chunk planning and ambiguity closure.
- TDR: adopted outcomes requiring behavior change MUST map to acceptance criteria IDs.
- Autonomous delivery: board artifacts gate high/critical transitions.
- Git/Release: unresolved critical findings block release unless approved exception exists.
- Evidence contract: board review evidence MUST be complete and auditable.

## Anti-Patterns

1. Narrative-only minutes without action register.
2. Severity labels without owners/dates.
3. Accepted actions without closure evidence.
4. Cadence slips without exception and recovery date.
5. Promotion decisions without explicit gate criteria.
6. Seat assignments without corpus evidence and scoring records.

## Positioning Note

Where simulation roles are used, label them clearly as simulation and avoid implying external endorsement.
