# Devil's Advocate Review — SCN-10.x Phase 10 Chunks and Tests

- Cadence lane: `Accountability Review`
- Board lens emphasis: `test-design`
- Yardstick: ADG test core compliance, interpreted through the board's
  existing evidence rules, fail-closed posture, repeatability, isolation,
  diagnostic clarity, and inspectable artifact requirements.

This review is deliberately adversarial. It asks, for each chunk/test:
what could still be wrong, what would fail if the current evidence were
too optimistic, and whether the artifact set is strong enough to meet the
repo's own compliance bar.

## Compliance Yardstick

The review uses these ADG test-core questions:

1. Is the evidence inspectable and reproducible from the recorded artifact?
2. Does the test fail closed instead of passing by accident?
3. Is the test isolated from hidden environment coupling?
4. Does the failure mode point to the exact missing control?
5. Does the result stay stable across repeated runs?
6. Does the artifact set match the board's stated acceptance criteria?

## Chunk Review

| Chunk | Devil's Advocate Observation | ADG Test Core Compliance Check | Verdict |
|---|---|---|---|
| SCN-10.0 | Bootstrap artifacts are mostly administrative; the main risk is that the signoff/traceability scaffolding could drift before the real work lands. | Pass: the planning artifacts are explicit and traceable, but they depend on later chunks for substantive evidence. | Compliant with a monitoring note |
| SCN-10.1 | Core policy is foundational, so any ambiguity in the doctrine would contaminate every later chunk. | Pass: the evidence URIs and optional-capability language are directly referenced, and the intent is inspectable. | Compliant |
| SCN-10.2 | The initial Makefile shape was over-optimized for multi-platform attestations and could not run in the local docker-driver path. | Pass after correction: the host-platform default now runs twice with the same digest; attestations remain opt-in. | Compliant, with an explicit environment-scope caveat |
| SCN-10.3 | A wrapper can look hardened on paper while still leaking host coupling through runtime selection or mount semantics. | Pass: the wrapper evidence explicitly shows runtime detection, `--network=none`, `CapDrop=["ALL"]`, and a failing outbound-fetch probe. | Compliant |
| SCN-10.4 | Templates are easy to hand-wave as “done” while leaving the consumer story incomplete. | Pass: the fragment set covers the wrapper, ignore policy, Claude guidance, settings, and Plan B fallback. | Compliant |
| SCN-10.5 | Adapter specs can drift into prose without proving they are actually aligned with the source-of-truth policy. | Pass: both adapter docs point at the same core doctrine and the prompt addendum is byte-identical. | Compliant |
| SCN-10.6 | Removal work can be incomplete if legacy paths survive in docs or manifests. | Pass: the Graphify submodule, scripts, fixtures, and manifest references are removed. | Compliant |
| SCN-10.7 | A validator can be green on the happy path while missing a failure-path regression. | Pass: the positive fixture and negative fixtures cover the expected fail-closed shape. | Compliant |
| SCN-10.8 | Denylist checks are often the easiest place for a hole to slip through, especially on raw command/arg/env inspection. | Pass: the matrix explicitly covers each forbidden pattern, including raw `npx codegraph`. | Compliant |
| SCN-10.9 | Release gates can become ceremonial if they do not actually connect to a live evidence contract. | Pass: the release process now names the CG URIs and the CockpitVM pilot capture format. | Compliant |
| SCN-10.10 | Board closeout can overstate completion if it treats ratification as proof instead of a summary of evidence. | Pass, but only because the closeout now references the actual green SCN-10.2 build result and the exact monitor-lane dispositions. | Compliant with board-level caution |

## Test Review

| Test / Evidence Slice | Devil's Advocate Observation | ADG Test Core Compliance Check | Verdict |
|---|---|---|---|
| SCN-10.2 reproducible digest | The first attempt was environment-blocked, so the test only became meaningful after the fallback was made explicit. | Pass: the evidence now shows two identical runs with a stable digest and emitted SBOM file. | Green |
| SCN-10.2 Docker inspect | Static declaration alone is weak unless the runtime posture is separately checked. | Pass: the doc records `USER 10001:10001` and the empty capability posture. | Green |
| SCN-10.3 wrapper static check | A static wrapper check is insufficient if the runtime flag set is not actually exercised. | Pass: static evidence is paired with live `docker inspect` output and a network-failure probe. | Green |
| SCN-10.7 consumer validator | A consumer validator must fail on missing wiring, not just succeed on a clean fixture. | Pass: positive and negative fixture coverage exists, including missing digest and missing SBOM. | Green |
| SCN-10.8 denylist matrix | Denylists are only convincing if each entry has a distinct non-zero failure and diagnostic. | Pass: each denylisted flag is mapped to a specific fixture and expected message. | Green |
| SCN-10.9 release gate | A release gate is weak unless it is clearly scoped to the consumer that declares the capability. | Pass: the gate is consumer-scoped and non-CG releases remain on the standard path. | Green |

## Findings

| ID | Severity | Finding | Disposition |
|---|---|---|---|
| FND-DA-001 | Low | SCN-10.2 required an environment correction before it became a trustworthy reproducibility proof. | Accepted; the corrected test is now green and documented as the canonical path. |
| FND-DA-002 | Low | SCN-10.10 ratification should not be read as proof of all future CG adoption risks. | Accepted; monitor-lane items remain explicit. |

## Summary

No open critical findings were identified in the devil's-advocate pass.
The main caution is that SCN-10.2 is now explicitly a host-platform
verification path with opt-in attested multi-platform mode, so future
board readers should not assume the attested path is the default local
verification mode.
