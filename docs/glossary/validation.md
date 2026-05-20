---
phase: 9
stage_produced: implementation
context: validation
authoring_authority: Accountable Delivery Lead
created: 2026-05-19
last_review: 2026-05-19
---

# Validation — Bounded-Context Glossary

The vocabulary of `validation/`, `scripts/validators/`, and the
`scripts/validate_governance.sh` chain: the layer that turns governance
manifests, evidence artifacts, and consistency rules into pass/fail
verdicts.

Per `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Per-Context Authoring
Authority, the Accountable Delivery Lead accepts proposals, approves
amendments and deprecations, and resolves homograph disputes with peer
contexts (`governance-authoring`, `memory-palace`, `adapters`).

## Terms

### Consistency Rule

- **Definition.** A numbered normative clause in
  `validation/CONSISTENCY_RULES.md` declaring an invariant that the
  governance manifest or a peer artifact must satisfy, with an
  associated WARN-or-FAIL disposition.
- **Owning context.** validation
- **Canonical references.**
  - `validation/CONSISTENCY_RULES.md`
- **Synonyms (deprecated).** none.

### Validator

- **Definition.** An executable module under `scripts/validators/`
  callable as `python -m scripts.validators.<name> --manifest <path>`
  that returns a `(exit_code, message)` verdict against one or more
  consistency rules.
- **Owning context.** validation
- **Canonical references.**
  - `scripts/validators/`
  - `scripts/validate_governance.sh`
- **Synonyms (deprecated).** none.

### Gate

- **Definition.** A point in the autonomous-delivery state machine
  where validator verdicts collectively determine whether work
  advances; gates are fail-closed by default.
- **Owning context.** validation
- **Canonical references.**
  - `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Gate Conditions
  - `scripts/validate_governance.sh`
- **Synonyms (deprecated).** none.

### Fail-Closed

- **Definition.** The default validator disposition: any structural
  violation, missing required artifact, or red verdict halts the state
  machine without an explicit exception.
- **Owning context.** validation
- **Canonical references.**
  - `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` §Fail-Closed Semantics
- **Synonyms (deprecated).** none.

### WARN-Until-Ratified

- **Definition.** The advisory disposition assigned to a rule whose
  thresholds have not yet been ratified by a board decision; the
  validator prints to stderr and exits 0 until ratification flips the
  rule to fail-closed.
- **Owning context.** validation
- **Canonical references.**
  - `core/MUTATION_EVIDENCE.md` §Advisory Marker
  - `validation/CONSISTENCY_RULES.md` §17
- **Synonyms (deprecated).** "soft gate" used informally pre-Phase 9;
  the formal term is **WARN-until-ratified**.

### Analyzer Capability

- **Definition.** An optional manifest block under `analyzers.*`
  declaring a downstream-consumer capability (e.g.
  `domainGlossary`, `mutation`, `architectureFitness`) with structural
  required keys and a tier-gated presence rule.
- **Owning context.** validation
- **Canonical references.**
  - `contracts/governance-manifest.schema.json` `analyzers` block
  - `validation/CONSISTENCY_RULES.md` §17–§19
- **Synonyms (deprecated).** none.

### Fixture

- **Definition.** A versioned positive or negative example manifest
  (or evidence file) under `validation/fixtures/` used to exercise
  validator pass/fail behaviour without coupling to live repository
  state.
- **Owning context.** validation
- **Canonical references.**
  - `validation/fixtures/`
- **Synonyms (deprecated).** none.

### Exception

- **Definition.** A time-bound, board-approved waiver of a fail-closed
  rule recorded in the exception registry; consumed by validators that
  consult the registry before flipping a verdict.
- **Owning context.** validation
- **Canonical references.**
  - `core/EXCEPTIONS_AND_WAIVERS.md`
  - `docs/governance/exceptions.yaml`
- **Synonyms (deprecated).** none.

### Waiver

- **Definition.** Synonym for **Exception** in the autonomous-delivery
  state machine; the two terms are interchangeable at v1 but the
  canonical noun in validation prose is **Exception**.
- **Owning context.** validation
- **Canonical references.**
  - `core/EXCEPTIONS_AND_WAIVERS.md`
- **Synonyms (deprecated).** none.

### Protected Path

- **Definition.** A repository-relative directory listed under
  `analyzers.domainGlossary.coverageRule.protectedPaths` or
  `analyzers.architectureFitness.rulesPath`; validators apply the
  naming-correspondence and forbidden-import rules inside protected
  paths only.
- **Owning context.** validation
- **Canonical references.**
  - `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Naming Correspondence Rule
  - `core/MODULARITY_GOVERNANCE.md` §Architecture Fitness Rule
- **Synonyms (deprecated).** none.

## Deprecations

(none at v1)
