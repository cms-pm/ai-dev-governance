---
phase: 9
stage_produced: implementation
context: memory-palace
produced_by_skill: adapters/providers/claude/skills/finding-seams/SKILL.md
produced_at: 2026-05-19
scope: astaire/ submodule full source tree
---

# Astaire Seam Map — SCN-9.4 Evidence

Produced by walking the `astaire/` source tree per
`adapters/providers/claude/skills/finding-seams/SKILL.md` and recording
every seam between the memory-palace domain and its I/O collaborators
(SQLite, FTS5, filesystem, tokenizer, stdlib clock). Refactor cost
ranking is **L / M / H** based on the number of call sites,
test-coverage depth, and downstream coupling.

The SCN-9.4 hexagonal refactor targets the **claims/projection
domain pilot** (Q2 resolution) — the entries marked **PILOT** below.
The remaining entries inform SCN-9.5 (characterisation suite) and the
Phase 10 full-repo refactor.

## Seams by Type

### 1. SQLite connection seam (the dominant seam)

Every public function in `astaire/src/` accepts a `sqlite3.Connection`
as its first positional argument. The connection is constructed in
`astaire/src/db.py:get_connection` and lifecycle-managed by
`astaire/src/db.py:managed_connection` and `transaction`.

| Module | Call sites | Cost | Notes |
|---|---|---|---|
| `astaire/src/db.py:15` (`get_connection`) | 1 entry point; consumed by CLI + tests | L | Constructor seam; trivially port-able. |
| `astaire/src/db.py:108` (`managed_connection`) | CLI bootstrap only | L | Context manager wrapping `get_connection`. |
| `astaire/src/db.py:122` (`transaction`) | every write path | M | Cross-cutting transaction-scope contract. |
| **`astaire/src/project.py`** (PILOT) | 11 functions take `sqlite3.Connection` | **M** | Refactor target — claims/projection domain. |
| `astaire/src/registry.py` | 16 functions take `sqlite3.Connection` | H | Document registry; defer to Phase 10. |
| `astaire/src/ingest.py` | 8 functions take `sqlite3.Connection` | H | Source → claims pipeline; defer to Phase 10. |
| `astaire/src/lint.py` | full module reads from DB | M | Defer to Phase 10 (covered by characterisation tests in SCN-9.5). |
| `astaire/src/export.py` | reads only | L | Cleanly read-side; pure formatter. Defer. |
| `astaire/src/prune.py` | small write surface | L | Defer to Phase 10. |

**Refactor pattern** (SCN-9.4 PILOT scope only): introduce
`astaire/src/domain/claims/ports.py` declaring a `ClaimRepository`
Protocol with the SQL methods the projection engine consumes; move the
SQLite-bound implementation into `astaire/src/adapters/sqlite/` and
have the existing module re-export the adapter symbol so call sites
remain unchanged.

### 2. FTS5 query seam

FTS5 access is concentrated in three call sites and one sanitiser.

| Reference | Cost | Notes |
|---|---|---|
| `astaire/src/registry.py:283` (`_sanitize_fts_query`) | L | Pure function on a string; lives in the domain. |
| `astaire/src/registry.py:297` (`search_documents`) | L | Issues `MATCH` against `document_fts`. |
| `astaire/src/project.py` claim/entity FTS reads | M | Indirect via `v_active_claims` / `v_entity_hub_scores`; SCN-9.4 PILOT target. |
| `astaire/src/lint.py` FTS staleness checks | L | Defer. |

**Refactor pattern** (PILOT): introduce an `FTSIndex` Protocol with
`search(query: str) -> list[FTSHit]`; the SQLite adapter wraps the
existing `MATCH` SQL. Domain code consumes only the Protocol.

### 3. Pytest fixture seam (test-only)

| Reference | Cost | Notes |
|---|---|---|
| `astaire/tests/conftest.py:8` (`db_conn`) | L | In-memory SQLite per test; cleanest seam for port fakes. |
| `astaire/tests/test_project.py:20` (test fixtures) | L | Builds DB state via SQL inserts; can be replaced with port-fake builders post-refactor. |
| `astaire/tests/test_registry.py:26/41/351` (fixtures) | L | Document-registry test setup; out of pilot scope. |
| `astaire/tests/test_ingest.py:18/30/38` (fixtures) | L | Ingest test setup; out of pilot scope. |

**Refactor pattern** (PILOT): SCN-9.4 leaves the existing fixtures in
place and adds a parallel `claim_repo` / `fts_index` fixture pair under
`astaire/tests/conftest.py` that yields in-memory port-fake
implementations. New projection-domain tests consume the fakes; legacy
tests continue to consume `db_conn`. Both must stay green.

### 4. Monkeypatch seam (test-only escape hatch)

| Reference | Cost | Notes |
|---|---|---|
| `astaire/tests/test_ingest.py:714/722` (L0 failure injection) | L | Patches `src.ingest.generate_l0`; preserved by refactor (module path unchanged). |
| `astaire/tests/test_ingest.py:735/742` (L0 failure injection on document path) | L | Same pattern. |

**Refactor pattern**: leave the monkeypatch seams intact —
`src.ingest.generate_l0` remains a callable symbol after the projection
refactor (the implementation moves, the export does not).

### 5. Module-level singleton seam (none)

Astaire has **no module-level singletons** in the claims/projection
domain. Connections are always passed explicitly. This is the cleanest
class of seam — no refactor work needed.

### 6. Filesystem + tokenizer seam (adjacent collaborators)

| Reference | Cost | Notes |
|---|---|---|
| `astaire/src/utils/hashing.py:hash_file` | L | Pure function over a path; safe to call from domain helpers in the read-side only. |
| `astaire/src/utils/tokens.py:count_tokens` | L | Thin tiktoken wrapper; pure. |
| `astaire/src/utils/ulid.py:generate` | L | Pure (no I/O); generates ULIDs. |
| `astaire/src/registry.py:142` (`path.read_text`) | L | Read-side I/O at register-document boundary. |

**Refactor pattern** (PILOT): keep `utils/` modules importable from the
domain — they have no SQLite/FTS coupling. The architecture-fitness
rule forbids `sqlite3`, `astaire.db`, and `astaire.fts` imports under
`astaire/src/domain/claims/`; it does not forbid `utils/`.

## SCN-9.4 PILOT Target Summary

The hexagonal refactor lands the following under one commit on branch
`SCN-9.4`:

1. New package `astaire/src/domain/claims/` (I/O-free).
   - `models.py` — frozen dataclasses for `Claim`, `Entity`,
     `Contradiction`, `Relationship`, `Projection`.
   - `ports.py` — `ClaimRepository`, `EntityRepository`, `FTSIndex`,
     `ProjectionCache` Protocol declarations.
   - `__init__.py` — re-exports.
2. New package `astaire/src/adapters/sqlite/` implementing the ports
   against the existing schema; thin wrappers around `astaire/src/db.py`.
3. `astaire/src/project.py` refactored to consume the ports via
   constructor injection while preserving its existing
   `sqlite3.Connection`-taking façade (legacy callers unchanged).
4. New `claim_repo` / `fts_index` pytest fixtures under
   `astaire/tests/conftest.py` returning port-fake implementations;
   new domain-level tests added beside existing tests.
5. `scripts/validators/architecture_fitness.py --audit` lands in
   the same SCN-9.4 commit (ADG repo, not submodule) and forbids
   `sqlite3`, `astaire.db`, and `astaire.fts` imports under
   `astaire/src/domain/claims/`.

## Out-of-PILOT Seams (Phase 10 candidates)

Tracked here so SCN-9.5's characterisation suite covers them:

- `astaire/src/ingest.py` full pipeline.
- `astaire/src/registry.py` document-registry surface.
- `astaire/src/lint.py` and `astaire/src/prune.py` write paths.
- `astaire/src/cli.py` argparse-to-function wiring.

## Risk Notes

- The pilot keeps `astaire/src/project.py` as the public surface; the
  refactor is **internal** and call sites remain unchanged. This
  satisfies the R-9-01 mitigation ("pilot-only scope") and the
  rollback path ("revert the claims/projection refactor commit").
- The pytest suite covers `project.py` exhaustively
  (`astaire/tests/test_project.py` is 499 LOC for a 499 LOC source
  module) which gives the refactor a strong safety net.
- Glossary entries for **Claim**, **Entity**, **Projection**, and
  **FTS** in `docs/glossary/memory-palace.md` already point at
  `astaire/src/domain/claims/` as the canonical reference — the
  glossary is authored to the post-refactor layout.
