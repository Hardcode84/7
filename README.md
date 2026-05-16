# wave-mlir

Standalone MLIR **Wave** dialect: an explicit wave-level programming model for
AMDGPU, extracted from an in-tree LLVM/MLIR prototype.

Status: code imported from `llvm/llvm-project` branch `wave-dsl`
(tip `469ba96be262`). CMake glue is wired but **the build is not yet
green out-of-tree** — see "Known build deps" below.

## Layout

Mirrors the in-tree MLIR layout so that `#include "mlir/Dialect/Wave/..."`
references resolve without rewriting:

```
include/mlir/Dialect/Wave/        # Wave dialect IR + transforms (.h / .td)
include/mlir/Dialect/WaveMachine/ # WaveMachine machine-level dialect
include/mlir/Target/Wave/         # AMDGPU translation entry points
lib/Dialect/Wave/{IR,Transforms}/ # Dialect impl, WaveAMD* passes,
                                  # WaveToGPU, WaveToROCDL, WaveMachine,
                                  # waitcnt
lib/Dialect/WaveMachine/IR/       # WaveMachine impl
lib/Target/Wave/                  # AMDGPU assembly backend + translation
python/mlir/dialects/             # Wave / WaveAMD bindings + wave_dsl tracer
test/{Dialect,Conversion,Target,Integration,python}/
examples/wave/                    # small DSL examples
docs/                             # Explicit Wave Programming Model proposal
```

## Known build deps

The imported transforms reach into AMDGPU internals that aren't part of
the public MLIR/LLVM install surface — `lib/Target/AMDGPU/*` headers and
their TableGen output. The top-level `CMakeLists.txt` points
`LLVM_MAIN_SRC_DIR` and `LLVM_BINARY_DIR` at the bootstrap LLVM source
and build trees (`build/_deps/llvm-project`, `build/llvm-build`) so the
imported `target_include_directories(... lib/Target/AMDGPU)` lines
resolve. Override `WAVE_LLVM_PROJECT_SRC_DIR` /
`WAVE_LLVM_PROJECT_BUILD_DIR` if you bootstrapped LLVM elsewhere.

`WaveAMDHazardWaits.cpp` originally referenced `llvm::AMDGPU::SNop` /
`llvm::AMDGPU::SDelayAlu` helpers added by the (still-unmerged) upstream
commit `6490bb708b51` "Share AMDGPU hazard delay encodings". Those
helpers are vendored locally in that translation unit under
`amdgpu_compat::`; once upstream lands, delete the vendored block and
restore the `llvm::AMDGPU::` qualifications.

Python bindings (`MLIR_ENABLE_BINDINGS_PYTHON`) and a `wave-opt` /
`wave-translate` tool driver are TODO.

## Building

LLVM/MLIR is pulled at the commit pinned in `llvm-commit.txt`. There is no
submodule; the dep is fetched and built by a helper script.

```bash
# Fetch + build LLVM/MLIR into build/llvm-install (one-off, slow).
python build_tools/build_llvm.py -j$(nproc)

# Configure and build the dialect.
cmake -S . -B build -G Ninja
cmake --build build
```

Environment overrides (skip the bootstrap when you already have LLVM):

| Variable | Meaning |
|---|---|
| `LLVM_INSTALL_DIR` | path to an existing LLVM install (`lib/cmake/{llvm,mlir}`) |
| `LLVM_PROJECT_SOURCE_DIR` | existing `llvm-project` source checkout (will be built) |
| `LLVM_COMMIT` | override the pinned commit |

## Development

Pre-commit covers formatting and licensing checks:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

## License

Apache-2.0 with LLVM exception. See `LICENSE.TXT`.
