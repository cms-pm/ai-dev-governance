# SCN-10.12 CodeGraph Contract Visibility

Generated: 2026-05-24

## Scope

This validation covers the consumer-visible CodeGraph contract added after the
v1.1.1 MCP fragment fix. The goal is to make CG visible to:

- new consumers bootstrapping on ADG v1.1.0+
- existing consumers retrofitting from pre-CG releases
- consumers that remain non-CG and should not be forced into CG wiring
- consumers that partially declare CG and must fail closed

## Checks

- `bash -n scripts/bootstrap_project.sh` - pass.
- `bash -n scripts/validate_bootstrap.sh` - pass.
- Temporary non-CG consumer with `docs/governance/codegraph-contract.md` -
  `scripts/validate_bootstrap.sh` pass.
- Temporary partial-CG consumer with only `codegraphIndexFreshnessURI` -
  `scripts/validate_bootstrap.sh` fail as expected with incomplete declaration.
- Temporary retrofit consumer -
  `bootstrap_project.sh --retrofit --force` creates
  `docs/governance/codegraph-contract.md` and bootstrap evidence rows for
  CodeGraph contract presence and declaration state.
- `bash scripts/validate_governance.sh` - pass.
- `.astaire/astaire lint` - pass, 0 warnings, 0 errors after refresh.
- `git diff --check` - pass.

## Contract Shape

Bootstrap and retrofit create a non-overwriting project-local decision record:

```text
docs/governance/codegraph-contract.md
```

Non-CG consumers pass with the contract present and both CG evidence URIs
absent. CG-declared consumers must declare both
`codegraphIndexFreshnessURI` and `codegraphImageDigestURI`; partial
declarations fail before release evidence can treat CG as active.

The activation path remains strict Docker/container wrapper only. There is no
npm fallback in the consumer contract.
