---
name: hexagonal-architecture
description: Python-idiom ports and adapters scaffolding. Defines Protocol-based ports, constructor-injected adapters, and the I/O-free domain package layout that the architecture-fitness validator enforces. Source of truth is core/MODULARITY_GOVERNANCE.md.
---

# hexagonal-architecture — Python ports & adapters

**Source of truth:** `core/MODULARITY_GOVERNANCE.md`. Dependency
direction rule, "domain has no I/O imports" rule, and fitness-function
format live there. This skill provides Python idioms; the
`scripts/validators/architecture_fitness.py` validator enforces the
rule from the source-of-truth document.

## When to load

- Refactoring an existing module so its domain core is I/O-free
  (e.g. SCN-9.4 claims/projection refactor).
- Greenfield design of a bounded context that will be subject to the
  `analyzers.architectureFitness` block.
- Reviewing a PR for dependency-direction compliance.

## CodeGraph-first refactor check

When the consumer declares CodeGraph, run `mcp__codegraph__impact`,
`mcp__codegraph__callers`, `mcp__codegraph__callees`,
`mcp__codegraph__context`, or `mcp__codegraph__explore` against the target
module or symbol before broad native spidering and before production edits.
Use the result to seed the ports/adapters affected-file list. If CodeGraph is
unavailable, stale, or outside declared scope, record that fallback before
using `Read`, `Grep`, `Glob`, `rg`, `find`, or recursive listings.

## Layout idiom

```
astaire/src/
  domain/
    claims/                # I/O-free; only stdlib + dataclasses + typing
      __init__.py
      models.py            # @dataclass(frozen=True) value objects
      ports.py             # Protocol classes — the inbound/outbound ports
      services.py          # pure orchestration; depends only on ports
  adapters/
    claims/
      sqlite_repo.py       # implements ClaimRepository Protocol
      fts_index.py         # implements ClaimSearchIndex Protocol
  app/
    claims_cli.py          # composition root: builds adapters, injects them
```

## Port idiom (Protocol, not ABC)

```python
from typing import Protocol, Iterable
from .models import Claim, ClaimId

class ClaimRepository(Protocol):
    def get(self, claim_id: ClaimId) -> Claim | None: ...
    def upsert(self, claim: Claim) -> None: ...
    def by_entity(self, entity_id: str) -> Iterable[Claim]: ...
```

Protocols (PEP 544) are preferred over `abc.ABC` because they are
structural and allow test doubles without inheritance gymnastics. See
`finding-seams` skill for the seam catalogue this enables.

## Adapter idiom

```python
class SqliteClaimRepository:
    def __init__(self, conn: sqlite3.Connection) -> None:
        self._conn = conn

    def get(self, claim_id: ClaimId) -> Claim | None:
        row = self._conn.execute(
            "SELECT * FROM claim WHERE claim_id = ?", (claim_id,)
        ).fetchone()
        return _row_to_claim(row) if row else None
```

The adapter knows about `sqlite3`; the domain does not. This is the
exact import boundary the architecture-fitness rule polices, quoted
from `core/MODULARITY_GOVERNANCE.md` §Dependency Direction —
> "No module under the domain package may import an adapter module or
> a stdlib I/O module (`sqlite3`, `requests`, `pathlib.Path.open`,
> etc.)."

## Fitness wiring

`scripts/validators/architecture_fitness.py` reads
`analyzers.architectureFitness.rulesPath` from `governance.yaml` and
walks the protected directory. Rules are expressed as forbidden import
strings. The validator exits non-zero when a forbidden import appears.

## Smoke check

Refactor a one-function fixture under
`validation/fixtures/architecture/positive/` into the
domain/adapter/composition-root shape; run the architecture-fitness
validator; confirm exit 0. Then break the rule in
`validation/fixtures/architecture/negative/` and confirm non-zero
exit.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/hexagonal-architecture/SKILL.md`
(TypeScript original); ADG version targets Python Protocols,
constructor injection, and the dependency-direction validator;
delegates all normative authority to `core/MODULARITY_GOVERNANCE.md`.
