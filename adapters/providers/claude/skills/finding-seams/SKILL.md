---
name: finding-seams
description: Identify substitution points (seams) in existing Python code so it becomes testable without editing at the call site. Catalogues constructor injection, fixture, monkeypatch, and module-level singleton seams ranked by refactor cost. Source of truth is core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md §Refactor Onramp.
---

# finding-seams — Pytest seam catalogue

**Source of truth:** `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
§Refactor Onramp. The "seam map + characterisation suite required at
rubric score >= 2" rule is authored there; this skill produces the
seam map.

## When to load

- Preparing to refactor a tightly coupled module (e.g. SCN-9.4
  `astaire/` claims/projection core).
- A board lens flags "no seam map filed" for a refactor PR.
- Investigating an untestable third-party dependency.

## Pytest seam catalogue

| Seam | Mechanism | Refactor cost | Notes |
|---|---|---|---|
| Constructor injection | rewrite class to accept the collaborator as a parameter | medium | Preferred for adapter-style dependencies; pairs with the `hexagonal-architecture` skill. |
| Pytest fixture | introduce `@pytest.fixture` returning a fake or real collaborator | low | Best when many tests share the substitution. |
| `monkeypatch` | patch a module-level reference inside a test | low | Reversible; scoped to the test; use when constructor injection is impossible. |
| `unittest.mock.patch` | decorator/context-manager replacement of a symbol | low | Same trade-offs as `monkeypatch`; chosen when an existing suite already uses `mock`. |
| Module-level singleton | replace the global with a factory function or registry | high | Last-resort seam; flag in the seam map as a refactor follow-up. |
| `importlib.reload` | reset module state between tests | high | Symptom of hidden global state; document as a smell. |

## Seam map output

File: `docs/evidence/seam-maps/<target>-seam-map.md`. Template:

```markdown
---
target: astaire/src/claims/projection.py
rubric_score: <0-5>
authored_by: finding-seams skill
---

# Seam map — claims/projection

| Symbol | Current coupling | Proposed seam | Cost | Sibling test |
|---|---|---|---|---|
| `_open_sqlite(path)` | direct `sqlite3.connect` call | constructor-inject a `ConnectionFactory` Protocol | medium | `tests/test_projection.py::test_uses_injected_connection` |
| `_TOKENIZER` | module-level singleton (`tiktoken`) | factory function gated by a fixture | high | `tests/test_projection.py::test_uses_alt_tokenizer` |
…
```

Each row cites at least one sibling test that, once written, will
exercise the seam. The seam map is the input to the
characterisation-suite skill (which writes the actual safety net).

## Workflow

1. Read the target module via `Read`; do not modify it yet.
2. Enumerate every cross-boundary call (I/O, globals, module-level
   state).
3. For each, choose the lowest-cost seam from the table that preserves
   call-site signature.
4. Write the seam map under `docs/evidence/seam-maps/`.
5. Register with `.astaire/astaire scan`.

## Quoted source-of-truth rule

From `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor
Plan —
> "Seam map and characterisation test suite required before any
> production edits when the complexity rubric scores >= 2."

## Smoke check

Catalogue the seams in `astaire/src/registry.py::register_document`
(read-only); produce a one-page seam map under
`docs/evidence/seam-maps/`. Attach to SCN-9.3 evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/finding-seams/SKILL.md` (TypeScript
original); ADG version targets pytest's seam vocabulary and
delegates all normative authority to
`core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`.
