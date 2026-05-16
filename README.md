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

## Known build deps (not yet satisfied)

The imported transforms reach into AMDGPU internals that aren't part of
the public MLIR/LLVM install surface, **and** rely on a small upstream
LLVM patch from the `wave-dsl` branch that isn't merged yet:

- `AMDGPUInsertDelayAlu`, `SIInstrInfo`, `AMDGPUBaseInfo` exposing shared
  hazard-delay encodings (see commit
  `6490bb708b51` "Share AMDGPU hazard delay encodings").

Until that lands upstream (or we vendor / patch it locally), `cmake
--build build` will fail to compile `WaveAMDHazardWaits.cpp` and the
AMDGPU translation. The CMake configure step does work and produces
TableGen output.

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
