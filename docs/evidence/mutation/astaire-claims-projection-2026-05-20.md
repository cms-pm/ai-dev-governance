---
phase: 9
scn: 9.5
stage_produced: validation
target: astaire/src/domain/claims/
tool: cosmic-ray
tool_version: 8.4.6
produced_at: 2026-05-20
---

# Astaire Claims Projection Mutation Baseline

This is the first SCN-9.5 mutation baseline for the I/O-free
`astaire/src/domain/claims/` pilot introduced in SCN-9.4.

## Run Metadata

| Field | Value |
|---|---|
| Tool | Cosmic Ray 8.4.6 |
| Config | `astaire/cosmic-ray.toml` |
| Session DB | `artifacts/cosmic-ray/astaire-claims-projection.sqlite` |
| Target paths | `astaire/src/domain/claims/{models.py,ports.py,__init__.py}` |
| Test command | `uv run pytest -q tests/test_domain_claims.py` |
| Baseline test result | `21 passed` after strengthening the domain suite |
| Local inner-loop check | mutmut 3.5.0 installed and configured; see tool note below |

## Aggregate Result

| Metric | Count |
|---|---:|
| Total mutants | 70 |
| Killed | 37 |
| Survived | 33 |
| Equivalent candidates | 33 |
| Accepted residuals | 0 |
| Raw mutation score | 52.86% |
| Equivalent-adjusted score if EQ-SCN-9.5-001 is accepted | 100.00% |

The first rough pass before test strengthening killed 21 of 70 mutants
(30.00%). SCN-9.5 immediately added domain tests for frozen dataclasses,
slots, and Protocol default limits; the rerun killed 37 of 70.

## Per-Module Breakdown

| Module | Total | Killed | Survived | Triage |
|---|---:|---:|---:|---|
| `src/domain/claims/models.py` | 30 | 30 | 0 | no survivors |
| `src/domain/claims/ports.py` | 40 | 7 | 33 | `equivalent-exception-candidate-SCN-9.5-EQ-001` |
| `src/domain/claims/__init__.py` | 0 | 0 | 0 | no generated mutants |

## Survivor List

All surviving mutants are in `src/domain/claims/ports.py` and mutate
PEP 604 return annotations on `Protocol` method stubs. Because Astaire
uses `from __future__ import annotations`, these signatures are stored
as annotations and do not change runtime behavior of the Protocols or
the adapter/fake implementations exercised by the suite.

| ID | Location | Operator family | Original | Mutated examples | Disposition |
|---|---|---|---|---|---|
| EQ-SCN-9.5-001A | `ports.py:38` `ClaimRepository.get_claim` | `ReplaceBinaryOperator_BitOr_*` | `Claim \| None` | `Claim + None`, `Claim & None`, `Claim - None`, etc. | `equivalent-exception-candidate-SCN-9.5-EQ-001` |
| EQ-SCN-9.5-001B | `ports.py:58` `EntityRepository.get_entity` | `ReplaceBinaryOperator_BitOr_*` | `Entity \| None` | `Entity + None`, `Entity & None`, `Entity - None`, etc. | `equivalent-exception-candidate-SCN-9.5-EQ-001` |
| EQ-SCN-9.5-001C | `ports.py:82` `ProjectionCache.read` | `ReplaceBinaryOperator_BitOr_*` | `str \| None` | `str + None`, `str & None`, `str - None`, etc. | `equivalent-exception-candidate-SCN-9.5-EQ-001` |

## Equivalent-Mutant Exception Candidate

**SCN-9.5-EQ-001.** Cosmic Ray's operator set mutates type-only
Protocol return annotations. Under the current interpreter and module
settings, those annotations are not executed and do not affect method
dispatch, runtime Protocol checks, adapter behavior, or projection
output. The mutants are therefore candidates for exclusion under
`core/MUTATION_EVIDENCE.md` §Equivalent-Mutant Exception Process.

Reviewer approval is deferred to SCN-9.7 DEC-0005. Until then, the raw
score remains 52.86% and the equivalent-adjusted score is advisory.

## mutmut Inner-Loop Note

`uv run --with mutmut mutmut --version` returns `mutmut, version
3.5.0`, and `[tool.mutmut]` is configured in `astaire/pyproject.toml`
with `astaire/mutmut.ini` as a mirror for older mutmut installations.
The scoped run is not used as gate evidence because mutmut 3.5.0 cannot
cleanly associate the selected dataclass/Protocol mutants in this
project layout: class/dataclass-only runs report no associated tests,
while function runs under the top-level package name `src` hit mutmut's
internal `src.` module-name guard. Cosmic Ray remains the authoritative
SCN-9.5 evidence tool.

## Commands Run

```bash
cd astaire
uv run pytest -q tests/test_domain_claims.py
uv run --with cosmic-ray cosmic-ray init cosmic-ray.toml ../artifacts/cosmic-ray/astaire-claims-projection.sqlite --force
uv run --with cosmic-ray cosmic-ray exec cosmic-ray.toml ../artifacts/cosmic-ray/astaire-claims-projection.sqlite
uv run --with mutmut mutmut --version
uv run --with mutmut mutmut run
```
