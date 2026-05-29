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
- `op.walk(...)` lambdas can return `WalkResult::interrupt()` to stop early and propagate failure; check the result with `.wasInterrupted()`.
- Use `return signalPassFailure();` to abort a failed pass.
- Prefer named accessors to `getResult(0)` when possible.
- In LIT tests, never use raw SSA names like `%0` or `%1` in `CHECK` lines. Capture them with placeholders such as `[[VAL:%.*]]` and reuse the placeholder.
- For type-rewriting passes, drive the dialect-conversion infrastructure (`TypeConverter` + `applyPartialConversion`) instead of poking `Value::setType` from a walk; the conversion driver tracks materializations across boundaries that bare in-place mutation does not. Reuse upstream populators (`populateAnyFunctionOpInterfaceTypeConversionPattern`, `populateReturnOpTypeConversionPattern`, `populateCallOpTypeConversionPattern`, `scf::populateSCFStructuralTypeConversionsAndLegality`) rather than hand-rolling per-op clone-and-replace.
- **Verifiers must be local.** `verify()` checks the op's own attributes, operand/result types, and region structure -- nothing else. Walking def-use chains, peeking at producers, or reading other ops' state belongs in passes that `signalPassFailure()`. If you reach for `op.getOperand(i).getDefiningOp<X>()` inside a verifier, stop.

## Commits

- Before every commit, run full lit and integration tests:
  `cmake --build build --target check-wave-mlir -j $(nproc)` and
  `build/bin/llvm-lit -sv build/test --filter='Integration'`.
- Small, focused commits. One logical change per commit. If you're wondering whether to split — split.
- Commit messages should be descriptive, or at least funny. Not both is acceptable. Neither is not.
