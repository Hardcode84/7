# Wave autotuning ops: design

Working notes; iterate freely.

## What this enables

A self-contained autotuning loop expressed inside the transform
sequence: declare a bounded search space, prune via assumptions, fan
out independent trials over per-trial cloned modules, score each
result, replace the original payload with the winning clone. No host
driver, no subprocess shell-out, no PassManager juggling — the wave
compilation pipeline file owns the search.

## Two new ops

### `wave.transform.get_int_attr`

Generic attribute reader. The wave-to-AMDGPU pipeline already attaches
per-kernel metrics (`waveamdmachine.vgpr_count`, `..._sgpr_count`,
`...lds_size`) and the resource-info pass gains module-level "max
across kernels" siblings (`waveamdmachine.vgpr_count_max`, etc.).
This op pulls one out as a `!transform.param<i64>` so it composes
with upstream `transform.match.param.cmpi`, `transform.param.constant`,
`transform.print` for free.

```mlir
%vgprs = wave.transform.get_int_attr "waveamdmachine.vgpr_count_max"
    from %module : (!transform.any_op) -> !transform.param<i64>
```

Failure modes:
- target op missing the named attribute -> definite failure (caller's
  fault; bug in the body sequence).
- attribute is not an `IntegerAttr` -> definite failure.

One C++ file (`WaveTransformOps.cpp`), one op, no new analysis. Future
typed variants (`get_string_attr`, `get_array_attr`) can copy the
shape.

### `wave.transform.tune`

```mlir
%winner, %score = wave.transform.tune %module
    body = @compile_one
    score = @score_max_throughput
    assumes = @feasibility
{
  variables = {
    wave_m_tiles = #wave.tune_pow2_in<[1, 8]>,
    wave_n_tiles = #wave.tune_pow2_in<[1, 8]>,
    wave_k_tiles = #wave.tune_pow2_in<[1, 4]>
  }
} : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
```

The op:

1. Enumerates the Cartesian product of `variables` in deterministic
   lex order (by attribute key, then enumerated value index).
2. For each config: if `assumes` is provided, invokes it with the
   config values as trailing `!transform.param<i64>` args; silenceable
   failure -> skip this config without running the body.
3. Clones the input payload into a fresh `OwningOpRef<ModuleOp>` in
   the shared `MLIRContext` and invokes `body` on the clone with the
   config values as trailing args. The body is expected to bind the
   values into the cloned module's `wavemeta.params` dict (via
   `wave.transform.bind_param` -- separate small op, see below) and
   then drive the compilation sequence.
4. After `body` returns, invokes `score` on the clone and records the
   resulting `!transform.param<i64>`.
5. Picks the maximum score across all trials, then moves the winning clone's
   non-transform contents and module attributes into the source module.
6. Yields the winning clone (now the payload) and the winning score.

Trials are dispatched concurrently on the `MLIRContext`'s shared
thread pool (the same one `--mlir-num-threads` configures); the op
takes no per-op parallelism knob -- that's a context concern, not an
IR concern. Trials are launched in enumeration order; completion
order is arbitrary. Aggregation happens on the parent thread after a
join barrier.

### Tiny helper op: `wave.transform.bind_param`

The body sequence needs to write each variable into the cloned
module's `wavemeta.params` dict before invoking the specialiser. A
two-line op handles it:

```mlir
wave.transform.bind_param %clone "wave_m_tiles" = %m
    : (!transform.any_op, !transform.param<i64>) -> ()
```

Patches one entry of the module-level `wavemeta.params` dict on
`%clone`. Mutates the existing dict if present, creates it if absent.
No semantic check beyond "target is a ModuleOp."

## Variable domains

Three concrete domain attrs exist:

- `#wave.tune_enum<[1, 2, 4, 8]>` -- explicit list.
- `#wave.tune_range<lo, hi, step>` -- `[lo, hi)` with `step`.
- `#wave.tune_pow2_in<[lo, hi]>` -- powers of two in `[lo, hi]` (closed).
  Sugar for the common case in tile-search.

The element type is fixed to `i64`; broader types stay open.

Cardinality of the search space is bounded statically (no symbolic
ranges). Cross-product is computed eagerly inside the tune op; large
spaces should be pruned via `assumes` rather than expressed as
unbounded variables.

## Failure semantics

| Source of failure                          | Tune op response                |
|--------------------------------------------|---------------------------------|
| `assumes` returns silenceable failure      | skip this config, no trial run  |
| `body` returns silenceable failure         | discard trial, continue         |
| `body` returns definite failure            | propagate, kill the whole tune  |
| `score` returns definite failure           | propagate, kill the whole tune  |
| No config passes `assumes`                 | definite failure on the tune op |
| Every trial silenceably failed             | definite failure on the tune op |
| `body` or `score` aborts (CHECK / assert)  | crashes the process (as today)  |

"Silenceable failure" is the upstream `DiagnosedSilenceableFailure`
mechanism. Writers of `body` / `score` express soft-fails via
`transform.match.param.cmpi` (predicate violations) or new helpers
that read an attribute and emit silenceable failure when present (see
below).

### Detecting reg spill / LDS overflow as soft-fail

Regalloc transform stages emit a definite failure when budgets cannot be
satisfied. For tune, that condition needs to surface as a discardable signal,
not a hard abort.

Two future shapes:

1. **Attribute on overflow.** A transform sequence converts the regalloc hard
   failure into `waveamdmachine.regalloc_overflowed` diagnostic IR, then the
   body sequence reads it and emits a silenceable failure. Same shape for LDS
   over-budget with an LDS marker.
2. **Custom failure variant.** Regalloc emits a structured
   `DiagnosedSilenceableFailure`, and the tune op catches it directly.
   Cleaner but requires plumbing through the pass-to-transform
   boundary, which upstream doesn't expose cleanly.

Prefer (1): signal stays inspectable and the body sequence stays declarative.

## Scoring

Single `!transform.param<i64>` returned by the `score` named sequence.
**Maximised** by default. Current tests use direct integer attributes and
constants; arithmetic combinators for multi-metric scores are open scope.

## Parallelism

Per-trial cloning + shared MLIRContext. The context's uniquer is
already locked; structural mutation of disjoint cloned subtrees is
race-free by inspection (no shared `Op` or `Block` between trials).

Dispatch:
- Worker count comes from `MLIRContext::getThreadPool()` (i.e. from
  `--mlir-num-threads` or whatever set the context's threading
  configuration). The op never spawns its own pool.
- Trials dispatched in enumeration order.
- Each worker takes a `(config, OwningOpRef<ModuleOp>)` pair, runs
  `body` then `score`, writes the result to a slot.
- Parent thread waits on the join, reduces winners.

Determinism: enumeration order is the deterministic baseline; on
score tie, lower enumeration index wins. Worker completion order
doesn't affect the final result.

Caveats:
- The context's thread pool is shared with other passes; the tune op
  enqueues work to it without assuming exclusive ownership. Other
  ops running concurrently on the same pool share the cores.
- Diagnostics from concurrent trials are emitted through the MLIR parallel
  wrapper in config order.

## File layout

- `include/mlir/Dialect/Wave/IR/WaveAttrs.td` -- tune domain attrs.
- `include/mlir/Dialect/Wave/IR/WaveTransformOps.td` -- transform ops.
- `lib/Dialect/Wave/IR/WaveTransformOps.cpp` -- apply impls for tune,
  bind-param, attribute reads, cycle estimates, pressure reports, and
  regalloc transform ops.
- `lib/Dialect/Wave/Transforms/RegAlloc/WaveAMDResourceInfo.cpp` --
  resource attributes such as `waveamdmachine.vgpr_count_max`.
- `lib/Dialect/Wave/Transforms/RegAlloc/` -- regalloc transform-loop
  implementation and overflow/verification helpers.
- `test/Dialect/Wave/transform-*.mlir` -- round-trip + apply tests for each op.
  Specifically:
  - `transform-get-int-attr.mlir` — attribute fetch happy path +
    missing-attr + wrong-type negatives.
  - `transform-bind-param.mlir` — dict mutation idempotence.
  - `transform-tune.mlir` -- tune enumeration, assumes pruning, hard failure,
    range/pow2 domains, and no-feasible failure.
  - `transform-tune-smoke.mlir` -- tune plus `wavemeta-specialize` smoke test.

## Open Scope

- Multi-objective scoring (Pareto, lexicographic).
- Guided search (Bayesian, hill-climbing). The search space is still
  enumerated; later iterations could add a dynamic-domain variable with a
  feedback API.
- Non-`i64` variable types.
- Caching shared upstream stages across trials.
- A reproducibility seed for the worker pool. Determinism is
  preserved by enumeration ordering, not by RNG control.

## Open questions

### How does the tune op's body learn the variable values?

Two options, the doc picks (a):

(a) Trailing `!transform.param<i64>` args to `body` and `score`, one
    per variable in declared order. Bound to the trial's config
    values by the tune op before invocation. `body` is responsible
    for calling `wave.transform.bind_param` to push them into the
    `wavemeta.params` dict.
(b) The tune op pre-binds the `wavemeta.params` dict itself; `body`
    just compiles. Simpler caller side but inflexible — body can't
    use the values for any purpose other than wavemeta binding.

(a) keeps the values first-class so they can also feed `assumes` and
participate in score arithmetic.

### Where does the winning clone end up?

At the end, the tune op moves the winning clone's non-transform module body and
module-level attributes into the original module. The first result handle points
at that original module after replacement; the original target handle is
consumed.

### Diagnostic ordering with parallelism

Trials run under MLIR's parallel diagnostic wrapper, so diagnostic emission
follows config order after the join. Definite failures propagate; silenceable
failures discard the trial.

### Empty domains

If a variable's domain is empty (e.g., `range<5, 5, 1>`), the op
fails verification. Same for `pow2_in<[3, 3]>` (no power of two in
that range). Caught locally at op build / verify time.

### Variable correlation

Variables are enumerated independently (full cross-product); the
`assumes` sequence prunes invalid combinations after the fact. No
direct dependency notation in the variable domain itself.

A derived-domain attribute could express one variable as a function of others.
