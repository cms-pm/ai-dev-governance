#!/usr/bin/env python3
"""Consumer-side recursive registration helper for canonical governance docs.

ADG-BOOTSTRAP-07. `.astaire/astaire startup --root .` performs a shallow scan
and does not walk deep governed trees (e.g. `docs/planning/phase-*/chunks/`,
`docs/validation/**`, `docs/governance/**`, `docs/releases/**`). This helper
registers those trees explicitly with typed classifiers so the result stays
governed rather than a blind recursive ingest.

Usage (from the consumer repo root):

    UV_CACHE_DIR=.astaire/.uv-cache \\
    PYTHONPATH=.governance/ai-dev-governance/astaire \\
    uv run --no-project --with tiktoken \\
      python templates/astaire_register_canonical_docs.py

or copy into the consumer repo's `scripts/` and invoke directly.

Notes
-----
- This is a consumer template. The longer-term fix is a first-class
  `register-canonical` subcommand in Astaire itself. Until that ships and
  this repo re-pins the astaire submodule, use this helper.
- The collection-helper API in astaire has known drift: `_derive_title`
  takes one arg in `governance_authoring.py` and two args (path, doc_type)
  in `ai_dev_governance.py`. This helper imports from the collection module
  that matches the target collection and adapts the call accordingly.
"""
from __future__ import annotations

import sys
from pathlib import Path

# Canonical doc-tree classifiers. Keep explicit — blind recursion loses
# governance signal.
CANONICAL_TREES: list[tuple[str, str, list[str]]] = [
    # (relative-path-glob, doc_type, tags)
    ("docs/planning/**/*.md", "chunk-plan", ["phase-plan"]),
    ("docs/validation/**/*.md", "validation-evidence", ["validation"]),
    ("docs/governance/**/*.md", "governance-artifact", ["governance"]),
    ("docs/governance/board/**/*.md", "board-artifact", ["board"]),
    ("docs/releases/**/*.md", "release-evidence", ["release"]),
]


def main(root: Path) -> int:
    try:
        from src.collections import ai_dev_governance as coll  # type: ignore
    except ImportError as e:
        print(
            f"[register-canonical] FAIL: cannot import astaire collection module: {e}\n"
            "Set PYTHONPATH to the astaire submodule (e.g. "
            ".governance/ai-dev-governance/astaire) before invoking.",
            file=sys.stderr,
        )
        return 2

    register = getattr(coll, "register_document", None)
    derive_title = getattr(coll, "_derive_title", None)
    if register is None or derive_title is None:
        print(
            "[register-canonical] FAIL: astaire collection module missing expected "
            "entrypoints (register_document / _derive_title).",
            file=sys.stderr,
        )
        return 2

    # Adapt to the two-arg _derive_title(filepath, doc_type) form used in
    # ai_dev_governance.py; fall back to the one-arg form if the collection
    # module hasn't been updated yet.
    def _title(path: Path, doc_type: str) -> str:
        try:
            return derive_title(path, doc_type)
        except TypeError:
            return derive_title(path)

    total = 0
    for pattern, doc_type, tags in CANONICAL_TREES:
        for filepath in sorted(root.glob(pattern)):
            if not filepath.is_file():
                continue
            title = _title(filepath, doc_type)
            register(filepath, doc_type, title, tags=tags or None)
            total += 1
            print(f"[register-canonical] {doc_type}: {filepath.relative_to(root)}")

    print(f"[register-canonical] registered {total} canonical documents")
    return 0


if __name__ == "__main__":
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    sys.exit(main(root.resolve()))
