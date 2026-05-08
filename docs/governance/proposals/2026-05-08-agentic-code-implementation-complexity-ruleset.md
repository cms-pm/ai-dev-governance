# Agentic Code Implementation Complexity Ruleset Adoption Record

Status: `implemented-in-core`
Core policy: `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
Approval gate: `docs/governance/proposals/2026-05-08-agentic-code-implementation-complexity-ruleset-approval.md`
Prepared on: 2026-05-08
Instituted: yes, for the generic ADG baseline

## Decision

The non-product-specific portions of the CockpitVM-originated complexity
proposal are adopted into `ai-dev-governance` as reusable strict-baseline
policy. The normative rules now live in:

- `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
- `core/EVIDENCE_CONTRACT.md`
- `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
- `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`
- `contracts/implementation-handoff.schema.json`
- `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`

This proposal file remains as traceability for the adoption decision.

## Adopted Generic Rules

ADG now requires production-code implementation work to account for:

- component ownership and one reason to change,
- mutable-state ownership,
- resource ownership,
- state-machine ownership and legal-transition evidence,
- task or service-loop ownership and execution metadata,
- descriptive and consistent naming,
- verb-oriented function names where appropriate,
- duplicate-name avoidance, including ambiguous pairs such as `vm_common` and
  `vm_shared`,
- generic domain-based component placement,
- line-count warning thresholds and hard caps,
- change-amplification, cognitive-load, and unknown-unknown probes,
- validation evidence for diagrams, line counts, module boundaries, and
  exceptions.

## Excluded Product-Specific Rule

A consumer-specific placement amendment from the originating project is
intentionally not part of the reusable ADG baseline. ADG adopts only the generic
rule:

> Product-specific behavior belongs in the product workspace or product-owned
> component tree, not in a generic root merely because the build can compile it.

Specific product workspace paths remain consumer-local overlay policy and
should be recorded in that consumer's governance amendment artifacts.

## Authorship Context

This adoption originated from a CockpitVM board-review exercise that used
expert-informed simulated personas. The upstream ADG policy does not claim
endorsement by any real individual. It incorporates broadly applicable
software-design ideas: single responsibility, narrow interfaces, deep modules,
information hiding, strategic programming, and explicit treatment of the
complexity symptoms of change amplification, cognitive load, and unknown
unknowns.

## Institution Notes

The approval is limited to reusable, non-product-specific rules. Consumer
projects MAY add stricter local overlays for product-specific placement,
language-specific caps, domain-specific state-machine notation, or additional
release evidence, but overlays may not weaken the strict-baseline controls.
