# Code Intelligence Governance

## Purpose

Define the bounded context, tier model, evidence contract, and freshness
rules for code-intelligence tooling used by ADG consumers. This policy
keeps durable governance memory and local code navigation in separate roles
so agents can choose the right surface without scope drift.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Two-Tier Doctrine

ADG recognizes two code-intelligence tiers:

| Tier | Capability | Authority | Required Presence |
|---|---|---|---|
| Tier 1 | Astaire | Governance memory palace and port-of-first-resort for ADG artifacts | Required for strict ADG consumers |
| Tier 2 | CodeGraph (CG) | Optional local code intelligence for source navigation and structural queries | Optional at v1 |

Tier 1 is the durable governance memory layer. Agents MUST query Astaire
first for `core/**`, `docs/planning/**`, and other registered governance
artifacts before falling back to direct reads under the exceptions in
`core/PLANNING_METHODOLOGY.md`.

Tier 2 is an optional local source-code intelligence layer. When a consumer
declares CG support, agents MUST check CG before token-heavy native
repository spidering for source-code discovery inside the declared path
scope. Token-heavy spidering includes broad `Glob`, `Grep`, `Read`, `find`,
`rg`, recursive listing, and exploratory multi-file reads whose purpose is
to discover symbols, call paths, ownership, or file impact. Agents use CG for
symbol lookup, call/reference navigation, file-impact discovery, and
source-structure exploration inside the declared path scope. CG results are
advisory context; final changes and evidence MUST still bind to repository
files and acceptance IDs.

For refactoring work in a CG-declared consumer, the CG-first check is a hard
pre-edit requirement. Before any production refactor edit, agents MUST use
`mcp__codegraph__impact`, `mcp__codegraph__callers`,
`mcp__codegraph__callees`, `mcp__codegraph__context`, or
`mcp__codegraph__explore` to identify affected files and dependencies, unless
CG is unavailable, stale, or outside declared scope. Any fallback MUST be
recorded in the implementation note before native spidering begins.

## Bounded-Context Glossary

The code-intelligence bounded context is owned by the Accountable Delivery
Lead. Term amendments follow `core/DOMAIN_LANGUAGE_GOVERNANCE.md`
§Per-Context Authoring Authority.

### Code Intelligence

- **Definition.** The family of local tools that project repository content
  into queryable context for planning, navigation, validation, or review.
- **Owning context.** code-intelligence
- **Canonical references.**
  - `core/CODE_INTELLIGENCE_GOVERNANCE.md`
- **Synonyms (deprecated).** "code search brain"; use "code intelligence".
- **Notes.** This term names the context as a whole, not a single tool.

### Astaire

- **Definition.** The Tier-1 governance memory palace that registers ADG
  artifacts, emits projections, and acts as the port-of-first-resort for
  governance reads.
- **Owning context.** code-intelligence
- **Canonical references.**
  - `runbooks/ASTAIRE_ACCESS.md`
  - `core/PLANNING_METHODOLOGY.md` §Governance Principles
- **Synonyms (deprecated).** "memory palace" is descriptive; the canonical
  tool name is "Astaire".
- **Notes.** Homograph: the `memory-palace` glossary owns Astaire's internal
  storage vocabulary. This context owns Astaire's ADG tier role.

### CodeGraph (CG)

- **Definition.** The optional Tier-2 local code-intelligence capability for
  source-code structural queries inside a declared repository path scope.
- **Owning context.** code-intelligence
- **Canonical references.**
  - `core/CODE_INTELLIGENCE_GOVERNANCE.md` §Tier-2 Declaration
  - `core/EVIDENCE_CONTRACT.md` §Validation Evidence
- **Synonyms (deprecated).** "CG" is an allowed abbreviation after first use.
- **Notes.** CG is advisory context and does not replace tests, direct file
  evidence, or Astaire governance projections.

### CodeGraph Index Freshness

- **Definition.** The evidence that a declared CG index was built no earlier
  than the most recent commit affecting the declared path scope.
- **Owning context.** code-intelligence
- **Canonical references.**
  - `core/CODE_INTELLIGENCE_GOVERNANCE.md` §Freshness Rule
  - `core/EVIDENCE_CONTRACT.md` `codegraphIndexFreshnessURI`
- **Synonyms (deprecated).** "index freshness"; use the full term in evidence
  schemas.

### CodeGraph Image Digest

- **Definition.** The immutable container-image digest used to run the CG MCP
  service or validator for a consumer repository.
- **Owning context.** code-intelligence
- **Canonical references.**
  - `core/CODE_INTELLIGENCE_GOVERNANCE.md` §Tier-2 Declaration
  - `core/EVIDENCE_CONTRACT.md` `codegraphImageDigestURI`
- **Synonyms (deprecated).** "image pin"; use "CodeGraph Image Digest".

## Tier-2 Declaration

A consumer that enables CG MUST declare the capability in its governance
manifest or equivalent adapter configuration. The declaration MUST include:

- path scope: the source directories and generated/build exclusions that CG
  is allowed to index
- invocation surface: MCP server or wrapper command used by the agent
- image digest: an immutable digest for the CG runtime when containerized
- evidence URIs: `codegraphIndexFreshnessURI` and
  `codegraphImageDigestURI`

CG required-presence is advisory at v1. A strict ADG consumer MAY omit CG
entirely. When omitted, agents use Astaire for governance context and native
repo tools (`rg`, file reads, language test runners, and compiler output) for
source discovery.

When CG is declared, required-presence is no longer advisory for source-code
navigation practice: agents MUST perform the CG-first check before broad
native source discovery and MUST perform the refactor impact check before
production refactor edits.

## Path-Scope Contract

CG MUST operate only inside its declared path scope. Generated artifacts,
vendored dependencies, ADG submodule paths, raw research corpora, and build
outputs SHOULD be excluded unless the acceptance item explicitly depends on
them.

Agents MUST NOT use CG findings outside the declared path scope as evidence
for acceptance, impact analysis, or release gating. If path scope is missing,
ambiguous, or stale, CG MUST be treated as unavailable for that task.

## Freshness Rule

When CG is declared for an acceptance item, the index freshness evidence MUST
show that the CG index timestamp is greater than or equal to the most recent
commit timestamp touching the declared path scope. If the evidence cannot be
produced, the CG result MAY still guide local exploration, but it MUST NOT be
used as validation or release evidence.

The canonical evidence pointer is `codegraphIndexFreshnessURI`. The artifact
SHOULD include:

- declared path scope
- most recent relevant commit SHA and timestamp
- CG index build timestamp
- checker identifier
- pass/fail status

## Evidence URIs

The code-intelligence context registers two evidence URIs:

- `codegraphIndexFreshnessURI` — pointer to freshness evidence for the
  declared CG index and path scope
- `codegraphImageDigestURI` — pointer to the immutable runtime image digest
  used for the CG service or validation path

See `core/EVIDENCE_CONTRACT.md` for requiredness by evidence type.

## Anti-Patterns

1. Reintroducing Graphify as an ADG integration surface.
2. Using a stale CG index as validation evidence.
3. Declaring CG without a path scope.
4. Citing a mutable image tag such as `latest` instead of an immutable digest.
5. Letting CG replace Astaire for governance artifact reads.
6. Broad native source-code spidering before a CG-first check in a
   CG-declared consumer.
7. Starting a production refactor in a CG-declared consumer without a CG
   impact/caller/callee/context check or an explicit fallback note.

## Cross-References

- `core/DOMAIN_LANGUAGE_GOVERNANCE.md` — bounded-context term authority and
  naming-correspondence rules.
- `core/EVIDENCE_CONTRACT.md` — registered evidence URI fields.
- `core/AUTONOMOUS_DELIVERY_GOVERNANCE.md` — optional Tier-2 capability
  declaration in artifact-first execution.
- `core/PLANNING_METHODOLOGY.md` — Astaire-first read discipline.
