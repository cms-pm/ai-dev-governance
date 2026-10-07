# Contributing

ADG governs its own development, so contributions follow the same process
it prescribes for consumer repos.

## Before you open a pull request

1. Open an issue describing the problem or proposal. Policy changes
   (anything under `core/`, `contracts/` or `runbooks/`) need discussion
   before code.
2. Work on a branch; `main` is protected (`core/GIT_BRANCH_STRATEGY.md`).
3. Write a short summary line plus validation bullets in the commit body,
   matching the existing history (`fix:`, `feat:`, `docs:`, `chore:`,
   `SCN-x.y:`).

## Checks

```bash
scripts/validate_governance.sh          # must pass; CI runs it on every PR
scripts/validate_astaire_wiring.sh --root .
```

If you change a validator, add or update a fixture under `validation/` that
proves the failure path, not only the passing one.

## Planning artifacts

Phased work is planned in SCN chunks under `docs/planning/`
(`core/PLANNING_METHODOLOGY.md`). Small fixes do not need a chunk plan.

## License

By contributing you agree that your contribution is licensed under the
MIT License in `LICENSE`.
