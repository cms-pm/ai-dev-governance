# Submodule Consumer Runbook

## Add as Submodule

```bash
git submodule add <PRIVATE_GIT_URL>/ai-dev-governance.git .governance/ai-dev-governance
git submodule update --init --recursive
```

## Pin to Release Tag

```bash
cd .governance/ai-dev-governance
git fetch --tags
git checkout v0.2.0
cd -
git add .governance/ai-dev-governance
git commit -m "Pin governance submodule to v0.2.0"
```

## Scheduled Bump

```bash
cd .governance/ai-dev-governance
git fetch --tags
git checkout <NEW_TAG>
cd -
git add .governance/ai-dev-governance
git commit -m "Bump governance submodule to <NEW_TAG>"
```

## Detached HEAD Recovery

```bash
cd .governance/ai-dev-governance
git checkout main
git pull --ff-only
```

## Rollback

```bash
git checkout <PREVIOUS_COMMIT_SHA> -- .governance/ai-dev-governance
git commit -m "Rollback governance submodule pin"
```

## Consumer Requirements

- Pin to tags, never track remote branches.
- Review changelog and migration notes before every bump.
- Use monthly or quarterly cadence from governance manifest.
- Configure `boardReview` in governance manifest for strict baseline use.
- Adopt board templates from `templates/` for packet, meeting, and opportunity reports.
