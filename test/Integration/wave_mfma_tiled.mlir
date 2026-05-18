// REQUIRES: host-supports-amdgpu-mfma, wave-python-bindings
//
// Runs the Python tiled matmul example on gfx9 MFMA hardware. `--chip`
// selects the MFMA fragment shape in auto mode; the kernel still stages
// fragments through LDS and writes the f32 accumulator through the usual
// fragment_store path.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=64 --k=32 \
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
// CHECK-DAG: 16, 16, 16, 16, 16, 16, 16, 16
// CHECK-DAG: 32, 32, 32, 32, 32, 32, 32, 32
