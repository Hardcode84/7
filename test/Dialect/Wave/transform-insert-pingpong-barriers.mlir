// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' | FileCheck %s

// Two FU-regions (~19 VALU then ~19 SALU) cross the 16-op detector
// window, so partitionRegions splits them. The transform stamps an
// s_setprio at func entry and an s_barrier at the VALU/SALU boundary.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @two_regions
// CHECK: waveamdmachine.s_setprio %{{.+}} : (!waveamdmachine.imm) -> ()
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_barrier
// CHECK: waveamdmachine.s_add_i32
  func.func @two_regions(%a: !waveamdmachine.reg<vgpr, 1>, %b: !waveamdmachine.reg<vgpr, 1>) attributes {wave.kernel} {
    %v0 = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.v_add_u32 %v0, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.v_add_u32 %v1, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.v_add_u32 %v2, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v4 = waveamdmachine.v_add_u32 %v3, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v5 = waveamdmachine.v_add_u32 %v4, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v6 = waveamdmachine.v_add_u32 %v5, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v7 = waveamdmachine.v_add_u32 %v6, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v8 = waveamdmachine.v_add_u32 %v7, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v9 = waveamdmachine.v_add_u32 %v8, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v10 = waveamdmachine.v_add_u32 %v9, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v11 = waveamdmachine.v_add_u32 %v10, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v12 = waveamdmachine.v_add_u32 %v11, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v13 = waveamdmachine.v_add_u32 %v12, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v14 = waveamdmachine.v_add_u32 %v13, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v15 = waveamdmachine.v_add_u32 %v14, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v16 = waveamdmachine.v_add_u32 %v15, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v17 = waveamdmachine.v_add_u32 %v16, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v18 = waveamdmachine.v_add_u32 %v17, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %v19 = waveamdmachine.v_add_u32 %v18, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %i = waveamdmachine.imm 1 : !waveamdmachine.imm
    %s0 = waveamdmachine.s_mov_b32_value %i : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %s1:2 = waveamdmachine.s_add_i32 %s0#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s2:2 = waveamdmachine.s_add_i32 %s1#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s3:2 = waveamdmachine.s_add_i32 %s2#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s4:2 = waveamdmachine.s_add_i32 %s3#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s5:2 = waveamdmachine.s_add_i32 %s4#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s6:2 = waveamdmachine.s_add_i32 %s5#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s7:2 = waveamdmachine.s_add_i32 %s6#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s8:2 = waveamdmachine.s_add_i32 %s7#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s9:2 = waveamdmachine.s_add_i32 %s8#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s10:2 = waveamdmachine.s_add_i32 %s9#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s11:2 = waveamdmachine.s_add_i32 %s10#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s12:2 = waveamdmachine.s_add_i32 %s11#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s13:2 = waveamdmachine.s_add_i32 %s12#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s14:2 = waveamdmachine.s_add_i32 %s13#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s15:2 = waveamdmachine.s_add_i32 %s14#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s16:2 = waveamdmachine.s_add_i32 %s15#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s17:2 = waveamdmachine.s_add_i32 %s16#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s18:2 = waveamdmachine.s_add_i32 %s17#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %s19:2 = waveamdmachine.s_add_i32 %s18#0, %i : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }
  transform.named_sequence @__transform_main(%root: !transform.any_op {transform.readonly}) {
    wave.transform.insert_pingpong_barriers from %root : (!transform.any_op) -> ()
    transform.yield
  }
}
