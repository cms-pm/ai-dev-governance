# Evidence Contract

## Purpose

Defines minimum evidence fields required for planning sign-off, acceptance validation, board governance, autonomous delivery transitions, and release quality gates.

## Planning Evidence

Each phase sign-off record MUST include:

- phase ID
- approver
- decision timestamp
- ambiguity score
- confidence score
- unresolved question count
- reference to artifacts
- risk-tier assignment summary

## Validation Evidence

Each acceptance item MUST include:

- acceptance ID
- execution timestamp
- environment profile
- checker/test identifier
- pass/fail status
- artifact URI/path
- `evidence_mode` — the verification-depth tier the pass/fail status was
  observed under. See §Evidence-Mode Qualified Verdicts.
- `intentAssertions` — the set of adversarial/non-triviality/source-authority
  checks executed for this acceptance item's hard requirements, and their
  outcomes. See `core/ACCEPTANCE_INTEGRITY.md` for the check taxonomy.
- `acceptanceIntegrity` — the classification of whether this acceptance
  record's verdict is trustworthy (for example `sound`, `hollow`,
  `mode_gated_mock`, `no_intent_assertion`). See
  `core/ACCEPTANCE_INTEGRITY.md` for the classification rules.

The following per-acceptance evidence URIs are REQUIRED at the risk
tier where the corresponding analyzer block becomes required (see
`validation/CONSISTENCY_RULES.md` §17–§19); OPTIONAL otherwise:

- `mutationReportURI` — pointer to the mutation report defined in
  `core/MUTATION_EVIDENCE.md` §Evidence URI Contract. REQUIRED at
  risk-tier ≥ medium once SCN-9.7 ratifies the threshold table.
- `farleyScorecardURI` — pointer to the test-design lens scorecard
  registered as `farley-scorecard` (see
  `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` §Test-Design Lens).
  REQUIRED at risk-tier ≥ high.
- `glossaryCoverageURI` — pointer to the glossary-coverage validator
  report defined in `core/DOMAIN_LANGUAGE_GOVERNANCE.md`. REQUIRED at
  risk-tier ≥ medium when the chunk introduces new domain vocabulary;
  REQUIRED unconditionally at risk-tier critical.
- `codegraphIndexFreshnessURI` — pointer to the CodeGraph (CG) index
  freshness evidence defined in
  `core/CODE_INTELLIGENCE_GOVERNANCE.md` §Freshness Rule. REQUIRED when
  an acceptance item cites CG output as validation or release evidence;
  OPTIONAL when CG is used only as exploratory context.
- `codegraphImageDigestURI` — pointer to the immutable CG runtime image
  digest used by the MCP service or validator. REQUIRED when a consumer
  declares CG as an enabled Tier-2 capability for the acceptance item;
  OPTIONAL when the consumer does not declare CG.

## Board Review Evidence

Each board review cycle MUST include:

- meeting ID and cadence lane
- packet reference
- severity-ranked critiques
- action register with owners and due windows
- adopted/deferred/rejected decision log
- go/no-go statement
- unresolved critical finding count

## Expert-Agent Selection Evidence

Each board composition cycle MUST include:

- role/lens coverage map
- candidate scoring records
- corpus source references
- conflict-check outcome
- composition approval record (chair signoff)
- refresh trigger and cadence metadata

## Automation Transition Evidence

Each state transition MUST include:

- state name
- transition timestamp
- required artifact references
- transition outcome (`pass|fail|blocked`)
- blocker reason (if not pass)

## Implementation Complexity Evidence

Each production-code implementation MUST include:

- component owner and placement rationale
- naming review result, including duplicate or near-duplicate module scan
- mutable state owners
- resource owners
- state-machine declaration or explicit "no state machine" statement
- task/service-loop declaration or explicit "no task loop" statement
- public surface summary
- line-count evidence for touched production files
- change-amplification, cognitive-load, and unknown-unknown scores
- exception IDs for any hard-cap or forbidden-pattern violation
- diagram references when state or task topology changes

## Release Evidence

Each release MUST include:

- version tag
- compatibility statement
- migration notes (if required)
- exception status summary
- required checks summary
- board critical closure summary
- implementation complexity summary for production-code changes
- RTK setup verification and usage summary for strict Claude/Codex consumers:
  - Claude Code: `rtk init --show`, `rtk gain`, and `rtk discover`
  - Codex: `rtk init --show --codex`, `rtk gain`, and `rtk discover`
  - when repo-local RTK tracking is used, include one live usage proof such as `rtk gain --history` after a repo-local RTK command or equivalent database-mutation evidence
- Astaire knowledge-base evidence (mandatory from v0.6.0 onward):
  - L0 snapshot captured at release tag cut: `docs/releases/<version>/l0-snapshot.md`
  - Health report with zero blocking findings: `docs/releases/<version>/health-report.md`
  - Both artifacts emitted by `scripts/emit_release_evidence.sh <version>`
- CodeGraph Tier-2 evidence (when the release manifest declares CG):
  - `codegraphIndexFreshnessURI`
  - `codegraphImageDigestURI`
  - declared CG path scope and checker identifier

## Scenario Status Vocabulary

Acceptance-item `pass/fail status` MUST resolve to one of:

- `not-started`  — no test exists yet
- `expected-fail` — test exists, implementation pending (tombstone)
- `passing`       — test exists and passes against current implementation
- `failing`       — test exists and fails against current implementation
- `waived`        — covered by an exception/waiver under
                    `core/EXCEPTIONS_AND_WAIVERS.md`

`skipped` is not a valid terminal state for a scenario with ratified
acceptance criteria. Runners MAY produce `skipped` as an intermediate
state (for example, an environment-unavailable HiL probe) but evidence
records MUST resolve to one of the values above before sign-off.

## Evidence-Mode Qualified Verdicts

Every acceptance record MUST declare `evidence_mode`, the
verification-depth tier under which its pass/fail status was observed.
Tiers, ordered least to most rigorous:

1. `mock` — no real target/environment; stubbed or simulated inputs.
2. `sil` — software-in-the-loop against real production code, no target
   hardware.
3. `hil_record_only` — hardware/target-in-the-loop, evidence captured but
   not yet promoted through the full board/release path.
4. `board_passing` — hardware/target-in-the-loop evidence that has cleared
   board review and is release-eligible.

A recorded terminal status from §Scenario Status Vocabulary MUST be
qualified by its `evidence_mode` wherever both fields are present, using
the form `<status>@<evidence_mode>` (for example `passing@sil`,
`passing@mock`). A bare `passing` with no `evidence_mode` qualifier is not
a valid acceptance record at strict-baseline profile.

Downstream consumers (dashboards, release evidence, board packets) MUST
NOT collapse a lower-tier verdict such as `passing@mock` into an
unqualified `passing` claim or represent it as equivalent to
`passing@board_passing`. Doing so discards the verification-depth signal
this field exists to preserve; see `core/ACCEPTANCE_INTEGRITY.md` for the
mechanical detection of this failure mode.

## Format

Evidence MAY be stored as markdown, JSON, or YAML if required fields are present and machine-readable summaries are available.
