# Compilation pipeline as IR: transform-dialect strategy

State-of-the-tree, kept in sync with what's in `master`. The
"working notes" framing is gone -- the staged adoption finished
through Stage 5's parallel-dispatch + grid-tune part. What's
written here is what the source does, with a residual section for
what's still unfinished.

## The idea in one paragraph

The wave-mlir compilation pipeline is MLIR `transform`-dialect
IR sitting in `lib/Target/Wave/pipelines/pipelines.mlir`, run via
`transform-preload-library` + `transform-interpreter`. The
pipeline is data the user can edit, parameterise, and search
over. Wave-specific transform ops let the pipeline query its own
intermediate state (VGPR / SGPR / LDS counts, regalloc-overflow
flags) and feed that back into pipeline decisions. The autotune
search space (e.g. `wave_k_tiles` unroll) is encoded as a single
`wave.transform.tune` op with a bounded variable domain; the op
clones the payload per-trial, runs `body` / `score` named
sequences, picks the max-score winner, and installs the winner's
content back into the original module. Trials run on the LLVM
thread pool.

## What landed where

### Pipeline as IR

`lib/Target/Wave/pipelines/pipelines.mlir` holds
`@waveamd_backend` (the full backend: `waveamd-to-machine`,
`waveamd-abi-lowering`, `waveamd-decompose-mem-tuples`,
`waveamd-insert-ticket-waits`, `waveamd-reg-alloc`,
`waveamd-insert-hazard-waits`, `waveamd-resource-info`,
`waveamd-metadata`) and `@compile_kernels` (the backend +
`wave-compile-kernels`). The default entry is
`@__transform_main`, which `wave-translate` picks up implicitly.
Tests select richer entries by name via
`transform-interpreter{entry-point=…}`.

`wave-set-target-attr` runs ahead of the interpreter and stamps
`waveamdmachine.target` plus pre-loads every dialect a downstream
pass might pull in, since the interpreter's multi-threaded
context refuses late dialect registration.

### Parameter passing

Two intertwined mechanisms:

- **Build-time / source-level parameters:** `wavemeta.param "name"
  : T` reads from a module-level `wavemeta.params` dict
  (`WaveMetaDialect::getParamsAttrName()`). `wavemeta-specialize`
  folds the op to `arith.constant` and substitutes
  parameter-named `!wavemeta.ptuple` widths (`ptuple<T, "name">`)
  with concrete int widths, then expands the nested ptuple to
  flat scalars via the dialect-conversion driver. Recursive
  `convertType` + chunking source / target materialisations make
  `ptuple<ptuple<af, M>, "wave_k_tiles">` collapse to `K * M`
  scalars in one specialise run.
- **Transform-time / autotune parameters:** `wave.transform.bind_
  param %mod "name" = %v as <type>` patches one entry of the
  target module's `wavemeta.params` dict before specialise runs.
  The `as <type>` clause re-types the autotune-native
  `!transform.param<i64>` to the kernel's actual type (`index`,
  `i32`, ...). Mismatched types are a hard error during
  `wavemeta-specialize`, not a silent skip -- autotuners feeding
  `i64` into an `index` param get told the real cause instead of
  chasing a "no binding" downstream cascade.

### Measurement / query

One generic op rather than a family of typed measurement ops:

```mlir
%vgprs = wave.transform.get_int_attr
    "waveamdmachine.vgpr_count_max" from %module
    : (!transform.any_op) -> !transform.param<i64>
```

Reads a named `IntegerAttr` off each payload op and yields it as
a `!transform.param<i64>`. `waveamd-resource-info` already
attaches per-kernel `waveamdmachine.{vgpr,sgpr,lds}_count{,_max}`
attributes, and `waveamd-reg-alloc` with `mark-overflow=true`
attaches `waveamdmachine.regalloc_overflowed_count` (always set
to `0` when none overflowed, so consumers don't have to
distinguish absent-vs-zero). Composing these with upstream
`transform.match.param.cmpi`, `transform.param.constant`,
`transform.print` covers what the sketched
`measure_vgpr_pressure` / `measure_sgpr_pressure` /
`measure_lds_bytes` ops were meant to do, without growing the op
table for each attribute we already write down.

Soft-fail tuning of overflow: `waveamd-reg-alloc` gains
`mark-overflow=true` (set `waveamdmachine.regalloc_overflowed = 1`
on the func, keep the rest of allocation virtual, return
success) and `vgpr-limit` / `sgpr-limit` overrides for testing.
Downstream `waveamd-resource-info` chokes on partially-allocated
funcs by design -- the tune body's `match.param.cmpi eq %count,
%zero` silenceably bails on overflowed trials *before* reaching
resource-info.

### Alternatives + grid + score

`wave.transform.tune` is the de-facto `transform.alternatives` +
`alternatives_grid` from the original sketch:

```mlir
%winner, %best = wave.transform.tune %root
    body = @body score = @score (assumes = @assumes)?
    { variables = { k = #wave.tune_enum<[1, 2, 4, 8]>,
                    m = #wave.tune_pow2_in<[1, 16]>,
                    n = #wave.tune_range<0, 8, 2> } }
    : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
```

- Enumerates the Cartesian product of the variable domains in
  declared (first-key-slow) order so trial indices are stable.
- Three variable kinds: `#wave.tune_enum<[v0, v1, ...]>`,
  `#wave.tune_range<lo, hi, step>` (half-open), and
  `#wave.tune_pow2_in<[lo, hi]>` (powers of two in the closed
  range). Domain attrs verify their own non-emptiness.
- Optional `assumes` runs first per config; silenceable failure
  prunes the trial.
- `body` runs on a fresh clone (`OwningOpRef<ModuleOp>`); its
  silenceable failure also prunes.
- `score` runs on the same clone and must yield one i64 param.
  Max score wins; ties resolve by lower enumeration index.
- Winner replaces the original payload via `installWinner`,
  which moves non-transform ops over and adopts the clone's
  module-level attrs (e.g. `wavemeta.params`). Transform-dialect
  ops on both sides are skipped -- the original module still
  hosts the running interpreter (including the tune op itself).
- Definite failures inside any sub-sequence propagate. An
  empty feasible set is a definite failure ("no feasible tune
  trial").

### Per-kernel pipeline attachment

`__transform_main` is the convention. `wave-translate` and the
backend look for it implicitly; tests use
`transform-interpreter{entry-point=…}` to override. No
`wave.pipeline = @…` attribute -- a global default is enough for
the cases we have. The `transform.with_named_sequence` module
trait gates the named-sequence machinery; `bind_param` and the
tune op's lit tests stamp it via the Python `module.operation.
attributes["transform.with_named_sequence"] = UnitAttr.get()`
path.

### Parallel dispatch (Stage 5 piece)

`wave.transform.tune`'s trial loop is `mlir::parallelFor` over
the configs. Each trial constructs its own
`transform::TransformState` via
`transform::detail::makeTransformStateForTesting` -- the public
factory (the bare ctor is private). The "testing" naming is
misleading: cross-thread isolation of the scope stack and
payload-handle mappings is the actual requirement here.
Reduction stays sequential and walks `outcomes` in enumeration
order so winner tie-breaks resolve identically to the serial
version.

Per-trial: clone the module (each gets its own
`OwningOpRef<ModuleOp>`), build three sequential per-sequence
states (`assumes`, `body`, `score`), no shared mutable state
during the parallel phase beyond the StorageUniquer plus the
read-only source module.

## What's still hard / unfinished

- **Caching shared upstream stages.** Every trial re-runs every
  pass in `body` -- including the expensive backend lowering that
  precedes the tunable axis. For a tune over `wave_k_tiles`, the
  K-independent prefix (wave-to-machine, ABI lowering, ticket
  waits, ...) gets paid N times; post-regalloc hazard insertion runs
  after the overflow check. A
  `transform.checkpoint %m` / `transform.restore_from %ckpt` pair
  would let the body fork only the K-dependent suffix. Not built.
- **Pre-regalloc pressure estimation.** Trials measure VGPR
  count by running the full backend through reg-alloc.
  Soft-failing via `mark-overflow` already removes the
  expensive-on-overflow case (regalloc keeps going instead of
  crashing the pass), but the trial still pays for everything up
  to and including reg-alloc. An abstract evaluator over
  WaveAMDMachine IR would prune faster, at the cost of drifting
  from the allocator. Not built.
- **Diagnostics on no-feasible.** The tune op silenceably
  silences per-trial diagnostics so the surviving message is just
  "no feasible tune trial". The user wanting to know *why* all
  trials died would need a verbose mode that attaches the
  per-trial reasons. Not built.
- **Versioning of pipeline files.** The
  `lib/Target/Wave/pipelines/pipelines.mlir` evolves with the
  dialect; user-supplied pipeline files do not. No `wave-version
  = "1.2"` attribute checked at preload, no migration. Open.

## Where this connects to existing wave work

- **Hazard catalog.** A hypothetical `count_inserted_nops`
  measurement op is still a natural fit on top of
  `hazard-mitigation`; today nothing in autotune leans on it.
- **Gap-walking regalloc.** `mark-overflow` on
  `waveamd-reg-alloc` (the production allocator, not a separate
  estimator) is what makes the autotune budget loop work end-to-
  end. A future pre-allocator pressure estimator would reuse the
  same free-list bookkeeping.

## Prior art

- IREE's transform-dialect kernel codegen pipeline:
  https://iree.dev/community/blog/2023-06-22-iree-cuda-backend/.
- Triton's autotune loop is host-driven (Python); shape of the
  search space and scoring conventions translate cleanly.
- Upstream MLIR `transform.alternatives` /
  `transform.foreach_match` tests in
  `mlir/test/Dialect/Transform/`.
