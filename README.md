# wave-mlir

Standalone MLIR **Wave** dialect: an explicit wave-level programming model
for AMDGPU. The dialect preserves uniformity, lane masks, wave size, and
memory ordering as first-class IR facts, and lowers through an
inspectable WaveAMDMachine dialect to AMDGPU assembly.

The design rationale is in [`docs/AMDGPUExplicitWaveProgrammingModel.md`].

## What's in here

- `Wave` dialect — explicit wave-level ops (lane id, work-group id, masks,
  ballots, lane permutations, structured `where`, symbolic offset
  algebra via `wave.index_expr`, memory ops with explicit tokens, WMMA
  fragments).
- `WaveAMD` dialect — AMDGPU-specific extensions (`make_buffer`,
  WMMA opcodes, register class hints).
- `WaveAMDMachine` dialect — inspectable machine-level IR after wave-to-amdgpu
  selection: explicit SGPR / VGPR / mask / memory-token operands, every
  pass-pipeline stage is a printable IR boundary.
- Transform passes: selection (`waveamd-to-machine`), ABI lowering,
  register allocation, hazard / waitcnt insertion, resource info, HSA
  metadata, GPU binary emission.
- `wave-opt` and `wave-translate` tools wired with the full pipeline,
  plus `wave-symbols-test` for the symbolic-offset smoke test.
- Python bindings (`mlir.dialects.wave`, `mlir.dialects.waveamd`,
  `mlir.dialects.wave_dsl`) and a tiled-WMMA matmul kernel in
  `examples/wave/wmma_matmul_tiled.py` that runs end-to-end on
  gfx1100.

## Layout

```
include/mlir/Dialect/Wave/        Wave dialect IR + transforms (.h / .td)
include/mlir/Dialect/WaveAMDMachine/ WaveAMDMachine machine-level dialect
include/Wave-c/                   CAPI (used by the Python bindings)
lib/Dialect/Wave/{IR,Transforms}/ Dialect impl + waveamd-* passes
lib/Dialect/WaveAMDMachine/IR/       WaveAMDMachine impl
lib/Target/Wave/                  AMDGPU assembly backend + translation
lib/CAPI/                         CAPI implementation
python/                           Nanobind extension + wave_dsl builder
runtime/                          libwave_runtime.so for mlir-runner tests
tools/{wave-opt,wave-translate,wave-symbols-test}/
test/{Dialect,Conversion,Target,Integration,python}/
examples/wave/                    Small kernels + the tiled WMMA matmul
third_party/ixsimpl/              Symbolic-offset engine (git submodule)
docs/                             Design proposal + scratch notes
```

## Building

LLVM/MLIR is pulled at the commit pinned in `llvm-commit.txt` (no
submodule; the dep is fetched and built by a helper script). The
ixsimpl symbolic engine ships as a git submodule under
`third_party/ixsimpl`.

```bash
# Fetch ixsimpl (clone with --recurse-submodules to skip this step).
git submodule update --init --recursive

# One-off: fetch + build LLVM/MLIR into build/llvm-install. Slow.
python build_tools/build_llvm.py -j$(nproc)

# Configure and build wave-mlir.
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

Environment overrides for callers who already have a usable LLVM:

| Variable | Meaning |
|---|---|
| `LLVM_INSTALL_DIR` | path to an existing LLVM install (`lib/cmake/{llvm,mlir}`) |
| `LLVM_PROJECT_SOURCE_DIR` | existing `llvm-project` source checkout (will be built) |
| `LLVM_COMMIT` | override the pinned commit |

The transform layer reaches into AMDGPU backend internals
(`lib/Target/AMDGPU/*` headers and their TableGen output), so the
LLVM source and build trees stay reachable from the configure step.
`WAVE_LLVM_PROJECT_SRC_DIR` / `WAVE_LLVM_PROJECT_BUILD_DIR` let you
point at out-of-tree LLVM trees if the defaults under `build/_deps/`
are not what you want.

## Running

`wave-opt` runs the Wave / WaveAMD / WaveAMDMachine passes individually;
`wave-translate --wave-to-amdgpu-asm` is the all-in-one frontend that
emits AMDGPU assembly. The matmul example runs end-to-end through
`mlir-runner` on an AMDGPU box with the ROCm runtime visible:

```bash
PIPELINES=build/share/wave-mlir/pipelines/pipelines.mlir
python examples/wave/wmma_matmul_tiled.py --m=64 --n=64 --k=48 --bm=2 --bn=2 --use-buffer \
  | build/bin/wave-opt --pass-pipeline="builtin.module(wave-set-target-attr{chip=gfx1100},transform-preload-library{transform-library-paths=${PIPELINES}},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)" \
  | build/llvm-install/bin/mlir-runner \
      --shared-libs=build/llvm-install/lib/libmlir_rocm_runtime.so \
      --shared-libs=build/llvm-install/lib/libmlir_runner_utils.so \
      --shared-libs=build/lib/libwave_runtime.so \
      --entry-point-result=void
```

The example can also run the full pipeline itself and compare the GPU
result against a deterministic CPU reference. This path fills A/B with
pseudo-random f16 values derived from `--seed`, runs `wave-opt` and
`mlir-runner`, then checks each output tile:

```bash
PYTHONPATH=build/python_packages/wave_mlir \
python examples/wave/wmma_matmul_tiled.py \
  --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 \
  --wave-k-tiles=2 --compare-cpu --seed=7
```

The Python builder uses `ixsimpl` (submoduled under `third_party/`)
as the symbolic engine for `wave.index_expr`; see the
"Symbolic Offset Algebra" section of the design doc.

## Development

Pre-commit covers formatting, lint, licensing, and complexity checks:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

Integration tests under `test/Integration/` need a real AMDGPU device
and `mlir-runner` with the ROCm runtime; the rest of the lit suite is
host-only.

Perf-sensitive assembly goldens live under `test/PerfGolden/`. Each
kernel has a small `test_*.py` script, checked-in `.s` golden, and
either frozen Wave input or deterministic generator args. Lit passes the
configured build root and tools, so these tests validate the current
build instead of a source-tree `build/` directory. On ASM drift, rerun
hardware perf for the old and new assembly before updating the golden.

```bash
build/bin/llvm-lit -sv build/test --filter='PerfGolden'
python -m pytest -q test/PerfGolden
```

## License

Apache-2.0 with LLVM exception. See `LICENSE.TXT`.

[`docs/AMDGPUExplicitWaveProgrammingModel.md`]: docs/AMDGPUExplicitWaveProgrammingModel.md
