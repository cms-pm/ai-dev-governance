# Embedded Verification Checklist — Production Fixture

This fixture artifact stands in for a real release-evidence document.
Consumers project this template into their release evidence root and
record concrete results against each item from
`adapters/profiles/CockpitVM_Embedded_Style.md` §Verification Checklist.

## Compile time

- [ ] No virtual function tables present in the binary.
- [ ] No exception tables (`.eh_frame` / DWARF unwind) from
      project-owned translation units.
- [ ] No RTTI metadata symbols.
- [ ] Template instantiation count within the per-binary budget.

## Link time

- [ ] No `malloc` / `free` / `_Znwm` / `_ZdlPv` symbols resolved from
      project-owned objects.
- [ ] No `throw` / `catch` unwind symbols.
- [ ] Stack usage within the project-declared bound; `--print-stack-usage`
      output retained.

## Runtime

- [ ] WCET analysis recorded for every critical path.
- [ ] Stack high-water-mark profile completed on representative workloads.
- [ ] Error-path code coverage meets the project-declared minimum.
