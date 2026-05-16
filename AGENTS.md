## Tone

Code comments, docstrings, and commit messages share the same voice: terse, dry, informative. Wit is welcome, fluff is not. Say what the thing does, not what you wish it did. If a comment doesn't earn its line, delete it.

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

## Commits

- Small, focused commits. One logical change per commit. If you're wondering whether to split — split.
- Commit messages should be descriptive, or at least funny. Not both is acceptable. Neither is not.
