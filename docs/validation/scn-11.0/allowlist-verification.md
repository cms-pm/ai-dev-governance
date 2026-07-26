# SCN-11.0 — Consumer-Surface Allowlist Verification

Date: 2026-07-26
Branch under test: `SCN-11.0` @ `946b39c`
Purpose: convert pool question Q2 (consumer-branch allowlist) from a
reasoned resolution into a test-verified one, per
`core/PLANNING_METHODOLOGY.md` confidence rubric level 5, and to
adjudicate audit finding C-1.

Method: build the consumer surface twice — once with the allowlist as
originally written in Q2, once corrected — bootstrap a consumer from each,
and observe. Both directions were run; a single passing build would not be
evidence.

## Build results

| Build | Allowlist | Tracked files | `astaire` gitlink | `docs/governance/exceptions.yaml` |
|---|---|---|---|---|
| v0 | Q2 as authored | 253 | **absent** | **absent** |
| v1 | Q2 corrected (adds `astaire`, `docs/governance/exceptions.yaml`, `.rtk`, `CLAUDE.md`) | 257 | present | present |

Both builds excluded `docs/planning/`, `docs/releases/`, `docs/validation/`,
`docs/evidence/`, `.claude/`, `.claude-flow/`, `.swarm/`, `artifacts/` —
verified at zero files each.

## v1 (corrected) — PASS

Bootstrapped via `bootstrap_project.sh --new` from the built branch.
Astaire initialized successfully (`uv sync` resolved against
`${GOVERNANCE_MOUNT}/astaire`). `validate_bootstrap.sh` reported **14
`[PASS]` checks, exit 0**, including `Astaire submodule pinned to expected
SHA (ed16f6d)`.

### Negative control — planted violation

`.astaire/astaire` removed → **exit 1**, 3 failed checks:

```
[FAIL] .astaire/astaire does not exist
[FAIL] .astaire/astaire is not executable
[FAIL] .astaire/astaire wrapper missing or not executable
```

Control restored → **exit 0**. Two-directional discrimination confirmed:
the gate fails on the plant and passes on the control in the same
environment. This validates the SCN-11.4-05 antiProxy design as executable
rather than merely specified.

## v0 (as authored) — DEFECT CONFIRMED, AND NOT DETECTED

`astaire/` is unambiguously consumer-required. The Astaire wrapper written
by `bootstrap_project.sh:166` runs:

```
uv sync --project "${REPO_ROOT}/${GOVERNANCE_MOUNT}/astaire"
```

Without the gitlink there is no Astaire — the port-of-first-resort premise
does not function at all.

Observed on the v0 consumer:

- `bootstrap_project.sh` exited **0**. Astaire's failure
  (`error: No such file or directory`) was swallowed by the `|| true`
  guard on the startup call.
- `.governance/ai-dev-governance/astaire` does not exist.
- `.astaire/astaire status` exits **2** — the wrapper does correctly
  report failure to its caller.
- **`validate_bootstrap.sh` reported `Bootstrap validation passed`,
  exit 0.**

### Root cause of the non-detection (new finding)

`scripts/validate_bootstrap.sh:141-156` guards the tentacle-pin check on
`git -C "$GOVERNANCE_MOUNT/astaire" rev-parse --git-dir` succeeding. When
the submodule is absent the guard fails and the **entire check is skipped
with no output** — not a WARN, not a FAIL. Confirmed by differential
observation: the string `Astaire submodule pinned` appears **1** time on
the v1 consumer and **0** times on the v0 consumer.

The only residual signal is
`[WARN] .astaire/memory_palace.db not found`, which is non-blocking by
design (`:135-139`) and indistinguishable from a normal
not-yet-initialized consumer.

**A consumer whose Astaire submodule is entirely missing is certified
green by the consumer-side validator.** This is a silent-zero of the class
named in `core/HARNESS_METRICS.md`, in the validator that Phase 11 was
promoting to a blocking CI gate. Had Thread A landed on the v0 allowlist,
CI would have enforced a check that cannot see the defect it most needs to
catch.

Registered as **R-11-08**. Requires a fail-closed acceptance criterion in
Thread A: when `GOVERNANCE_MOUNT` is present, the tentacle path MUST exist
and the pin check MUST execute — a skipped pin check MUST be a FAIL, not
silence.

## Bearing on Q2 scoring

- The resolution's *method* (scripted allowlist) is confirmed correct and
  now executed end to end.
- The resolution's *content* as authored was defective, and the defect was
  load-bearing rather than cosmetic.
- The defect was **not** detectable by the oracle the plan relied on.
  Q2's residual uncertainty therefore does not fall to zero on a passing
  build: this exercise demonstrated that a passing
  `validate_bootstrap.sh` is insufficient evidence of allowlist
  completeness. `P` remains meaningful pending R-11-08.

Confidence for Q2 moves to **5** (verified by test, both directions).
`P` is held at `0.20` rather than reduced, because the verification
established that the instrument cannot certify completeness.

## Reproduction

```
git clone --no-hardlinks <repo> adg-src && cd adg-src && git checkout SCN-11.0
# apply allowlist, git rm -r --cached the complement, commit
bootstrap_project.sh --new <consumer> --governance-url <adg-src>
<consumer>/.governance/ai-dev-governance/scripts/validate_bootstrap.sh
```

Sandbox note: the nested `astaire` submodule URL was redirected to a local
checkout via `url.<local>.insteadOf`, and `protocol.file.allow=always` was
set for local-path submodule adds (required on git >= 2.38). This is the
same mechanism SCN-11.4's CI smoke job will need; its viability is
confirmed here.
