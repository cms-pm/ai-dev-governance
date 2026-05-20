---
phase: 9
stage_produced: plan
---

# Phase 9 Risk Log — TDR Hardening (DDD + Hexagonal + Mutation + Test-Design)

Linked to: `docs/planning/pool_questions/phase-9-tdr-hardening.md`,
`docs/planning/chunks/phase-9-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-9-04 | Manifest schema additions (mutation, glossary, architecture-fitness) reject existing downstream consumer manifests despite the optional-at-v1 contract | Medium | Low | SCN-9.2, SCN-9.6, first downstream adoption | All three blocks declared `optional` in `governance-manifest.schema.json` per Q5 resolution. Tier-gated presence is enforced at the `validation/CONSISTENCY_RULES.md` §17–§19 layer, not in the schema. Migration note (SCN-9.6) provides copy-paste templates and explains tier-vs-presence semantics. First downstream consumer adoption is the live test. Closure cadence mirrors R-8.2-02. | Accountable Delivery Lead | At first downstream consumer adoption of any of the three new blocks |
| R-9-05 | Glossary authoring authority drift — bounded contexts disagree on canonical term definitions, or new code lands without naming-correspondence enforcement | Medium | Medium | SCN-9.4, SCN-9.6, every consumer adoption | `core/DOMAIN_LANGUAGE_GOVERNANCE.md` names per-context authoring authority in the file preamble. The `glossary_coverage.py` validator (SCN-9.2) checks that types/functions/test names in the bounded-context directory map to glossary terms. Disputes escalate to board review (the test-design lens MAY annex glossary findings). | Accountable Delivery Lead | Phase 10 bootstrap and quarterly thereafter |

## Carried-forward from Phase 8.2 / 8.3 (monitor lane)

| ID | Carried-forward reason | Phase 9 monitor action |
|---|---|---|
| R-8.2-02 | Static-analyzer capability schema landed at SCN-8.3.4; closure waits on first downstream consumer adoption. Phase 9 adds three more analyzer blocks (mutation, glossary, architecture-fitness) under the same backward-compat discipline. | Sprint critique re-checks downstream-consumer adoption for both the SCN-8.3.4 analyzer-capability block and the new SCN-9.2 blocks. |
| R-8.2-05 | Cross-phase R-8.2-05 (Phase 8.1 reciprocal entry on `main`) remained open at Phase 8.3 sign-off. | Standing sprint-critique read of `phase-8.1-risks.md` on `main` each iteration; closure cadence unchanged. Carries to Phase 10 if open at SCN-9.7. |
| R-8.3-03 | Schema-rejection risk pattern for downstream consumers; Phase 9 inherits the same mitigation under Q5 (optional-at-v1, tier-gated presence). | Co-monitored with R-9-04 at first downstream adoption of the SCN-9.2 blocks. |

## Closed Risks

| ID | Closure / disposition |
|---|---|
| R-9-01 | Closed at SCN-9.7. The SCN-9.4 pilot refactor stayed scoped to `astaire/src/domain/claims/`; architecture-fitness audit passes; full Astaire pytest suite is green. |
| R-9-02 | Closed at SCN-9.7. SCN-9.5 mutation baseline produced usable data; DEC-0005 accepted SCN-9.5-EQ-001 and ratified the thresholds. |
| R-9-03 | Closed at SCN-9.7. Claude skills retained source-of-truth pointers; SCN-9.6 runbooks/templates add no new all-caps modal directives. |

## Carried Forward After Phase 9

| ID | Disposition |
|---|---|
| R-9-04 | Carry to Phase 10 until first downstream consumer adoption of each new analyzer block validates optional-at-schema/tier-gated-presence behavior. |
| R-9-05 | Carry to Phase 10 and quarterly glossary ownership review; current Phase 9 glossary files are stable, but downstream/code-evolution drift is ongoing. |
| R-8.2-02 | Carry to Phase 10 until first downstream consumer adoption of analyzer declarations and Phase 9 analyzer blocks. |
| R-8.2-05 | Carry to Phase 10 because no Phase 8.1 reciprocal risk-log artifact is present in this repo at SCN-9.7 sign-off. |

## Rollback Strategy Notes

- **SCN-9.0 rollback.** Delete the four bootstrap artifacts; remove the
  Phase 9 row from `signoffs.md` and `traceability.md`. No transitive
  dependents.
- **SCN-9.1 rollback.** Revert the policy authoring commit. All five
  amended core docs return to pre-SCN-9.1 text; the three new docs are
  deleted. Astaire registrations drop on next scan.
- **SCN-9.2 rollback.** Revert the schema delta, §17–§19 rule text,
  validator wiring, and submodule pin bump. Existing manifests
  continue to validate under the pre-SCN-9.2 schema. The submodule
  retains the upstream commits; only registration coverage reverts.
- **SCN-9.3 rollback.** Delete `adapters/providers/claude/skills/` and
  any added slash-command files under `adapters/providers/claude/commands/`.
  Adapter-only rollback; no governance or `astaire/` impact.
- **SCN-9.4 rollback.** Revert the claims/projection refactor commit.
  Glossary files and seam map remain on disk as inert documentation.
  Existing pytest suite returns to pre-refactor structure; the
  architecture-fitness rule de-activates because the protected
  directory no longer exists.
- **SCN-9.5 rollback.** Delete the mutation report, Farley scorecard,
  characterisation suite, and threshold-ratification proposal. Cosmic
  Ray + mutmut configuration files remain (no behavioural impact).
  Astaire registrations drop on next scan.
- **SCN-9.6 rollback.** Revert the runbook + template + README updates.
  Migration note is removed; templates revert to their previous shape.
- **SCN-9.7 rollback.** Sign-off rollback follows the established
  pattern in `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability
  (revert the signoff row + traceability flip + TO-DO ticks + advisory
  marker re-introduction + §17 fail-close revert together).
