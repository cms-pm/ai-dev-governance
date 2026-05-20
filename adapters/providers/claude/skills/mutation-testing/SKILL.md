---
name: mutation-testing
description: Run mutation testing on Python code using Cosmic Ray (gate evidence) and mutmut (inner loop). Produce the survivor list with disposition column. Source of truth is core/MUTATION_EVIDENCE.md.
---

# mutation-testing — Cosmic Ray + mutmut for Python

**Source of truth:** `core/MUTATION_EVIDENCE.md`. Operator policy,
advisory tier threshold table (advisory until SCN-9.7), survivor triage
protocol, equivalent-mutant exception process, and evidence URI
contract all live there. This skill contains tool ergonomics only.

## When to load

- Closing the MUTATE step of the `tdd` skill cycle.
- Producing the `mutationReportURI` evidence required by the SCN's
  manifest analyzer block.
- Investigating a surviving mutant flagged by the analyzer in a
  `validate_governance.sh` run.

## Tooling layout

| Loop | Tool | Config | Output |
|---|---|---|---|
| Gate (CI / release evidence) | Cosmic Ray | `astaire/cosmic-ray.toml` | `docs/evidence/mutation/<target>-<DATE>.md` |
| Inner loop (developer) | mutmut | `astaire/pyproject.toml` `[tool.mutmut]` (`astaire/mutmut.ini` kept as a mirror for older mutmut) | terminal report; promotes to Cosmic Ray on commit |

Cosmic Ray is the evidence tool. mutmut is for tight RED-GREEN-MUTATE
loops where Cosmic Ray's full pass is too slow.

## Cosmic Ray run

```bash
cd astaire
uv run --with cosmic-ray cosmic-ray init cosmic-ray.toml ../artifacts/cosmic-ray/astaire-claims-projection.sqlite
uv run --with cosmic-ray cosmic-ray exec cosmic-ray.toml ../artifacts/cosmic-ray/astaire-claims-projection.sqlite
uv run --with cosmic-ray cosmic-ray dump ../artifacts/cosmic-ray/astaire-claims-projection.sqlite > \
    ../artifacts/cosmic-ray/astaire-claims-projection.json
```

The report header carries: target package, total mutants, killed,
survived, equivalent-claimed, mutation score (killed / (total -
equivalent)). Convert the JSON dump into the Markdown evidence file
under `docs/evidence/mutation/`. The survivor table includes one column
per `core/MUTATION_EVIDENCE.md` §Survivor Triage requirement (id,
operator, location, disposition).

## mutmut inner loop

```bash
cd astaire
uv run --with mutmut mutmut run
uv run --with mutmut mutmut results
uv run --with mutmut mutmut show <id>
```

Disposition options are quoted from
`core/MUTATION_EVIDENCE.md` §Survivor Triage —
> "kill (add or strengthen test), equivalent (file exception), accept
> (downgrade tier with board waiver)."

## Threshold interaction

While the table is advisory (per `core/MUTATION_EVIDENCE.md` §Tier
Thresholds, marked advisory until SCN-9.7), the
`scripts/validators/mutation_threshold.py` validator runs in WARN mode.
Past SCN-9.7 sign-off the same validator runs in fail-close mode at the
ratified thresholds (handled by `validation/CONSISTENCY_RULES.md` §17,
not by this skill).

## Smoke check

Run Cosmic Ray against the SCN-9.3 fixture under
`validation/fixtures/mutation/positive/`. Confirm the report file is
produced, parses as Markdown, and the validator accepts it. Attach the
report to the SCN-9.3 evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/mutation-testing/SKILL.md` (Stryker /
TypeScript original); ADG version targets Cosmic Ray + mutmut and
delegates all normative authority to `core/MUTATION_EVIDENCE.md`.
