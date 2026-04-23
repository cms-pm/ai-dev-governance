# Astaire Bootstrap Runbook

Covers: fresh-clone initialization, knowledge-base regeneration, and
troubleshooting for the `.astaire/memory_palace.db` SQLite store.

## Why the DB is not committed

`memory_palace.db` is a generated artifact — a compiled view of source files
already tracked in git. Committing it would cause binary merge conflicts on
every content change. The canonical source of truth is:

1. The **governance artifacts** in `docs/planning/`, `docs/releases/`,
   `docs/governance/` — registered via `astaire scan`
2. The **raw sources** in `raw/` — ingested via `astaire ingest`

## Quick start (fresh clone)

```bash
# 1. Initialize and scan governance artifacts
.astaire/astaire startup --root .

# 2. Verify document count (should be >= 30)
.astaire/astaire status

# 3. Optionally re-ingest raw/ sources
#    (skip if raw/ is empty or if you only need the document registry)
for f in raw/articles/*.md raw/notes/*.md; do
  [[ -f "$f" ]] && .astaire/astaire ingest "$f" --title "$(basename "$f" .md)"
done
```

## Deep-tree registration (consumer repos)

`.astaire/astaire startup --root .` performs a shallow scan of the default
collection paths. Consumer repos with deep governance trees
(`docs/planning/phase-*/chunks/`, `docs/validation/**`, `docs/governance/**`,
`docs/releases/**`) need an explicit recursive registration pass to get the
full corpus into the knowledge base.

Copy the template helper into the consumer repo and invoke it after
`startup`:

```bash
cp .governance/ai-dev-governance/templates/astaire_register_canonical_docs.py \
   scripts/astaire_register_canonical_docs.py

UV_CACHE_DIR=.astaire/.uv-cache \
PYTHONPATH=.governance/ai-dev-governance/astaire \
uv run --no-project --with tiktoken \
  python scripts/astaire_register_canonical_docs.py
```

The helper uses typed classifiers (chunk-plan, validation-evidence,
governance-artifact, board-artifact, release-evidence) so the result is
explicit rather than a blind recursive ingest. Edit `CANONICAL_TREES` in
the helper to match your repo's actual tree shape.

A first-class `register-canonical` subcommand in Astaire itself is the
longer-term fix — track the astaire upstream PR and drop this helper once
the repo re-pins to a release that carries it.

## Regeneration steps

If `memory_palace.db` is corrupted or you want a clean slate:

```bash
rm -f .astaire/memory_palace.db
.astaire/astaire startup --root .
```

The startup command re-initializes the schema from
`astaire/docs/schema/memory_palace_schema.sql` and re-scans all registered
collection paths.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `no such file: memory_palace.db` | Run `.astaire/astaire startup --root .` |
| `0 documents found` after scan | Check `--root` resolves to repo root, not `astaire/` subdir |
| FTS query with hyphen crashes | Upgrade astaire submodule to `>= v0.2.1`; use spaces instead of hyphens in FTS terms as a workaround |
| `cannot DELETE from contentless fts5 table` | Upgrade astaire submodule to `>= v0.2.1`; drop and recreate FTS tables (see astaire v0.2.1 release notes) |
| Scan registers wrong doc_type | Check `SCAN_RULES` in `astaire/src/collections/ai_dev_governance.py`; ensure target directory exists |

## Gitignore policy

The following are excluded from version control:

```
.astaire/memory_palace.db
.astaire/*.db-shm
.astaire/*.db-wal
raw/**/*.pdf
raw/**/*.docx
```

Binary source files (PDFs, Word docs) are excluded because they are typically
large and available externally. Markdown sources in `raw/` ARE committed so
the claim provenance chain is reproducible.
