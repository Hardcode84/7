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

// CHECK-LABEL: func.func @promote_bounded_loop_index_binding
// CHECK: waveamd.make_buffer
// CHECK: scf.for
// CHECK: wave.index_expr <"32 + 32*i + 128*Mod(lane, 16)"> ["i", "lane"]
// CHECK: wave.load {{%.*}} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>)
func.func @promote_bounded_loop_index_binding(
    %in: !wave.ptr<#wave.global, f16>, %trip_raw: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %trip = wave.assume %trip_raw as "n"
      [#wave.pred<"n >= 0">, #wave.pred<"n <= 3">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %c0 to %trip step %c1 : i32 {
    %offset = wave.index_expr <"32 + 32*i + 128*Mod(lane, 16)">
        ["i", "lane"](%i, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptr = wave.ptr_add %in, %offset
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %value, %token = wave.load %ptr
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    scf.yield
  }
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_i64_uniform_base_offset
// CHECK: waveamd.make_buffer
// CHECK: wave.index_expr <"raw0"> assuming
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
func.func @promote_i64_uniform_base_offset(
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
