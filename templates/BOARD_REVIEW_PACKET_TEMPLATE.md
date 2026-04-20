# Board Review Packet Template

Copy target naming convention:
- `<planningPath>/board/committee-review-packet-<YYYY-MM-DD>.md`

## Packet Metadata

- Date: `<YYYY-MM-DD>`
- Cadence lane: `<Sprint Critique|Accountability Review|Incident/Emergency>`
- Chair: `<name>`
- Scribe: `<name>`
- Meeting objective: `<decision this meeting must produce>`

## Machine-Readable Metadata (YAML)

```yaml
packetId: PKT-0001
cadenceLane: Accountability Review
meetingDate: YYYY-MM-DD
relatedBoardId: BRD-YYYY-MM
sourceRiskTierSummary:
  low: 0
  medium: 0
  high: 0
  critical: 0
```

## Required Inputs

1. Active scope/roadmap summary and delta since last meeting.
2. Current risk log and unresolved critical/high items.
3. Ambiguity summary and open planning questions.
4. Validation traceability status and latest evidence highlights.
5. Runtime/operations health summary and incident report.
6. Prior action closure report.

## Gate Snapshot

- Open critical findings: `<count>`
- Open high findings: `<count>`
- Release blocker status: `<blocked|not blocked>`
- Active exceptions affecting board actions: `<ids or none>`

## Pre-Read Questions

1. `<question>`
2. `<question>`
3. `<question>`

## Structural Context

### God Nodes

- `<node + why it matters>`

### Surprising Connections

- `<connection + ranked rationale>`

### AMBIGUOUS-Edge Backlog

- `<edge + why it remains unresolved>`

### Open Contradictions

- `<contradiction + impact>`

## Immediate Implementation Directives

- `PR scope:` `<one behavior per PR or one repo-local workstream>`
- `File ownership:` `<paths the implementation should touch>`
- `Validation:` `<tests/evidence required before the action is considered closed>`
- `Release impact:` `<blocking|non-blocking|waivable with chair approval>`

## Links

- Risk log: `<path>`
- Traceability: `<path>`
- Prior meeting record: `<path>`
- Opportunity register: `<path>`
