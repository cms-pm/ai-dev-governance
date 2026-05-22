# Plan B: LSDF-Core Reference Path

Some consumers cannot run the containerized CodeGraph MCP server because the
host lacks Docker-compatible runtime support, the repository is Python-only
and already uses LSDF tooling, or local security policy blocks container
execution. In that case, keep CodeGraph disabled and use this reference path
as a lightweight source-discovery fallback.

## Upstream Reference

The reference location for upstream LSDF-core material is
`raw/lsdf-core/`. Graphify and document-corpus tools can inspect that content
as reference material without making it part of the product-code index.

Suggested layout:

```text
raw/lsdf-core/
  README.md
  upstream-notes.md
  examples/
```

## Reference Notes

- A consumer with CodeGraph disabled has no `codegraph` server entry in
  `.mcp.json`.
- A consumer with no local CodeGraph-compatible index usually has no
  `.codegraphignore`.
- Release evidence in this path comes from native repository tools, tests,
  compiler output, and Astaire governance projections.
- LSDF-core content remains reference material rather than vendored ADG
  template content or normative ADG policy.

## Return Path

When a container runtime becomes available, rebuild the CodeGraph image from
the ADG template, write `.codegraph/image.digest`, copy the MCP and ignore
fragments, and produce freshness evidence before using CodeGraph results as
release evidence.
