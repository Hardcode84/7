# wavec

A C99 frontend for the Wave kernel language. It is a second producer of
`wave`-dialect MLIR (the C analog of `python/mlir/dialects/wave_dsl.py`):
bytes -> arena AST -> type-checked AST -> textual Wave IR, reusing the
existing backend (`wave-opt` / `wave-translate`) unchanged.

The language and lowering are specified in
[`../docs/CFrontendDesign.md`](../docs/CFrontendDesign.md); the v1 grammar
(EBNF) is [`../docs/CFrontendGrammar.md`](../docs/CFrontendGrammar.md).
This README covers only how to build, test, and what the frontend does vs
refuses today.

Uniformity is declared in the types (`float a` uniform -> SGPR,
`simd<float,32> xv` lane-varying -> VGPR, `mask<32>` a lane mask), never
inferred, so the frontend is type-directed lowering, not whole-program
divergence/alias analysis.

## Build

`wavec` is part of the main wave-mlir build. The C front
(lexer/parser/sema) links only libc; the lowering bridge links the in-tree
Wave CAPI and MLIR CAPI targets.

```sh
cmake --build build --target wavec
```

Build flags for the whole front are strict and non-negotiable:
`-std=c99 -pedantic -Werror -Wall -Wextra`. No GNU/clang extensions; the
front is portable to any conforming C99 compiler.

The bridge uses CMake targets, not archive globs: `WaveCAPI`,
`MLIRCAPIIR`, `MLIRCAPIArith`, `MLIRCAPIFunc`, and `MLIRCAPISCF`.

## Targets and stage layout

| Target | Language | Links | Role |
|---|---|---|---|
| `wavefront` (static lib) | C99 | libc only | lexer + parser + sema + astdump + diag + arena. No MLIR. |
| `wavefront_lower` (static lib) | C++17 | MLIR CAPI + WaveCAPI | the ONLY C++/MLIR component: AST -> Wave IR via the generic `mlirOperationCreate` API. |
| `wavec` (exe) | C (links C++ bridge) | `wavefront` + `wavefront_lower` | driver: file -> lex -> parse -> sema -> lower -> textual IR. |
| `wavec_arena_test` / `wavec_lex_test` / `wavec_parse_test` / `wavec_sema_test` | C99 | `wavefront` | per-stage unit tests, each at its own interface. |
| `wavec_lower_test` (exe) | C++17 | `wavefront_lower` | lowering-stage test: hand-built ASTs -> IR, independent of the parser. |

Source map:

```
include/        public headers: arena, diag, token, lex, parse, ast,
                astdump, sema, lower
src/arena.c     page-aligned (4 KiB) bump arena. The ONLY malloc/free in
                the front; everything else bump-allocates and frees the
                arena wholesale.
src/diag.c      diagnostics list (arena-backed, severity + source span)
src/lex.c       byte buffer -> token array (no realloc; arena-backed)
src/parse.c     bounded recursive-descent parser -> arena AST
src/sema.c      type checker (Type Rules): accept/reject + diagnostics
src/astdump.c   AST -> text (used by parse_test to assert AST shape)
src/lower.cpp   AST -> Wave IR (the C++ bridge); renders module to text
src/wavec.c     driver / entry point (the only file I/O in the project)
test/golden/saxpy.wave   the worked end-to-end example
```

The front honors the implementation rules in the design: no global state
(arenas, symbol table, depth counter, MLIR context all thread through
explicit context structs), arena allocation only, bounded recursion
(explicit depth cap in both parser and lowerer), ASCII only, no
OS-specific calls outside the entry point.

## Running the tests

All stage tests plus the golden lowering check run under ctest:

```sh
cmake --build build --target check-wavec
```

Each stage is tested at its OWN interface, not only end-to-end:

- `arena_test` -- allocator behavior (alignment, bump, exhaustion).
- `lex_test` -- source -> token-kind stream; asserts the exact token
  sequence.
- `parse_test` -- source -> AST; asserts the dumped AST text
  (`astdump`) exactly.
- `sema_test` -- AST -> accept/reject; asserts acceptance and specific
  rejection diagnostics (e.g. mask-in-`if`, width mismatch, `shared`
  non-pointer).
- `wavec.lower_goldens` (drives `wavec_lower_test`) -- builds each golden's AST by
  hand, lowers it, normalizes both the output and the checked-in golden
  through `wave-opt` (SSA-name normalization), and requires structural
  equality. It also runs the built-in overfit probe (a permuted saxpy
  AST must NOT reproduce the canned golden).
- `wavec.e2e` -- runs the `wavec` driver on real `.wave` files, round-trips
  good outputs through `wave-opt`, FileChecks selected cases, and checks
  rejection diagnostics for bad inputs.

Run a single stage test directly, e.g.:

```sh
build/wavec/wavec_sema_test
build/wavec/wavec_lower_test saxpy        # prints the saxpy IR
build/wavec/wavec_lower_test --swap       # the overfit-probe variant
```

### End-to-end golden (the driver on real source)

`lower_test` feeds a hand-built AST; the driver exercises the full
pipeline (file -> lex -> parse -> sema -> lower):

```sh
build/bin/wavec wavec/test/golden/saxpy.wave > /tmp/mine.mlir
build/bin/wave-opt /tmp/mine.mlir > /tmp/mine.norm
build/bin/wave-opt wavec/test/golden/mlir/saxpy.mlir > /tmp/gold.norm
diff /tmp/gold.norm /tmp/mine.norm
```

This diff is NOT byte-empty, by design, and that is correct, not a bug:
the golden (generated by `saxpy_gen.py`) hoists the per-lane addresses
`x+i` / `y+i` into locals before the predicated region and CSEs `y+i` so
the store reuses the load's pointer. The surface type `simd<float*,W>` is
not declarable, so `saxpy.wave` spells `x+i` / `y+i` inline; faithful
non-CSE lowering therefore emits the `ptr_add`s inside the `where`. The
two are semantically identical -- the delta is exactly the hoist + CSE the
backend does and the frontend must never do. Concretely:

- `wave-opt --canonicalize --cse` on the frontend output collapses the
  redundant store-pointer `ptr_add` (CSE), leaving ONLY the placement of
  two side-effect-free, region-invariant `ptr_add`s: just inside the
  `where` (frontend) vs just above it (golden).
- That remaining delta is loop-invariant code motion OUT of the `where`.
  `wave.where` is lane predication, not a loop, so it is correctly not a
  `LoopLikeOpInterface`; `--loop-invariant-code-motion` does not (and must
  not) hoist out of it. The golden's hoist was a source-authoring choice
  in the generator, reproduced here by declaring the addresses as locals.

The byte-exact "must match" is asserted by the lowering conformance test
on the hoisted AST: `wavec_lower_test saxpy` through `wave-opt` is
byte-identical to `wavec/test/golden/mlir/saxpy.mlir` through `wave-opt`
(this is what `wavec.lower_goldens` checks).

## Overfit probe

The frontend must DERIVE IR from structure + types, never recognize a
known input and emit a canned result. Two probes confirm this; both run
the full driver on perturbed `saxpy` source.

1. Rename-invariance (same program, every identifier renamed:
   `x/y/a/n/lane/wave/i/active/xv/yv` -> `aa/bb/scale/cnt/ll/ww/idx/m/p/q`).
   The normalized IR is BYTE-IDENTICAL to the original. Names are not
   load-bearing.
2. Swap-sensitivity (semantically different program: load `y` then `x`,
   compute `a*yv + xv`, store to `y`). The normalized IR DIFFERS from the
   original in exactly the expected place -- the `ptr_add` base operands
   flip (`%arg0`/`%arg1` swap order) -- and does NOT equal the golden. The
   frontend tracks the actual program, not a template.

The in-tree `lower_goldens` test runs the equivalent AST-level swap probe
(`lower_test --swap`) and fails the build if the swapped variant ever
reproduces the golden.

## Support matrix

What the v1 frontend lowers end-to-end (each verified through `wave-opt`):

| Construct | Lowers to | Status |
|---|---|---|
| `kernel [[amdgpu_wave_size(N)]] void f(...)` | `func.func` + `wave.kernel` | yes |
| `[[amdgpu_lds_size(N)]]` | `wave.lds_size` attr | yes |
| `[[amdgpu_waves_per_workgroup(N)]]` | `wave.waves_per_workgroup`, `wave.workgroup_size`, `gpu.known_block_size` | yes |
| `[[amdgpu_workgroup_size(N)]]` | `wave.workgroup_size`, `gpu.known_block_size` | yes |
| scalar params `bool/half/float/index/int*_t/uint*_t`, `T*`, `shared T*` | `f32`/`i32`/`index`/`!wave.ptr<#global\|#shared, T>` | yes |
| `simd<T,W>` / `mask<W>` / `vector<T,N>` / `fragment<role,T,M,N,W,R>` | `!wave.simd` / `!wave.mask` / `vector<NxT>` / `!waveamd.fragment` | yes |
| arithmetic: int `+ - * / % << >> & \| ^`; simd-float `+ - *`; scalar-float `+ - * /` (scalar broadcast) | `wave.binary`, `wave.f{add,sub,mul}`, `arith.{addf,subf,mulf,divf}`, `wave.splat` | yes |
| compare `< <= > >= == !=` | simd -> `wave.cmpi` -> `mask`; scalar -> `arith.cmpi` -> i1 (signed/unsigned from int type) | yes |
| compound assign `+= -= *= ...` | desugar to op + rebind local | yes |
| pointer `+` offset | `wave.ptr_add` (uniform ptr or simd-of-ptr base) | yes |
| `lane_id<W>()` / `subgroup_id()` / `workgroup_id<ax>()` / `workitem_id<ax>()` / `read_first(x)` | `wave.lane_id` / `wave.subgroup_id` / `wave.workgroup_id` / `wave.workitem_id` / `wave.read_first` | yes |
| `load(p [after t])` (value, or `auto [v,t]` destructure) | `wave.load` -> (simd, token); scalar and vector payloads | yes |
| `store(v, p [after t])` | `wave.store` (value-first `$v -> $p`) -> token; scalar and vector payloads | yes |
| `barrier(t...)` / `join(t...)` / `wait(t...)` / `token()` | `wave.barrier` / `join` / `wait` / `token` | yes |
| `lds_base<T>([K])` | `wave.lds_base {offset=K}` : `shared T*` | yes |
| `index_cast(x)` | `arith.index_cast` / `arith.index_castui` | yes |
| `cast<T>(x)` (fp<->fp, int<->int, int<->fp) with verifier policies | `wave.cast {kind[, policy]}` | yes |
| `fragment_fill<T>(bits)` / `fragment_pack<T>(regs)` / `fragment_unpack(frag)` | `waveamd.fragment_fill` / `waveamd.fragment_pack` / `waveamd.fragment_unpack` | yes |
| `mma_wmma_*` / `mma_mfma_*` explicit builtins | `waveamd.mma` with frontend-selected kind attr | yes |
| fragment load/store sugar | source macros over `load`/`store` + `fragment_pack`/`fragment_unpack` | yes |
| `where (m) {...} [otherwise {...}]`, incl. result-carrying | `wave.where` (+ synthesized `otherwise` yielding carried-in for then-only carries) | yes |
| `if (c) {...} [else {...}]` (uniform bool), incl. result-carrying | `scf.if` | yes |
| `for <iv> i in lb..ub [step s] {...}`, mutable-local carries | `scf.for` with `iter_args` (SSA construction) | yes |

Honestly NOT supported in v1 (each returns a clear error, never a fake):

| Construct | Where it errors | Message |
|---|---|---|
| `while (c) {...}` | lowering | `lowering: while loops not supported` (parsed + type-checked; lowering refuses -- out of v1 scope) |
| unary `- ! ~` | lowering | `lowering: unary operators not supported` (parsed; no lowering yet) |
| simd-float `/` | lowering | `lowering: unsupported float operator` |
| `reduce`/`ballot`/`any` | sema | not a known builtin |
| user (non-`kernel`) functions, value-returning kernels, arrays/subscript, deref/address-of, `?:` | parse | parse error (not in the v1 grammar) |

Type-rule violations are rejected by sema with a precise diagnostic and
zero output, e.g.:

- `mask<W>` in `if` / `bool` in `where` -> herded to the right construct.
- `simd<T,W>` / `mask<W>` / `lane_id<W>` width != the kernel wave size.
- `shared` on a non-pointer.
- implicit `bool` <-> sized-int initialization.
- `[[amdgpu_wave_size(N)]]` with N not 32 or 64, or `vector<T,N>` with N == 0
  or absurdly large (these previously aborted the process; now clean errors).

## Notes / known follow-ups

- The end-to-end `saxpy.wave` output is the structural golden minus the
  generator's manual hoist + the backend's CSE (documented above); byte
  equality is asserted on the hoisted-AST lowering path.
- `while`, unary operators, and reduction/ballot helpers remain open growth
  items. They error honestly today.
- v0 emits textual IR piped to `wave-opt`. The in-memory C-API switch and
  `wave-translate --wave-to-amdgpu-asm` end-to-end run are future work.
