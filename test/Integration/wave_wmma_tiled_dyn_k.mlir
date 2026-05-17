// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul where the K
// extent is plumbed at runtime through `scf.for` + the new
// `wavemachine.uniform_loop`. Uses the same per-axis 1.0/2.0 fill as
// the static-K test so the expected output ("32, 32, 32, 32, 64, 64,
// 64, 64" / "64, 64, 64, 64, 128, 128, 128, 128" for K=32) matches
// byte-for-byte.
//
// The kernel is lowered through:
//   scf.for ... iter_args(acc, a_ptr, b_ptr) -> ...
//        ^---- has {wave.nonzero_trip} so the selector skips the
//              entry s_cmp_lt_i32 and uses a post-tested loop.
//   -> wavemachine.uniform_loop %inits ... { ...wavemachine.continue_if ... }
//   -> AMDGPU assembly with s_cmp_lt_i32 / s_cbranch_scc0 (back-edge)
//      and a single loop head/tail label pair.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --dyn-k --m=16 --n=64 --k=32 \
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
// CHECK: 32, 32, 32, 32, 64, 64, 64, 64
// CHECK: 64, 64, 64, 64, 128, 128, 128, 128
