# Embedded Verification Checklist — MVP Fixture

Stub fixture artifact for the MVP profile's
`evidence.embeddedVerificationChecklistPath`. Mirrors the section
structure of `adapters/profiles/CockpitVM_Embedded_Style.md`
§Verification Checklist.

## Compile time
- [ ] vtables absent.
- [ ] eh_frame / DWARF unwind absent.
- [ ] RTTI metadata absent.

## Link time
- [ ] No dynamic-allocation symbols.
- [ ] No exception unwind symbols.
- [ ] Stack usage within declared bound.

## Runtime
- [ ] WCET recorded for critical paths.
- [ ] Stack high-water mark profiled.
- [ ] Error-path coverage above declared minimum.
