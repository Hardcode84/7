// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @skip_reused_index_binding_names
// CHECK-NOT: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
func.func @skip_reused_index_binding_names(
    %out: !wave.ptr<#wave.global, i32>,
    %a_raw: i32,
    %b_raw: i32) attributes {wave.kernel} {
  %a = wave.assume %a_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %b = wave.assume %b_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off0 = wave.index_expr <"x + lid"> ["x", "lid"](%a, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %off1 = wave.index_expr <"-x + lid"> ["x", "lid"](%b, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %base, %off1
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @skip_i64_uniform_base_offset
// CHECK-NOT: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
func.func @skip_i64_uniform_base_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %x_raw: i64) attributes {wave.kernel} {
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i64
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base = wave.ptr_add %out, %x
      : !wave.ptr<#wave.global, i32>, i64 -> !wave.ptr<#wave.global, i32>
  %ptr = wave.ptr_add %base, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
