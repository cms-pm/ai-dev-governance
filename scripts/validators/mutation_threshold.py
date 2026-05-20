"""Mutation-threshold validator (Phase 9 SCN-9.7).

Verifies the `analyzers.mutation` block. DEC-0005 ratified the Phase 9
threshold table, so strict-baseline manifests now fail closed when the
block is absent. The schema still treats the block as optional at v1;
required-presence is enforced here.

Structural FAIL conditions (exit 1):

- `analyzers.mutation` is declared but missing one of the required
  leaf keys: `tool`, `commandTemplate`, `reportPath`, or `threshold`.
- `threshold` sub-object is declared but missing `medium`, `high`, or
  `critical`.

PASS conditions (exit 0, silent):

- Block present and structurally valid.
- Block absent on a non-strict-baseline profile.

CLI:

  python -m scripts.validators.mutation_threshold --manifest <path>
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from scripts.validators._analyzer_block import (
    collect_analyzer_lines,
    has_nested_key,
    has_top_level_key,
    parse_profile,
    profile_requires_block,
)

REQUIRED_TOP_LEVEL = ("tool", "commandTemplate", "reportPath", "threshold")
REQUIRED_THRESHOLD_TIERS = ("medium", "high", "critical")


def check(manifest_path: Path) -> tuple[int, str]:
    """Return `(exit_code, message)`. Exit 0 on PASS/WARN, 1 on FAIL."""
    if not manifest_path.exists():
        return 1, f"manifest path missing: {manifest_path}"

    block_lines = collect_analyzer_lines(manifest_path, "mutation")
    profile = parse_profile(manifest_path)

    if not block_lines:
        if profile_requires_block(profile):
            return 1, (
                f"{manifest_path}: profile={profile} but "
                "analyzers.mutation is absent after DEC-0005 ratification"
            )
        return 0, f"{manifest_path}: analyzers.mutation absent (non-strict profile)"

    for key in REQUIRED_TOP_LEVEL:
        if not has_top_level_key(block_lines, key):
            return 1, (
                f"{manifest_path}: analyzers.mutation is declared but "
                f"missing required key '{key}'"
            )

    for tier in REQUIRED_THRESHOLD_TIERS:
        if not has_nested_key(block_lines, "threshold", tier):
            return 1, (
                f"{manifest_path}: analyzers.mutation.threshold is "
                f"declared but missing required tier '{tier}'"
            )

    return 0, f"{manifest_path}: analyzers.mutation structurally valid"


def _main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.validators.mutation_threshold",
        description=(
            "Mutation-threshold validator. Checks fail-closed presence "
            "and structure of analyzers.mutation in a governance manifest."
        ),
    )
    parser.add_argument("--manifest", type=Path, required=True)
    args = parser.parse_args(argv)
    code, message = check(args.manifest)
    if code != 0:
        print(message, file=sys.stderr)
    return code


if __name__ == "__main__":
    sys.exit(_main(sys.argv[1:]))
