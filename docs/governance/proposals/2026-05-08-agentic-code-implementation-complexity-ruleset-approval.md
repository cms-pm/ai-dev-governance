# Human Approval Gate: Agentic Code Implementation Complexity Ruleset

Status: `approved`
Ruleset: `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
Traceability record: `docs/governance/proposals/2026-05-08-agentic-code-implementation-complexity-ruleset.md`
Approved on: 2026-05-08
Instituted: yes

## Purpose

This artifact records approval for the reusable, non-product-specific
implementation-complexity controls now adopted into `ai-dev-governance`.

## Machine-Readable Approval Record

```yaml
approvalId: GOV-APPROVAL-2026-05-08-AGENTIC-COMPLEXITY
rulesetPath: core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md
approvalStatus: approved
approvedBy: cms-pm
approvedAt: 2026-05-08
approvedScope: strict-profile-default
effectiveDate: 2026-05-08
expiresAt: null
conditions:
  - Product-specific placement rules are excluded from the upstream ADG baseline and remain consumer-local overlay policy.
  - Consumer overlays may add stricter product-specific placement rules but may not weaken the core complexity controls.
```

## Approval Semantics

The generic rules are active for strict-baseline consumers through the core
policy and profile references. They may be used by agents, reviewers, and gate
automation for future production-code work.

A product-specific placement amendment from the originating project was not
upstreamed as a generic rule. Its reusable lesson is captured by the
component-placement section of `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`.

## Evidence of Institution

- Core policy added: `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
- Strict profile updated: `adapters/profiles/STRICT_BASELINE.md`
- Autonomous delivery stop rules updated:
  `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
- Operations runbook updated: `runbooks/AUTONOMOUS_DELIVERY_OPERATIONS.md`
- Evidence contract updated: `core/EVIDENCE_CONTRACT.md`
- Handoff schema extended: `contracts/implementation-handoff.schema.json`
- Board meeting template extended:
  `templates/BOARD_REVIEW_MEETING_TEMPLATE.md`
- Validator coverage added: `scripts/validate_governance.sh`

## Local Overlay Guidance

Projects that need path-specific rules, such as placing product code under a
particular workspace tree, should record those requirements in their consumer
overlay at `docs/governance/amendments/`.
