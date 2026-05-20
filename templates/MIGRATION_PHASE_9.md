# Phase 9 Migration Note

This note helps a consumer repo adopt the Phase 9 analyzer, glossary,
mutation, and test-design review additions without changing schema
compatibility expectations.

## What Changed

Phase 9 adds three optional analyzer blocks to `governance.yaml`:

- `analyzers.mutation`
- `analyzers.domainGlossary`
- `analyzers.architectureFitness`

The manifest schema accepts their absence at v1. Required-presence is
handled by `validation/CONSISTENCY_RULES.md` §17-§19, where risk tier
and project profile decide whether the block should be present.

## Copy-Paste Analyzer Blocks

Use `templates/ANALYZERS_PHASE_9_TEMPLATE.yaml` as the starting point.
Adjust paths to match the consumer repo layout.

## Glossary Quick Start

1. Copy `templates/DOMAIN_GLOSSARY_CONTEXT_TEMPLATE.md` to
   `docs/glossary/<context>.md`.
2. Fill in terms owned by the bounded context.
3. Set `analyzers.domainGlossary.path` to `docs/glossary/`.
4. Run `python3 -m scripts.validators.glossary_coverage --manifest governance.yaml`.

## Mutation Harness Quick Start

1. Add a Cosmic Ray config near the Python package under test.
2. Add a mutmut inner-loop config in `pyproject.toml` or `mutmut.ini`.
3. Put Markdown reports under `docs/evidence/mutation/`.
4. Keep survivor triage in the report; do not hide survivors by
   weakening the target path.

## Farley Review Cadence

For medium-or-higher risk chunks, produce a Farley scorecard under
`docs/evidence/farley/` when test design is material to the board or
release decision. Use `runbooks/TEST_DESIGN_REVIEW.md` for the flow.

## Dry-Run Checklist

```bash
python3 -m scripts.validators.mutation_threshold --manifest governance.yaml
python3 -m scripts.validators.glossary_coverage --manifest governance.yaml
python3 -m scripts.validators.architecture_fitness --manifest governance.yaml
bash scripts/validate_governance.sh
```

Expected result during Phase 9: structural failures still fail, while
mutation threshold enforcement remains WARN-mode until DEC-0005.
