# Evidence Contract

## Purpose

Defines minimum evidence fields required for planning sign-off, acceptance validation, and release quality gates.

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

## Release Evidence

Each release MUST include:

- version tag
- compatibility statement
- migration notes (if required)
- exception status summary
- required checks summary

## Format

Evidence MAY be stored as markdown, JSON, or YAML if required fields are present and machine-readable summaries are available.
