// REQUIRES: host-supports-amdgpu-mfma, wave-python-bindings
//
// Runs the Python tiled matmul example on gfx9 MFMA hardware. `--chip`
// selects the MFMA fragment shape in auto mode; the kernel still stages
// fragments through LDS and writes the f32 accumulator via the
// fragment_unpack + tuple wave.store chain.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=64 --k=64 --bm=2 --bn=2 \
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
// CHECK-DAG: 64, 64, 64, 64
// CHECK-DAG: 256, 256, 256, 256
