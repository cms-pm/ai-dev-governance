# Agent Instructions — Example Consumer Repo

This file demonstrates a consumer `AGENTS.md` that satisfies the SCN-C
acceptance check: the Astaire CLI snippet (from
`templates/ASTAIRE_CLI_SNIPPET.md`) is inlined so every agent session
carries the port-of-first-resort surface in working context.

---

## Astaire — port-of-first-resort for governance artifacts

Astaire is the mandatory first read for any `docs/planning/**`,
`docs/releases/**`, or board artifact. Direct file reads are only
permitted when (a) Astaire has no projection for the target, or
(b) the read is in service of an edit.

**CLI location:** `.astaire/astaire` (repo root). Always invoke with
this full path — the wrapper sets `--db` to `.astaire/memory_palace.db`
and routes to the pinned submodule. Never invoke bare `astaire`; it is
not on PATH and will not use the correct database.

```bash
.astaire/astaire --help
.astaire/astaire status
.astaire/astaire query -t chunk-plan
.astaire/astaire context --tag phase=<n> --budget 6000
.astaire/astaire scan --root .
```

| Subcommand | When to use |
|---|---|
| `startup` | First action in a new session: `.astaire/astaire startup --root .` |
| `status` | "What does the knowledge base currently know?" |
| `query` | Look up artifacts by collection, type, tag, or FTS. |
| `context` | Assemble a token-budgeted bundle before planning or implementation. |
| `scan` | After writing or editing artifacts, register them. |
| `lint` | Before a release or gate review. |
| `ingest` | Bringing external corpus (articles, transcripts) into the store. |

Hyphens inside `--fts` queries are fragile (SQLite FTS5); prefer
phrasal forms.

Full surface: see `.governance/ai-dev-governance/runbooks/ASTAIRE_ACCESS.md`.

---

## RTK

This repo uses RTK for token compression. The hook rewrites `git`,
`uv run`, and other high-volume shell commands transparently. Run
`rtk gain` to check savings.
