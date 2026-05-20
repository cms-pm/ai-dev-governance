"""Glossary-coverage validator (Phase 9 SCN-9.2).

Verifies the `analyzers.domainGlossary` block when present and emits a
WARN to stderr (exit 0) when a strict-baseline manifest omits the
block. Per Phase 9 Q5 resolution, presence is OPTIONAL at the schema
layer; tier-gated required-presence is enforced as a soft signal here.
The naming-correspondence check (types/functions/test-names vs glossary
terms) is SCN-9.4 work; this SCN-9.2 validator confines itself to
structural checks.

Structural FAIL conditions (exit 1):

- `analyzers.domainGlossary` is declared but missing `path` or
  `coverageRule`.
- `coverageRule` is declared but contains no `protectedPaths` entry.

WARN conditions (exit 0, message on stderr):

- Strict-baseline profile and the block is absent.
- Block present and `path` does not resolve to an existing directory.

PASS conditions (exit 0, silent):

- Block present, structurally valid, and `path` exists.
- Block absent on a non-strict-baseline profile.

CLI:

  python -m scripts.validators.glossary_coverage --manifest <path>
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from scripts.validators._analyzer_block import (
    collect_analyzer_lines,
    get_top_level_value,
    has_nested_key,
    has_top_level_key,
    parse_profile,
    profile_requires_block,
)

REQUIRED_TOP_LEVEL = ("path", "coverageRule")


def check(manifest_path: Path) -> tuple[int, str]:
    """Return `(exit_code, message)`. Exit 0 on PASS/WARN, 1 on FAIL."""
    if not manifest_path.exists():
        return 1, f"manifest path missing: {manifest_path}"

    block_lines = collect_analyzer_lines(manifest_path, "domainGlossary")
    profile = parse_profile(manifest_path)

    if not block_lines:
        if profile_requires_block(profile):
            return 0, (
                f"[WARN] {manifest_path}: profile={profile} but "
                "analyzers.domainGlossary is absent — see "
                "validation/CONSISTENCY_RULES.md §18"
            )
        return 0, (
            f"{manifest_path}: analyzers.domainGlossary absent (non-strict profile)"
        )

    for key in REQUIRED_TOP_LEVEL:
        if not has_top_level_key(block_lines, key):
            return 1, (
                f"{manifest_path}: analyzers.domainGlossary is declared "
                f"but missing required key '{key}'"
            )

    if not has_nested_key(block_lines, "coverageRule", "protectedPaths"):
        return 1, (
            f"{manifest_path}: analyzers.domainGlossary.coverageRule is "
            "declared but missing required key 'protectedPaths'"
        )

    declared_path = get_top_level_value(block_lines, "path")
    if declared_path:
        resolved = (manifest_path.parent / declared_path).resolve()
        if not resolved.is_dir():
            return 0, (
                f"[WARN] {manifest_path}: analyzers.domainGlossary.path="
                f"{declared_path} does not resolve to an existing "
                f"directory ({resolved}) — full coverage check deferred "
                "to SCN-9.4"
            )

    return 0, f"{manifest_path}: analyzers.domainGlossary structurally valid"


def _main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.validators.glossary_coverage",
        description=(
            "Glossary-coverage validator. Checks structural presence of "
            "analyzers.domainGlossary in a governance manifest."
        ),
    )
    parser.add_argument("--manifest", type=Path, required=True)
    args = parser.parse_args(argv)
    code, message = check(args.manifest)
    if code != 0:
        print(message, file=sys.stderr)
    elif message.startswith("[WARN]"):
        print(message, file=sys.stderr)
    return code


if __name__ == "__main__":
    sys.exit(_main(sys.argv[1:]))
