# Astaire — repo-local memory palace

This directory hosts the SQLite memory-palace database that backs the
**port-of-first-resort** principle: every agent call reads L0 from here
before touching any other tentacle.

## Files

- `memory_palace.db` — SQLite store (gitignored).
- `astaire` — launcher script that pins `--db` to `.astaire/memory_palace.db`
  and routes to the pinned Astaire submodule at `astaire/`.

## Usage

From repo root:

```
./.astaire/astaire startup --root .
./.astaire/astaire status
./.astaire/astaire query --tag chunk=1.4
./.astaire/astaire context --tag chunk=1.4 --budget 4000
```

Evidence bundles for releases land at `docs/releases/astaire/`.

## Why repo-local

The Astaire submodule is pinned (see `.gitmodules`). Running Astaire from
`astaire/` would put its DB inside the submodule tree and drift from the
pin. The launcher here delegates to `uv run astaire` inside `astaire/` but
keeps the consumer-repo DB under this repo's control.
