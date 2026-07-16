// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @regalloc_transform_loop_lds_spills_post_failure_use(
  // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
  // CHECK-SAME: waveamdmachine.metadata = [{name = "wave.regalloc.iterations", value = 2 : i64}
  // CHECK-SAME: {name = "wave.regalloc.agpr.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.remat.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.sgpr_to_vgpr.dwords", value = 0 : i64}
  // CHECK-SAME: {name = "wave.regalloc.lds.dwords", value = 1 : i64}
  // CHECK-SAME: {name = "wave.regalloc.scratch.dwords", value = 0 : i64}
  // CHECK-SAME: waveamdmachine.regalloc_assignments
  // CHECK-SAME: waveamdmachine.regalloc_transform_state =
  // CHECK-SAME: stage = "linear-scan-success"
  // CHECK: waveamdmachine.ds_store_addtid_b32
  // CHECK: waveamdmachine.ds_load_addtid_b32
  // CHECK: waveamdmachine.s_endpgm
  func.func @regalloc_transform_loop_lds_spills_post_failure_use()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.vgpr_count_max = 4 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
    %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %spill, %tok1 = waveamdmachine.global_load_tuple_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %parts:2 = waveamdmachine.tuple_to_elements %spill
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %use0 = waveamdmachine.v_add_u32 %parts#0, %sum
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_add_u32 %use0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.s_endpgm
    return
  }

  // CHECK-LABEL: func.func @regalloc_transform_loop_lds_restores_cloned_body_m0(
  // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1,
  // CHECK: [[USER_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
  // CHECK-NEXT: [[SPILL_M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[SPILL_M0]]
  // CHECK-NEXT: [[RESTORED_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 [[RELOAD]], {{%.*}}, {{%.*}}, [[RESTORED_M0]]
  // CHECK: } {fetch_alignment = 32 : i64, fetch_phase = 16 : i64}
  func.func @regalloc_transform_loop_lds_restores_cloned_body_m0()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                  waveamdmachine.vgpr_count_max = 4 : i64,
                  waveamdmachine.agpr_count_max = 0 : i64} {
    %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
    %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
    %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %carry_init, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %hot, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
        : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
        : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    %loop = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry_init : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<vgpr, 1>):
      %a, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
      %dma = waveamdmachine.buffer_load_lds_b32
          %carry, %desc, %zero, %m0 after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %b, %tok4 = waveamdmachine.global_load_b32 %off, %base after %dma
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use_hot = waveamdmachine.v_add_u32 %hot, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 1>)
    } {fetch_alignment = 32 : i64, fetch_phase = 16 : i64}
        -> !waveamdmachine.reg<vgpr, 1>
    %use_result = waveamdmachine.v_add_u32 %loop, %hot
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.s_endpgm
    return
  }
}
