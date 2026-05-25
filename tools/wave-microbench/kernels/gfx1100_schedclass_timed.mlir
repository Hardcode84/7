// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

// gfx1100 per-SchedClass probes. Each kernel stores t0/t1 in out[0]/out[1].

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @sched_salu_chain_timed(%out: !wave.ptr<i32, #wave.global>,
                                  %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %seed = wave.addi %n_inner, %c0 : i32, i32 -> i32

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %seed)
      -> (i32) : i32 {
    %a0 = wave.addi %acc, %c1 : i32, i32 -> i32
    %a1 = wave.addi %a0, %c1 : i32, i32 -> i32
    %a2 = wave.addi %a1, %c1 : i32, i32 -> i32
    %a3 = wave.addi %a2, %c1 : i32, i32 -> i32
    %a4 = wave.addi %a3, %c1 : i32, i32 -> i32
    %a5 = wave.addi %a4, %c1 : i32, i32 -> i32
    %a6 = wave.addi %a5, %c1 : i32, i32 -> i32
    %a7 = wave.addi %a6, %c1 : i32, i32 -> i32
    %a8 = wave.addi %a7, %c1 : i32, i32 -> i32
    %a9 = wave.addi %a8, %c1 : i32, i32 -> i32
    %a10 = wave.addi %a9, %c1 : i32, i32 -> i32
    %a11 = wave.addi %a10, %c1 : i32, i32 -> i32
    %a12 = wave.addi %a11, %c1 : i32, i32 -> i32
    %a13 = wave.addi %a12, %c1 : i32, i32 -> i32
    %a14 = wave.addi %a13, %c1 : i32, i32 -> i32
    %a15 = wave.addi %a14, %c1 : i32, i32 -> i32
    scf.yield %a15 : i32
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %rs = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %rs -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

func.func @sched_valu_chain_timed(%out: !wave.ptr<i32, #wave.global>,
                                  %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %lane)
      -> (!wave.simd<i32, 32>) : i32 {
    %a0 = wave.addi %acc, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a1 = wave.addi %a0, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a2 = wave.addi %a1, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a3 = wave.addi %a2, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a4 = wave.addi %a3, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a5 = wave.addi %a4, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a6 = wave.addi %a5, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a7 = wave.addi %a6, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a8 = wave.addi %a7, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a9 = wave.addi %a8, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a10 = wave.addi %a9, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a11 = wave.addi %a10, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a12 = wave.addi %a11, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a13 = wave.addi %a12, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a14 = wave.addi %a13, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a15 = wave.addi %a14, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %a15 : !wave.simd<i32, 32>
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %r -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

func.func @sched_vmem_store_timed(%out: !wave.ptr<i32, #wave.global>,
                                  %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %lane)
      -> (!wave.simd<i32, 32>) : i32 {
    %v0 = wave.addi %acc, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok0 = wave.store %v0 -> %pout
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
    %v1 = wave.addi %v0, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok1 = wave.store %v1 -> %pout after %tok0
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
          -> !wave.mem.token
    %v2 = wave.addi %v1, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok2 = wave.store %v2 -> %pout after %tok1
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
          -> !wave.mem.token
    %v3 = wave.addi %v2, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %tok3 = wave.store %v3 -> %pout after %tok2
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
          -> !wave.mem.token
    scf.yield %v3 : !wave.simd<i32, 32>
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %r -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

func.func @sched_lds_load_timed(%out: !wave.ptr<i32, #wave.global>,
                                %n_inner: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %lds_ptrs = wave.ptr_add %lds, %lane
      : !wave.ptr<i32, #wave.shared>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.shared>, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %seed = wave.store %lane -> %lds_ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.shared>, 32>)
        -> !wave.mem.token
  %ready = wave.barrier %seed : (!wave.mem.token) -> !wave.mem.token

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %lane)
      -> (!wave.simd<i32, 32>) : i32 {
    %l0:2 = wave.load %lds_ptrs after %ready
        : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
    %a0 = wave.addi %l0#0, %acc
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %l1:2 = wave.load %lds_ptrs after %l0#1
        : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
    %a1 = wave.addi %l1#0, %a0
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %l2:2 = wave.load %lds_ptrs after %l1#1
        : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
    %a2 = wave.addi %l2#0, %a1
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %l3:2 = wave.load %lds_ptrs after %l2#1
        : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
    %a3 = wave.addi %l3#0, %a2
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %a3 : !wave.simd<i32, 32>
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %r -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

func.func @sched_barrier_timed(%out: !wave.ptr<i32, #wave.global>,
                               %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %lane)
      -> (!wave.simd<i32, 32>) : i32 {
    %tok = wave.barrier : () -> !wave.mem.token
    %next = wave.addi %acc, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %r -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

func.func @sched_branch_loop_timed(%out: !wave.ptr<i32, #wave.global>,
                                   %n_inner: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c0s = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %c1s = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %c2s = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %p0 = wave.ptr_add %buffer, %c0s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %p1 = wave.ptr_add %buffer, %c1s
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %out_idx = wave.addi %lane, %c2s
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %pout = wave.ptr_add %buffer, %out_idx
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>

  %t0 = wave.read_cycles : i32
  %r = scf.for %i = %c0 to %n_inner step %c1 iter_args(%acc = %lane)
      -> (!wave.simd<i32, 32>) : i32 {
    %next = wave.addi %acc, %c1s
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  %t1 = wave.read_cycles : i32

  %t0s = wave.splat %t0 : i32 -> !wave.simd<i32, 32>
  %t1s = wave.splat %t1 : i32 -> !wave.simd<i32, 32>
  %tok0 = wave.store %t0s -> %p0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  %tok1 = wave.store %t1s -> %p1 after %tok0
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  %tok2 = wave.store %r -> %pout after %tok1
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

}
