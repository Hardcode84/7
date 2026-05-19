// REQUIRES: host-supports-amdgpu-mfma, wave-python-bindings
//
// Runs the Python tiled matmul example on gfx9 MFMA hardware. `--chip`
// selects the MFMA fragment shape in auto mode; the kernel still stages
// fragments through LDS and writes the f32 accumulator through the usual
// fragment_store path.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=64 --k=48 --bm=2 --bn=2 \
// RUN:   | wave-opt --wave-compile-kernels='chip=%chip' \
// RUN:       --convert-scf-to-cf \
// RUN:       --gpu-to-llvm=use-bare-pointers-for-kernels=true \
// RUN:       --convert-to-llvm \
// RUN:       --reconcile-unrealized-casts \
// RUN:   | mlir-runner \
// RUN:       --shared-libs=%mlir_rocm_runtime \
// RUN:       --shared-libs=%mlir_runner_utils \
// RUN:       --shared-libs=%wave_runtime \
// RUN:       --entry-point-result=void \
// RUN:   | FileCheck %s
//
// CHECK-DAG: 48, 48, 48, 48
// CHECK-DAG: 192, 192, 192, 192
