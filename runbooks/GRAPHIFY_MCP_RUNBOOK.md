# Graphify MCP Runbook

## Purpose

Describe the optional MCP sidecar path for consumers that want live graph
queries after Astaire L0 routes them there.

## Baseline Rule

- Astaire remains the port-of-first-resort.
- MCP is a tentacle, not a bypass.
- Consumers SHOULD keep `graphify.mcpSidecar: false` unless they have a clear
  operational need for live traversal.

## Startup

```bash
python -m graphify.serve graphify-out/graph.json
```

Register the stdio server in the client's MCP config only after the graph has
been generated and validated.

## Client Notes

- Claude Code: register the stdio command in the local MCP config.
- Codex: register the stdio command in the local MCP config.
- Generic MCP client: point the client at the same stdio command and ensure the
  working directory contains `graphify-out/graph.json`.

## Agent Mental Model

1. Start at Astaire L0.
2. Read the `route:` line.
3. If the route points at `graphify.mcp`, open the MCP query path.
4. Return a compact structural answer, not raw graph dumps.
