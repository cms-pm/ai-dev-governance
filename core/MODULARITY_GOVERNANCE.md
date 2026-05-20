# Modularity Governance (Ports and Adapters)

## Purpose

This core policy defines the modularity discipline required for
production code under ADG. It is provider- and language-agnostic and
applies to any repository declaring a modularity profile, with explicit
applicability rules below.

Keywords `MUST`, `SHOULD`, and `MAY` are normative.

## Core Principle

Production components MUST separate **domain** (behavior and rules) from
**I/O** (databases, filesystems, networks, time, randomness, external
services). The domain MUST be reachable through declared **ports**;
**adapters** implement those ports against concrete I/O. This is the
hexagonal (ports + adapters) shape; the rule itself is language-agnostic.

## Definitions

- **Domain.** Code expressing business rules, invariants, value objects,
  and aggregates. Domain code MUST be reachable without booting any
  external resource.
- **Port.** A declared interface (Python `Protocol`, Java/TS
  interface, Go interface, Rust trait, C header) owned by the domain
  and named in domain vocabulary.
- **Adapter.** An implementation of a port that performs I/O. Lives
  outside the domain package or module tree.
- **Composition root.** The single entry point (CLI main, service
  bootstrap, test fixture) where adapters are wired to the domain.
- **Bounded context.** As defined in
  `core/DOMAIN_LANGUAGE_GOVERNANCE.md`. Each bounded context MAY have
  its own domain/port/adapter layering.

## Applicability

This policy applies to production-code work in any repository whose
governance manifest declares `analyzers.architectureFitness` (see
`validation/CONSISTENCY_RULES.md` §19) **or** whose declared risk tier
for the chunk is medium or higher.

For documentation-only changes, localized test-only changes, or
prototype scratch work clearly marked as such, agents MAY record "not
applicable" with a short reason.

## Dependency Direction Rule

The dependency graph MUST flow inward:

```
adapter  ─▶  port  ─▶  domain
            (owned by domain)
```

Specifically:

1. Domain modules MUST NOT import adapter modules.
2. Domain modules MUST NOT import I/O libraries (e.g. `sqlite3`,
   `requests`, `boto3`, filesystem, network, time-of-day, random) except
   through a port declared in the domain.
3. Ports MAY import only standard-library type primitives and other
   domain types.
4. Adapters MAY import anything they need (I/O libraries, third-party
   SDKs) and MUST implement at least one declared port.
5. The composition root MAY import adapters and the domain; nothing else
   imports the composition root.

The "domain has no I/O imports" rule is the hard floor. An import audit
under the protected domain directory MUST return zero hits for the I/O
modules enumerated in the project's architecture-fitness rule file.

## Port Declaration Rules

Every port MUST:

1. Be named after a domain capability, not an implementation
   (`ClaimStore`, not `SQLiteClaimsTable`).
2. Live in the domain package adjacent to the types it serves.
3. Declare only the methods the domain actually uses. Adapter-only
   conveniences (connection pools, transactions, batch helpers) MUST
   live behind the port surface, not on it.
4. Be implementable by at least one production adapter and at least one
   test fake or in-memory adapter (for use by domain unit tests).

## Adapter Rules

Every adapter MUST:

1. Implement at least one declared port.
2. Live outside the protected domain directory.
3. Translate adapter-layer errors into domain-vocabulary errors at the
   port boundary. Domain code MUST NOT see adapter-specific exception
   types.
4. Be replaceable: swapping one adapter for another at the composition
   root MUST NOT require domain edits.

## Composition Root Rules

The composition root:

1. MUST be the only place adapter constructors are called with real
   I/O configuration.
2. MUST be discoverable from the repository entry point (e.g.
   `src/<package>/__main__.py`, a `cmd/<name>/main.go`, etc.).
3. MUST NOT contain domain logic; its job is wiring.
4. MAY be split into multiple composition roots (CLI vs. service vs.
   test harness) provided each is self-contained.

## Architecture Fitness Function Format

Repositories under this policy MUST declare a fitness function as a
machine-checkable rule. Default format (`analyzers.architectureFitness`
manifest block; see `contracts/governance-manifest.schema.json`):

```yaml
analyzers:
  architectureFitness:
    rulesPath: validation/architecture-fitness.yaml
    engine: scripts/validators/architecture_fitness.py
```

The rules file declares the protected domain directory and the
forbidden imports:

```yaml
rules:
  - id: domain-no-io
    protectedPath: <package>/src/domain/
    forbiddenImports:
      - sqlite3
      - <package>.db
      - <package>.fts
      - requests
```

The validator MUST exit 0 when no forbidden import appears under the
protected path, and non-zero (with the offending file and line) when
any forbidden import is present.

## Refactor Onramp

When existing code does not yet satisfy this policy, the entry path is
defined in `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor
Plan: a seam map plus a characterisation-test suite MUST land before any
production edit when the complexity rubric scores ≥ 2.

## Risk Tier Coupling

- Low-tier chunks MAY proceed without declaring an architecture-fitness
  block, provided no production-code module crosses the
  domain/adapter boundary they would otherwise govern.
- Medium-tier and higher chunks MUST either declare the
  `analyzers.architectureFitness` block in the governance manifest or
  record an exception under `core/EXCEPTIONS_AND_WAIVERS.md`.

## Anti-Patterns

1. Module names that mix domain and I/O (`UserRepositorySQLite`,
   `OrderEmailSenderHTTP`). Use port + adapter separation instead.
2. "God adapters" that implement five unrelated ports.
3. Tests that boot real I/O because no in-memory adapter exists for the
   port.
4. Composition logic that drifts into domain modules (e.g. a domain
   class that constructs its own database connection).
5. Forbidden-import suppressions (`# noqa`, `// nolint`) under the
   protected path. The fitness function MUST fail-closed; exceptions go
   through the policy in `core/EXCEPTIONS_AND_WAIVERS.md`.

## Cross-References

- `core/DOMAIN_LANGUAGE_GOVERNANCE.md` — ports MUST be named in the
  bounded context's ubiquitous language.
- `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor Plan —
  seam-map and characterisation-test gating for refactor work.
- `core/MUTATION_EVIDENCE.md` — mutation evidence for domain code is
  expected to be the highest-scoring tier in the threshold table.
- `validation/CONSISTENCY_RULES.md` §19 — required-presence of the
  `analyzers.architectureFitness` block by risk tier.
- `contracts/governance-manifest.schema.json` — schema for the
  `analyzers.architectureFitness` block.
