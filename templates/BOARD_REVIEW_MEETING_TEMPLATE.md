# Board Review Meeting Template

Use this file as the canonical template for each board/committee review meeting.

Copy target naming convention:
- `<planningPath>/board/committee-virtual-meeting-<topic>-<YYYY-MM-DD>.md`

## Status
Draft

## Date
`<YYYY-MM-DD>`

## Positioning Note
This is a `<real|simulated>` board review. Where simulation roles are used, this exercise is not authored or endorsed by external individuals.

## Machine-Readable Metadata (YAML)

```yaml
meetingId: MTG-0001
boardId: BRD-YYYY-MM
cadenceLane: Sprint Critique
riskTierFocus:
  - high
  - critical
packetRef: <path>
```

## Meeting Cadence Lane
`<Sprint Critique (weekly) | Accountability Review (4-week/monthly) | Incident/Emergency (within 24h)>`

## Chair and Participants
- Chairperson: `<name>`
- Board/Committee reviewers:
  - `<name>`
  - `<name>`
- Domain owners present:
  - `<domain-owner-1>`
  - `<domain-owner-2>`
- Scribe: `<name>`

## Objective
State the decision this meeting must produce (for example: course-correct implementation, approve/no-go promotion gate, or evaluate unresolved critical risks).

## Packet Presented (Pre-Read)
1. `<spec/roadmap status>`
2. `<phase risk log>`
3. `<ambiguity summary>`
4. `<validation traceability/evidence>`
5. `<incident/runtime summary>`
6. `<prior action closure report>`

## Agenda (Timeboxed)
1. Context and objective recap - `<X min>`
2. Evidence review and unresolved risks - `<X min>`
3. Constructive criticism round - `<X min>`
4. Opportunity triage and ownership - `<X min>`
5. Go/No-Go and gate decision - `<X min>`
6. Integration and deadlines - `<X min>`

## Constructive Criticism Log
Use one row per critique item.

| ID | Observation | Risk/Gap | Severity (`Critical/High/Medium/Low`) | Required Adjustment | Evidence Needed for Closure | Owner | Target Window |
|---|---|---|---|---|---|---|---|
| FND-0001 | `<what is currently true>` | `<why this is risky>` | `<severity>` | `<specific change request>` | `<test/artifact path>` | `<owner>` | `<date/window>` |

## Structured Findings (JSON)

```json
[
  {
    "findingId": "FND-0001",
    "meetingId": "MTG-0001",
    "severity": "High",
    "lens": "architecture",
    "observation": "...",
    "riskGap": "...",
    "requiredAdjustment": "...",
    "closureEvidence": "...",
    "owner": "...",
    "targetDate": "YYYY-MM-DD",
    "status": "open"
  }
]
```

## Opportunity Register (Meeting Output)
All accepted opportunities must receive stable IDs.

| ID | Severity | Opportunity / Gap | Immediate Deliverable | Suggested Owner | Target Window | Status (`Adopted/Deferred/Rejected`) |
|---|---|---|---|---|---|---|
| COM-001 | `<severity>` | `<opportunity>` | `<deliverable>` | `<owner>` | `<window>` | `<status>` |

## Structured Decisions (JSON)

```json
[
  {
    "decisionId": "DEC-0001",
    "meetingId": "MTG-0001",
    "relatedFindingIds": ["FND-0001"],
    "outcome": "Adopted",
    "rationale": "...",
    "gate": {
      "scopeDecision": "Go",
      "gateStatement": "...",
      "preconditions": ["..."]
    }
  }
]
```

## Go / No-Go Decision
- Scope decision: `<Go|No-Go>`
- Gate statement: `<explicit promotion/deployment gate>`
- Preconditions: `<list of required closures>`

## Integration Targets
List exact files to update from this meeting:
1. `<planningPath>/board/committee-opportunity-register-<topic>-<YYYY-MM-DD>.md`
2. `<planningPath>/phase-<n>-risks.md`
3. `<planningPath>/pool_questions/<...>.md`
4. `<planningPath>/ambiguity-round-<n>-summary.md`
5. `<planningPath>/chunk-<...>-implementation-plan.md`
6. `<planningPath>/gherkin/phase-<n>/chunk-<...>.feature`
7. `<planningPath>/test-plans/chunk-<...>-test-plan.md`
8. `<validationPath>/traceability.md`
9. `<planningPath>/board/committee-artifacts-overview.md`

## Action Register (Post-Meeting)
| Action ID | Description | Owner | Due Date | Evidence Path | Status |
|---|---|---|---|---|---|
| ACT-001 | `<action>` | `<owner>` | `<date>` | `<path>` | `<open/closed>` |

## Implementation Handoff (JSON)

```json
{
  "handoffId": "HOF-0001",
  "sourceMeetingId": "MTG-0001",
  "riskTier": "high",
  "adoptedActionIds": ["ACT-001"],
  "chunkMappings": [{"actionId": "ACT-001", "chunkId": "chunk-1.2.3"}],
  "acceptanceMappings": [{"chunkId": "chunk-1.2.3", "acceptanceId": "SCN-1.2-03"}],
  "riskDeltaPaths": ["docs/planning/phase-1-risks.md"],
  "traceabilityPath": "docs/validation/traceability.md",
  "owner": "...",
  "status": "ready"
}
```

## Ambiguity and Follow-Up Questions
1. `<question>`
2. `<question>`
3. `<question>`

## Signoff
- Prepared by: `<name>`
- Reviewed by Chair: `<name/date>`
- Board/Committee status: `<Approved|Conditional|Rejected>`

## Post-Meeting Checklist
- [ ] Meeting notes published.
- [ ] Opportunity register addendum created.
- [ ] Risk log updated.
- [ ] Ambiguity/pool question artifacts updated.
- [ ] Chunk/Gherkin/test-plan artifacts created for adopted items.
- [ ] Validation expectations and evidence paths defined.
- [ ] Board artifacts overview updated.
