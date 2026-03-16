# Compatibility Matrix

| Governance Version | Consumer Compatibility | Migration Required |
|--------------------|------------------------|--------------------|
| v0.4.x             | strict                 | Yes (adopt chunk-scope CI gate and atomic SCN scope policy) |
| v0.3.x             | strict                 | Yes (add `automation`, `boardReview.selection`, and `boardReview.composition` in strict baseline manifests) |
| v0.2.x             | strict                 | Yes (add `boardReview` to manifest for strict baseline consumers) |
| v0.1.x             | strict                 | No                 |

## Rules

- Minor and patch versions are backward compatible unless explicitly declared otherwise.
- Major versions may require manifest and policy migration.
- Strict baseline consumers should keep board review and automation controls enabled from v0.3.x onward and enforce chunk-scope validation from v0.4.x onward.
