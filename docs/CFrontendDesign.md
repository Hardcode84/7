# A C-family frontend for wave-mlir

A small explicit-wave kernel language, authored in C-family syntax,
lowering to the existing `wave` dialect and reusing the backend unchanged.
It is the C analog of `python/mlir/dialects/wave_dsl.py`. It is tractable
because the usual hard GPU-frontend problem -- deciding SGPR-uniform vs
VGPR-lane-varying -- is **declared in the types**, never inferred.

Status: design spec. Settled choices are stated normatively; genuinely
open questions are under [Open decisions](#open-decisions). Reading order:
the language (types, control flow, memory), then design and lowering, then
implementation (parser choice), then the plan. North star is the saxpy in
`docs/AMDGPUExplicitWaveProgrammingModel.md` 519-536.

## Example

```c
kernel [[amdgpu_wave_size(32)]]
void saxpy(float *x, float *y, float a, uint32_t n) {
  simd<uint32_t, 32> lane = lane_id<32>();
  uint32_t           wave = wave_id_in_grid();
  simd<uint32_t, 32> i    = wave * 32 + lane;
  mask<32>           active = i < n;
  where (active) {
    simd<float, 32> xv = load(x + i);
    simd<float, 32> yv = load(y + i);
    store(a * xv + yv, y + i);
  }
}
```

Adapted from the model md, with two deliberate surface changes from it: the
lane type is spelled `simd<>` not `wave<>` (matching `!wave.simd`), and
`store` is value-first not pointer-first (matching the IR `$value -> $ptr`).
`[[amdgpu_wave_size(N)]]` fixes the kernel wave width: every
`simd<T,W>`/`mask<W>`/`lane_id<W>` must use `W == N`, and `N` must match the
target wavefront (the backend derives width from the target and validates).
Later snippets elide surrounding declarations: free identifiers like `gA`,
`off_a`, `BK`, `K`, `p`, `scratch` are kernel parameters or prior locals.

## Types

Uniformity is part of the type and is never inferred:

- Uniform scalars (-> SGPR): `bool`, sized ints (`int32_t`/`uint32_t`/...),
  `float`/`half`.
- `index` -- uniform target-width integer for offset/index math. Maps to
  MLIR builtin `index`. No implicit convert to/from sized ints; use
  `index_cast`.
- `simd<T, W>` (-> VGPR) -- lane-varying, `W` lanes (dialect type
  `!wave.simd<T, W>`).
- `vector<T, N>` -- packed payload of `N` elements, maps to MLIR
  `vector<N x T>`. Nests as a per-lane payload: `simd<vector<float, 8>, 32>`
  -> `!wave.simd<vector<8 x f32>, 32>` (`load` supports vector payloads,
  `WaveOps.td` 517-520).
- `mask<W>` -- lane mask.
- `ptr`: `T*` is `#wave.global`; `shared T*` is `#wave.shared` (LDS), from
  `shared_memory_base<T>(...)`. `#private` not in v1; `#buffer` is `#waveamd.buffer`
  (a target-dialect space), also out. (The spec writes
  `#global` as shorthand for the dialect's `#wave.global`.)
- `fragment<role, T, M, N, W, R>` maps to `!waveamd.fragment`. Load/store
  sugar stays macro-level: memory moves use `load`/`store` plus
  `fragment_pack`/`fragment_unpack`.

Generics are element-first: `simd<float, 32>`, `vector<float, 4>`. Surface
sized ints (`int*_t`/`uint*_t`) and a builtin's `i32` result map to the same
signless IR integer and are assignment-compatible; signedness only selects
op variants (compare `ult`/`slt`, cast policy).

`wave.index_expr` takes `index`/signless-int (uniform) or
`simd<index|i32, W>` (lane) bindings and always yields `index` /
`!wave.simd<index, W>` (`WaveOps.td` 469-473). So offset math may be written
in `index` or any sized int; the offset reaching `load`/`store` is `index`
by construction, and `index_cast` is only for mixing widths.

Type rules (full checklist in model md 544-576): arithmetic on `simd<T,W>`
is elementwise over active lanes; a scalar broadcasts into a `simd` op; a
compare on `simd` yields `mask`, on scalars yields `bool`; `simd` does not
implicitly convert to scalar (use `read_first`/`reduce`); `where (m)`
intersects the active mask; inactive-lane values are unspecified unless
produced by `select`/`merge`.

## Operators and builtins

All custom ops are spelled as C function calls: `name(values)`, with `<...>`
carrying compile-time args (widths, types) where needed. Operators:

- Arithmetic `+ - * / % << >>`: elementwise on `simd`, uniform on scalars;
  a mixed scalar/`simd` operand broadcasts the scalar.
- Compare `< <= > >= == !=`: `simd` -> `mask<W>`, scalar -> `bool`.
- Bitwise/logical `& | ^ ~ ! && ||`.
- Assignment `=` and compound `+= -= *= /= &= |= ^= <<= >>=` (reassigns a
  mutable local; loop carries use this, see [Control flow](#control-flow)).

Builtins map 1:1 to a Wave op. `store` is value-first (matches the IR
`$value -> $ptr`); a trailing `after tok` adds a dependency edge, not a
value argument.

| Builtin | Signature | Op |
|---|---|---|
| `lane_id<W>()` | `() -> simd<i32, W>` (`W` sets width) | `wave.lane_id` |
| `wave_id_in_grid()` | `() -> uint32_t` (grid-global; see Lowering) | composed |
| `workgroup_id<ax>()` | `() -> uint32_t` (uniform; `ax` const 0..2) | `wave.workgroup_id` |
| `workitem_id<ax>()` | `() -> simd<i32, W>` (lane-varying; `ax` const 0..2) | `wave.workitem_id` |
| `load(ptr [after t])` | `(ptr) -> (simd<T,W>, token)` | `wave.load` |
| `store(value, ptr [after t])` | `(simd<T,W>, ptr) -> token` | `wave.store` |
| `barrier([t...])` | `(token...) -> token` | `wave.barrier` |
| `wait(t...)` | `(token...) -> ()` | `wave.wait` |
| `join(t...)` | `(token...) -> token` | `wave.join` |
| `token()` | `() -> token` (empty seed) | `wave.token` |
| `shared_memory_base<T>([K])` | `(const i64 K = 0) -> shared T*` (K = byte offset) | `wave.shared_memory_base` |
| `index_cast(x)` | `int <-> index` (either direction) | `arith.index_cast` / `arith.index_castui` |
| `cast<T>(x)` | `(U) -> T` numeric (see cast note) | `wave.cast` |

`shared_memory_base`'s offset is an optional compile-time constant (default 0, folds
to the op's `i64` attribute); runtime LDS addressing is `ptr_add` on the
base.

`cast<T>` (T = element type; lane shape is inherited, so
`cast<float>(simd<i32,W>)` -> `simd<float,W>`) infers the `wave.cast` kind
from source/target element kinds and materializes a `policy` dict attribute
per the verifier (`Wave.cpp` 388-418 -- three independent policies):

- fp->fp `fpconvert`: optional rounding (default `rne`); no other policy.
- int->int `intconvert`: widening (target wider) requires
  `extension = #wave.cast_extension<sign|zero>` from the source int
  signedness (`int*_t` sign, `uint*_t` zero); narrowing/same-width takes no
  policy.
- int->fp `int_to_fp` / fp->int `fp_to_int`: require
  `signedness = #wave.cast_signedness<signed|unsigned>` from the int type
  (`int_to_fp` rounding defaults `rne`). `signedness` is rejected on
  `intconvert`, `extension` is rejected off widening intconvert.

Implemented: `read_first`, fragment pack/unpack/fill, and explicit
WMMA/MFMA builtin names. Open: `reduce_*`, `ballot`, `any`.

## Control flow

Two conditionals, split by condition type -- this *is* the
uniform-vs-divergent (SGPR-branch vs EXEC-mask) distinction made syntactic:

- `if (c) {...} else {...}` -- `c : bool` (uniform) -> `scf.if`. Whole wave
  branches.
- `where (m) {...} otherwise {...}` -- `m : mask<W>` -> `wave.where`. Lane
  predication.

The type checker enforces the split: `if` rejects a `mask`, `where` rejects
a `bool`. A lane-varying compare yields `mask`, so it cannot land in an
`if` -- the types herd code to the right construct.

Uniform loops use a range `for` (own the parser -> drop C's three-clause
form). Half-open to match `scf.for` `[lb, ub)`. The IV type is declared in
the header; `scf.for` takes any signless int or `index` (`SCFOps.td` 162,
267-269: `AnySignlessIntegerOrIndex`, lb/ub/step same type), so the surface
does too:

```c
for index i in 0..n { ... }            // i : index (uniform), iterates [0, n)
for uint32_t k in 0..K step BK { ... } // sized IV; lb/ub/step unify to it
while (c) { ... }                      // c : bool (uniform) -> scf.while
```

Declare the IV type to match the bounds and skip casts: `for uint32_t i in
0..n` when `n : uint32_t` keeps the loop in `uint32_t`; the literal `0`
adopts the IV type. Bounds are uniform; a lane-varying trip count is not a
`for` -- it is the `while (any(todo)) { where (...) {...} }` idiom (model md
620-636). Half-open `0..n` matches `scf.for`; Pascal-style `to n` reads
inclusive and invites off-by-one.

Loop-carried values are just mutable locals -- write it like C. A variable
declared before the loop and reassigned in the body becomes a `scf.for`
iter_arg; the frontend builds the SSA (standard SSA construction over
mutable locals, Braun et al. -- bounded to local values; memory stays
token-explicit). Tokens carry the same way (reassign for pipelining):

```c
simd<float,32> acc = 0.0f;          // scalar broadcasts to simd
for index i in 0..n {
  acc = acc + load(x + i);     // reassigned -> carried as iter_arg
}
// acc holds the final value

token t = barrier();
for index k in 0..K step BK {
  auto [v, t1] = load(p after t);
  acc = acc + v;
  t = t1;                      // token reassigned -> carried too
}
```

The same rule threads variables modified inside `if`/`where` into `scf.if`
/ `wave.where` results (merged across branches; for `where` the merge is a
mask-select, so inactive lanes keep the carried-in value). A local assigned
in some-but-not-all branches must have a dominating definition before the
construct, else it is a use-before-def error (mandatory init normally
satisfies this). A then-only `wave.where` leaves inactive lanes unspecified,
so to carry a value modified only in `then` the frontend emits an
`otherwise` region yielding the carried-in value (equivalently
`select(mask, then_value, carried_in)`). This is SSA construction, not the
alias/divergence
analysis we reject: a local's def-use is fixed by the AST, no approximation.

## Memory and tokens

Memory ordering is explicit and programmer-threaded, mirroring the IR; the
compiler never infers it (no `restrict`, no alias analysis -- that is the
"rediscovery" the model rejects, model md 362). This matches the backend:
the scheduler derives memory-ordering edges only from token SSA edges in
`WaveAMDMachineGreedySchedule.cpp`; un-tokened memory ops carry no ordering and
may be reordered or overlapped freely. Two dependency kinds exist; only one
needs a token:

| Dependency | Carried by | Token? |
|---|---|---|
| RAW through a register (`xv = load(...)`, then `a*xv`); store-data readiness | SSA value edge | no |
| WAW; WAR without a value dep; RAW through memory (LDS); barrier; async completion | nothing in value flow | **yes** |

saxpy needs no tokens: the store's data value-depends on both loads.

Ops (`WaveOps.td` 388-533): `load`/`store` take an optional `$dependency`
token and always produce one; `token()` (seed -> `wave.token`), `after`
(happens-after), `join` (merge), `wait` (drain), `barrier` (deps in ->
token out). `store`/`barrier`/`join`/`token()` return a single token
(`barrier()` with no deps is still a real workgroup sync; `token()` is an
inert seed):

```c
token t = store(a*xv + yv, y + i);
token b = barrier(t0, t1);
token j = join(t0, t1);
token z = token();                 // empty seed, e.g. an initial loop-carried token
wait(t);
```

The dependency edge is a trailing `after`: `store(v, p after t1)`. `load`
returns `(value, token)`; capture the token only when a later op must wait
on the load -- a WAR not covered by value flow:

```c
auto [xv, t] = load(x + i);
token s = store(scratch, x + i after t);   // do not overwrite x[i] until the load read it
```

`auto [xv, t]` is the destructuring form -- one grammar production, not a
C++ feature. Most loads drop the token: `xv = load(x + i);`; a multi-result builtin
(only `load` in v1) in expression position -- e.g. nested `store(load(p),
q)` -- yields its value and drops the token. Tokens are plain SSA values, so
they do not touch the no-stringify FFI rule that the `index_expr` offsets do.

LDS round-trip (the canonical multi-token case; mirrors `wave_matmul.py`
1089-1104):

```c
shared half *lds_a = shared_memory_base<half>(0);       // #wave.shared; kernel: [[amdgpu_lds_size(N)]]
shared half *lds_b = shared_memory_base<half>(2048);
token g0 = store(load(gA + off_a), lds_a);     // gA, off_a: elided kernel params
token g1 = store(load(gB + off_b), lds_b);
token bar = barrier(g0, g1);
simd<half,32> a = load(lds_a after bar);
simd<half,32> b = load(lds_b after bar);
```
`shared_memory_base<T>(byteOffset)` returns a uniform `shared T*` into kernel
shared memory; the kernel declares arena size with `[[amdgpu_lds_size(N)]]` (->
`wave.lds_size`).

Footgun, by design: a forgotten token is a legal reorder -- a silent race,
the same deal `wave_dsl` makes today. The optional seatbelt is a lint ("two
stores to one ptr base, no token between"), never analysis in codegen.

## Why this is tractable

The hard part of a GPU C frontend is normally divergence/uniformity
analysis. Here it is declared in the type (`float a` uniform,
`simd<float,32> xv` lane-varying, `mask<32>` a lane mask), so the frontend
is **type-directed lowering**, not whole-program analysis. The model's Type
Rules (model md 544-576) are the conformance checklist. The frontend owns
exactly three pieces of machinery -- a parser, a type checker, and SSA
construction over mutable locals -- none of which is the alias/divergence
analysis the model rejects.

## Architecture: a second IR producer

The frontend is another producer of `wave` dialect IR, exactly like
`wave_dsl` from Python; everything below the dialect already exists and is
tested (163 lit tests + integration). Build order:

- v0 emits **textual `wave` IR**, piped into the existing `wave-opt` /
  `wave-translate`. This inherits the full backend and the golden-file test
  harness for free: the golden saxpy IR is generated via `wave_dsl`
  (`wavec/test/golden/mlir/saxpy.mlir`, round-trips through `wave-opt`);
  the frontend reproduces it under FileCheck.
- Then switch to in-memory MLIR C API for speed/robustness.
- Emit typed `!wave.ptr<#global, f32>`; the existing
  `wave-normalize-pointer-offsets` pass byte-addresses later. No pre-optimizing.

Existing C surface to build on:

- `include/Wave-c/Dialects.h` -- CAPI handles for every Wave type and
  attribute (simd/mask/mem.token/ptr/expr/pred/fragment/addrspaces) plus
  dialect + pass registration. **No op builders** -- build ops via generic
  `mlirOperationCreate` with op-name strings, as Python does.
- `ixsimpl` is already a C library (`ixs_ctx_create`, `ixs_add`, `ixs_cmp`,
  `ixs_bounds_*`). The symbolic offset engine is natively C-callable.

## Lowering: saxpy walkthrough

Near 1:1 with ops that already exist:

| Source | Wave IR | Type |
|---|---|---|
| `kernel [[amdgpu_wave_size(32)]] void f(...)` | `func.func` + wave-size attr | -- |
| `[[amdgpu_waves_per_workgroup(N)]]` | launch attrs + `gpu.known_block_size` | -- |
| `[[amdgpu_workgroup_size(N)]]` | launch attrs + `gpu.known_block_size` | -- |
| `float *x`, `float a`, `uint32_t n` | `!wave.ptr<#global,f32>`, `f32`, `i32` | uniform |
| `lane_id<32>()` | `wave.lane_id` | `!wave.simd<i32,32>` |
| `wave_id_in_grid()` | `workgroup_id*waves_per_wg + wave.subgroup_id` | uniform `i32` |
| `wave*32 + lane` | `wave.binary muli` (uniform) -> `wave.binary addi` | `!wave.simd<i32,32>` |
| `i < n` | `wave.cmpi ult` (unsigned operands) | `!wave.mask<32>` |
| `where (active) {...}` | `wave.where %active {...}` | -- |
| `load(x + i)` | `wave.ptr_add` (simd<i32> offset) -> `wave.load` + token | `!wave.simd<f32,32>` |
| `a*xv + yv` | broadcast `a` -> `wave.fmul`/`wave.fadd` (or `wave.fma`) | `!wave.simd<f32,32>` |
| `store(..., y + i)` | `wave.store` | -- |

`wave_id_in_grid` is the grid-global wave id, `workgroup_id*waves_per_wg +
subgroup_id` (`wave.subgroup_id` alone is workgroup-local and yields
`index`, so it is `index_cast`-bridged to the `i32` `workgroup_id` before
the add). The golden IR (`wavec/test/golden/mlir/saxpy.mlir`, generated by
`wave_dsl`, round-trips through `wave-opt`) shows saxpy's `x + i` lowering to a plain
`wave.ptr_add` with a `simd<i32>` offset -- no `index_expr`, since the
offset is one explicit SIMD value. (The generator stands `wave.workgroup_id`
in for `wave_id_in_grid`, which the DSL does not expose as a single
builtin.) The symbolic `index_expr` path (built structurally via `ixs_*` ->
`mlirWaveExprAttrGetFromNodePtr`, never stringified) is for **affine**
offsets -- matmul tile addressing `base + row*stride + col` -- where the
backend splits the expression into SGPR base + VGPR lane offset + immediate.
saxpy never reaches that.

## Verified goldens

Generated by the tested `wave_dsl` bindings and round-tripped through
`wave-opt`.

| Golden | Construct | Confirms |
|---|---|---|
| `wavec/test/golden/mlir/saxpy.mlir` | saxpy | `cmpi ult`, value-first `store $v -> $p`, `where %m {...} : mask`, `load -> (simd, token)`, `ptr_add` (not index_expr) |
| `wavec/test/golden/mlir/reduce_sum.mlir` | `for` + carry | `scf.for ... iter_args(...) -> (!wave.simd<f32,32>) : i32` (mutable local -> iter_arg) |
| `wavec/test/golden/mlir/lds_roundtrip.mlir` | LDS tokens | `shared_memory_base : #wave.shared`, `wave.lds_size` attr, `store ... after %t` -> `barrier %t -> token` -> `load ... after` |
| `wavec/test/golden/mlir/where_carry.mlir` | result `where` | `wave.where %m { wave.yield %v } : mask -> simd` |
| `wavec/test/golden/mlir/cast_f32_f16.mlir` | `cast` | `wave.cast fpconvert : simd<f32> -> simd<f16>` (no policy) |
| `wavec/test/golden/mlir/uniform_if_else.mlir` | `if`/`else` | uniform `arith.cmpi` (i1) -> `scf.if %c -> (simd) {...} else {...}` |
| `wavec/test/golden/mlir/where_otherwise.mlir` | `where`/`otherwise` | `wave.cmpi -> mask` -> `wave.where %m {...} otherwise {...} : mask -> simd` |

Policy-laden int casts (`int_to_fp`, widening `intconvert`) are exercised by
`test/Dialect/Wave/ops.mlir`. These goldens settled the IR-detail
questions three doc-review rounds kept missing: the `slt`->`ult` predicate,
value-first store, `ptr_add`-vs-`index_expr` for simple offsets, the
`lds_size` attribute, the `scf.for` carry shape, and the `if`-vs-`where`
split (uniform `arith.cmpi`/`scf.if` vs lane `wave.cmpi`/`wave.where`).

## Strategy: custom parser

Custom parser on the MLIR Toy skeleton. CIR is the documented fallback if
scope ever grows to real-C ingestion.

The language is **deliberately not-C**: the non-C surface (`simd<>`,
`mask<>`, `where`, tokens, lane intrinsics) *is* the language; the C-shaped
part is just scalar arithmetic and uniform control flow. "Clang gives you
90% of C for free" buys the cheap 90% and leaves the expensive 10% we came
for. Both Clang routes also force a choice:

1. smuggle `simd<>`/`mask<>`/tokens through `ext_vector` + builtins +
   addrspace quals, then reconstruct wave semantics in the lowering -- the
   same rediscovery we reject, relocated; or
2. patch Clang Sema+parser (CM-style) against a target that commits daily.

We already carry one fast-moving coupling (LLVM AMDGPU backend internals).
A second daily-churning coupling at the front, to make a C parser accept a
not-C language, is not worth it for a small bespoke language. The
destructuring `auto [v,t]` does not change this -- it is one grammar
production plus trivial local `auto` inference, not a C++ requirement; what
forces a C++ parser is *being C++* (Clang), which also loses the
`where`/`kernel` keywords.

## Routes considered

| Route | Reuse | Cost |
|---|---|---|
| **Custom parser** (Toy skeleton; chibicc/cproc as grammar refs) | MLIR Toy: live, Apache-2.0-w-LLVM-exc, C++, recursive-descent lexer/parser -> MLIRGen. Exact pipeline shape. | Write the grammar (small). Frozen once written. |
| Clang-embed (Polygeist `MLIRScanner`) | Worked Clang-AST -> MLIR scanner, same license. | 230 KB single file, version-locked, `main` ~1yr stale. |
| CIR-embed (upstream CIRGen front + CIR->Wave pass) | All of Clang's C-family front + typed, structure-preserving IR; addrspace model maps to global/shared/private. | CIR op churn (commits daily, ~64% upstreamed); `ThroughMLIR` template not upstream; surface still not-C. |

License is a non-issue: everything except tcc (LGPL) and lcc is permissive
(most are the exact Apache-2.0-w-LLVM-exception we use). Engineering fit,
not legal, decides it.

## Prior art

- **iree-org/wave** -- closest living relative: an AMD "Wave" Python DSL
  with a "Water" MLIR dialect + `waveasm` backend, same symbolic
  memory-access idea. Python-authored, no explicit `simd<T,W>` C type
  system, no C frontend. We would be building the front it lacks.
- **Intel ESIMD** (`simd<T,N>`) -- explicit SIMD as a C++ class template +
  `[[intel::sycl_explicit_simd]]` attr; magic in lowering. Stock Clang
  parses it. Proves the type-template approach; cannot host non-C keywords.
- **C-for-Metal** -- `vector`/`matrix` added to Clang's base type system (a
  Clang extension, not a library). The CM-style "patch Clang" route.
- **Polygeist/cgeist** -- reference Clang-AST -> MLIR (emits scf/affine).
- **ClangIR (CIR)** -- official Clang AST -> MLIR; OpenCL-C -> SPIR-V via
  GSoC. See [ClangIR](#clangir).
- **MLIR Toy / DSP-MLIR / nelli** -- the custom-parser -> custom-dialect
  pattern. Toy is the chosen skeleton.

## Salvage targets

- **MLIR Toy tutorial** (Apache-2.0-w-LLVM-exc, in llvm-project): the
  skeleton -- recursive-descent lexer/parser + `MLIRGen` emitting a custom
  dialect. Lift verbatim, graft the C-family grammar on.
- **chibicc** (MIT): mine its tokenizer and typed-AST idioms. Caveat: dead
  since 2020-12, pure C with global mutable state. Reference, not a
  wholesale fork.
- **cproc** (ISC, maintained 2026): a living C11 recursive-descent parser if
  a maintained base is preferred over chibicc.
- Hand-rolled recursive descent beats a generator for a language this small.
  If a generator is wanted: re2c (public domain) lexer + lemon/ANTLR.

## ClangIR

- The `llvm/clangir` incubator is **archived** (verified: `archived:true`,
  last push 2026-02-21). Active CIR development moved **upstream** into
  `llvm-project/clang/lib/CIR` (verified: CIRGenStmt commits 2026-06-03).
  Target upstream, never the incubator.
- CIR preserves the right altitude: `cir.if`/`cir.for`/`cir.scope`, typed
  `!cir.ptr` with **address spaces**, `cir.load`/`cir.store`, `cir.call`,
  struct/array/vector types. The addrspace enum
  (`offload_private/local/global`) maps cleanly to Wave private/shared/
  global -- a convention worth adopting in our emitter regardless of route.
- `ThroughMLIR` (CIR -> standard MLIR dialects; the template for a
  CIR->Wave pass) is **not upstreamed** (verified: upstream Lowering/ has
  only DirectToLLVM). Port ~2.8k lines or write CIR->Wave fresh.
- Verdict: if we ever need to ingest real C/C++ with wave extensions
  (headers, preprocessor, full sema), CIR-as-front + CIR->Wave is the right
  heavy tool -- not the starting point for saxpy. The wave/mask/token
  surface is not C, so Clang patching or builtin-smuggling is unavoidable on
  that path.

## Stages

v1 scope: saxpy + `if`/`for`/`while` plus fragment/MMA primitives.

0. **Freeze the grammar** (EBNF) for the v1 subset -- drafted in
   [CFrontendGrammar.md](CFrontendGrammar.md). Pins the lexer rules (`<...>`
   type-args, `0..n` vs `0.` float) and the typedef-free disambiguation.
1. **`wavec` skeleton on the Toy pattern**, emitting textual `wave` IR.
   Golden saxpy IR exists (`wavec/test/golden/mlir/saxpy.mlir`, generated via `wave_dsl`,
   verified through `wave-opt`) -- the FileCheck target.
2. **Lexer + parser + AST**: ptr/scalar/`simd<>`/`mask<>`/`vector<>` types,
   function decl, var decls, arithmetic + compare, `where`/`otherwise`,
   `if`/`else`, range `for <int> i in 0..n step s`, `while`, builtins
   `lane_id`/`wave_id_in_grid`/`load`/`store`/`barrier`.
3. **Sema / type checker** enforcing the Type Rules. The only "analysis" --
   type propagation, not a fixpoint.
4. **Lowering** AST -> textual IR, incl. ixsimpl offset construction and SSA
   construction of mutable locals into `scf.for`/`if`/`where` carries. Drive
   end to end: `wavec saxpy | wave-translate --wave-to-amdgpu-asm`, run,
   compare to a CPU saxpy.
5. **Harden + grow**: in-memory MLIR C API (add
   `mlirWaveTranslateToAMDGPUAsm`), reduction/ballot helpers, launch metadata,
   and tuning params.

## Open decisions

- IV/offset typing convention: when to prefer `index` vs sized ints for
  ids and loop bounds (style only; the mechanism is settled).
- Operator/builtin surface beyond v1: spellings for
  `reduce`/`ballot`/`any` and launch/tuning metadata.

## References

Internal:
- `docs/AMDGPUExplicitWaveProgrammingModel.md` 519-636 (saxpy, type rules,
  control flow), 362 (rediscovery rejection).
- `include/mlir/Dialect/Wave/IR/WaveOps.td` 388-533 (token ops), 469-473
  (index_expr), 517-520 (vector payload).
- `lib/Dialect/Wave/Transforms/WaveAMDMachineGreedySchedule.cpp` (memory edges
  are token-only).
- `python/mlir/dialects/wave_matmul.py` 1034-1116 (token threading).
- `include/Wave-c/Dialects.h` (CAPI: types/attrs, no op builders).
- LLVM tree: `mlir/.../SCF/IR/SCFOps.td` 162, 267-269 (`scf.for` IV types).

External:
- iree-org/wave -- https://github.com/iree-org/wave
- Intel ESIMD -- https://intel.github.io/llvm/design/ESIMDDesignNotes.html
- C-for-Metal -- https://arxiv.org/abs/2101.11049
- Polygeist -- https://github.com/llvm/Polygeist (scanner: tools/cgeist/Lib/clang-mlir.cc)
- ClangIR -- https://llvm.github.io/clangir/ ; upstream: llvm-project/clang/lib/CIR
- MLIR Toy -- https://mlir.llvm.org/docs/Tutorials/Toy/
- chibicc -- https://github.com/rui314/chibicc ; cproc -- https://sr.ht/~mcf/cproc/
