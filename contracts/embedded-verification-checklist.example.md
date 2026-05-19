# Embedded Verification Checklist — Example

Illustrative artifact that the example manifest's
`evidence.embeddedVerificationChecklistPath` resolves to. Consumer
projects copy this template into their evidence root and record concrete
results against each item from
`adapters/profiles/CockpitVM_Embedded_Style.md` §Verification Checklist.

## Compile time
- [ ] No virtual function tables in the binary.
- [ ] No exception tables from project-owned translation units.
- [ ] No RTTI metadata symbols.
- [ ] Template instantiations within the per-binary budget.

## Link time
- [ ] No dynamic-allocation symbols from project-owned objects.
- [ ] No `throw` / `catch` unwind symbols.
- [ ] Stack usage within the project-declared bound.

## Runtime
- [ ] WCET analysis recorded for every critical path.
- [ ] Stack high-water mark profile complete.
- [ ] Error-path code coverage meets the project-declared minimum.
