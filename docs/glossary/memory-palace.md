---
phase: 9
stage_produced: implementation
context: memory-palace
authoring_authority: Domain Owner — Memory Palace (astaire submodule maintainer)
created: 2026-05-19
last_review: 2026-05-19
---

# Memory-Palace — Bounded-Context Glossary

The vocabulary of the `astaire/` submodule: the hybrid claim store +
document registry that backs ADG's projection layer. Per
`astaire/CLAUDE.md`, the core is **document-type agnostic**; this
glossary names the concepts owned by the memory-palace context itself,
not the application-layer types declared by individual collections.

Per `core/DOMAIN_LANGUAGE_GOVERNANCE.md` §Per-Context Authoring
Authority, the astaire submodule maintainer accepts proposals, approves
amendments and deprecations, and resolves homograph disputes with peer
contexts (`governance-authoring`, `validation`, `adapters`).

The protected source tree for this context is `astaire/src/domain/`
(see `analyzers.domainGlossary.coverageRule.protectedPaths` in this
repo's `governance.yaml`).

## Terms

### Claim

- **Definition.** A single structured assertion of the form
  `(entity, predicate, value)` with provenance, confidence, claim type,
  and epistemic tag.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/CLAUDE.md` §Core concepts → "The claim is the atomic unit"
  - `astaire/docs/schema/memory_palace_schema.sql` `claim` table
  - `astaire/src/domain/claims/` (SCN-9.4 pilot)
- **Synonyms (deprecated).** none.
- **Notes.** Homograph: `claim` in `governance-authoring` informal
  speech may refer to a board assertion — the canonical
  governance-authoring term is **Board Finding**. In memory-palace,
  `claim` always means the storage-layer atomic unit.

### Entity

- **Definition.** A de-duplicated subject of one or more claims, with a
  canonical name and an alias set, classified by `entity_type` (person,
  org, system, concept, place, event).
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/CLAUDE.md` §Core concepts → "Entities are de-duplicated
    subjects"
  - `astaire/docs/schema/memory_palace_schema.sql` `entity` table
- **Synonyms (deprecated).** none.

### Relationship

- **Definition.** A typed directed edge between two entities, drawn
  from the closed type set `{supports, contradicts, depends_on,
  evolved_into, part_of, related_to, tested_by}` and optionally backed
  by an evidence claim.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/docs/schema/memory_palace_schema.sql` `relationship` table
- **Synonyms (deprecated).** none.

### Contradiction

- **Definition.** A first-class record naming two active claims that
  disagree on the same `(entity_id, predicate)`, with a resolution
  status of `open`, `superseded`, or `accepted-both`.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/docs/schema/memory_palace_schema.sql` `contradiction`
    table
- **Synonyms (deprecated).** none.

### Document

- **Definition.** A registered file in a collection, identified by
  ULID, with collection scope, document type, status, tags, content
  hash, and token count.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/src/registry.py:register_document`
  - `astaire/docs/schema/memory_palace_schema.sql` `document` table
- **Synonyms (deprecated).** none.

### Collection

- **Definition.** A named group of related document types with its own
  configuration (allowed types, lifecycle stages, statuses) stored in
  `collection.config_json`; the application-layer plug point for the
  document registry.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/src/collections/`
  - `astaire/CLAUDE.md` §Collections and documents
- **Synonyms (deprecated).** none.

### Projection (L0 / L1 / L2)

- **Definition.** The pre-compiled context cache produced by the
  projection engine; L0 is the global summary (~2-4K tokens), L1 is a
  per-scope digest (~1-2K each), L2 is a per-query detail block held
  on demand.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/src/project.py`
  - `astaire/CLAUDE.md` §Projection tiers
- **Synonyms (deprecated).** "projection cache" used informally; the
  formal noun is "projection".

### FTS (Full-Text Search)

- **Definition.** The SQLite FTS5 virtual-table index over claim,
  entity, and document content used by the query path; one of the two
  ports the memory-palace domain depends on.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/src/registry.py:_sanitize_fts_query`
  - `astaire/docs/schema/memory_palace_schema.sql` `claim_fts`,
    `entity_fts`, `document_fts`
- **Synonyms (deprecated).** none.
- **Notes.** Adapter implementations live in `astaire/src/adapters/`
  (SCN-9.4 pilot); the domain depends only on the `FTSIndex` port
  Protocol.

### Hub Score

- **Definition.** A `2 * claim_count + relationship_count` ranking
  signal stored on every entity; surfaces the most connected entities
  in the L0 summary.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/docs/schema/memory_palace_schema.sql` `v_entity_hub_scores`
- **Synonyms (deprecated).** none.

### Ingest

- **Definition.** The operation that takes a source document, extracts
  entities and claims, links them into the relationship graph, detects
  contradictions, and regenerates the L0 cache.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/src/ingest.py`
  - `astaire/CLAUDE.md` §Operations → Ingest
- **Synonyms (deprecated).** none.

### Source

- **Definition.** The provenance record for a single document or
  synthesis input; every claim references exactly one source.
- **Owning context.** memory-palace
- **Canonical references.**
  - `astaire/docs/schema/memory_palace_schema.sql` `source` table
- **Synonyms (deprecated).** none.

## Deprecations

(none at v1)
