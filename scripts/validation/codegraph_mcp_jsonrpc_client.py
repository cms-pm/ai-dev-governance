#!/usr/bin/env python3
"""Docker-wrapped CodeGraph MCP JSON-RPC shape smoke.

This harness intentionally talks to the MCP server over stdio instead of using
an SDK so ADG validates the wire shape a native Claude Code or Codex client
would see.
"""

from __future__ import annotations

import argparse
import json
import os
import select
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


EXPECTED_TOOLS = {
    "codegraph_search",
    "codegraph_context",
    "codegraph_callers",
    "codegraph_callees",
    "codegraph_impact",
    "codegraph_node",
    "codegraph_explore",
    "codegraph_status",
    "codegraph_files",
}


class RpcClient:
    def __init__(self, argv: list[str], project_root: Path, timeout: float) -> None:
        self.project_root = project_root
        self.timeout = timeout
        self.proc = subprocess.Popen(
            argv,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
        )
        self.next_id = 1

    def close(self) -> None:
        if self.proc.poll() is None:
            self.proc.terminate()
            try:
                self.proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.proc.kill()

    def request(self, method: str, params: dict[str, Any] | None = None) -> dict[str, Any]:
        assert self.proc.stdin is not None
        assert self.proc.stdout is not None
        req_id = self.next_id
        self.next_id += 1
        payload: dict[str, Any] = {"jsonrpc": "2.0", "id": req_id, "method": method}
        if params is not None:
            payload["params"] = params
        self.proc.stdin.write(json.dumps(payload) + "\n")
        self.proc.stdin.flush()

        deadline = time.monotonic() + self.timeout
        while time.monotonic() < deadline:
            ready, _, _ = select.select([self.proc.stdout], [], [], 0.1)
            if not ready:
                if self.proc.poll() is not None:
                    stderr = self.proc.stderr.read() if self.proc.stderr else ""
                    raise AssertionError(f"MCP server exited while waiting for {method}: {stderr}")
                continue
            line = self.proc.stdout.readline()
            if not line:
                if self.proc.poll() is not None:
                    stderr = self.proc.stderr.read() if self.proc.stderr else ""
                    raise AssertionError(f"MCP server exited while waiting for {method}: {stderr}")
                time.sleep(0.05)
                continue
            response = json.loads(line)
            if response.get("id") != req_id:
                continue
            if response.get("jsonrpc") != "2.0":
                raise AssertionError(f"{method} response missing jsonrpc=2.0: {response}")
            if "error" in response:
                raise AssertionError(f"{method} returned error: {response['error']}")
            if "result" not in response:
                raise AssertionError(f"{method} response missing result: {response}")
            return response
        raise AssertionError(f"Timed out waiting for {method}")

    def notify(self, method: str, params: dict[str, Any] | None = None) -> None:
        assert self.proc.stdin is not None
        payload: dict[str, Any] = {"jsonrpc": "2.0", "method": method}
        if params is not None:
            payload["params"] = params
        self.proc.stdin.write(json.dumps(payload) + "\n")
        self.proc.stdin.flush()


def text_from_tool(response: dict[str, Any], tool_name: str) -> str:
    result = response["result"]
    content = result.get("content")
    if not isinstance(content, list) or not content:
        raise AssertionError(f"{tool_name} result.content must be a non-empty list")
    texts: list[str] = []
    for item in content:
        if not isinstance(item, dict) or item.get("type") != "text" or not isinstance(item.get("text"), str):
            raise AssertionError(f"{tool_name} content item must be text: {item}")
        texts.append(item["text"])
    return "\n".join(texts)


def tool_call(
    client: RpcClient,
    name: str,
    arguments: dict[str, Any],
    tool_project_path: str | None,
) -> tuple[dict[str, Any], str]:
    if tool_project_path and "projectPath" not in arguments:
        arguments = {**arguments, "projectPath": tool_project_path}
    response = client.request("tools/call", {"name": name, "arguments": arguments})
    return response, text_from_tool(response, name)


def require_contains(text: str, expected: str, label: str) -> None:
    if expected not in text:
        raise AssertionError(f"{label} missing {expected!r}; preview={text[:800]!r}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-root", required=True)
    parser.add_argument("--tool-project-path")
    parser.add_argument("--root-uri")
    parser.add_argument("--evidence-json", required=True)
    parser.add_argument("--timeout", type=float, default=45.0)
    parser.add_argument("server_argv", nargs=argparse.REMAINDER)
    args = parser.parse_args()

    server_argv = args.server_argv
    if server_argv and server_argv[0] == "--":
        server_argv = server_argv[1:]
    if not server_argv:
        raise SystemExit("server command is required after --")

    project_root = Path(args.project_root).resolve()
    root_uri = args.root_uri or project_root.as_uri()
    tool_project_path = args.tool_project_path
    evidence: dict[str, Any] = {
        "projectRoot": str(project_root),
        "rootUri": root_uri,
        "toolProjectPath": tool_project_path,
        "serverCommand": server_argv,
        "checks": [],
    }

    client = RpcClient(server_argv, project_root, args.timeout)
    try:
        init = client.request(
            "initialize",
            {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "adg-codegraph-mcp-shape-smoke", "version": "1.0.0"},
                "rootUri": root_uri,
            },
        )
        init_result = init["result"]
        if init_result.get("serverInfo", {}).get("name") != "codegraph":
            raise AssertionError(f"initialize serverInfo.name mismatch: {init_result}")
        if "tools" not in init_result.get("capabilities", {}):
            raise AssertionError(f"initialize capabilities.tools missing: {init_result}")
        client.notify("initialized")
        evidence["checks"].append({"name": "initialize", "status": "pass"})

        tools_list = client.request("tools/list")
        tools = tools_list["result"].get("tools")
        if not isinstance(tools, list):
            raise AssertionError("tools/list result.tools must be a list")
        tool_names = {tool.get("name") for tool in tools if isinstance(tool, dict)}
        missing = sorted(EXPECTED_TOOLS - tool_names)
        if missing:
            raise AssertionError(f"tools/list missing expected tools: {missing}")
        evidence["checks"].append({"name": "tools/list", "status": "pass", "toolCount": len(tool_names)})

        matrix: list[dict[str, Any]] = []

        _, status_text = tool_call(client, "codegraph_status", {}, tool_project_path)
        require_contains(status_text, "CodeGraph Status", "status")
        matrix.append({"task": "index health", "nativeAvoided": "manual .codegraph/db inspection", "calls": ["codegraph_status"]})

        _, files_text = tool_call(
            client,
            "codegraph_files",
            {"path": "src/mcp", "format": "tree", "includeMetadata": True, "maxDepth": 3},
            tool_project_path,
        )
        require_contains(files_text, "tools.ts", "files")
        matrix.append({"task": "project layout", "nativeAvoided": "find/ls tree walk", "calls": ["codegraph_files"]})

        _, search_text = tool_call(
            client,
            "codegraph_search",
            {"query": "ToolHandler", "kind": "class", "limit": 5},
            tool_project_path,
        )
        require_contains(search_text, "ToolHandler", "search")
        require_contains(search_text, "src/mcp/tools.ts", "search")
        _, node_text = tool_call(
            client,
            "codegraph_node",
            {"symbol": "ToolHandler", "includeCode": False},
            tool_project_path,
        )
        require_contains(node_text, "ToolHandler", "node")
        matrix.append({"task": "function/type definition lookup", "nativeAvoided": "rg + Read definition chase", "calls": ["codegraph_search", "codegraph_node"]})

        _, context_text = tool_call(
            client,
            "codegraph_context",
            {"task": "Understand ToolHandler execute and MCP tool dispatch", "maxNodes": 12, "includeCode": True},
            tool_project_path,
        )
        require_contains(context_text, "ToolHandler", "context")
        matrix.append({"task": "compact task context", "nativeAvoided": "recursive grep plus multi-file Read", "calls": ["codegraph_context"]})

        _, callers_text = tool_call(
            client,
            "codegraph_callers",
            {"symbol": "ToolHandler.execute", "limit": 12},
            tool_project_path,
        )
        require_contains(callers_text, "execute", "callers")
        _, callees_text = tool_call(
            client,
            "codegraph_callees",
            {"symbol": "ToolHandler.execute", "limit": 12},
            tool_project_path,
        )
        require_contains(callees_text, "execute", "callees")
        _, impact_text = tool_call(
            client,
            "codegraph_impact",
            {"symbol": "ToolHandler.execute", "depth": 2},
            tool_project_path,
        )
        require_contains(impact_text, "ToolHandler", "impact")
        matrix.append({"task": "refactor blast-radius check", "nativeAvoided": "manual caller/callee graph via rg", "calls": ["codegraph_callers", "codegraph_callees", "codegraph_impact"]})

        _, explore_text = tool_call(
            client,
            "codegraph_explore",
            {"query": "ToolHandler execute tools.ts MCPServer handleToolsCall", "maxFiles": 6},
            tool_project_path,
        )
        require_contains(explore_text, "ToolHandler", "explore")
        require_contains(explore_text, "tools.ts", "explore")
        if len(explore_text) > 45000:
            raise AssertionError(f"explore output too large: {len(explore_text)} chars")
        matrix.append({"task": "seam/refactor survey", "nativeAvoided": "broad Read loop over related files", "calls": ["codegraph_explore"]})

        evidence["checks"].append({"name": "representative-tool-matrix", "status": "pass", "matrix": matrix})
        evidence["summary"] = {
            "status": "pass",
            "toolCalls": [call for item in matrix for call in item["calls"]],
        }
        Path(args.evidence_json).write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
        return 0
    except Exception as exc:
        evidence["summary"] = {"status": "fail", "error": str(exc)}
        Path(args.evidence_json).write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
        raise
    finally:
        client.close()


if __name__ == "__main__":
    sys.exit(main())
