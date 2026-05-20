# Mutation Testing Runbook

Operational guide for applying `core/MUTATION_EVIDENCE.md`. The core
policy remains the source of authority for tier thresholds, survivor
triage, equivalent-mutant exceptions, and evidence URI shape.

## Purpose

Use this runbook when a medium-or-higher risk chunk needs mutation
evidence, or when a consumer repo is adopting the Phase 9
`analyzers.mutation` manifest block.

## Tool Layout

| Loop | Python tool | Typical use |
|---|---|---|
| Gate evidence | Cosmic Ray | phase/chunk mutation report under `docs/evidence/mutation/` |
| Inner loop | mutmut | fast local investigation before rerunning Cosmic Ray |

Cosmic Ray is the portable evidence path for ADG Python repos. mutmut is
developer ergonomics; if mutmut cannot model the repo layout, document
that finding and keep Cosmic Ray as the gate artifact.

## Setup

1. Add a Cosmic Ray config beside the Python project, for example
   `astaire/cosmic-ray.toml`.
2. Add mutmut config in `pyproject.toml` under `[tool.mutmut]` or mirror
   it in `mutmut.ini` for older local workflows.
3. Add the manifest block from
   `templates/ANALYZERS_PHASE_9_TEMPLATE.yaml`.
4. Keep the mutation target narrow: production modules only, not tests,
   fixtures, generated code, or broad infrastructure.

## Cosmic Ray Flow

```bash
cd astaire
uv run --with cosmic-ray cosmic-ray init cosmic-ray.toml ../artifacts/cosmic-ray/session.sqlite --force
uv run --with cosmic-ray cosmic-ray exec cosmic-ray.toml ../artifacts/cosmic-ray/session.sqlite
uv run --with cosmic-ray cosmic-ray dump ../artifacts/cosmic-ray/session.sqlite > ../artifacts/cosmic-ray/session.json
```

Convert the session dump into a Markdown report under
`docs/evidence/mutation/`. Include aggregate counts, per-module
breakdown, survivor disposition, and the command log.

## Survivor Triage

Classify every survivor using the labels from
`core/MUTATION_EVIDENCE.md`:

- `kill-pending`: add or strengthen a test, then rerun.
- `equivalent-exception-<id>`: record the equivalence argument and
  reviewer approval.
- `accepted-residual-<id>`: record the accepted gap, owner, and review
  date.

Do not lower the threshold to hide a survivor. If the baseline data
shows the threshold is not meaningful for the target, feed that result
to the board proposal.

## Evidence Checklist

- Tool name and version.
- Config path.
- Run timestamp and host context.
- Target paths.
- Test command.
- Aggregate killed/survived/equivalent counts.
- Per-module breakdown.
- Survivor table with disposition.
- Pointer to the raw session artifact when retained.

## Consumer Notes

At schema v1 the analyzer block is optional. Tier-gated presence is a
validation-layer concern in `validation/CONSISTENCY_RULES.md` §17, and
mutation thresholds remain advisory until SCN-9.7 DEC-0005.
