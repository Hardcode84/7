# AMDGPU tests with Mirage and RocJITsu

Use Mirage to run Wave GPU kernels on an x86-64 Linux CPU. A physical AMD
GPU is not required. RocJITsu executes the generated GPU code through the
ROCm runtime.

Use these tests to check output values. Use target hardware for performance
measurements and hardware timing checks.

## Prepare the build and SDK

Run the commands from the repository root in Bash. Use the Python environment
for the Wave build. The build must include Python bindings, `wavec`,
`mlir-runner`, and the MLIR runtime libraries. See the build steps in the
[README](../README.md).

The commands use a separate SDK environment. Do not activate it: the tests
must use the Wave Python environment.

```bash
set -euo pipefail

WAVE_ROOT=$(pwd)
WAVE_BUILD=$(realpath "${WAVE_BUILD:-build}")
WAVE_PYTHON=$(command -v python)
SIM_WORK="$WAVE_BUILD/simulator"
SIM_VENV="${SIM_VENV:-$SIM_WORK/sdk-venv}"
WAVE_LLVM_SOURCE="${WAVE_LLVM_SOURCE:-$WAVE_BUILD/_deps/llvm-project}"
mkdir -p "$SIM_WORK/logs"

cmake --build "$WAVE_BUILD" \
  --target wave-opt wave-translate WavePythonModules wavec -j "$(nproc)"

"$WAVE_PYTHON" -m venv "$SIM_VENV"
"$SIM_VENV/bin/python" -m pip install --pre \
  --index-url https://nightly.repo.amd.com/rocm/whl-next/ \
  'rocm[libraries,devel]==10.1.0a20260909'
"$SIM_VENV/bin/rocm-sdk" init
"$SIM_VENV/bin/rocm-sdk" version
ROCM_ROOT=$("$SIM_VENV/bin/rocm-sdk" path --root)
"$ROCM_ROOT/bin/mirage" --version
```

This SDK version supplies these configurations:

| Target | Configuration | Wave size |
| --- | --- | --- |
| gfx942 | `gfx942_cdna3.json` | 64 |
| gfx950 | `gfx950_mi355x.json` | 64 |
| gfx1250 | `gfx1250_mi455x.json` | 32 |

Keep the version fixed when you compare results. The installation method and
configuration names follow the [IREE simulator test change](https://github.com/iree-org/iree/pull/24913).

## Build the MLIR ROCm wrapper

The pinned SDK supplies HIP 7. A Wave build can have an MLIR ROCm wrapper
linked to HIP 6. A library search path does not change that dependency.
Build a separate wrapper from the LLVM source used by the Wave build.
Set `WAVE_LLVM_SOURCE` if that source is stored elsewhere.

```bash
"${CXX:-c++}" -shared -fPIC -O2 -D__HIP_PLATFORM_AMD__ \
  -I "$ROCM_ROOT/include" \
  -I "$WAVE_BUILD/llvm-install/include" \
  "$WAVE_LLVM_SOURCE/mlir/lib/ExecutionEngine/RocmRuntimeWrappers.cpp" \
  -L "$ROCM_ROOT/lib" -lamdhip64 \
  -o "$SIM_WORK/libmlir_rocm_runtime.so"

LD_LIBRARY_PATH="$ROCM_ROOT/lib" \
  ldd "$SIM_WORK/libmlir_rocm_runtime.so"
```

Check that `libamdhip64.so.7` and `libhsa-runtime64.so.1` resolve to the
selected SDK. Do not create a HIP 6 library alias for HIP 7.

## Start one session per test

Define these functions in the same shell. Each command gets a new simulator
session, a separate log directory, and a 180-second timeout. The shell keeps
the command's failure status through `tee`.

```bash
run_sim() (
  set -euo pipefail
  local target=$1
  local label=$2
  shift 2
  local config_name
  case "$target" in
    gfx942) config_name=gfx942_cdna3.json ;;
    gfx950) config_name=gfx950_mi355x.json ;;
    gfx1250) config_name=gfx1250_mi455x.json ;;
    *) echo "Unsupported simulator target: $target" >&2; exit 2 ;;
  esac

  local sim_runtime
  local log_dir
  sim_runtime=$(mktemp -d -t wsim.XXXXXX)
  trap 'rm -rf -- "$sim_runtime"' EXIT
  log_dir=$(mktemp -d "$SIM_WORK/logs/$target-$label.XXXXXX")
  echo "Log: $log_dir/output.log"

  MIRAGE_RUNTIME="$sim_runtime" \
  timeout --signal=TERM --kill-after=10 180 \
    "$ROCM_ROOT/bin/mirage" run \
    --config "$ROCM_ROOT/share/rocjitsu/configs/$config_name" \
    --workdir "$WAVE_ROOT" \
    --env "PATH=$ROCM_ROOT/bin:$PATH" \
    --env "LD_LIBRARY_PATH=$ROCM_ROOT/lib" \
    --env "ROCM_LIB=$ROCM_ROOT/lib" \
    --env "HIP_RUNTIME_LIB=$ROCM_ROOT/lib/libamdhip64.so" \
    --env "MLIR_ROCM_RUNTIME=$SIM_WORK/libmlir_rocm_runtime.so" \
    -- "$@" 2>&1 | tee "$log_dir/output.log"
)

run_sim_test() (
  set -euo pipefail
  local target=$1
  local test_name=$2
  run_sim "$target" "$test_name" \
    "$WAVE_BUILD/bin/llvm-lit" -sv -j 1 \
    --pass-env=ROCM_LIB \
    --pass-env=HIP_RUNTIME_LIB \
    --pass-env=MLIR_ROCM_RUNTIME \
    --pass-env=ROCJITSU_RUNTIME_DIR \
    --pass-env=MIRAGE_RUNTIME \
    --pass-env=MIRAGE_SESSION \
    "$WAVE_BUILD/test/Integration/$test_name.mlir"
)
```

Keep the temporary directory name short. Mirage creates a Unix socket below
it. A long name can exceed the socket address limit and prevent daemon
startup. If `TMPDIR` is set, use a short temporary directory for it.

Lit must run inside the session. Its `rocminfo` probe then selects the
simulated target for `%chip` and the `REQUIRES` features. The SDK `bin`
directory must come first in the process search path.

Lit preserves `LD_PRELOAD` and `LD_LIBRARY_PATH`. The `--pass-env` options
preserve the other simulator and library settings. Without them, a child
process can lose its simulator session or select a different HIP library.

## Check the target and run smoke tests

```bash
run_sim gfx942 target "$ROCM_ROOT/bin/rocminfo"
run_sim gfx950 target "$ROCM_ROOT/bin/rocminfo"
run_sim gfx1250 target "$ROCM_ROOT/bin/rocminfo"

run_sim_test gfx942 wavec_saxpy_runtime
run_sim_test gfx950 wavec_saxpy_runtime
run_sim_test gfx1250 wavec_saxpy_runtime

run_sim_test gfx942 wave_mfma_tiled
run_sim_test gfx942 wave_mfma_gfx942_bf16_runtime
run_sim_test gfx950 wave_mfma_tiled
```

Check that each target probe reports the requested `gfx` target. Each lit
invocation must report one passed test. An unsupported or skipped test does
not establish correct execution.

SAXPY checks six sizes, including zero, one, a wave boundary, and multiple
waves. The MFMA tests compare random matrix results with a CPU reference.

## Run a Python example directly

The `MLIR_ROCM_RUNTIME` setting controls lit's `%mlir_rocm_runtime`
substitution. Python examples use their build's runtime libraries unless
you pass `--shared-lib`. Supply all three libraries when you override them.

For example, run the gfx1250 TDM GEMM with a CPU result check:

```bash
run_sim gfx1250 tdm-gemm \
  "$WAVE_PYTHON" "$WAVE_ROOT/examples/wave/gfx1250_tdm_matmul.py" \
  --chip=gfx1250 --m=32 --n=32 --k=64 \
  --random-data --compare-cpu --seed=41 \
  --wave-opt="$WAVE_BUILD/bin/wave-opt" \
  --shared-lib="$SIM_WORK/libmlir_rocm_runtime.so" \
  --shared-lib="$WAVE_BUILD/llvm-install/lib/libmlir_runner_utils.so" \
  --shared-lib="$WAVE_BUILD/lib/libwave_runtime.so"
```

This check must report `CPU comparison passed: values=1024`.

## Diagnose a failure

- A wave-width error before launch is a compiler or generator failure.
  Generic gfx942 MFMA needs wave64 and four input elements per lane.
- A missing `libamdhip64.so.6` means a HIP 6 dependency remains. Check the
  wrapper and the libraries selected by the test. Do not mask the ABI mismatch.
- Exit status 124 means the outer timeout expired. Keep the failing command,
  SDK version, target configuration, generated code, and log.
- A HIP crash does not identify its cause by itself. Reduce the failing kernel
  and distinguish emitted-code errors from runtime and simulator errors.

With the pinned SDK, gfx1250 TDM GEMM passed its CPU check. A separate
gfx1250 WMMA GEMM timed out; an instrumented retry crashed in
`hipStreamDestroy` after synchronization. That failure is not resolved.
To establish its cause, retain the HSACO, reproduce it with a direct HIP
runner, and compare runtime or simulator versions with that same HSACO.

Use small correctness cases before larger tests. Run each selected test in
its own session. See the [RocJITsu test corpus](https://github.com/ROCm/rocjitsu-test-corpus)
for simulator regression cases.
