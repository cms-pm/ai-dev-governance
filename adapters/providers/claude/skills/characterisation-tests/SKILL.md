---
name: characterisation-tests
description: Pin down current Python behaviour with snapshot / golden-master pytest patterns before refactoring legacy code. Uses syrupy snapshots or hand-rolled golden files; marks tests with @pytest.mark.characterisation. Source of truth is core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md §Refactor Onramp.
---

# characterisation-tests — Pytest snapshot / golden-master suite

**Source of truth:** `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
§Refactor Onramp. The "seam map + characterisation suite required at
rubric score >= 2" rule is authored there; this skill produces the
characterisation suite that pairs with the seam map.

## When to load

- After the `finding-seams` skill has produced a seam map for the
  target module.
- Before any production edits to a legacy module flagged by the
  complexity rubric at >= 2.
- Standing up a safety net for an upcoming hexagonal refactor
  (e.g. SCN-9.5 characterisation suite for `astaire/` ingest, FTS,
  and CLI modules).

## Tooling

- Preferred: `syrupy` — pytest plugin for inline + file snapshots.
- Fallback: hand-rolled golden files under `tests/golden/` with a
  helper to compare bytes / parsed JSON / parsed Markdown.
- Marker: every characterisation test carries
  `@pytest.mark.characterisation` so the test runner can include or
  exclude them in dedicated phases.

`pytest.ini` registration of the marker:

```ini
[pytest]
markers =
    characterisation: documents current behaviour of legacy code;
                      removable once the target is hexagonally
                      refactored and unit-covered.
```

## Pattern (syrupy)

```python
import pytest
from astaire.src.ingest import ingest_source

@pytest.mark.characterisation
def test_ingest_source_pins_current_output(snapshot, tmp_path):
    fixture = tmp_path / "sample.md"
    fixture.write_text("# Heading\n\nbody\n")
    result = ingest_source(fixture)
    assert result == snapshot  # syrupy snapshot file is the spec
```

## Pattern (hand-rolled golden)

```python
import json
import pytest
from pathlib import Path
from astaire.src.ingest import ingest_source

GOLDEN = Path(__file__).parent / "golden" / "ingest_sample.json"

@pytest.mark.characterisation
def test_ingest_source_matches_golden(tmp_path):
    fixture = tmp_path / "sample.md"
    fixture.write_text("# Heading\n\nbody\n")
    result = ingest_source(fixture)
    assert result == json.loads(GOLDEN.read_text())
```

## Discipline

Before selecting fixtures or reading broadly across legacy code, use
CodeGraph first when the consumer declares it: run a narrow
`mcp__codegraph__context`, `explore`, `callers`, `callees`, or `impact`
query for the target path/symbol and record the affected files in the
characterisation evidence note. If CodeGraph is unavailable, stale, or
outside declared scope, record that fallback before native spidering.

Quoted from
`core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` §Refactor Onramp —
> "Characterisation tests pin observed behaviour, not desired
> behaviour. They are scaffolding for a refactor and are removed once
> the target is unit-covered through proper TDR."

The suite is registered in the evidence bundle as the companion of the
seam map and is summarised in
`docs/evidence/seam-maps/<target>-characterisation-suite.md`.

## Smoke check

Pin one current behaviour of `astaire/src/utils/tokens.py:count_tokens`
with a syrupy snapshot and the `@pytest.mark.characterisation` marker;
run pytest; confirm the snapshot file is written and the test passes.
Attach to SCN-9.3 evidence bundle.

## Provenance

Structure adapted from
`raw/skills-entourage/skills/characterisation-tests/SKILL.md`
(TypeScript original); ADG version targets pytest, syrupy, and the
`@pytest.mark.characterisation` marker; delegates all normative
authority to `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`.
