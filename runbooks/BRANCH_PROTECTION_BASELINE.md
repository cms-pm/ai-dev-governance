# Branch Protection Baseline

## Required Settings

- Protect `main` from direct push
- Require pull request before merge
- Require status checks to pass before merge
- Require at least one approving review (two for strict critical paths)
- Require CODEOWNERS review
- Dismiss stale approvals on new commits

## Required Checks

- governance-consistency
- chunk-scope
- markdown-link-check
- schema-validation

## Release Permissions

- Only maintainers can create tags/releases
- Releases must reference validated commit on `main`
