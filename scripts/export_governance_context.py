#!/usr/bin/env python3
"""Export manifest-derived governance context as JSON."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root",
        default=".",
        help="Repo root that contains governance.yaml (default: current directory).",
    )
    parser.add_argument(
        "--manifest",
        default=None,
        help="Optional manifest path override relative to --root or absolute.",
    )
    args = parser.parse_args()

    root = Path(args.root).resolve()
    sys.path.insert(0, str(root / "astaire" / "src"))

    try:
        from governance import load_governance_context
    except Exception as exc:  # pragma: no cover - shell path
        raise SystemExit(f"failed to load astaire governance helpers: {exc}")

    print(
        json.dumps(
            load_governance_context(root, args.manifest),
            indent=2,
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
