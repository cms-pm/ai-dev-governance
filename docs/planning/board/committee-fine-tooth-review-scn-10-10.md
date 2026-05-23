# Fine-Tooth Board Re-Review — SCN-10.9 / SCN-10.10 Closeout

- Cadence lane: `Accountability Review`
- Trigger: board self-review after the first SCN-10.10 packet understated
  evidence gaps and treated several contradictions as low-severity cautions.
- Scope: SCN-10.9 release gate, SCN-10.10 closeout, and downstream Phase 11
  handoff readiness.

## Review Posture

The first closeout packet was too trusting. This re-review treats every
unchecked box, stale traceability row, and prose-only gate as suspect until it
has concrete evidence or a named follow-up.

## Findings

| ID | Observation | Risk / Gap | Severity | Required Adjustment | Closure Evidence | Owner | Target Window |
|---|---|---|---|---|---|---|---|
| FND-0028 | `docs/planning/phase-10-todo.md` left every SCN-10.10 checkbox open while `signoffs.md` and `traceability.md` claimed ratification. | The board signed off on a phase whose own closeout checklist still said incomplete. | High | Close the checklist only after packet, meeting, risk, signoff, traceability, and lint evidence are in place. | `docs/planning/phase-10-todo.md` SCN-10.10 rows checked with corrected two-tier wording. | Accountable Delivery Lead | Immediate |
| FND-0029 | `docs/planning/traceability.md` kept SCN-10.0 rows pending while SCN-10.10 claimed all SCN-10 rows were done. | Traceability could not support the signoff claim. | High | Update SCN-10.0 evidence rows or reopen SCN-10.10. | `docs/planning/traceability.md` SCN-10.0 rows marked `done` with evidence text. | Accountable Delivery Lead | Immediate |
| FND-0030 | `docs/planning/phase-10-risks.md` listed R-10-01 under open risks while closeout claimed it was closed. | Risk posture was internally contradictory. | Medium | Move R-10-01 to closed risks and leave R-10-02/03/04 in monitor lane. | `docs/planning/phase-10-risks.md` closed-risk table. | Accountable Delivery Lead | Immediate |
| FND-0031 | SCN-10.9 added a release gate mostly as prose; it did not state the exact validator command a CG-declared release must run. | Consumers could satisfy the checklist narratively without exercising fail-closed wiring. | High | Require `scripts/validate_codegraph_wiring.sh --root <consumer-root>` before tagging declared CG releases. | `runbooks/RELEASE_PROCESS.md` CodeGraph gate command block. | Accountable Delivery Lead | Immediate |
| FND-0032 | The SCN-10.2 SBOM fixture labeled itself as `docker-buildx-sbom-attestation` even when attestations were disabled. | Evidence could be mistaken for an attested Buildx SBOM. | Medium | Rename the fixture creator to the ADG Makefile SBOM fixture. | `templates/codegraph/Makefile.snippet` SBOM creator string. | Accountable Delivery Lead | Immediate |
| FND-0033 | The SCN-10.10 todo said "three-tier doctrine" even though Phase 10 ratified the two-tier Astaire / CodeGraph doctrine. | The closeout artifact misstated the doctrine under review. | Medium | Correct the wording to two-tier doctrine. | `docs/planning/phase-10-todo.md` SCN-10.10 checklist. | Accountable Delivery Lead | Immediate |
| FND-0034 | The first devil's-advocate pass framed these issues as low-severity cautions and did not block signoff. | Board review quality was below the ADG constructive criticism protocol. | High | Add this fine-tooth review as a supplementary board artifact and record that the earlier pass was insufficient. | This file, plus packet and meeting addenda. | Board chair / Scribe | Immediate |

## Gate Result

Phase 10 remains ratified only after the immediate corrective actions above are
applied and Astaire lint returns `0 warnings, 0 errors`.

The board does not reopen R-10-01. It does keep R-10-02, R-10-03, R-10-04,
R-8.2-02, R-8.2-05, R-9-04, and R-9-05 in monitor lane.

## Phase 11 Handoff Cautions

- Phase 11 must not treat SCN-10.9 as complete unless the declared-CG release
  path runs the CodeGraph wiring validator.
- Phase 11 must distinguish host-platform digest reproducibility from
  attested multi-platform provenance.
- Phase 11 bootstrap should read this artifact before accepting the Phase 10
  signoff as clean input.
