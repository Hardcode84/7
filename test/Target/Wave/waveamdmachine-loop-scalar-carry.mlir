// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,canonicalize,cse,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-hazard-waits,waveamd-resource-info,waveamd-metadata)' | FileCheck %s --check-prefix=PIPE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// The SIMD pointer result type comes from the lane binding, but IRA
// proves `floor(lid / 32) == 0`; the carried offset stays SGPR-side.
// CHECK-LABEL: func.func @uniform_buffer_pointer_carry
// CHECK: %[[WG:.*]] = waveamdmachine.s_workgroup_id_x
// CHECK: %[[SO:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WG]],
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop {{.*}} carries(%{{.*}}, %[[SO]], %{{[^ ]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[CARRY:[^:]+]]: !waveamdmachine.reg<sgpr, 1>, %{{[^:]+}}: !waveamdmachine.mem.token):
// CHECK: waveamdmachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %[[CARRY]]
// CHECK: %[[NEXT:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[CARRY]],
// CHECK: waveamdmachine.continue_if {{.*}} carries(%{{.*}}, %[[NEXT]], %{{[^ ]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: waveamdmachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %[[LOOP]]#1
// CHECK-NOT: waveamdmachine.v_add_u32
//
// PIPE-LABEL: func.func @uniform_buffer_pointer_carry
// PIPE: waveamdmachine.uniform_loop
// PIPE: waveamdmachine.buffer_store_b32
func.func @uniform_buffer_pointer_carry(%a: !wave.ptr<#wave.global, i32>,
                                        %n: i32, %range: i32, %x: i32) -> (!wave.mem.token, !wave.mem.token) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %n_bounded = wave.assume %n as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buf = waveamd.make_buffer %a, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wg_raw = wave.workgroup_id 0
  %wg = wave.assume %wg_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %off = wave.index_expr <"floor(1/32*lid) + wg"> ["lid", "wg"] (%lane, %wg)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %observe_seed_1 = wave.token : !wave.mem.token
  %res, %observe_region_2 = scf.for %i = %c0 to %n_bounded step %c1 iter_args(%q = %p0, %observe_carry_3 = %observe_seed_1)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) : i32  {
    %tok = wave.store %vx -> %q
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    %nq = wave.ptr_add %q, %c1
        : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %observe_join_4 = wave.join %observe_carry_3, %tok : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %nq, %observe_join_4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token
  }
  %tok2 = wave.store %vx -> %res
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return %tok2, %observe_region_2 : !wave.mem.token, !wave.mem.token
}

// CHECK-LABEL: func.func @workgroup_id_loop_lower
// CHECK: %[[WG:.*]] = waveamdmachine.s_workgroup_id_x : !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: %[[INIT:.*]] = waveamdmachine.s_mov_b32_value %[[WG]] : (!waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>) -> !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.uniform_loop {{.*}} carries(%[[INIT]], %{{[^ ]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: ^bb0(%[[IV:[^:]+]]: !waveamdmachine.reg<sgpr, 1>, %{{[^:]+}}: !waveamdmachine.mem.token):
// CHECK: %[[NEXT:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[IV]],
// CHECK: waveamdmachine.continue_if {{.*}} carries(%[[NEXT]], %{{[^ ]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
func.func @workgroup_id_loop_lower(%out: !wave.ptr<#wave.global, i32>,
                                   %n: i32) -> !wave.mem.token attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wg = wave.workgroup_id 0
  %observe_seed_5 = wave.token : !wave.mem.token
  %observe_region_6 = scf.for %i = %wg to %n step %c1 iter_args(%observe_carry_7 = %observe_seed_5) -> (!wave.mem.token) : i32  {
    %ptrs = wave.ptr_add %out, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    %observe_join_8 = wave.join %observe_carry_7, %tok : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %observe_join_8 : !wave.mem.token
  }
  return %observe_region_6 : !wave.mem.token
}

}
