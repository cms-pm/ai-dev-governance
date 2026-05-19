# Embedded Systems Profile

## Purpose

Optional overlay for embedded and hardware-coupled projects.

## Opt-in declaration

This profile is **opt-in**: it applies only to projects whose governance
manifest lists `profiles/embedded` under `adapters`. Consumers that do
not declare the embedded profile do not pick up the embedded-specific
gates defined here or in `CockpitVM_Embedded_Style.md`.

## Additional Controls

- Hardware-in-loop validation required for timing-critical and I/O-bound acceptance criteria.
- Thermal and power validation requirements must be explicit in acceptance checks.
- Deterministic timing thresholds must include jitter bounds.
- Fallback behavior under resource pressure must be specified and tested.

## Required Style

Projects declaring this profile MUST adopt
`adapters/profiles/CockpitVM_Embedded_Style.md` in full. The style guide
is the authoritative project-owned C/C++ embedded discipline. Its
§Determinism Requirements, §Required Type-Safety Patterns, §Pointer-Use
Rule, §Verification Checklist, and §Tooling Integration sections are
normative for any C/C++ translation unit owned by an embedded-profile
project.

## Fail-Closed Release Gate

Every release of an embedded-profile project MUST carry verification
evidence covering the CockpitVM Embedded Style §Verification Checklist
(compile, link, and runtime items). The governance manifest MUST declare
the evidence location under the key
`evidence.embeddedVerificationChecklistPath`. The path MUST resolve to a
file under the project's evidence root. Absence of the key, or absence
of the referenced file, fails the release gate.

`validation/CONSISTENCY_RULES.md` Contract Rules §14 declares the gate;
`scripts/validate_governance.sh` enforces it across every governance
manifest in the source repository and its fixture suite.

## Notes

This profile extends core policy and strict baseline. It does not replace them.
