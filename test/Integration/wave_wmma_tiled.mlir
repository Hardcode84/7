// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA iu8 matmul.
//
// The Python helper in examples/wave emits a `gpu.module` + host `main`
// for a 64x64 x 32x64 matmul tiled with 2x2 = 4 waves per workgroup
// (4 workgroups, 4 waves per workgroup → 16 16x16 tiles → 4096 i32s).
// Both A and B are filled with 1s via `waveamd.fragment_fill`, so each
// output element equals K=32 and the host-side `printMemrefI32` produces
// an uninterrupted run of `32, 32, 32, ...` values.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --m=64 --n=64 --k=32 --bm=2 --bn=2 \
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
// One 16-wide run of `32`s is enough evidence that the WMMA tiles
// computed the right value at the (otherwise irregularly-wrapped)
// `printMemrefI32` output.
// CHECK: 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
