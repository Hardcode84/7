## Tone

Comments earn their line or get cut. The bar is: would the next reader, staring at the code, miss this? If no, the comment is fluff.

Caveman style. Telegraph English. Substance > prose.

- **One line is the target.** Two is a stretch. Five is a smell -- rename the symbol, split the function, or add a structural assert so the comment isn't load-bearing.
- **Say what's non-obvious**, not what the code already says. The function name carries the "what"; the comment carries the "why this shape" or "what would break otherwise".
- **No function-header essays.** Block comments above functions are the worst offender. If you find yourself writing five lines of intent above a `static` helper, the name is wrong or the function does too much.
- **No backstory.** "Previously / used to / old shape was / the X path now does Y" rots the moment the prior shape is forgotten. Describe the current constraint, not the rescue narrative.
- **No restating the signature**, no narrating the body, no "this function takes X and returns Y", no "Step 1, Step 2, Step 3" play-by-play.
- **Function doc says what, not how.** A header comment tells the caller what they get back; storage tricks ("hash-consed", "pointer-equal", "interval propagation"), bookkeeping ("copies the input to satisfy..."), and library internals ("via `ixs_check`", "cheap relative to `simplifyX`") belong in the body next to the surprising line, not in the docstring. If the *how* matters to a caller, expose it through a typed return or a named flag instead of in prose.
- **No cross-references that go stale.** "Same as the load side", "mirrors the foo path", "see also bar()" -- these snap when one side moves and the other doesn't. If the symmetry matters, factor a shared helper.
- **No hedging.** "Essentially", "basically", "more or less", "note that", "it's worth noting", "we should probably", "kind of" -- cut them.
- **Drop articles and filler** when the meaning survives. "We", "the X path", "this approach", "in order to", "due to the fact that" -- gone. `// rank parity required` beats `// We require that the ranks are parity-equal in order to ...`.
- **Don't apologise to the future**, don't explain well-known idioms (`// clone the body`, `// build the result vector`), don't paraphrase identifiers (`// loc is the location`).

Concrete contrasts, paraphrased from real diffs:

Bad:
```cpp
// Per-slot reduction carry fold: collapses to raw `yielded[oi]` on
// plain yield (`masks[oi]` null) and to `arith.select(mask, yielded,
// carry)` on predicated yield, matching the carry semantics the
// previous lowering produced inside the body.
```

Good:
```cpp
// Plain yield: passthrough. Predicated: select(mask, raw, carry).
```

Bad:
```cpp
// Reduction-iter shape for the chunk body: load each outs init at
// the parallel-only offset (the slot every thread owns
// post-partition), build a nested `scf.for` over reduction iters
// with the inits as `iter_args`, clone the body once per innermost
// iteration, propagate yielded values as carries through the nest,
// and store the outer loop's results back at the same outs offset.
```

Good:
```cpp
// Reduction iter syms bind to loop IVs through the nest and restore
// on unwind -- siblings see no temp binding.
```
(Everything else the bad version says is plain in the code.)

Bad:
```cpp
// Capture the destination shape for the OOB-store guard so the
// downstream body can compose the bound conjunction. Only populate
// when the per-axis offset shape matches the destination rank
// because the bound zips per-axis and rank parity has to hold.
```

Good:
```cpp
// Rank parity required: bound zips per-axis. Empty indices skip
// (bound vacuously true on a whole-tile write).
```

Same rule covers docstrings, commit bodies, and PR descriptions. Wit is welcome, fluff is not. Neither is acceptable.

## FFI boundaries

- **Never round-trip structural data through strings.** When a Python /
  C / C++ value already has a structural representation (an
  `ixsimpl.Expr`, an `MlirAttribute`, an op handle, an
  `IntegerValueRange`, ...), pass it across language boundaries via the
  structural API. The canonical bridges are: hash-consed handles
  through their owning store; `serialize` / `deserialize` for stable
  cross-context binary blobs; CAPI functions that take typed handles
  or `uintptr_t` pointers. Reaching for `str(expr)` + parse on the
  other side is wrong even when it happens to work -- the parser is
  lossy, slow, and re-runs every time, and the resulting handle is
  not pointer-equal to peers built structurally. `repr(...)` /
  `str(...)` is for humans and printers; data that crosses a boundary
  uses the structural path.

## Implementation Discipline

- **No shortcuts, never overfit.** Implement the general mechanism, not a
  known input. Goldens are conformance tests, not templates. Unsupported
  features return clear errors; no fabricated ops or canned output.
- **Wave memory ordering is explicit.** Legality is SSA dominance plus
  explicit token edges. Do not add implicit alias analysis, barrier inference,
  or loop-carried memory dependencies to any transform. If ordering matters,
  encode it in IR.
- **Scheduler is a stall filler.** It builds legal ready sets and applies model
  decisions. Target, occupancy, latency, resource, and filler compatibility
  policy belongs in `CostModel`, represented by named stalls when applicable.
  Never add target-specific ranking, a second order, or a post-schedule veto.

## Wave AMD Regalloc

- Pressure relief for `WaveAMDRegAlloc*` follows
  `lib/Dialect/Wave/Transforms/AGENTS.md`.
- Keep alias-set construction and linear scan. On allocation failure, ask
  providers for one relief plan, add required non-spillable temp ranges, and
  rerun scan.
- Provider order is strict: `AGPR -> Remat -> LDS -> Scratch`. First provider
  with any legal candidate wins; later providers are not queried for cheaper
  relief.
- Always spill/remat the whole alias set. Failed live range is eligible.
  A legal plan is accepted even when it does not solve pressure alone.
- Candidate alias set must intersect the allocation failure point. Relief size
  is not a filter; use bridge count, loop-depth penalty, and stable tie-breaks.
- Bridge temps are normal intervals except `nonPromotable`/non-spillable.
- Base regalloc talks only through the common provider interface. No
  provider-specific logic in `WaveAMDRegAlloc.cpp`. Each provider
  implementation lives in its own file.
- Providers own legality, capacity, bridge counting, bridge temp ranges, and
  materialization. Bridge loop depth is cost, not legality.
- AGPR MFMA accumulator chains need no bridges when banks already match.
- Remat rebuilds cheap expression trees only when all non-rematerialized leaves
  are live at every consumer needing the rebuilt value.
- LDS and Scratch share spill logic. LDS is occupancy/budget-limited; Scratch
  is unlimited and last by provider order.
- Materialization waits until allocation planning is done. Do not rebuild alias
  sets from scratch after each plan.

## Perf golden ASM

- Use one `test/PerfGolden/test_*.py` per kernel. Keep frozen Wave MLIR
  or deterministic generator args, plus checked-in `.s` goldens under
  `test/PerfGolden/Inputs/`.
- Lit must pass configured tools and build roots, e.g. `%wave_obj_root`
  or `--wave-translate wave-translate`. Never hard-code `build/bin` or
  `${repo}/build` in perf golden tests.
- Run goldens when ASM can drift: `build/bin/llvm-lit -sv build/test
  --filter='PerfGolden'`. For helper-level repro, use
  `python -m pytest -q test/PerfGolden`.
- Regenerate checked-in ASM with
  `python build_tools/regenerate_perf_goldens.py --build-dir build`; it runs
  each helper with `--generated-out`, updates `test/PerfGolden/Inputs/`, then
  reruns the PerfGolden lit filter.
- Measure regalloc stage timing for the default perf golden with
  `python build_tools/measure_regalloc_stage_timing.py --runs 5 --warmups 1`.
  For a generated helper, pass `--perf-golden-test test/PerfGolden/test_*.py`;
  the helper must support `--emit-mlir` and the timing script verifies ASM
  against the checked-in golden. For A/B, pass repeated
  `--tool label=/path/to/wave-translate` arguments.
- ASM drift is a review stop, not a failure proof. Benchmark old and new
  assembly on the same hardware before updating a golden.
- New generated golden file types need REUSE coverage. Python helpers must
  pass Black and Ruff before commit.

## Local Performance Repro

- Before GEMM perf calibration, especially after branch switch or rebase,
  rebuild every tool in the calibration path:

```bash
cmake --build build --target wave-opt wave-translate WavePythonModules -j $(nproc)
```

- `wave-matmul-calibrate` invokes `build/bin/wave-translate`; rebuilding only
  `wave-opt` can leave stale HSACO/ISA generation and invalidate TFLOP
  comparisons.
- Prefer `tools/wave-matmul-calibrate/wave-matmul-perf-sweep.py` for gfx950
  f16, MXFP4, and v9 perf sweeps. It rebuilds the calibration tools unless
  `--skip-rebuild`, uses random inputs unless `--all-ones`, reports TFLOP/s,
  and can write CSV with `--csv`.
- Sweep defaults cross-reference `docs/Gfx950MatmulProfiles.md`: f16 K values
  are `512,1024,2048,3072,4096,8192,16384`; MXFP4 K values are
  `1024,2048,3072,4096,8192,16384,32768`; v9 is fixed at `K=4096`.
  `--k-values` overrides f16/MXFP4 only.
- Perf sweeps default to `--no-check`; use `--check` for smaller smoke shapes.
  Use `--dry-run --skip-rebuild` to inspect the command matrix.

## Language and MLIR Guidelines

### Python

- Prefer `math.prod` over `reduce`.
- Iteration over `set` is not stable; sort or otherwise stabilize order when output must be deterministic.
- Underscore-prefixed names are module-private. Do not import them across modules; either drop the underscore or move the helper somewhere public.
- Use `contextlib.suppress(ExcType)` instead of bare `try` / `except` / `pass`.
- Prefer `pathlib.Path` over `os.path`; use `/`, `.exists()`, `.read_text()`, and related `Path` APIs.
- Avoid local imports unless they are needed to keep expensive or optional dependencies lazy.

### LLVM/MLIR C++

- Do not use braces for single-line `if` bodies.
- Avoid `auto` when the type is not trivial to infer; lambdas and iterators are fine.
- Do not name variables `module`, to avoid collision with C++ modules.
- Prefer `std::array` over `std::vector` / `llvm::SmallVector` when the count is known at compile time.
- Use descriptive asserts with `&& "message"`.
- Use `Op::create(builder, ...)` syntax.
- Use `cast<Type>(arg)` syntax.
- Prefer `llvm::seq` to C-style counted loops.
- For MLIR/C++ debug logging, include `llvm/Support/DebugLog.h` and use `LDBG()` / `LDBG_OS()` instead of raw `LLVM_DEBUG(llvm::dbgs() << ...)`.
- Mark TU-local free functions `static` even inside an `namespace { ... }`. Anonymous namespaces house struct/class definitions; free functions get an explicit `static` so the storage class is visible at the signature and not implied from a brace fifty lines up. Templates keep `template <...>` first then `static`; `[[noreturn]]` stays leftmost.
- AMDGPU backend instruction emission goes through MCInst/MCInstPrinter. Do not print ISA text directly except labels, directives, and comments.
- Do not branch on AMDGPU chip names as strings. Parse targets once and use `llvm::AMDGPU::IsaVersion` or MC subtarget predicates for arch checks.
- Keep structs/classes compact: non-trivial/container fields first (`SmallVector`, `DenseMap`, `BitVector`, `std::optional`, etc.), then pointer/view/scalar fields in descending size, then small enums/bools. When reordering fields, fix or replace positional aggregate initializers.

### MLIR

- Use `getConstantIntValue(Value/Attribute)` to extract a constant integer from either a value or an attribute instead of manually matching `arith.constant`.
- Prefer `StringRef` and `Twine` over `std::string` for string handling.
- Use `DenseMap::lookup(key)` when a missing key should return a default-constructed value without inserting into the map.
- Do not root passes on concrete ops until necessary; prefer broader interfaces or dialects.
- Do not collect `func::FuncOp` just to rescan each body for target ops. Walk
  pass root once. Iterate functions only for function-scoped state or legality.
- `op.walk(...)` lambdas can return `WalkResult::interrupt()` to stop early and propagate failure; check the result with `.wasInterrupted()`.
- Use `return signalPassFailure();` to abort a failed pass.
- Prefer named accessors to `getResult(0)` when possible.
- In LIT tests, never use raw SSA names like `%0` or `%1` in `CHECK` lines. Capture them with placeholders such as `[[VAL:%.*]]` and reuse the placeholder.
- For type-rewriting passes, drive the dialect-conversion infrastructure (`TypeConverter` + `applyPartialConversion`) instead of poking `Value::setType` from a walk; the conversion driver tracks materializations across boundaries that bare in-place mutation does not. Reuse upstream populators (`populateAnyFunctionOpInterfaceTypeConversionPattern`, `populateReturnOpTypeConversionPattern`, `populateCallOpTypeConversionPattern`, `scf::populateSCFStructuralTypeConversionsAndLegality`) rather than hand-rolling per-op clone-and-replace.
- **Verifiers must be local.** `verify()` checks the op's own attributes, operand/result types, and region structure -- nothing else. Walking def-use chains, peeking at producers, or reading other ops' state belongs in passes that `signalPassFailure()`. If you reach for `op.getOperand(i).getDefiningOp<X>()` inside a verifier, stop.

## Commits

- New features require a `test/Integration` test. Target/dialect lit is
  supporting coverage, not a replacement.
- Before every commit, run full lit, wavec, and integration tests:
  `cmake --build build --target check-wave-mlir -j $(nproc)`,
  `cmake --build build --target check-wavec -j $(nproc)`, and
- Small, focused commits. One logical change per commit. If you're wondering whether to split — split.
- Commit messages should be descriptive, or at least funny. Not both is acceptable. Neither is not.
