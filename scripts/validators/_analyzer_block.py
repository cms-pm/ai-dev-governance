"""Shared helpers for the Phase 9 SCN-9.2 analyzer-block validators.

The three validators (`mutation_threshold`, `glossary_coverage`,
`architecture_fitness`) operate at the structural level: they check
that an `analyzers.<name>:` sub-block exists in the manifest and that
its required leaf keys are present. Deep semantic checks (mutation
score vs threshold; identifier-vs-glossary correspondence; import
audits) are SCN-9.4 / SCN-9.5 work.

Parsing follows the line-based pattern from `governance_gates.py`:
indent-aware regex over the manifest text. Inline comments are
stripped. PyYAML is intentionally not a dependency.
"""

from __future__ import annotations

import re
from pathlib import Path


def parse_profile(manifest_path: Path) -> str | None:
    """Return the manifest profile string."""
    for raw_line in manifest_path.read_text().splitlines():
        line = raw_line.split("#", 1)[0].rstrip()
        m = re.match(r"^profile:\s*(\S+)", line)
        if m:
            return m.group(1)
    return None


def profile_requires_block(profile: str | None) -> bool:
    """Strict-baseline (with or without +embedded) implies medium-or-higher."""
    if profile is None:
        return False
    return profile.startswith("strict-baseline")


def collect_analyzer_lines(manifest_path: Path, block_name: str) -> list[str]:
    """Return the raw lines under `analyzers.<block_name>:`.

    The returned lines are de-indented relative to the block header by
    stripping the leading indentation common to all entries. Inline
    comments are preserved (each validator strips as it parses).

    Empty list when the block is absent.
    """
    lines = manifest_path.read_text().splitlines()
    in_analyzers = False
    in_block = False
    block_indent: int | None = None
    captured: list[str] = []

    for raw_line in lines:
        stripped_for_indent = raw_line.split("#", 1)[0].rstrip()
        if not stripped_for_indent:
            if in_block:
                captured.append("")
            continue

        indent = len(stripped_for_indent) - len(stripped_for_indent.lstrip())
        content = stripped_for_indent.strip()

        if indent == 0:
            in_analyzers = content.startswith("analyzers:")
            in_block = False
            block_indent = None
            continue

        if not in_analyzers:
            continue

        # Direct child of analyzers: (indent == 2 typically).
        if indent == 2:
            in_block = content.startswith(f"{block_name}:")
            block_indent = indent if in_block else None
            continue

        if in_block and block_indent is not None and indent > block_indent:
            captured.append(stripped_for_indent)
        elif in_block and indent <= (block_indent or 0):
            in_block = False
            block_indent = None

    return captured


def has_top_level_key(block_lines: list[str], key: str) -> bool:
    """True if `<key>:` appears at the shallowest indent of `block_lines`."""
    if not block_lines:
        return False
    indents = [len(line) - len(line.lstrip()) for line in block_lines if line.strip()]
    if not indents:
        return False
    base = min(indents)
    target = re.compile(rf"^\s{{{base}}}{re.escape(key)}:\s*(.*)$")
    return any(target.match(line) for line in block_lines)


def get_top_level_value(block_lines: list[str], key: str) -> str | None:
    """Return the scalar value of `<key>:` at the shallowest indent."""
    if not block_lines:
        return None
    indents = [len(line) - len(line.lstrip()) for line in block_lines if line.strip()]
    if not indents:
        return None
    base = min(indents)
    target = re.compile(rf"^\s{{{base}}}{re.escape(key)}:\s*(\S.*)?$")
    for line in block_lines:
        m = target.match(line)
        if m:
            value = (m.group(1) or "").strip().strip('"').strip("'")
            return value or None
    return None


def has_nested_key(block_lines: list[str], parent: str, key: str) -> bool:
    """True if `<key>:` appears under `<parent>:` (one level deeper)."""
    if not block_lines:
        return False
    indents = [len(line) - len(line.lstrip()) for line in block_lines if line.strip()]
    if not indents:
        return False
    base = min(indents)
    parent_re = re.compile(rf"^\s{{{base}}}{re.escape(parent)}:\s*$")
    child_indent: int | None = None
    in_parent = False
    for line in block_lines:
        if not line.strip():
            continue
        if parent_re.match(line):
            in_parent = True
            child_indent = None
            continue
        if not in_parent:
            continue
        line_indent = len(line) - len(line.lstrip())
        if line_indent <= base:
            in_parent = False
            continue
        if child_indent is None:
            child_indent = line_indent
        if line_indent == child_indent:
            stripped = line.strip()
            m = re.match(rf"^{re.escape(key)}:\s*(.*)$", stripped)
            if m:
                return True
    return False
