# Astaire CLI Snippet (consumer template)

Paste the section below into the consumer repo's `AGENTS.md`,
`CLAUDE.md`, or equivalent agent-bootstrap document. Keep it at or
near the top so every agent session loads it into working context.

Replace `<WRAPPER_PATH>` with the consumer's repo-local wrapper
(default: `.astaire/astaire`).

---

## Astaire — port-of-first-resort for governance artifacts

Astaire is the mandatory first read for any `docs/planning/**`,
`docs/releases/**`, or board artifact. Direct file reads are only
permitted when (a) Astaire has no projection for the target, or
(b) the read is in service of an edit.

```bash
<WRAPPER_PATH> --help
<WRAPPER_PATH> status
<WRAPPER_PATH> query -t chunk-plan
<WRAPPER_PATH> context --tag phase=<n> --budget 6000
<WRAPPER_PATH> scan --root .
```

| Subcommand | When to use |
|---|---|
| `startup` | First action in a new session. |
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
