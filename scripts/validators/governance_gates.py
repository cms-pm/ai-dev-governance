"""Stand-alone governance gates extracted from scripts/validate_governance.sh.

One gate lives here:

- embedded-profile fail-closed gate: per-manifest verdict. Manifests that
  declare `profiles/embedded` under `adapters` MUST carry
  `evidence.embeddedVerificationChecklistPath` pointing to a file that
  exists relative to the manifest. Manifests that do not declare the
  embedded profile MUST NOT carry the key.

CLI:

  python -m scripts.validators.governance_gates --manifest <path>

`scripts/validate_governance.sh` orchestrates the per-manifest sweep by
invoking this module; the verdict logic lives here so it can be
unit-tested in isolation.

Exit codes: 0 on PASS, 1 on FAIL with an explicit human-readable message
on stderr. The shell script aggregates exit codes across manifests.

Note: the agency-string CI guard previously lived alongside the
embedded-profile gate. It was retired at SCN-8.3.2 per the closure of
OPP-8.2-004 — the one-time repo-wide sweep at Phase 8.2 bootstrap is
sufficient; ongoing per-pass enforcement is not required.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

CHECKLIST_KEY = "embeddedVerificationChecklistPath"
EMBEDDED_ADAPTER = "profiles/embedded"


def _parse_manifest(path: Path) -> dict:
    """Extract `adapters` list and `evidence.embeddedVerificationChecklistPath`.

    Lightweight line-based parser matching the original shell-embedded
    Python heredoc behaviour; tolerates inline comments and arbitrary
    sibling keys.
    """
    adapters: list[str] = []
    checklist_path: str | None = None
    in_adapters = False
    in_evidence = False
    for raw_line in path.read_text().splitlines():
        line = raw_line.split("#", 1)[0].rstrip()
        if re.match(r"^\S", line):
            in_adapters = line.startswith("adapters:")
            in_evidence = line.startswith("evidence:")
            continue
        if in_adapters:
            m = re.match(r"^\s*-\s*(\S+)", line)
            if m:
                adapters.append(m.group(1))
        if in_evidence:
            m = re.match(rf"^\s+{re.escape(CHECKLIST_KEY)}:\s*(\S+)", line)
            if m:
                checklist_path = m.group(1)
    return {"adapters": adapters, CHECKLIST_KEY: checklist_path}


def check_embedded_profile_gate(manifest_path: Path) -> tuple[bool, str]:
    """Return `(passed, message)` for the embedded-profile fail-closed gate.

    Pass conditions:
      - manifest declares `profiles/embedded` AND declares the checklist
        key pointing to an existing file (relative to manifest).
      - manifest does NOT declare `profiles/embedded` AND does NOT
        declare the checklist key.

    Fail conditions:
      - embedded profile declared, key missing.
      - embedded profile declared, key present but path does not exist.
      - embedded profile NOT declared, key present.
    """
    if not manifest_path.exists():
        return False, f"manifest path missing: {manifest_path}"

    data = _parse_manifest(manifest_path)
    has_embedded = EMBEDDED_ADAPTER in data["adapters"]
    declared = data[CHECKLIST_KEY]

    if has_embedded:
        if not declared:
            return False, (
                f"{manifest_path} declares {EMBEDDED_ADAPTER} but is missing "
                f"evidence.{CHECKLIST_KEY}"
            )
        resolved = (manifest_path.parent / declared).resolve()
        if not resolved.is_file():
            return False, (
                f"{manifest_path} declares evidence.{CHECKLIST_KEY}={declared} "
                f"but {resolved} does not exist"
            )
        return True, f"{manifest_path}: embedded profile + checklist OK"

    if declared is not None:
        return False, (
            f"{manifest_path} does not declare {EMBEDDED_ADAPTER} but carries "
            f"evidence.{CHECKLIST_KEY}={declared}; the key must be "
            f"absent for non-embedded manifests"
        )
    return True, f"{manifest_path}: non-embedded, no checklist key"


def _main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        prog="python -m scripts.validators.governance_gates",
        description="Stand-alone governance gates (embedded-profile fail-closed gate).",
    )
    parser.add_argument(
        "--manifest",
        type=Path,
        required=True,
        help="Run the embedded-profile fail-closed gate on a single manifest.",
    )
    args = parser.parse_args(argv)

    passed, message = check_embedded_profile_gate(args.manifest)
    if not passed:
        print(message, file=sys.stderr)
        return 1
    # Per-manifest invocation is silent on success; the orchestrating
    # shell script emits a single aggregate [PASS] line after the loop.
    return 0


if __name__ == "__main__":
    sys.exit(_main(sys.argv[1:]))
