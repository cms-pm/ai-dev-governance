# raw/ — Immutable Source Corpus

Files here are ingested into the Astaire knowledge base via:

```bash
.astaire/astaire ingest <file> --title "<title>"
```

Once ingested, source files are **never edited** — they are the provenance record
for extracted claims. To supersede a claim, add a newer source and let Astaire
resolve the contradiction.

## Directory conventions

| Directory | Contents |
|---|---|
| `articles/` | Blog posts, technical write-ups, governance commentary |
| `papers/` | Academic or research papers (PDF or markdown) |
| `transcripts/` | Meeting transcripts, interview notes |
| `notes/` | Session notes, decisions not captured in formal artifacts |

## Naming convention

`YYYY-MM-DD-<slug>.<ext>` — the date prefix enables temporal ordering during
contradiction resolution.

## What belongs here vs. in `docs/`

- `raw/` — external or unstructured sources that feed the claim store
- `docs/planning/` — structured governance artifacts (chunk plans, scenarios, board records)
- `docs/releases/` — release evidence bundles

Governance artifacts in `docs/` are registered via `astaire scan`; raw sources
are ingested via `astaire ingest`. Do not cross-register.

## Regenerating the knowledge base

The `.astaire/memory_palace.db` is not committed. To rebuild after a fresh clone:

```bash
.astaire/astaire startup --root .
# Then re-ingest any raw/ sources you want in the claim store:
for f in raw/articles/*.md; do
  .astaire/astaire ingest "$f" --title "$(basename "$f" .md)"
done
```

See `runbooks/ASTAIRE_BOOTSTRAP.md` for the full regeneration runbook.
