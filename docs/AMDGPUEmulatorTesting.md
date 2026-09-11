# AMDGPU tests with Mirage and RocJITsu

Use Mirage to run Wave GPU kernels on an x86-64 Linux CPU. A physical AMD
GPU is not required. RocJITsu executes the generated GPU code through the
ROCm runtime. Use the simulator to check output values. Use target hardware
for performance measurements and hardware timing checks.

## Set up the simulator

Use the Python environment for the Wave build. The build must include
Python bindings, `wavec`, `mlir-runner`, and the MLIR runtime libraries.
See the build steps in the [README](../README.md).

From the repository root, run:

```bash
python build_tools/amdgpu_simulator.py setup
```

The helper installs SDK `10.1.0a20260909` in a separate virtual environment
under the build directory. It rebuilds the Wave tools and builds a separate
MLIR ROCm wrapper against the SDK's HIP 7 library. It uses the LLVM source
from the Wave build. Do not activate the SDK environment: the tests use the
Wave Python environment.

Use these options for a different build layout:

- `--build-dir`: configured Wave build directory; default: `build`.
- `--sdk-venv`: SDK virtual environment; default: `BUILD/simulator/sdk-venv`.
- `--llvm-source`: matching LLVM source; default: `BUILD/_deps/llvm-project`.
- `--cxx`: host C++ compiler command; default: `CXX`, or `c++` if unset.

These options apply to both `setup` and `test`. Repeat any custom options
when you run tests. Setup can be run again with the same SDK environment.
It installs the fixed version used by this guide.

## Run tests

Run the default smoke tests on all three targets:

```bash
python build_tools/amdgpu_simulator.py test
```

| Target | Configuration | Wave size | Default tests |
| --- | --- | --- | --- |
| gfx942 | `gfx942_cdna3.json` | 64 | SAXPY, f16 MFMA GEMM, bf16 MFMA GEMM |
| gfx950 | `gfx950_mi355x.json` | 64 | SAXPY, f16 MFMA GEMM |
| gfx1250 | `gfx1250_mi455x.json` | 32 | SAXPY, TDM GEMM |

SAXPY checks six sizes, including zero, one, a wave boundary, and multiple
waves. The GEMM tests compare random matrix results with a CPU reference.

Select targets or tests with repeated options:

```bash
python build_tools/amdgpu_simulator.py test --target gfx942 --target gfx950
python build_tools/amdgpu_simulator.py test \
  --target gfx942 --test wave_mfma_gfx942_bf16_runtime
python build_tools/amdgpu_simulator.py test \
  --target gfx1250 --test Integration/wave_gfx1250_tdm_gemm_runtime.mlir
```

A test basename selects a file under `test/Integration`. A path is relative
to `test/`. Each selected test runs on each selected target. With no
`--target` option, all three targets are selected.

The helper rebuilds the tools and wrapper before a test run. Use
`--skip-build` only when that build is current. Use `--timeout` to change
the 180-second limit for each command.

## Sessions and results

Each target gets a `rocminfo` check. The reported GPU must match the requested
target. Each test then gets a fresh Mirage session. The helper passes the
SDK libraries and session settings through lit to its child processes.
The Python examples also use the selected MLIR ROCm wrapper.

Each test must report exactly one `PASS`. An unsupported, skipped, missing,
or failed test causes a nonzero helper exit status. The helper continues
with the remaining tests after a test failure.

Results are stored under `BUILD/simulator/logs/run-*`. Each run records the
SDK version and target configurations. Each command has an `output.log` and
`command.json`. Its process status is stored in `exit-code.txt`. Each completed
lit invocation also has `results.json`.

Mirage needs short Unix socket names. The helper uses a short temporary
directory name and removes it after each session. If your temporary parent
directory is too long, select a shorter one with `--runtime-dir`.

## Diagnose a failure

- A wave-width error before launch is a compiler or generator failure.
  Generic gfx942 MFMA needs wave64 and four input elements per lane.
- A missing `libamdhip64.so.6` means a HIP 6 dependency remains. Run setup
  again and check the test's library selection. Do not create a HIP 6
  library alias for HIP 7: a search path cannot change the ABI dependency.
- Exit status 124 in `exit-code.txt` means the outer timeout expired.
  Keep the command, SDK version, target configuration, generated code, and log.
- A HIP crash does not identify its cause by itself. Reduce the kernel and
  distinguish emitted-code errors from runtime and simulator errors.

With the pinned SDK, gfx1250 TDM GEMM passed its CPU check. A separate
gfx1250 WMMA GEMM timed out; an instrumented retry crashed in
`hipStreamDestroy` after synchronization. That failure is not resolved.
To establish its cause, retain the HSACO, reproduce it with a direct HIP
runner, and compare runtime or simulator versions with that same HSACO.

Use small correctness cases before larger tests. Keep the SDK version fixed
when you compare results. The setup follows the
[IREE simulator test change](https://github.com/iree-org/iree/pull/24913).
See the [RocJITsu test corpus](https://github.com/ROCm/rocjitsu-test-corpus)
for simulator regression cases.
