---
phase: 9
scn: 9.5
stage_produced: validation
produced_at: 2026-05-20
target: astaire/tests/test_characterisation_phase9.py
---

# Astaire Characterisation Suite

SCN-9.5 adds `astaire/tests/test_characterisation_phase9.py` as the
temporary safety net for Phase 10's full-repo hexagonal refactor. Every
test is marked with `@pytest.mark.characterisation`, and the marker is
registered in `astaire/pyproject.toml`.

## Coverage Map

| Legacy area | Test | Behavior pinned | Seam-map link |
|---|---|---|---|
| `astaire/src/ingest.py` | `test_ingest_scan_directory_sorts_and_titles_registered_documents` | sorted recursive scan, title derivation, skipped unmatched files | filesystem + SQLite seam |
| `astaire/src/adapters/sqlite/fts_index.py` | `test_fts_adapter_sanitizes_punctuation_and_rejects_unknown_table` | FTS5 punctuation sanitising, empty query result, table allow-list | FTS5 query seam |
| `astaire/src/cli.py` | `test_cli_doctor_reports_schema_and_tokenizer_state` | doctor output shape for healthy DB/tokenizer state | CLI orchestration seam |

## Validation

```bash
cd astaire
uv run pytest -q tests/test_characterisation_phase9.py
uv run pytest -q tests/test_domain_claims.py tests/test_characterisation_phase9.py
```

Observed results:

- `3 passed in 0.35s`
- `24 passed in 0.37s`

## Phase 10 Use

The suite is intentionally narrow and output-focused. During the Phase
10 refactor it should be kept green while ingest, FTS, and CLI seams are
moved behind ports/adapters. Once equivalent replacement tests exist,
the characterisation marker lets maintainers find and retire these
temporary pins deliberately.
