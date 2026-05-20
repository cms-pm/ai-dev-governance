# Domain Language Governance (Ubiquitous Language)

## Purpose

This core policy defines how a project authors, evolves, and enforces
its **ubiquitous language** — the shared vocabulary between the
domain, the code, the tests, and the planning artifacts. It is
provider- and language-agnostic.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Core Principle

A term used to describe a concept in planning, tests, and code MUST be
the same term. Drift between conversational vocabulary and code
identifiers is the primary defect this policy prevents.

## Definitions

- **Bounded context.** A region of the system with its own coherent
  vocabulary. Two contexts MAY use the same word for different
  concepts; each context's glossary disambiguates.
- **Glossary.** A markdown file under `docs/glossary/<context>.md`
  enumerating every domain term in the context with a single
  definition, owning authority, and canonical references.
- **Canonical term.** The exact lexical form (case, spacing, plural)
  carried into type names, function names, and test names within the
  context.
- **Term authority.** The named human role accountable for accepting,
  amending, or deprecating a term in a given glossary.

## Glossary File Specification

Each `docs/glossary/<context>.md` MUST contain:

1. **Preamble.** Bounded-context name, owning authority (role title),
   creation date, last review date.
2. **Term entries.** One entry per term, in the form:

   ```markdown
   ### <CanonicalTerm>

   - **Definition.** One sentence, present tense, no examples.
   - **Owning context.** <context-name>
   - **Canonical references.**
     - `path/to/code/file.py:LineNo` (type, function, or test)
     - `core/<POLICY>.md` (when the term is policy-defined)
   - **Synonyms (deprecated).** List with replacement pointer, or
     "none".
   - **Notes.** Optional disambiguation, especially when a homograph
     exists in another context.
   ```

3. **Deprecation log.** A `## Deprecations` section listing retired
   terms with effective-date and replacement pointer. Entries MUST NOT
   be deleted.

## Per-Context Authoring Authority

Each glossary file MUST name its authoring authority in the preamble.
Authority responsibilities:

- Accepting new term proposals.
- Approving definition amendments.
- Approving deprecations.
- Resolving cross-context homograph disputes (with the corresponding
  authority of the other context).

Authority MAY be a role title (e.g. "Accountable Delivery Lead",
"Domain Owner — Memory Palace"). When a context has no clear human
authority, the project's `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md`
accountable-human role serves as the default.

## Naming Correspondence Rule

Within a bounded context's protected source tree (the package(s)
implementing the context), the following correspondence MUST hold:

1. Every public type whose name encodes a domain concept MUST match a
   glossary term (case-insensitive, allowing standard language
   conventions like `PascalCase` for classes vs. `snake_case` for
   functions).
2. Every test name expressing a domain behavior MUST reference at least
   one glossary term in either the test class name, the test function
   name, or an explicit `@pytest.mark` / equivalent tag.
3. Function names performing a domain operation MUST use the term's
   canonical verb form when the glossary declares one.

The `scripts/validators/glossary_coverage.py` validator enforces this
rule against the path(s) declared in
`analyzers.domainGlossary.coverageRule`.

## Cross-Context Homograph Rule

When the same word names different concepts in two contexts (e.g.
`claim` in `governance-authoring` vs. `claim` in `memory-palace`), each
glossary entry MUST include a **Notes** subsection naming the other
context's homograph and the canonical disambiguator (e.g. "see
memory-palace.md §Claim for the storage-layer meaning").

## Term Evolution Protocol

Adding a term:

1. The authoring authority accepts a proposal (commit, PR comment, or
   board action with ID).
2. The new entry lands in the glossary in the same commit (or earlier)
   as the first code identifier using it.
3. Astaire registers the updated glossary on the next `scan`.

Amending a definition:

1. The authority records the amendment with a date in the entry's
   **Notes** subsection or a "Last amended" line.
2. Any code or test identifier whose semantics no longer match MUST be
   updated in the same commit or carry an exception under
   `core/EXCEPTIONS_AND_WAIVERS.md`.

Deprecating a term:

1. The term moves to the **Deprecations** section with effective-date
   and replacement pointer.
2. Code identifiers using the deprecated term MUST be migrated within
   one phase; until migration completes, the deprecated term carries a
   tombstone marker in the glossary preamble (e.g.
   "Pending migration: `oldName` → `newName` by SCN-<phase>.<chunk>").

## Risk Tier Coupling

- Low-tier work MAY proceed without declaring
  `analyzers.domainGlossary`, provided the chunk introduces no new
  domain vocabulary.
- Medium-tier and higher chunks MUST either declare the
  `analyzers.domainGlossary` block in the governance manifest or
  record an exception under `core/EXCEPTIONS_AND_WAIVERS.md`.
- Critical-tier chunks MUST pass `glossary_coverage.py` exit 0 before
  sign-off (see `validation/CONSISTENCY_RULES.md` §18).

## Anti-Patterns

1. Terms defined in code (docstrings, comments) but absent from the
   glossary.
2. Synonyms used interchangeably (`user`, `account`, `principal`) when
   only one is canonical.
3. Glossary entries written as marketing prose rather than precise
   definitions.
4. Cross-context homographs without notes pointing at the other
   context.
5. Silent term renames that leave one half of the codebase on the old
   term.

## Cross-References

- `core/MODULARITY_GOVERNANCE.md` — ports MUST be named in glossary
  terms.
- `core/BOARD_REVIEW_GOVERNANCE_METHODOLOGY.md` — the test-design lens
  MAY annex glossary findings into board reviews.
- `core/EVIDENCE_CONTRACT.md` — `glossaryCoverageURI` is the
  per-acceptance evidence pointer for this policy.
- `validation/CONSISTENCY_RULES.md` §18 — required-presence of the
  `analyzers.domainGlossary` block by risk tier.
- `contracts/governance-manifest.schema.json` — schema for the
  `analyzers.domainGlossary` block.
- `runbooks/GLOSSARY_AUTHORING.md` — operating procedure (lands at
  SCN-9.6).
