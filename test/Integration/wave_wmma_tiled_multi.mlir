// REQUIRES: host-supports-amdgpu-wmma
//
// End-to-end check for the tiled WMMA f16xf16xf32 matmul with the
// post-`shri`/`muli` shape constraints relaxed:
//
//   * non-pow-2 K (48 = 3 K-tiles of 16, needs `muli` to scale the
//     per-lane base offset by K),
//   * `BM = BN = 2` (4 waves per workgroup; wave-id decomposition uses
//     `andi` + `shri`, and `M_blocks = N_blocks = 2` no longer needs to
//     be a power of two for the tile-coord math),
//
// so the pipeline exercises every new lowering path at once. Each
// per-K-step A/B fragment is staged through a per-wave LDS slot, so
// this test also exercises tuple `ds_store_b32` / `ds_load_b32`,
// `s_barrier`, and `wave.lds_size` -> `group_segment_fixed_size`
// (4 waves * 2 fragments * 1024 B = 8192 B) across the multi-wave
// shape and the `wavemachine.uniform_loop` back-edge -- the LGKM
// drain across iterations is the regression we exposed when the K
// loop became the only K accumulation shape.
//
// With the per-axis A/B fill (`A[i, :] = 1 if i<M/2 else 2`,
// `B[:, j] = 1 if j<N/2 else 2`) every output element is
// `C[i, j] = K * a(i) * b(j)` -- here `K=48`, so values are 48, 96, 192.
// We don't pin the exact tile-block layout (printMemrefF32 wraps on a
// single line); two checked substrings are enough evidence that
// non-trivial contributions from both A and B land in the result.
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --m=64 --n=64 --k=48 --bm=2 --bn=2 \
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
// CHECK-DAG: 48, 48, 48, 48, 48, 48, 48, 48
// CHECK-DAG: 192, 192, 192, 192, 192, 192, 192, 192
