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

## Release Evidence

Each release MUST include:

- version tag
- compatibility statement
- migration notes (if required)
- exception status summary
- required checks summary
- board critical closure summary
- RTK setup verification and usage summary for strict Claude/Codex consumers:
  - Claude Code: `rtk init --show`, `rtk gain`, and `rtk discover`
  - Codex: `rtk init --show --codex`, `rtk gain`, and `rtk discover`
  - when repo-local RTK tracking is used, include one live usage proof such as `rtk gain --history` after a repo-local RTK command or equivalent database-mutation evidence
- graphify posture (when the manifest declares a `graphify` object):
  - `graphify.securityMode` in use (verbatim from manifest)
  - `graphify.allowlistHash` — SHA-256 of the sorted allowlist
  - graphify CLI version + pinned commit SHA
  - a sample Astaire L0 projection demonstrating the `source_repo` invariant is observed
- Astaire knowledge-base evidence (mandatory from v0.6.0 onward):
  - L0 snapshot captured at release tag cut: `docs/releases/<version>/l0-snapshot.md`
  - Health report with zero blocking findings: `docs/releases/<version>/health-report.md`
  - Both artifacts emitted by `scripts/emit_release_evidence.sh <version>`

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

## Format

Evidence MAY be stored as markdown, JSON, or YAML if required fields are present and machine-readable summaries are available.
