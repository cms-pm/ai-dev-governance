#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Usage: scripts/prepare_release_branch.sh [--apply]

Prepare the governance source repo for a consumer-facing release branch by
removing self-hosted project delivery artifacts and restoring neutral baseline
placeholders.

With no flags, prints the paths that will be scrubbed.
With --apply, performs the scrub in-place.
EOF
}

SCRUB_PATHS=(
  "docs/planning"
  "docs/releases"
  "docs/validation"
  "raw"
  "graphify-out"
  "docs/governance/exceptions.yaml"
)

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" != "--apply" && "${1:-}" != "" ]]; then
  usage >&2
  exit 2
fi

echo "Release-branch scrub set:"
for path in "${SCRUB_PATHS[@]}"; do
  echo " - $path"
done

if [[ "${1:-}" != "--apply" ]]; then
  echo
  echo "Dry run only. Re-run with --apply to scrub the release branch."
  exit 0
fi

for path in "${SCRUB_PATHS[@]}"; do
  if [[ -e "$path" ]]; then
    rm -rf "$path"
  fi
done

mkdir -p docs/governance/amendments docs/governance/board docs

cat > docs/README.md <<'EOF'
# Docs

This release branch intentionally excludes the source repository's own planning,
validation, and release-history artifacts.

Consumers should create project-local directories such as:

- `docs/planning/`
- `docs/releases/`
- `docs/validation/`
- `docs/governance/board/`
- `docs/governance/amendments/`

Use the shared templates and runbooks in this repository to populate those
folders inside the consuming project, not inside the governance submodule.
EOF

cat > docs/governance/amendments/README.md <<'EOF'
# Governance Amendments

This directory is intentionally empty in the shared release branch.

Consumers may create project-local amendments in their own repository at
`docs/governance/amendments/` when stricter local constraints are needed.

Use `templates/GOVERNANCE_AMENDMENTS_README_TEMPLATE.md` as the starting point.
EOF

cat > docs/governance/board/README.md <<'EOF'
# Board Artifacts

This shared release branch does not ship source-repo-specific board rosters,
packets, or approvals.

Consumers should keep project-local board composition, approvals, packets, and
meeting records in their own repository under `docs/governance/board/`.
EOF

cat > docs/governance/board/board-composition.yaml <<'EOF'
status: placeholder
note: |
  Consumers should replace this file with their own project-local board
  composition record in the product repository, not inside the governance
  submodule.
EOF

cat > docs/governance/board/board-composition-approval.md <<'EOF'
# Board Composition Approval

Placeholder only.

Consumers should keep their real board composition approval record in the
product repository under `docs/governance/board/`.
EOF

cat > docs/governance/exceptions.yaml <<'EOF'
exceptions: []
EOF

echo "Release branch scrub complete."
