---
phase: 9
scn: 9.5
stage_produced: validation
tool: adapters/providers/claude/skills/test-design-reviewer/SKILL.md
produced_at: 2026-05-20
---

# Astaire Pytest Farley Scorecard

Scope: full `astaire/` pytest suite, with emphasis on the SCN-9.4
claims/projection pilot and the SCN-9.5 characterisation additions.

## Summary

| Property | Score | Evidence | Recommendation |
|---|---:|---|---|
| Authentic | 4 | CLI, ingest, registry, and project tests exercise public functions with real SQLite fixtures. | Keep adding user-path tests around CLI orchestration before Phase 10. |
| Repeatable | 5 | `uv run pytest -q` is deterministic locally; in-memory DB fixtures isolate state. | Preserve fixture isolation during the Phase 10 refactor. |
| Predictable | 4 | Failures usually identify the broken module; the new characterisation tests assert stable output shapes. | Improve failure messages in older broad assertions. |
| Independent | 4 | Tests use per-test DBs and temp dirs; no order dependency observed. | Watch for mutation-tool generated directories in local runs. |
| Specific | 4 | Domain tests now assert immutability, slots, Protocol defaults, and rendering separately. | Split a few larger CLI tests during Phase 10. |
| Empathetic | 3 | Many tests have SCN comments, but some assertions still rely on terse equality checks. | Add assertion context on high-value CLI and ingest failures. |
| Fast | 4 | Full suite: 372 passed in 8.67s before SCN-9.5; focused domain+characterisation suite: 24 passed in 0.37s. | Keep mutation target focused on the domain package. |
| Necessary | 4 | Mutation strengthening removed obvious gaps without deleting coverage. | Retire redundant legacy checks only after characterisation coverage is retained. |

Average score: **4.00 / 5**.

## Evidence Commands

```bash
cd astaire
uv run pytest -q
uv run pytest -q tests/test_domain_claims.py tests/test_characterisation_phase9.py
```

Observed results:

- Full suite before SCN-9.5 edits: `372 passed in 8.67s`.
- Focused SCN-9.5 suite after edits: `24 passed in 0.37s`.

## Findings

1. The suite is strong on deterministic storage behavior and public API
   workflows.
2. The original domain tests under-specified dataclass immutability and
   slots. SCN-9.5 added explicit tests, improving the Cosmic Ray score
   from 30.00% to 52.86% raw.
3. Remaining mutation survivors are tool/operator fit issues around
   type-only Protocol annotations, not clear evidence of missing runtime
   tests.
