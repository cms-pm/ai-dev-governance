---
description: Run the mutation-testing skill against the named Python package — Cosmic Ray for gate evidence, mutmut for the inner loop — and publish the survivor report.
argument-hint: <package path under astaire/src/> [optional output date override]
---

Load the `mutation-testing` skill. The skill's source of truth is
`core/MUTATION_EVIDENCE.md`.

Target package: `$ARGUMENTS` (default:
`astaire/src/domain/claims/`).

Steps:

1. Confirm `astaire/cosmic-ray.toml` exists for the target. If it
   does not, generate it from the skill's template.
2. Run the Cosmic Ray pass using the commands listed in the skill.
3. Write the report to
   `docs/evidence/mutation/<target-slug>-<YYYY-MM-DD>.md`.
4. For each survivor, populate the disposition column per the
   survivor triage options quoted from `core/MUTATION_EVIDENCE.md`
   §Survivor Triage.
5. Run `.astaire/astaire scan --root .` so the report registers as
   `mutation-report`.
6. Report the mutation score and the survivor count by disposition.

While the threshold table in `core/MUTATION_EVIDENCE.md` is advisory
(through SCN-9.7), the validator runs in WARN mode and does not
fail-close.
