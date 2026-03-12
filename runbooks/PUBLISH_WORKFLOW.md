# Publish Workflow (Private GitHub)

## Prerequisites

- GitHub org exists
- Private repository name: `ai-dev-governance`
- Maintainer access for release owners

## Initial Publish

```bash
cd .claude/methodology
git remote add origin <PRIVATE_GIT_URL>/ai-dev-governance.git
git push -u origin main
git tag -a v0.1.0 -m "Initial governance baseline"
git push origin v0.1.0
```

## Post-Publish Hardening

1. Enable branch protection on `main`
2. Require PR and status checks
3. Require CODEOWNERS review
4. Restrict tag/release creation to maintainers

## Release Cadence

- Scheduled governance updates monthly or quarterly
- Consumers bump to pinned tag only
