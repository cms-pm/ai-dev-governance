# Astaire CLI Snippet (consumer template)

Paste the section below into the consumer repo's `AGENTS.md`,
`CLAUDE.md`, or equivalent agent-bootstrap document. Keep it at or
near the top so every agent session loads it into working context.

The wrapper path is `.astaire/astaire` at the consumer repo root by
default — this is what `runbooks/SUBMODULE_CONSUMER_RUNBOOK.md` §Wire
Astaire Access creates. If the consumer places the wrapper elsewhere,
replace every occurrence of `.astaire/astaire` below with the actual
path before pasting.

---

## Astaire — port-of-first-resort for governance artifacts

Astaire is the mandatory first read for any `docs/planning/**`,
`docs/releases/**`, or board artifact. Direct file reads are only
permitted when (a) Astaire has no projection for the target, or
(b) the read is in service of an edit.

**CLI location:** `.astaire/astaire` (repo root). Always invoke with
this full path — the wrapper sets `--db` to `.astaire/memory_palace.db`
and routes to the pinned submodule. It also defaults `UV_CACHE_DIR` to
`.astaire/.uv-cache` so restricted environments do not need write
access to `~/.cache/uv`. Never invoke bare `astaire`; it is not on PATH
and will not use the correct database.

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

Full surface: see `.governance/ai-dev-governance/runbooks/ASTAIRE_ACCESS.md`
(path depends on where the governance submodule is mounted).

---
