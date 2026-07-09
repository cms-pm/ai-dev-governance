# Autonomous Delivery Governance

## Purpose

Define a policy-driven automation state machine that minimizes human intervention for low and medium risk work while preserving strict quality gates.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Automation State Machine

Required lifecycle:

1. `ingest`
2. `plan`
3. `artifact-generation`
4. `implementation`
5. `validation`
6. `board-review`
7. `gate`
8. `release`

Transitions MUST fail closed when required artifacts are missing or checks are red.

## Deterministic Stop Rules

Execution MUST stop when any of the following are true:

- Required planning or TDR artifacts are missing.
- Validation checks fail.
- Required implementation-complexity evidence is missing for production code.
- Required board artifacts are missing for high/critical work.
- Open critical board findings exist without approved exception.
- Required human approvals are missing for the assigned risk tier.

## Risk-Tiered Autonomy

| Tier | Typical Scope | Automation Behavior | Human Requirement | Board Requirement |
|---|---|---|---|---|
| low | localized low-risk change | auto-merge on green checks | none | no |
| medium | moderate scope, low blast radius | automated execution + merge gate | 1 reviewer | no |
| high | broad impact or hard-to-reverse change | automated execution, manual gate | chair signoff + reviewer | yes |
| critical | safety/security/data-integrity/runtime critical | automated execution with strict fail-closed gates | chair signoff + designated accountable approver | yes (mandatory) |

## Human Intervention Rules

Human intervention is required only for:

1. Initial and refresh board composition approval.
2. High/critical board outcomes.
3. Exception approvals and renewals.

All other paths SHOULD run with minimal manual operations under policy controls.

## Artifact-First Execution

Automation MUST emit machine-readable artifacts at each state boundary.

Minimum required structured artifacts:

- Board findings
- Board decisions
- Implementation handoff packet
- Implementation complexity note for production code
- Risk-tier assignment record
- Validation status summary

Implementation complexity evidence MUST follow
`core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` and include ownership,
naming/placement, line-count, state/task, and complexity-rubric findings when
production code changes.

Optional Tier-2 code-intelligence capabilities MAY be declared as structured
artifacts. CodeGraph (CG) is optional at v1: a consumer that declares CG MUST
emit the evidence fields registered in `core/EVIDENCE_CONTRACT.md`
(`codegraphIndexFreshnessURI` and `codegraphImageDigestURI`) when CG output is
used for validation or release evidence; a consumer that does not declare CG
MUST NOT fail required-presence checks solely because CG is absent.

## Release Gating

Release MUST be blocked when:

- unresolved critical findings exist and `criticalFindingsBlockRelease=true`
- required exception is missing or expired
- required checks fail

## Simulation Positioning

Expert-agent board personas are expert-informed simulations. They MUST not imply endorsement by real individuals.

## Delivery Loop Primitives

Autonomous delivery runs as a bounded loop over four primitives:

1. **Schedule** — selects the next unit of work (the `executionOrder` /
   dependency chain recorded in planning artifacts).
2. **Maker** — produces the change: implementation, evidence, or
   artifact.
3. **Separate checker** — independently re-derives the acceptance verdict
   from the maker's output rather than reading the maker's self-declared
   status. See §Checker Is Not the Maker.
4. **State on disk** — the loop's shared, inspectable state (ledgers,
   closeouts, status records) that both maker and checker read, and that
   survives process restarts.

This policy specifies the contract each primitive MUST satisfy. The
runner that schedules iterations, tunes retry/budget behavior, or
measures loop effectiveness over time is out of scope here; it is a
downstream, execution-environment concern.

## Checker Is Not the Maker

The agent, process, or session that produces a change MUST NOT be the
sole authority that grades its own acceptance verdict.

- A separate checker MUST re-derive `PASS`/`WAIVED`/`FAIL` (see §Gate
  Terminal States) from evidence. Reading and re-emitting the maker's
  self-reported status string does not satisfy this requirement.
- Where an isolated checker session/identity is not available (for
  example, supervised or CI use without a separate execution identity),
  the checker step MUST still run as a distinct code path that the maker
  cannot special-case or short-circuit, and its output MUST be treated as
  blocking, not self-issued.
- Fully unattended sufficiency — the checker running under a genuinely
  separate session/identity from the maker — is out of scope for this
  policy; it is a downstream, execution-environment concern.

## Read-Gate by Tier

Human read/review requirement for a delivery-loop iteration scales with
the risk tier already assigned under §Risk-Tiered Autonomy above. The
`Human Requirement` and `Board Requirement` columns in that table ARE the
read-gate: `low` requires no human read, `medium` requires reviewer read,
`high`/`critical` require chair signoff plus reviewer or designated
accountable-approver read. This policy does not introduce a second,
parallel tiering scheme — checker and release read-gates MUST key off the
same risk-tier assignment record produced under §Artifact-First
Execution.

## Gate Terminal States

Every gate/checker evaluation MUST resolve to exactly one of three
terminal states:

- `PASS` — the checker independently verified the evidence satisfies the
  requirement.
- `WAIVED` — an approved, time-bound exception under
  `core/EXCEPTIONS_AND_WAIVERS.md` covers the gap; the recorded `WAIVED`
  outcome MUST cite the exception ID.
- `FAIL` — the checker could not verify `PASS` and no approved waiver
  exists.

No fourth terminal state is valid at gate close. `skipped`, `pending`,
`unknown`, or an absent verdict are not terminal states; a gate that
reaches state-transition time without one of `PASS`/`WAIVED`/`FAIL`
recorded MUST be treated as `FAIL` for release-gating purposes
(fail-closed).

## Hollow Verdicts

A recorded `PASS` is invalid — regardless of its status string — if it
was computed from a value the maker controls, including but not limited
to:

- a hardcoded literal (a status field set to a passing value with no
  underlying check ever executed against it);
- a mode-gated stub (a check that only runs, or is only made to pass,
  under a low-rigor `evidence_mode` such as `mock`, and is then treated
  as equivalent to a verdict earned at a higher-rigor mode);
- a pre-declared or self-reported status string carried forward with no
  independent re-observation by the checker;
- an empty or vacuous acceptance set treated as satisfied by default.

Such a verdict MUST be classified as `hollow` and MUST NOT be recorded or
consumed as `PASS`. Mechanical detection and classification of hollow
verdicts is specified in `core/ACCEPTANCE_INTEGRITY.md`; this policy
establishes the doctrine that a hollow verdict is never a valid terminal
state, regardless of what the producing tool chain reports.

The harness meta-loop that measures checker effectiveness, tracks
verdict-integrity trends over time, or tunes gate thresholds is out of
scope for this policy; it is a downstream, execution-environment concern.
