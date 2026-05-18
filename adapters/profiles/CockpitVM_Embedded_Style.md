# CockpitVM Embedded Style

*Lineage: distilled from the Phase 8.2 evaluation memo at
`docs/planning/evaluations/p10-and-cockpitvm-style-eval.md`; agency-free
body text per memo §4.*

## Preamble

This profile is the authoritative project-owned C/C++ embedded style for
CockpitVM. It is **opt-in via the embedded profile**
(`adapters/profiles/EMBEDDED_PROFILE.md`): consumers that do not declare
the embedded profile in their governance manifest do not pick up the
embedded-specific gates defined here. This style **extends** the core
policy `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md` — specifically
its §Power of 10 Discipline (Universal) — and the Strict Baseline. It
does not replace either.

The keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and
**MAY** are normative throughout this document, interpreted per
RFC 2119. Power of 10 rule 9 (pointer use) is C/C++-specific and lives
here as its canonical home; the other Power of 10 rules are defined
universally in the core policy and cross-linked from §Determinism
Requirements below.

Code identifiers, namespaces, and example filenames in this document are
CockpitVM-owned (`cockpit::core::*`, `cockpit_public_api.h`, etc.).

## ABI Boundary

External module boundaries are unstable under C++ ABI; CockpitVM stays
deterministic by isolating C++ to translation units and presenting a
C-compatible public surface.

- **C linkage at public boundaries.** All public APIs MUST be declared
  with C linkage (`extern "C"`). C++ name mangling, vtable layout, and
  exception-table format vary across compilers and break the audit-once
  / link-anywhere property the embedded profile depends on.
- **POD-only across module boundaries.** Only Plain Old Data types MUST
  cross module boundaries. Non-POD types have compiler-specific layout
  and construction semantics and MUST NOT appear in `extern "C"`
  signatures.
- **Opaque handles for internal C++ state.** When a public API needs to
  refer to an internal C++ object, it MUST do so through an opaque
  handle (a forward-declared struct pointer in the C header). The
  internal C++ wrapper provides type safety on the implementation side.
- **Static placement, never heap.** Where C++ object lifecycle is
  needed, implementations MUST use placement-new into pre-allocated
  static buffers. Heap allocation post-init is forbidden — see
  §Determinism Requirements.

### Patterns

**POD wrapper.** Expose a C-compatible struct and wrap it internally
with a typed C++ accessor:

```c
extern "C" {
  typedef struct { uint32_t data; } cockpit_handle_t;
  int cockpit_api_call(cockpit_handle_t* handle);
}
```

**Opaque handle.** Pass internal C++ objects as opaque pointers:

```c
typedef struct cockpit_object* cockpit_handle;
cockpit_handle cockpit_create(void);
void cockpit_destroy(cockpit_handle h);
```

**Static placement.** Construct C++ objects into a fixed buffer:

```cpp
static uint8_t buffer[sizeof(Object) * COCKPIT_MAX_OBJECTS];
Object* obj = new (&buffer[i * sizeof(Object)]) Object();
```

## Allowed C++ Features

The following C++ features are allowed because each is either
compile-time only, zero runtime cost, or strictly bounds the runtime
footprint. Implementations MAY use them freely subject to the
constraints listed.

**Type system.**

- **Strong typing.** Compiler-enforced error detection at compile time.
- **`const` correctness.** Compiler-enforced immutability guarantees.
- **References (non-null, non-rebindable).** Safer than raw pointers
  with zero runtime cost.
- **Scoped enums (`enum class`).** Type-safe enumerations with no
  implicit conversion.

**Abstractions.**

- **Templates.** Compile-time polymorphism with zero runtime cost.
  Implementations MUST NOT let template instantiations exceed the
  per-binary size budget set by the project.
- **Inline functions.** Zero call overhead when the compiler honours
  the inlining hint. Implementations SHOULD verify inlining occurred
  on critical paths (e.g., by inspecting the disassembly or using
  `-Winline`).
- **CRTP (Curiously Recurring Template Pattern).** Static polymorphism
  without vtable indirection; replaces virtual dispatch.
- **`constexpr` functions.** Compile-time computation, no runtime cost.

**Organization.**

- **Namespaces.** Zero-cost code organization. CockpitVM code lives
  under `cockpit::*`.
- **Classes (data + methods).** Encapsulation without overhead.
  Implementations MUST NOT use virtual methods or inheritance other
  than CRTP.

**Resource management.**

- **RAII (Resource Acquisition Is Initialization).** Automatic cleanup,
  applied only to static resources (no heap acquisition).
- **Destructors.** Deterministic cleanup. Destructors MUST NOT be
  virtual and SHOULD be trivial or `constexpr`.

## Forbidden C++ Features

The following features are forbidden because each introduces runtime
non-determinism, unbounded resource use, or ABI instability across
toolchains.

**Runtime polymorphism.**

- **Virtual functions.** Vtable indirection adds 2–3 memory accesses
  per call with non-deterministic cache behaviour; vtable layout
  differs across compilers. **Alternative:** CRTP for static
  polymorphism.
- **Virtual destructors.** Imply a vtable and prevent trivial
  destruction. **Alternative:** non-virtual destructors with static
  lifetime management.
- **RTTI (`dynamic_cast`, `typeid`).** Runtime type-info metadata and
  code-size bloat. **Alternative:** compile-time type discrimination
  via templates.

**Dynamic features.**

- **Exceptions (`throw` / `try` / `catch`).** Non-local control flow
  and unbounded stack unwinding time; exception-table format varies
  across toolchains. **Alternative:** the `cockpit::core::Result<T, E>`
  pattern with explicit error propagation (see §Required Type-Safety
  Patterns).
- **Dynamic allocation (`new` / `delete`, `malloc` / `free`).**
  Non-deterministic allocation time, fragmentation, unbounded memory
  usage. **Alternative:** static allocation, placement-new into fixed
  buffers, fixed-size ring buffers.
- **STL dynamic containers (`std::vector`, `std::map`, …).** Hidden
  dynamic allocation and unbounded operations. **Alternative:** the
  fixed-size containers under §Required Type-Safety Patterns.
  **Exception:** `std::array` is allowed (zero-overhead wrapper).

**Complexity.**

- **Multiple inheritance.** Diamond-problem complexity and vtable
  ambiguity. **Alternative:** composition over inheritance.
- **Excessive operator overloading.** Obscures computational cost.
  Implementations MAY overload only zero-cost operators (`[]`, `->`,
  `*`).

## Determinism Requirements

Determinism requirements cross-link to the core §Power of 10 Discipline
(Universal) and elaborate the C/C++-specific consequences. The core
rules referenced below are normative; the elaborations here add
embedded-specific verification handles.

**Memory.**

- **All memory statically allocated at compile time** (elaborates core
  Power of 10 rule 3). Verification: link-time check for heap-symbol
  references (`malloc`, `_Znwm`, etc.).
- **Placement-new only, into pre-allocated static buffers.**
  Implementations MUST follow the `static buffer[…]; new (&buffer[i])
  Object();` pattern shown in §ABI Boundary.
- **No recursion, direct or indirect** (elaborates core Power of 10
  rule 1). Stack usage MUST be bounded and calculable. Verification:
  static analysis of the recursive call graph (e.g.,
  `-Wframe-larger-than=` plus an explicit call-graph audit).

**Timing.**

- **All loops MUST have compile-time or runtime bounds** (elaborates
  core Power of 10 rule 2):

  ```cpp
  for (size_t i = 0; i < COCKPIT_MAX_ITER && condition; ++i) { … }
  ```

  The unbounded form `while (condition) { … }` is forbidden.
- **Timeouts on every potentially blocking operation** (elaborates
  core Power of 10 rule 7):

  ```cpp
  uint32_t timeout = COCKPIT_MAX_WAIT_MS;
  while (!ready() && --timeout > 0) { /* poll */ }
  if (timeout == 0) return cockpit::core::Error::Timeout;
  ```

- **WCET (Worst Case Execution Time) MUST be calculable** on critical
  paths. Implementations SHOULD avoid data-dependent branches in
  critical paths; where unavoidable, WCET evidence MUST appear in the
  verification checklist below.

## Required Type-Safety Patterns

CockpitVM ships three deterministic type-safety patterns in the
`cockpit::core::` namespace. These replace the forbidden dynamic
features in §Forbidden C++ Features. Implementations MUST use these
patterns at module boundaries; they MAY use them internally.

### `cockpit::core::Result<T, E>`

Discriminated union of a success value or an error code. Replaces
exceptions.

```cpp
namespace cockpit::core {

template <typename T, typename E>
class Result {
  union { T value_; E error_; };
  bool is_ok_;
 public:
  static Result Ok(T val);
  static Result Err(E err);
  bool is_ok() const;
  T& value();    // precondition: is_ok()
  E& error();    // precondition: !is_ok()
};

}  // namespace cockpit::core
```

Usage:

```cpp
auto result = cockpit::core::divide(10, 2);
if (result.is_ok()) {
  cockpit::core::use(result.value());
} else {
  cockpit::core::handle(result.error());
}
```

### `cockpit::core::Span<T>`

Non-owning bounds-checked view into a contiguous sequence. Replaces
raw-pointer + size pairs at API boundaries.

```cpp
namespace cockpit::core {

template <typename T>
class Span {
  T* data_;
  size_t size_;
 public:
  Span(T* data, size_t size) : data_(data), size_(size) {}
  size_t size() const { return size_; }
  T& operator[](size_t i) { assert(i < size_); return data_[i]; }
};

}  // namespace cockpit::core
```

### `cockpit::core::RingBuffer<T, N>`

Fixed-capacity circular buffer with compile-time size. Replaces
`std::queue` / `std::deque`.

- Compile-time-known memory usage: `sizeof(T) * N`.
- Constant-time push / pop operations.
- Predictable failure modes (buffer full, buffer empty).

## Pointer-Use Rule (Power of 10 #9)

This rule lives only in this profile; it MUST NOT appear in the core
policy. CockpitVM C/C++ code MUST observe the following pointer
discipline:

- **At most one level of dereference.** Implementations MUST NOT
  dereference pointers more than one level deep in a single
  expression. Chained dereferences obscure data flow and frustrate
  static-analysis path enumeration. Where the data structure inherently
  requires deeper indirection, the implementation MUST introduce named
  intermediate variables so that each dereference is auditable on its
  own line.
- **No function pointers.** Function pointers defeat the static
  call-graph analysis that the embedded profile depends on for stack
  and WCET bounds. **Alternatives:**
  - **CRTP** for static polymorphism (compile-time dispatch).
  - **Tagged-union dispatch** for runtime selection from a closed,
    statically-known set of behaviours.
- Forbidden constructs include arrays of function pointers, callback
  registration tables resolved at runtime, and pointer-to-member
  function dispatch.

## Verification Checklist

The fail-closed release gate added in SCN-8.2.4 consumes this
checklist. Every item below MUST be produced as evidence on every
release of a project that declares the embedded profile.

**Compile time.**

- No virtual function tables in the binary.
- No exception tables (no `.eh_frame` / DWARF unwind sections from
  CockpitVM-owned translation units).
- No RTTI metadata symbols.
- Template instantiations stay within the per-binary size budget.

**Link time.**

- No `malloc` / `free` / `_Znwm` / `_ZdlPv` symbols resolved from
  CockpitVM-owned objects.
- No `throw` / `catch` unwind symbols.
- Stack usage within the project-declared bound
  (`--print-stack-usage` evidence retained).

**Runtime.**

- WCET analysis recorded for every critical path.
- Stack high-water mark profiling completed on representative
  workloads.
- Error-path code coverage meets the project-declared minimum.

## Tooling Integration

The analyzer floor declared here is the C/C++-specific elaboration of
the analyzer floor in `core/CODE_IMPLEMENTATION_COMPLEXITY_GOVERNANCE.md`
§Required Validation Evidence (rule 10 amendment). The analyzer choice
itself is declared in the governance manifest; this profile requires
the capabilities below regardless of which analyzer is named.

**Static analyzers — capability floor.**

- Must detect recursion (direct and indirect) — core Power of 10 rule 1.
- Must detect unbounded loops — core Power of 10 rule 2.
- Must detect dynamic allocation after init — core Power of 10 rule 3.
- Must detect unchecked return values / unvalidated parameters — core
  Power of 10 rule 7.
- Must detect uses of `virtual`, `throw`, `try`, `catch`, and missing
  `extern "C"` on declared public functions.
- Bounds-check coverage on indexable types (e.g., the analyzer SHOULD
  surface findings analogous to `cppcoreguidelines-pro-bounds-*` and
  `cppcoreguidelines-no-malloc`).

**Required build flags.**

```text
-fno-exceptions
-fno-rtti
-fno-threadsafe-statics
-fstack-usage
```

**Recommended build flags.**

```text
-Wall -Wextra -Werror
-Wconversion
-Wno-virtual-dtor
```

## Header / Implementation Organization

Public surface lives in C-linkage headers; C++ internals are visible
only to C++ translation units.

**Header (`cockpit_public_api.h`).**

```c
#ifdef __cplusplus
extern "C" {
#endif

/* C-compatible POD types */
typedef struct { /* … */ } cockpit_public_data_t;

/* C-compatible functions */
int cockpit_public_init(const cockpit_public_data_t* config);

#ifdef __cplusplus
}
#endif

/* C++ internals — only visible to C++ translation units */
#ifdef __cplusplus
namespace cockpit::internal {
  template <typename T> class TypeSafeWrapper { /* … */ };
}
#endif
```

**Implementation (`cockpit_public_api.cpp`).**

```cpp
#include "cockpit_public_api.h"

namespace cockpit::internal {
  // C++ implementation with full type safety
}

extern "C" {
  int cockpit_public_init(const cockpit_public_data_t* config) {
    return cockpit::internal::init_impl(config);
  }
}
```

## Sources

```bibtex
@article{10.1109/MC.2006.212,
  author    = {Holzmann, Gerard J.},
  title     = {The Power of 10: Rules for Developing Safety-Critical Code},
  journal   = {Computer},
  volume    = {39},
  number    = {6},
  pages     = {95--97},
  year      = {2006},
  month     = jun,
  publisher = {IEEE Computer Society Press},
  issn      = {0018-9162},
  doi       = {10.1109/MC.2006.212},
  url       = {https://doi.org/10.1109/MC.2006.212}
}
```
