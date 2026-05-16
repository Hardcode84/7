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

## Development

Pre-commit covers formatting and licensing checks:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

## License

Apache-2.0 with LLVM exception. See `LICENSE.TXT`.
