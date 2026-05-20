# Glossary Authoring Runbook

Operational guide for applying `core/DOMAIN_LANGUAGE_GOVERNANCE.md`.
The core policy remains the source of authority for glossary ownership,
term shape, naming correspondence, and deprecation handling.

## Purpose

Use this runbook when adding a bounded-context glossary under
`docs/glossary/` or when adopting the Phase 9
`analyzers.domainGlossary` manifest block.

## Authoring Flow

1. Choose the bounded context name used by code, docs, and tests.
2. Copy `templates/DOMAIN_GLOSSARY_CONTEXT_TEMPLATE.md` to
   `docs/glossary/<context>.md`.
3. Name the owning role in the preamble.
4. Add one row per term with definition, canonical references, aliases,
   and deprecation status.
5. Run the glossary validator against the consumer manifest.

## Term Selection

Prefer terms that appear in public types, functions, tests, CLI output,
manifest keys, or board artifacts. Avoid glossary entries for generic
implementation words that do not carry domain meaning.

## Naming Correspondence

For each protected path in `analyzers.domainGlossary.coverageRule`, make
sure important public names map back to glossary terms. When the code
uses an abbreviation, record the abbreviation as an alias rather than
creating a second competing term.

## Evolution

When a term changes meaning, add a deprecation entry and a replacement
term. Keep old references long enough for consumers to migrate, then
remove them in a planned compatibility window.

## Validation

```bash
python3 -m scripts.validators.glossary_coverage --manifest governance.yaml
bash scripts/validate_governance.sh
```

At schema v1 the analyzer block is optional. Tier-gated presence is a
validation-layer concern in `validation/CONSISTENCY_RULES.md` §18.
