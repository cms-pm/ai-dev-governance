"""Architecture-fitness validator (Phase 9 SCN-9.2 + SCN-9.4 audit).

Two modes:

1. **Structural** (default, SCN-9.2). Verifies the
   `analyzers.architectureFitness` block in a governance manifest and
   emits a WARN to stderr (exit 0) when a strict-baseline manifest
   omits it.
2. **Audit** (`--audit`, SCN-9.4). Walks the protected directories
   declared in the rules file and flags any module that imports a
   forbidden symbol. Per `core/MODULARITY_GOVERNANCE.md` §Architecture
   Fitness Rule, this is the full forbidden-import pass against the
   protected domain tree.

Structural FAIL conditions (exit 1):

- `analyzers.architectureFitness` is declared but missing `rulesPath`
  or `engine`.

Audit FAIL conditions (exit 1):

- Any file under `protectedPath` issues a top-level `import X` or
  `from X import …` for a name listed in `forbidden`.

WARN conditions (exit 0, message on stderr):

- Strict-baseline profile and the block is absent.
- Block present and `rulesPath` does not resolve to an existing file.

PASS conditions (exit 0):

- Block present, structurally valid, `rulesPath` exists.
- Block absent on a non-strict-baseline profile.
- Audit pass: no forbidden imports under any protected path.

CLI:

  python -m scripts.validators.architecture_fitness --manifest <path>
  python -m scripts.validators.architecture_fitness --audit \\
      --rules validation/architecture-fitness.yaml --root .
"""

from __future__ import annotations

import argparse
import ast
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


# ── SCN-9.4 audit mode ─────────────────────────────────────────


def _parse_rules(rules_path: Path) -> list[dict]:
    """Tiny YAML-subset parser for the rules file.

    Recognises the `forbiddenImports:` block with `protectedPath`,
    `forbidden` (list), and `description` (folded scalar ignored).
    Avoids a PyYAML dependency so this stays consistent with the rest
    of `scripts/validators/`.
    """

    entries: list[dict] = []
    current: dict | None = None
    in_forbidden_list = False
    in_section = False

    for raw in rules_path.read_text(encoding="utf-8").splitlines():
        line = raw.rstrip()
        if not line or line.lstrip().startswith("#"):
            continue
        stripped = line.lstrip()

        if stripped.startswith("forbiddenImports:"):
            in_section = True
            continue
        if not in_section:
            continue

        # Top-level keys outside the section terminate parsing.
        if not line.startswith((" ", "\t")) and not stripped.startswith("- "):
            in_section = False
            continue

        if stripped.startswith("- protectedPath:"):
            if current is not None:
                entries.append(current)
            current = {
                "protectedPath": stripped.split(":", 1)[1].strip(),
                "forbidden": [],
            }
            in_forbidden_list = False
            continue

        if current is None:
            continue

        if stripped.startswith("forbidden:"):
            in_forbidden_list = True
            continue

        if in_forbidden_list and stripped.startswith("- "):
            current["forbidden"].append(stripped[2:].strip())
            continue

        if stripped.startswith("description:"):
            in_forbidden_list = False
            continue

    if current is not None:
        entries.append(current)
    return entries


def _imports_in_module(module_path: Path) -> list[tuple[int, str]]:
    """Return (lineno, fully-qualified name) for every top-level import."""

    try:
        tree = ast.parse(module_path.read_text(encoding="utf-8"))
    except (OSError, SyntaxError):
        return []
    found: list[tuple[int, str]] = []
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                found.append((node.lineno, alias.name))
        elif isinstance(node, ast.ImportFrom):
            if node.module:
                found.append((node.lineno, node.module))
    return found


def _module_matches_forbidden(import_name: str, forbidden: str) -> bool:
    """An import matches a forbidden name if it equals it or is a
    submodule of it (`forbidden == 'src.db'` matches `src.db.foo`).
    """

    return import_name == forbidden or import_name.startswith(forbidden + ".")


def audit(root: Path, rules_path: Path) -> tuple[int, list[str]]:
    """Walk protected paths and flag forbidden imports.

    Returns `(exit_code, messages)`. `exit_code` is 1 if any violation
    is found, 0 otherwise. Missing protected paths emit a WARN
    (still exit 0).
    """

    if not rules_path.exists():
        return 1, [f"[FAIL] rules file missing: {rules_path}"]

    entries = _parse_rules(rules_path)
    if not entries:
        return 0, [f"{rules_path}: no forbiddenImports entries — audit no-op"]

    messages: list[str] = []
    violations: list[str] = []

    for entry in entries:
        protected = (root / entry["protectedPath"]).resolve()
        if not protected.exists():
            messages.append(
                f"[WARN] protectedPath does not exist: "
                f"{entry['protectedPath']}"
            )
            continue
        forbidden = entry["forbidden"]
        for py_file in sorted(protected.rglob("*.py")):
            for lineno, name in _imports_in_module(py_file):
                for f in forbidden:
                    if _module_matches_forbidden(name, f):
                        rel = py_file.relative_to(root)
                        violations.append(
                            f"[FAIL] {rel}:{lineno} imports forbidden "
                            f"name {name!r} (rule: {entry['protectedPath']} "
                            f"forbids {f!r})"
                        )

    if violations:
        return 1, violations
    messages.append(
        f"{rules_path}: audit clean across "
        f"{len(entries)} protected path(s)"
    )
    return 0, messages


def _main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.validators.architecture_fitness",
        description=(
            "Architecture-fitness validator. Default mode checks "
            "structural presence of analyzers.architectureFitness in a "
            "governance manifest. --audit walks the rules file and "
            "flags forbidden imports under protected paths (SCN-9.4)."
        ),
    )
    parser.add_argument("--manifest", type=Path)
    parser.add_argument(
        "--audit",
        action="store_true",
        help="Run the SCN-9.4 forbidden-import audit instead of the "
        "structural manifest check.",
    )
    parser.add_argument(
        "--rules",
        type=Path,
        help="Path to the architecture-fitness rules file "
        "(required with --audit).",
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("."),
        help="Repository root for resolving protectedPath entries "
        "(default: cwd).",
    )
    args = parser.parse_args(argv)

    if args.audit:
        if args.rules is None:
            print(
                "[FAIL] --audit requires --rules <path>",
                file=sys.stderr,
            )
            return 1
        code, messages = audit(args.root.resolve(), args.rules)
        for msg in messages:
            stream = sys.stderr if msg.startswith(("[FAIL]", "[WARN]")) else sys.stdout
            print(msg, file=stream)
        return code

    if args.manifest is None:
        print(
            "[FAIL] structural mode requires --manifest <path>",
            file=sys.stderr,
        )
        return 1

    code, message = check(args.manifest)
    if code != 0:
        print(message, file=sys.stderr)
    elif message.startswith("[WARN]"):
        print(message, file=sys.stderr)
    return code


if __name__ == "__main__":
    sys.exit(_main(sys.argv[1:]))
