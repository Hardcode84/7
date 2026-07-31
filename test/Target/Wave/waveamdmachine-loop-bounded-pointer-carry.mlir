// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

// CHECK-LABEL: func.func @shared_absolute_symbolic_carry
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>):
// CHECK: waveamdmachine.ds_store_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_symbolic_carry()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %result = scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %lds)
      -> (!wave.ptr<#wave.shared, i32>) : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"-3 + i <= 0">] : i32
    %next_offset = wave.index_expr <"64 - 64*Mod(i, 2)"> ["i"](%bounded)
        : (i32) -> index
    %next = wave.ptr_add %lds, %next_offset
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %result, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>) -> !wave.mem.token
  return
}
}

// CHECK-LABEL: func.func @shared_permuted_pointer_carries
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 1>):
// CHECK: waveamdmachine.ds_store_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_permuted_pointer_carries()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c64 = arith.constant 64 : index
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %slot1 = wave.ptr_add %lds, %c64
      : !wave.ptr<#wave.shared, i32>, index
      -> !wave.ptr<#wave.shared, i32>
  %result:2 = scf.for %i = %c0 to %c4 step %c1
      iter_args(%current = %lds, %next = %slot1)
      -> (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>) : i32 {
    scf.yield %next, %current
        : !wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>
  }
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %result#0, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>) -> !wave.mem.token
  return
}
}

// CHECK-LABEL: func.func @shared_absolute_cast_carry
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.ds_store_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_cast_carry()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %bytes = wave.ptr_cast %lds
      : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
  %result = scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %lds)
      -> (!wave.ptr<#wave.shared, i32>) : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"-3 + i <= 0">] : i32
    %next_offset = wave.index_expr <"256 - 256*Mod(i, 2)"> ["i"](%bounded)
        : (i32) -> index
    %next_byte = wave.ptr_add %bytes, %next_offset
        : !wave.ptr<#wave.shared, i8>, index
        -> !wave.ptr<#wave.shared, i8>
    %next = wave.ptr_cast %next_byte
        : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %result, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>) -> !wave.mem.token
  return
}
}
