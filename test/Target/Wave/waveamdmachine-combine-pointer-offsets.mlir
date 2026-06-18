// RUN: wave-opt --wave-combine-pointer-offsets %s | FileCheck %s --check-prefix=COMBINE
// RUN: wave-opt --wave-combine-pointer-offsets --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// COMBINE-LABEL: func.func @scalarized_ptr_add_memory_user
// COMBINE-SAME: (%[[OUT:.*]]: !wave.ptr<#wave.global, i32>, %[[LANE:.*]]: !wave.simd<i32, 32>)
// COMBINE: %[[OFF:.*]] = wave.index_expr <"4"> []() : () -> index
// COMBINE: %[[VOFF:.*]] = wave.splat %[[OFF]] : index -> !wave.simd<index, 32>
// COMBINE: %[[PTR:.*]] = wave.ptr_add %[[OUT]], %[[VOFF]] : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
// COMBINE-NOT: wave.splat {{.*}} : !wave.ptr<#wave.global, i32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
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

}
