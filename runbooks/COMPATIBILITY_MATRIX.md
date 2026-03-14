# Compatibility Matrix

| Governance Version | Consumer Compatibility | Migration Required |
|--------------------|------------------------|--------------------|
| v0.2.x             | strict                 | Yes (add `boardReview` to manifest for strict baseline consumers) |
| v0.1.x             | strict                 | No                 |

## Rules

- Minor and patch versions are backward compatible unless explicitly declared otherwise.
- Major versions may require manifest and policy migration.
- Strict baseline consumers should keep `boardReview` enabled from v0.2.x onward.
