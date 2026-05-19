---
phase: 8.3
stage_produced: plan
---

# Phase 8.3 Risk Log — Validator Hardening + Cross-Phase Closure

Linked to: `docs/planning/pool_questions/phase-8.3-bootstrap.md`,
`docs/planning/chunks/phase-8.3-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-8.3-01 | Validator factor-out drifts from current behaviour — 17/17 PASS or negative-fixture rejection breaks | High | Medium | SCN-8.3.2 | Acceptance criterion requires byte-identical exit codes against the existing fixture suite before merge. Stand-alone validator MUST be invoked from `validate_governance.sh` rather than replacing it. New unit fixtures cover the embedded-profile present/absent matrix. | Accountable Delivery Lead | At SCN-8.3.2 review |
| R-8.3-02 | Astaire submodule pin bump in SCN-8.3.3 breaks the wrapper or the `governance_authoring` plugin for this repo | Medium | Low | SCN-8.3.3 | Each of the three enhancements lands in the submodule first with its own test in `astaire/`; pin bump only after `.astaire/astaire startup --root .` succeeds locally. Rollback by reverting the pin SHA. | Accountable Delivery Lead | At SCN-8.3.3 review |
| R-8.3-03 | Analyzer-capability schema tightening rejects existing downstream consumer manifests | Medium | Medium | SCN-8.3.4 | Transitional `legacyString` field is mutually exclusive with `structured` and preserves backward compatibility. Schema migration documented in the SCN-8.3.4 evidence bundle. First downstream consumer adoption is the live test. | Accountable Delivery Lead | At first downstream consumer adoption |
| R-8.3-04 | R-8.2-05 remains open at Phase 8.3 sign-off because Phase 8.1 reciprocal entry has not landed on `main` | High | Medium | SCN-8.3.1, SCN-8.3.5 | Closure-request packet (SCN-8.3.1) is Phase 8.3's owned artifact; the verification hook reads `phase-8.1-risks.md` each sprint critique. If still open at SCN-8.3.5, R-8.2-05 carries forward to Phase 8.4 monitoring without blocking Phase 8.3 sign-off (per the bidirectional protocol — Phase 8.3 cannot unilaterally close). | Accountable Delivery Lead | Every Phase 8.3 sprint critique |

## Carried-forward from Phase 8.2 (monitor lane)

| ID | Carried-forward reason | Phase 8.3 monitor action |
|---|---|---|
| R-8.2-02 | Static-analyzer capability auditing schema being landed by SCN-8.3.4; closure still waits on first downstream consumer adoption. | Sprint critique re-checks downstream-consumer adoption status after SCN-8.3.4 merges. |
| R-8.2-03 | Opt-in confusion can re-emerge on any consumer-side adoption. | No new triangulation needed; sprint critique re-reads triangulation surface (preamble, fixture suite, memo) at first downstream embedded-profile adoption. |
| R-8.2-04 | Rebrand lineage opacity persists while CockpitVM Embedded Style is read independently of the memo. | SCN-8.3.3 enhancement #2 (evaluations path-to-type) materially improves auditor discovery — sprint critique re-evaluates after SCN-8.3.3 lands. |
| R-8.2-05 | Cross-phase trigger from OPP-8.2-003; owned by Phase 8.3 via SCN-8.3.1. | See R-8.3-04. |

## Closed Risks

(none — phase newly opened)

## Rollback Strategy Notes

- **SCN-8.3.1 rollback.** Delete the closure-request packet. No
  transitive dependents; R-8.2-05 returns to "open + monitored without
  owned closure artifact" state.
- **SCN-8.3.2 rollback.** Revert the factor-out commit. Inline Python
  returns to `scripts/validate_governance.sh`. Acceptance suite already
  proves behaviour parity — rollback is safe.
- **SCN-8.3.3 rollback.** Revert the pin bump in this repo. The
  submodule retains the upstream commit; only registration coverage
  reverts. Astaire workarounds re-apply per `phase-8.2-todo.md`
  §Follow-ups.
- **SCN-8.3.4 rollback.** Revert the schema delta + §16 rule. Existing
  manifests with `analyzerDeclaration.legacyString` continue to validate
  under the prior free-form rule.
- **SCN-8.3.5 rollback.** Sign-off rollback follows the established
  pattern in `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability
  (revert the signoff row + traceability flip + TO-DO ticks together).
