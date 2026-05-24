// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// Microbench: per-lane buffer store inside an scf.for of runtime
// trip count `n_inner`. Wave-microbench harness drives this via
// `--inner N` (which becomes `--args=2 --x N` for the runner).
//
// Per-iter work: splat(i) -> vadd lane,i -> store @ buffer[lane].
// Same address every iter; value depends on `i` so the compiler
// cannot collapse the stores.
//
// Wave32 / gfx10+; harness substitutes the detected chip into
// the gfx1100 token at lower time. Range=128 keeps the buffer
// within 32 i32 slots.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @vmem_store_loop(%out: !wave.ptr<i32, #wave.global>, %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %c0 to %n_inner step %c1 : i32 {
    %vi = wave.splat %i : i32 -> !wave.simd<i32, 32>
    %sum = wave.addi %lane, %vi
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok = wave.store %sum -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
    scf.yield
  }
  return
}

}
