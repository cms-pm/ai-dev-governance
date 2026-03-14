# Evidence Contract

## Purpose

Defines minimum evidence fields required for planning sign-off, acceptance validation, board governance, and release quality gates.

## Planning Evidence

Each phase sign-off record MUST include:

- phase ID
- approver
- decision timestamp
- ambiguity score
- confidence score
- unresolved question count
- reference to artifacts

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

## Release Evidence

Each release MUST include:

- version tag
- compatibility statement
- migration notes (if required)
- exception status summary
- required checks summary
- board critical closure summary

## Format

Evidence MAY be stored as markdown, JSON, or YAML if required fields are present and machine-readable summaries are available.
