// REQUIRES: host-supports-amdgpu-gfx942, wave-python-bindings
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip \
// RUN:   --m=64 --n=96 --k=64 --bm=2 --bn=1 --wave-m-tiles=2 --wave-n-tiles=3 --wave-k-tiles=2 \
// RUN:   --input-type=bf16 --output-layout=column-major --random-data --compare-cpu --seed=37 \
// RUN:   --shared-lib=%mlir_rocm_runtime --shared-lib=%mlir_runner_utils --shared-lib=%wave_runtime \
// RUN:   | FileCheck %s

// CHECK: CPU comparison passed: elements=6144 max_abs_diff=0.0
