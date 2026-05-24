// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// Same body as vmem_store_loop.mlir (scf.for of per-lane buffer stores,
// trip count `n_inner`) wrapped with `wave.read_cycles` reads. Counter
// values land in `out[0]` (t0, before the loop) and `out[1]` (t1, after
// the loop); body iters write to `out[lane + 2]` so they do not stomp
// the cycle slots. Host reads slots 0 and 1, computes
// `dt = (t1 - t0) & 0xFFFFF` to handle the 20-bit gfx11 wrap.
//
// gfx11 only -- wave.read_cycles lowers to s_getreg_b32
// hwreg(HW_REG_SHADER_CYCLES) which is RDNA3-only.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @vmem_store_loop_timed(%out: !wave.ptr<i32, #wave.global>,
                                  %n_inner: i32)
    attributes {wave.kernel} {
  // 256-byte range fits 64 i32 slots: 2 cycles + up to 62 lanes.
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>

  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c2 = arith.constant 2 : i32
  %c2_simd = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %body_idx = wave.addi %lane, %c2_simd
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %body_ptrs = wave.ptr_add %buffer, %body_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c0_simd = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1_simd = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %ptr_t0 = wave.ptr_add %buffer, %c0_simd
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %ptr_t1 = wave.ptr_add %buffer, %c1_simd
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %t0 = wave.read_cycles : i32
  %t0_simd = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %tok_t0 = wave.store %t0_simd -> %ptr_t0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token

  scf.for %i = %c0 to %n_inner step %c1 : i32 {
    %vi = wave.splat %i : i32 -> !wave.simd<i32, 32>
    %sum = wave.addi %lane, %vi
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok = wave.store %sum -> %body_ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
    scf.yield
  }

  %t1 = wave.read_cycles : i32
  %t1_simd = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok_t1 = wave.store %t1_simd -> %ptr_t1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  return
}

}
