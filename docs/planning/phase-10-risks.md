---
phase: 10
stage_produced: plan
---

# Phase 10 Risk Log — CodeGraph Tier-2 Code Intelligence

Linked to: `docs/planning/pool_questions/phase-10-codegraph.md`,
`docs/planning/chunks/phase-10-chunks.md`.

## Open Risks

| ID | Title | Severity | Likelihood | Trigger SCN(s) | Mitigation | Owner | Review Window |
|---|---|---|---|---|---|---|---|
| R-10-01 | Code-intelligence bounded-context glossary ambiguity — Astaire vs CodeGraph vs Graphify scope drift in downstream consumers | Low | Medium | SCN-10.1, SCN-10.6 | New `core/CODE_INTELLIGENCE_GOVERNANCE.md` lands the two-tier doctrine and bounded-context glossary entries under the `DOMAIN_LANGUAGE_GOVERNANCE.md` pattern (per-context authoring authority + naming-correspondence rule). SCN-10.6 removes Graphify from ADG entirely: no submodule, no wrapper scripts, no manifest block, and no active consumer install/invocation guidance. Doctrine + removal evidence close the ambiguity slice; final phase ratification remains at SCN-10.10. | Accountable Delivery Lead | Closed at SCN-10.10 |
| R-10-02 | Downstream CG adoption — `.mcp.json` wiring, `.codegraphignore` discipline, freshness-gate compliance lag behind Phase 10 sign-off | Medium | Medium | First consumer adoption (CockpitVM expected) | `scripts/validate_codegraph_wiring.sh` is consumer-side and fail-closed at the wiring level; the release-evidence gate in `RELEASE_PROCESS.md` activates *only* for consumers that declare CG in `governance.yaml`, so non-CG consumers (Plan B / no-tool) are not coerced. Closure cadence mirrors R-8.2-02 (sprint-critique re-check until first downstream adoption produces evidence). | Accountable Delivery Lead | At first downstream consumer adoption; sprint critique each Phase 11 iteration |
| R-10-03 | Removed Graphify fallback — consumers without CG rely on native repository tools for code discovery | Medium | Medium | First consumer not yet on CG; SCN-10.6 removal landing | SCN-10.6 removes Graphify instead of demoting it. Plan B (LSDF) is documented at `templates/codegraph/PLAN_B_LSDF.md` for Python-only / no-Docker consumers. Non-CG consumers are not coerced into Tier-2 adoption; they use Astaire for governance reads and native tools (`rg`, direct file reads, test runners, compiler output) for source discovery per `CLAUDE.md.fragment`. | Accountable Delivery Lead | At SCN-10.6 review; first consumer adoption window |
| R-10-04 | CockpitVM pilot — token/tool-call delta evidence not yet captured; benchmark assumptions (~35% cost / ~70% tool-call reduction from upstream README) unvalidated for embedded C/C++ corpora | Medium | Low | Post-SCN-10.10 monitor lane | The evidence *contract* (capture format) lands in `runbooks/RELEASE_PROCESS.md` at SCN-10.9 without requiring the evidence itself. The pilot is registered as monitor lane per the R-8.2-02 / R-9-04 precedent — Phase 10 sign-off does not block on pilot benchmark. Carries to Phase 11 monitor lane with explicit close-or-rebaseline decision at the first CockpitVM release that adopts CG. | Accountable Delivery Lead | At first CockpitVM release post-CG adoption |

## Carried-forward from Phase 9 (monitor lane)

| ID | Carried-forward reason | Phase 10 monitor action |
|---|---|---|
| R-8.2-02 | Static-analyzer capability schema landed at SCN-8.3.4; closure waits on first downstream consumer adoption. Phase 9 added three more analyzer blocks (mutation, glossary, architecture-fitness). Phase 10 does *not* extend the manifest schema (deferred per R-10-02 outcome). | Sprint critique re-checks downstream-consumer adoption for the SCN-8.3.4 + SCN-9.2 analyzer blocks. |
| R-8.2-05 | Cross-phase R-8.2-05 (Phase 8.1 reciprocal entry on `main`) remained open at Phase 9 sign-off. | Standing sprint-critique read of `phase-8.1-risks.md` on `main` each iteration; closure cadence unchanged. Carries to Phase 11 if open at SCN-10.10. |
| R-9-04 | Manifest schema additions (mutation, glossary, architecture-fitness) — first-downstream-adoption closure pending. Phase 10 does not add manifest schema; Phase 11 may extend for CG capability per R-10-02 outcome. | Co-monitored with R-10-02 at first downstream adoption. |
| R-9-05 | Glossary authoring authority drift. Phase 10 adds a new bounded context (code-intelligence) under `DOMAIN_LANGUAGE_GOVERNANCE.md`; the code-intelligence slice of R-9-05 closes at SCN-10.1; the broader R-9-05 carries forward. | At SCN-10.1 review (code-intelligence slice) and quarterly thereafter (broader R-9-05). |

## Closed Risks

(none — phase newly opened)

## Rollback Strategy Notes

- **SCN-10.0 rollback.** Delete the four bootstrap artifacts; remove the
  Phase 10 row from `signoffs.md` and the SCN-10 rows from
  `traceability.md`. No transitive dependents.
- **SCN-10.1 rollback.** Revert the policy authoring commit.
  `CODE_INTELLIGENCE_GOVERNANCE.md` is deleted; `EVIDENCE_CONTRACT.md`
  and `AUTONOMOUS_DELIVERY_GOVERNANCE.md` return to pre-SCN-10.1 text.
  Astaire registrations drop on next scan.
- **SCN-10.2 rollback.** Delete `templates/codegraph/Dockerfile` and
  the `Makefile.snippet`. No transitive dependents until SCN-10.3
  consumes the digest.
- **SCN-10.3 rollback.** Delete the POSIX + Windows wrappers. Templates
  that reference the wrapper path become inert until re-added.
- **SCN-10.4 rollback.** Delete the remaining `templates/codegraph/`
  files. Adapter specs (SCN-10.5) and validator (SCN-10.7) still resolve
  through `core/CODE_INTELLIGENCE_GOVERNANCE.md` for source-of-truth.
- **SCN-10.5 rollback.** Delete the two adapter `CODEGRAPH.md` files.
  Provider-skill registration drops on next Astaire scan.
- **SCN-10.6 rollback.** Restore the removed Graphify submodule, wrapper
  scripts, validator/fallback files, manifest schema/example block, fixtures,
  and active install/invocation guidance. This reopens R-10-01 and must be
  board-reviewed before release.
- **SCN-10.7 rollback.** Delete `scripts/validate_codegraph_wiring.sh`
  and the `validation/fixtures/codegraph/` tree. No transitive impact
  on Astaire or other validators.
- **SCN-10.8 rollback.** Revert the denylist extension to the validator.
  Positive fixtures continue to pass; the validator no longer fails on
  forbidden flags.
- **SCN-10.9 rollback.** Revert the `RELEASE_PROCESS.md` diff. The CG
  freshness gate de-activates; existing consumer releases continue under
  the pre-SCN-10.9 checklist.
- **SCN-10.10 rollback.** Sign-off rollback follows the established
  pattern in `core/PLANNING_METHODOLOGY.md` §Sign-off and Auditability
  (revert the signoff row + traceability flip + TO-DO ticks + R-10-01
  closure annotation together).
