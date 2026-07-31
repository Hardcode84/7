// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate --wave-to-amdgpu-asm %s > %t.s 2>/dev/null
// RUN: FileCheck %s --check-prefix=ASM --input-file=%t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 \
// RUN:   -filetype=obj %t.s -o /dev/null

// MACHINE-LABEL: func.func @bounded_pointer_carry
// MACHINE: %[[INITIAL:.*]] = waveamdmachine.ds_store_b32
// MACHINE: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// MACHINE-SAME: %[[INITIAL]]
// MACHINE: %[[VALUE:.*]], %[[READ:.*]] = waveamdmachine.ds_load_b32
// MACHINE-SAME: after %[[LOOP]]#2
// MACHINE: waveamdmachine.global_store_b32
// MACHINE-SAME: after %[[READ]]

// ASM-LABEL: bounded_pointer_carry:
// ASM: ds_store_b32
// ASM: s_cbranch_scc1
// ASM: ds_load_b32
// ASM: buffer_store_b32
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @bounded_pointer_carry(%out: !wave.ptr<#wave.global, i32>)
    attributes {
      wave.kernel,
      wave.lds_size = 1024 : i64,
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %initial_ptrs = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %root = wave.token : !wave.mem.token
  %initialized = wave.store %lane -> %initial_ptrs after %root
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  %result:2 = scf.for %i = %c0 to %c4 step %c1
      iter_args(%ptr = %lds, %dependency = %initialized)
      -> (!wave.ptr<#wave.shared, i32>, !wave.mem.token) : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"-3 + i <= 0">] : i32
    %next_offset = wave.index_expr <"64 - 64*Mod(i, 2)"> ["i"](%bounded)
        : (i32) -> index
    %next = wave.ptr_add %lds, %next_offset
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %next, %dependency
        : !wave.ptr<#wave.shared, i32>, !wave.mem.token
  }
  %load_ptrs = wave.ptr_add %result#0, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %read = wave.load %load_ptrs after %result#1
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %out_ptrs after %read
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
