---
name: domain-driven-design
description: Python-idiom DDD scaffolding. Frozen dataclasses for value objects, typed aggregates, branded NewType identifiers, per-bounded-context glossary authoring. Source of truth is core/DOMAIN_LANGUAGE_GOVERNANCE.md.
---

# domain-driven-design — Python DDD idioms + glossary authoring

**Source of truth:** `core/DOMAIN_LANGUAGE_GOVERNANCE.md`. Glossary
artifact spec, per-bounded-context authoring authority, naming
correspondence rule, and the evolution + deprecation protocol live
there.

## When to load

- Authoring or amending a `docs/glossary/<context>.md` file (SCN-9.4
  produces the first four).
- Designing a new bounded context that will be subject to the
  `analyzers.domainGlossary` block.
- Reviewing whether a type/function/test name corresponds to a
  glossary term.

## Bounded contexts in this repo

Resolved in Phase 9 Q1; canonical list lives in
`core/DOMAIN_LANGUAGE_GOVERNANCE.md` preamble:

- governance-authoring
- memory-palace
- validation
- adapters

## Value object idiom

```python
from dataclasses import dataclass
from typing import NewType

ClaimId = NewType("ClaimId", str)
EntityId = NewType("EntityId", str)

@dataclass(frozen=True, slots=True)
class Claim:
    claim_id: ClaimId
    entity_id: EntityId
    predicate: str
    value: str
    confidence: float
```

- `frozen=True` enforces immutability.
- `slots=True` keeps memory low and rejects ad-hoc attribute
  assignment.
- `NewType` brands string identifiers at the type checker, preventing
  accidental crosstalk between `ClaimId` and `EntityId`.

## Aggregate idiom

```python
@dataclass(frozen=True, slots=True)
class ClaimCluster:
    cluster_id: ClusterId
    claims: tuple[Claim, ...]

    def with_added(self, claim: Claim) -> "ClaimCluster":
        return ClaimCluster(self.cluster_id, (*self.claims, claim))
```

Mutation returns a new aggregate; the old reference is unchanged. This
matches the immutability principle in
`core/DOMAIN_LANGUAGE_GOVERNANCE.md`.

## Glossary file shape

Quoted from `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Glossary Artifact —
> "One file per bounded context under `docs/glossary/`; each entry
> names the term, definition, owning context, canonical references,
> and deprecation entries (if any)."

Template:

```markdown
---
context: governance-authoring
authoring_authority: <named role>
---

# Glossary — governance-authoring

## Claim
- **Definition:** …
- **Owning context:** governance-authoring
- **Canonical references:**
  - `core/AI_ASSISTED_TDR_METHODOLOGY.md` §…
  - `astaire/src/domain/claims/models.py:Claim`
- **Deprecation:** (none at v1)

## Entity
…
```

## Naming-correspondence rule

`scripts/validators/glossary_coverage.py` checks that public types,
functions, and test names under the bounded-context directory map to
glossary terms. The rule itself is authored in
`core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Naming Correspondence; this
skill is the authoring ergonomic.

## Smoke check

Author a one-term glossary file for the
`validation/fixtures/glossary/positive/` fixture context; run the
glossary-coverage validator; confirm `[PASS]`.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/domain-driven-design/SKILL.md`
(TypeScript original); ADG version targets frozen dataclasses,
`NewType` brands, and the per-context glossary authoring authority;
delegates all normative authority to
`core/DOMAIN_LANGUAGE_GOVERNANCE.md`.
