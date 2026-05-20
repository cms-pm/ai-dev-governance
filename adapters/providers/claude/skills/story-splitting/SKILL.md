---
name: story-splitting
description: Decompose a broad story, epic, or chunk into PR-sized vertical SCN slices using INVEST plus the Hamburger and SPIDR dimensions. Output is one or more candidate chunk plans written back to docs/planning/chunks/. Source of truth is core/PLANNING_METHODOLOGY.md §Chunk Splitting.
---

# story-splitting — INVEST + Hamburger / SPIDR

**Source of truth:** `core/PLANNING_METHODOLOGY.md` §Chunk Splitting.
INVEST criteria, the Hamburger method, and the SPIDR dimensions are
authored there as the chunk-decomposition aid. This skill is the
authoring ergonomic.

## When to load

- A chunk plan SCN is too large to land as a single atomic PR.
- `find-gaps` flagged a story as "horizontal slice / component-shaped".
- A new phase bootstrap (SCN-N.0) needs to enumerate candidate child
  chunks.

## INVEST quick test (quoted from the source-of-truth)

From `core/PLANNING_METHODOLOGY.md` §Chunk Splitting —
> "Independent, Negotiable, Valuable, Estimable, Small, Testable.
> A chunk failing any letter is split until each child passes."

## SPIDR dimensions

| Letter | Dimension | Example split for an ADG chunk |
|---|---|---|
| S | Spike (research timebox) | Spike: prototype `glossary_coverage.py` against one fixture before authoring the production validator. |
| P | Path (alternate flows) | Split positive-fixture path from negative-fixture path into two chunks. |
| I | Interface (UI / CLI / API) | Split CLI surface change from the underlying library change. |
| D | Data (variation) | Split low-tier manifest case from medium-tier case. |
| R | Rules (business rules) | Split each consistency rule (§17, §18, §19) into its own chunk. |

## Hamburger method

1. List the desired slices (top bun, fillings, bottom bun).
2. Pick the thinnest end-to-end vertical slice that delivers any user
   value (walking skeleton).
3. Add one filling at a time; each filling lands as its own chunk.
4. The bottom bun (hardening, evidence bundle, sign-off) is its own
   final chunk.

## Output: candidate chunk plan rows

Format matches the existing `docs/planning/chunks/phase-<n>-chunks.md`
shape:

```markdown
## SCN-<n>.<m> — <verb-leading title>

- **Scope.** …
- **Acceptance IDs.** SCN-<n>.<m>-01 (…), SCN-<n>.<m>-02 (…)
- **Acceptance criteria.** …
- **Risk tier.** low | medium | high
- **Validation method.** …
- **Atomic PR scope.** Single commit on branch `SCN-<n>.<m>`.
```

Write back into `docs/planning/chunks/phase-<n>-chunks.md` and
re-register with `.astaire/astaire scan`.

## Anti-patterns (drawn from the source-of-truth's §Chunk Splitting)

- Component-shaped child chunks (e.g. "schema only", "validator
  only", "test only") instead of vertical slices.
- Children that share an acceptance ID — splits should produce
  disjoint acceptance IDs.
- Children whose risk tier exceeds the parent (the split should
  reduce tier, not raise it).

## Smoke check

Take a deliberately over-broad scratch chunk (e.g. "add three
analyzer blocks plus all docs plus skills") under
`validation/fixtures/glossary/` and produce three INVEST-passing
child chunk rows. Show the diff; attach to SCN-9.3 evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/story-splitting/SKILL.md` (text-only
original); ADG version targets ADG chunk-plan format and delegates
all normative authority to `core/PLANNING_METHODOLOGY.md`.
