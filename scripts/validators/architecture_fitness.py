"""Architecture-fitness validator (Phase 9 SCN-9.2).

Verifies the `analyzers.architectureFitness` block when present and
emits a WARN to stderr (exit 0) when a strict-baseline manifest omits
it. Per Phase 9 Q5, presence is OPTIONAL at the schema layer. The full
import-audit pass (forbidden imports under the protected domain
directory) is SCN-9.4 work and lands in the same module under a
`--audit` flag; this SCN-9.2 entry confines itself to structural
checks.

Structural FAIL conditions (exit 1):

- `analyzers.architectureFitness` is declared but missing `rulesPath`
  or `engine`.

WARN conditions (exit 0, message on stderr):

- Strict-baseline profile and the block is absent.
- Block present and `rulesPath` does not resolve to an existing file.

PASS conditions (exit 0, silent):

- Block present, structurally valid, and `rulesPath` exists.
- Block absent on a non-strict-baseline profile.

CLI:

  python -m scripts.validators.architecture_fitness --manifest <path>
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from scripts.validators._analyzer_block import (
    collect_analyzer_lines,
    get_top_level_value,
    has_top_level_key,
    parse_profile,
    profile_requires_block,
)

REQUIRED_TOP_LEVEL = ("rulesPath", "engine")


def check(manifest_path: Path) -> tuple[int, str]:
    """Return `(exit_code, message)`. Exit 0 on PASS/WARN, 1 on FAIL."""
    if not manifest_path.exists():
        return 1, f"manifest path missing: {manifest_path}"

    block_lines = collect_analyzer_lines(manifest_path, "architectureFitness")
    profile = parse_profile(manifest_path)

    if not block_lines:
        if profile_requires_block(profile):
            return 0, (
                f"[WARN] {manifest_path}: profile={profile} but "
                "analyzers.architectureFitness is absent — see "
                "validation/CONSISTENCY_RULES.md §19"
            )
        return 0, (
            f"{manifest_path}: analyzers.architectureFitness absent "
            "(non-strict profile)"
        )

    for key in REQUIRED_TOP_LEVEL:
        if not has_top_level_key(block_lines, key):
            return 1, (
                f"{manifest_path}: analyzers.architectureFitness is "
                f"declared but missing required key '{key}'"
            )

    declared_rules = get_top_level_value(block_lines, "rulesPath")
    if declared_rules:
        resolved = (manifest_path.parent / declared_rules).resolve()
        if not resolved.is_file():
            return 0, (
                f"[WARN] {manifest_path}: "
                f"analyzers.architectureFitness.rulesPath={declared_rules} "
                f"does not resolve to an existing file ({resolved}) — "
                "full import audit deferred to SCN-9.4"
            )

    return 0, (
        f"{manifest_path}: analyzers.architectureFitness structurally valid"
    )


def _main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.validators.architecture_fitness",
        description=(
            "Architecture-fitness validator. Checks structural presence "
            "of analyzers.architectureFitness in a governance manifest."
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
