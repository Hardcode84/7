# wave-mlir

Standalone MLIR **Wave** dialect: an explicit wave-level programming model for
AMDGPU, extracted from an in-tree LLVM/MLIR prototype.

Status: scaffolding only. The dialect sources live on a branch of
`llvm/llvm-project` (`wave-dsl`) and will be imported here as the extraction
progresses.

## Layout (planned)

```
include/wave/        # Wave dialect IR + transforms headers
include/wavemachine/ # WaveMachine machine-level dialect headers
lib/                 # Implementations and lowerings
python/              # Python bindings + tracing DSL
test/                # FileCheck and integration tests
```

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
