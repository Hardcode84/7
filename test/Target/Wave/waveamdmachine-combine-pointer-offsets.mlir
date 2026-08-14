// RUN: wave-opt --wave-combine-pointer-offsets %s | FileCheck %s --check-prefix=COMBINE
// RUN: wave-opt --wave-combine-pointer-offsets --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// COMBINE-LABEL: func.func @scalarized_ptr_add_memory_user
// COMBINE-SAME: (%[[OUT:.*]]: !wave.ptr<#wave.global, i32>, %[[LANE:.*]]: !wave.simd<i32, 32>)
// COMBINE: %[[OFF:.*]] = wave.index_expr <"4"> []() : () -> index
// COMBINE: %[[SIMD_OFF:.*]] = wave.splat %[[OFF]] : index -> !wave.simd<index, 32>
// COMBINE: %[[PTR:.*]] = wave.ptr_add %[[OUT]], %[[SIMD_OFF]] : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
// COMBINE: wave.store %[[LANE]] -> %[[PTR]]
// MACHINE-LABEL: func.func @scalarized_ptr_add_memory_user
// MACHINE: waveamdmachine.global_store_b32
func.func @scalarized_ptr_add_memory_user(
    %out: !wave.ptr<#wave.global, i32>,
    %lane: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %off = wave.index_expr <"floor(1/32*lid)"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %c4 = arith.constant 4 : index
  %ptr = wave.ptr_add %base, %c4
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, index
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// COMBINE-LABEL: func.func @buffer_i32_identity_offset_chain
// COMBINE: %[[OFF:.*]] = wave.index_expr <"4 + raw0">
// COMBINE: %[[PTR:.*]] = wave.ptr_add %{{.*}}, %[[OFF]]
// COMBINE: wave.store %{{.*}} -> %[[PTR]]
// MACHINE-LABEL: func.func @buffer_i32_identity_offset_chain
// MACHINE: waveamdmachine.buffer_store_b32
func.func @buffer_i32_identity_offset_chain(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %c4 = arith.constant 4 : index
  %base = wave.ptr_add %buffer, %c4
      : !wave.ptr<#waveamd.buffer, i32>, index
      -> !wave.ptr<#waveamd.buffer, i32>
  %idx = wave.index_expr <"raw0"> assuming
      [#wave.pred<"raw0 >= 0 & -31 + raw0 <= 0">] ["raw0"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %base, %idx
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %token = wave.store %raw -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// A shared proof-backed pointer prefix is selected once.  Its direct store and
// the derived pointer must consume the same material address DAG; rebuilding
// the lane scale for each memory operation is quadratic in packet width.
// MACHINE-LABEL: func.func @shared_pointer_address_dag
// MACHINE-COUNT-1: waveamdmachine.v_lshlrev_b32
// MACHINE-COUNT-2: waveamdmachine.global_store_b32
func.func @shared_pointer_address_dag(
    %out: !wave.ptr<#wave.global, i32>,
    %lane: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %off = wave.index_expr <"lid"> assuming
      [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %common = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %c1 = arith.constant 1 : index
  %next = wave.ptr_add %common, %c1
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, index
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token0 = wave.store %lane -> %common
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %token1 = wave.store %lane -> %next after %token0
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
