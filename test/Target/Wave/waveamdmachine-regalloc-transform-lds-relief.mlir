// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=lds_relief})' | FileCheck %s

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @lds_relief(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    %r2 = wave.transform.regalloc_agpr_relief from %r1
        : (!transform.any_op) -> !transform.any_op
    %r3 = wave.transform.regalloc_remat_relief from %r2
        : (!transform.any_op) -> !transform.any_op
    %r4 = wave.transform.regalloc_lds_relief from %r3
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
    // CHECK-LABEL: func.func @lds_relief_spills_post_failure_use(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[OFF:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[LANE:%.*]] = waveamdmachine.v_readfirstlane_b32 [[OFF]]
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 2
    // CHECK: [[BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32 [[LANE]], [[SHIFT]]
    // CHECK: [[SPILL:%.*]], [[SPILLTOK:%.*]] = waveamdmachine.global_load_b32 [[OFF]]
    // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[M0]], [[SPILL]] after [[SPILLTOK]]
    // CHECK: [[RELOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[RELOAD_M0]] after [[STORE]]
    // CHECK: waveamdmachine.v_add_u32 [[RELOAD]],
    func.func @lds_relief_spills_post_failure_use()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_reloads_before_m0_user_setup(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[SPILL:%.*]], [[SPILLTOK:%.*]] = waveamdmachine.global_load_b32
    // CHECK: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]], [[SPILL]] after [[SPILLTOK]]
    // CHECK: [[RELOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[RELOAD_M0]] after [[STORE]]
    // CHECK: [[DMA_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK-NEXT: waveamdmachine.buffer_load_lds_b32 [[RELOAD]], {{%.*}}, {{%.*}}, [[DMA_M0]]
    func.func @lds_relief_reloads_before_m0_user_setup()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
      %dma = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %m0
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_restores_live_mov_m0(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[DMA_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK: waveamdmachine.global_load_b32
    // CHECK: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]],
    // CHECK-NEXT: [[RESTORED_STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    // CHECK-NEXT: [[RESTORED_LOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK: waveamdmachine.buffer_load_lds_b32 {{.*}}, {{.*}}, {{.*}}, [[RESTORED_LOAD_M0]]
    func.func @lds_relief_restores_live_mov_m0()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %dma = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %m0
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_restores_live_add_m0_and_scc(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[INC:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[DMA_M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[DST]], [[INC]]
    // CHECK: [[CMP:%.*]] = waveamdmachine.s_cmp_lt_i32 [[DST]], [[INC]]
    // CHECK: waveamdmachine.global_load_b32
    // CHECK: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]],
    // CHECK: [[SAVED_SCC:%.*]] = waveamdmachine.s_cselect_b32 [[CMP]],
    // CHECK: [[RESTORED_STORE_M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[DST]], [[INC]]
    // CHECK: [[RESTORED_STORE_SCC:%.*]] = waveamdmachine.s_cmp_lg_u32 [[SAVED_SCC]],
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    // CHECK: [[SAVED_RESTORED_SCC:%.*]] = waveamdmachine.s_cselect_b32 [[RESTORED_STORE_SCC]],
    // CHECK: [[RESTORED_LOAD_M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[DST]], [[INC]]
    // CHECK: [[RESTORED_LOAD_SCC:%.*]] = waveamdmachine.s_cmp_lg_u32 [[SAVED_RESTORED_SCC]],
    // CHECK: waveamdmachine.buffer_load_lds_b32 {{.*}}, {{.*}}, {{.*}}, [[RESTORED_LOAD_M0]]
    // CHECK: waveamdmachine.s_cbranch_scc1 [[RESTORED_LOAD_SCC]]
    func.func @lds_relief_restores_live_add_m0_and_scc()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %inc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %m0, %m0_scc = waveamdmachine.s_add_m0_i32 %dst, %inc
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %cmp = waveamdmachine.s_cmp_lt_i32 %dst, %inc
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<scc, 1>
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %dma = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %m0
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.s_cbranch_scc1 %cmp
          : !waveamdmachine.reg<scc, 1>, "taken"
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_prefers_outside_loop_bridges(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[OFF:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[LANE:%.*]] = waveamdmachine.v_readfirstlane_b32 [[OFF]]
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 2
    // CHECK: [[BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32 [[LANE]], [[SHIFT]]
    // CHECK: [[CARRY:%.*]], [[CARRYTOK:%.*]] = waveamdmachine.global_load_b32 [[OFF]]
    // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[M0]], [[CARRY]] after [[CARRYTOK]]
    // CHECK: [[LOOP:%.*]] = waveamdmachine.uniform_loop
    // CHECK-SAME: carries([[STORE]] : !waveamdmachine.mem.token)
    // CHECK: waveamdmachine.continue_if
    // CHECK-SAME: carries({{%.*}} : !waveamdmachine.mem.token)
    // CHECK: [[RELOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK-NEXT: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[RELOAD_M0]] after [[LOOP]]
    // CHECK: waveamdmachine.v_add_u32 [[RELOAD]],
    func.func @lds_relief_prefers_outside_loop_bridges()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
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
        %b, %tok4 = waveamdmachine.global_load_b32 %off, %base after %tok3
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
      } -> !waveamdmachine.reg<vgpr, 1>
      %use_carry = waveamdmachine.v_add_u32 %loop, %hot
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_accounts_dynamic_lds(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
    // CHECK: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]],
    // CHECK-NOT: offset 1024
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[BASE]]
    // CHECK: waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    // CHECK-NOT: offset 1024
    func.func @lds_relief_accounts_dynamic_lds()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_folds_dynamic_vgpr_addresses(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 1280
    // CHECK-NOT: waveamdmachine.imm 512
    // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32 {{%.*}}, [[SHIFT]]
    // CHECK-COUNT-2: waveamdmachine.ds_store_b32 [[ADDR]],
    // CHECK-NOT: waveamdmachine.v_add_u32 [[ADDR]],
    func.func @lds_relief_folds_dynamic_vgpr_addresses()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %half = waveamdmachine.imm 512 : !waveamdmachine.imm
      %half_addr = waveamdmachine.v_add_u32 %off, %half
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %addr = waveamdmachine.v_add_u32 %half_addr, %half
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %lds0 = waveamdmachine.ds_store_b32 %addr, %off after %tok0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %lds1 = waveamdmachine.ds_store_b32 %addr, %off after %lds0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %lds1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_preserves_live_vgpr_addresses(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[OFF:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[DYNAMIC:%.*]] = waveamdmachine.imm 1024
    // CHECK: [[OLD_ADDR:%.*]] = waveamdmachine.v_add_u32 [[OFF]], [[DYNAMIC]]
    // CHECK: [[LIVE:%.*]] = waveamdmachine.v_add_u32 [[OLD_ADDR]], [[OFF]]
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 1280
    // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32 [[OFF]], [[SHIFT]]
    // CHECK: waveamdmachine.ds_store_b32 [[ADDR]], [[LIVE]]
    // CHECK: waveamdmachine.ds_store_b32 [[ADDR]], [[OFF]]
    func.func @lds_relief_preserves_live_vgpr_addresses()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %dynamic = waveamdmachine.imm 1024 : !waveamdmachine.imm
      %addr = waveamdmachine.v_add_u32 %off, %dynamic
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %live = waveamdmachine.v_add_u32 %addr, %off
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>)
            -> !waveamdmachine.reg<vgpr, 1>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %lds0 = waveamdmachine.ds_store_b32 %addr, %live after %tok0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %lds1 = waveamdmachine.ds_store_b32 %addr, %off after %lds0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %lds1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_checks_vgpr_address_overflow(
    // CHECK-SAME: wave.dynamic_lds_size = 256 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK-NOT: waveamdmachine.imm 4294967039
    // CHECK: [[OFF:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[OVERFLOW_IMM:%.*]] = waveamdmachine.imm 4294967040
    // CHECK: [[OVERFLOW_BASE:%.*]] = waveamdmachine.v_add_u32
    // CHECK-SAME: [[OFF]], [[OVERFLOW_IMM]]
    // CHECK: [[FIT_IMM:%.*]] = waveamdmachine.imm 4294967295
    // CHECK: [[FIT_ADDR:%.*]] = waveamdmachine.v_add_u32 [[OFF]], [[FIT_IMM]]
    // CHECK: waveamdmachine.ds_store_b32 [[FIT_ADDR]],
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 256
    // CHECK: [[OVERFLOW_ADDR:%.*]] = waveamdmachine.v_add_u32
    // CHECK-SAME: [[OVERFLOW_BASE]], [[SHIFT]]
    // CHECK: waveamdmachine.ds_store_b32 [[OVERFLOW_ADDR]],
    // CHECK-NOT: waveamdmachine.imm 4294967039
    func.func @lds_relief_checks_vgpr_address_overflow()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 256 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %fit_imm = waveamdmachine.imm 4294967039 : !waveamdmachine.imm
      %fit_addr = waveamdmachine.v_add_u32 %off, %fit_imm
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %overflow_imm = waveamdmachine.imm 4294967040 : !waveamdmachine.imm
      %overflow_addr = waveamdmachine.v_add_u32 %off, %overflow_imm
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %lds0 = waveamdmachine.ds_store_b32 %fit_addr, %off after %tok0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %lds1 = waveamdmachine.ds_store_b32 %overflow_addr, %off after %lds0
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %lds1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_scopes_vgpr_addresses_to_blocks(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK-NOT: waveamdmachine.imm 1024
    // CHECK: waveamdmachine.uniform_if
    // CHECK: [[THEN_SHIFT:%.*]] = waveamdmachine.imm 1280
    // CHECK: [[THEN_ADDR:%.*]] = waveamdmachine.v_add_u32
    // CHECK-SAME: {{%.*}}, [[THEN_SHIFT]]
    // CHECK: [[THEN_STORE:%.*]] = waveamdmachine.ds_store_b32 [[THEN_ADDR]],
    // CHECK: waveamdmachine.yield [[THEN_STORE]]
    // CHECK: otherwise
    // CHECK: [[ELSE_SHIFT:%.*]] = waveamdmachine.imm 1280
    // CHECK: [[ELSE_ADDR:%.*]] = waveamdmachine.v_add_u32
    // CHECK-SAME: {{%.*}}, [[ELSE_SHIFT]]
    // CHECK: [[ELSE_STORE:%.*]] = waveamdmachine.ds_store_b32 [[ELSE_ADDR]],
    // CHECK: waveamdmachine.yield [[ELSE_STORE]]
    func.func @lds_relief_scopes_vgpr_addresses_to_blocks()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %dynamic = waveamdmachine.imm 1024 : !waveamdmachine.imm
      %addr = waveamdmachine.v_add_u32 %off, %dynamic
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %joined = waveamdmachine.uniform_if %cond {
        %then = waveamdmachine.ds_store_b32 %addr, %off after %tok0
            : (!waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1, 0>,
               !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
        waveamdmachine.yield %then : !waveamdmachine.mem.token
      } otherwise {
        %else = waveamdmachine.ds_store_b32 %addr, %off after %tok0
            : (!waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1, 0>,
               !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
        waveamdmachine.yield %else : !waveamdmachine.mem.token
      } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %joined
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_shifts_dynamic_dma_m0_once(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[INC:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[CMP:%.*]] = waveamdmachine.s_cmp_lt_i32 [[DST]], [[INC]]
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[SAVED:%.*]] = waveamdmachine.s_cselect_b32 [[CMP]], [[ONE]], [[ZERO]]
    // CHECK: [[SUM:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[DST]], [[INC]]
    // CHECK: [[DYN_SHIFT:%.*]] = waveamdmachine.imm 256
    // CHECK: [[DMA_M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[SUM]], [[DYN_SHIFT]]
    // CHECK: [[RELOAD_ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[RELOADED:%.*]] = waveamdmachine.s_cmp_lg_u32 [[SAVED]], [[RELOAD_ZERO]]
    // CHECK: waveamdmachine.buffer_load_lds_b32 {{.*}}, {{.*}}, {{.*}}, [[DMA_M0]]
    // CHECK: waveamdmachine.s_cbranch_scc1 [[RELOADED]]
    func.func @lds_relief_shifts_dynamic_dma_m0_once()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %inc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %m0, %m0_scc = waveamdmachine.s_add_m0_i32 %dst, %inc
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %cmp = waveamdmachine.s_cmp_lt_i32 %dst, %inc
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<scc, 1>
      %dma = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %m0
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.s_cbranch_scc1 %cmp
          : !waveamdmachine.reg<scc, 1>, "taken"
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_shifts_dynamic_m0_chain_once(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[STEP:%.*]] = waveamdmachine.imm 8192
    // CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 256
    // CHECK: [[M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[DST]], [[SHIFT]]
    // CHECK: [[DMA0:%.*]] = waveamdmachine.buffer_load_lds_b32 {{.*}}, [[M0]]
    // CHECK: [[NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[M0]], [[STEP]]
    // CHECK: waveamdmachine.buffer_load_lds_b32 {{.*}}, [[NEXT]] after [[DMA0]]
    func.func @lds_relief_shifts_dynamic_m0_chain_once()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.dynamic_lds_size = 1024 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
      %dma0 = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %m0
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %next, %unused = waveamdmachine.s_add_m0_i32 %m0, %step
          : (!waveamdmachine.m0, !waveamdmachine.imm)
            -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %dma1 = waveamdmachine.buffer_load_lds_b32 %sum, %desc, %zero, %next
          after %dma0
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_restores_live_m0_chain(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[DST:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[STEP:%.*]] = waveamdmachine.imm 8192
    // CHECK: [[USER_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK-NEXT: [[USER_NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[USER_M0]], [[STEP]]
    // CHECK: [[SPILL_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[SPILL_M0]],
    // CHECK-NEXT: [[RESTORED_STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.s_add_m0_i32 [[RESTORED_STORE_M0]], [[STEP]]
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0
    // CHECK-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    // CHECK-NEXT: [[RESTORED_LOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[DST]]
    // CHECK-NEXT: [[RESTORED_LOAD_NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[RESTORED_LOAD_M0]], [[STEP]]
    // CHECK: waveamdmachine.buffer_load_lds_b32 {{.*}}, [[RESTORED_LOAD_NEXT]]
    func.func @lds_relief_restores_live_m0_chain()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
      %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
      %next, %unused = waveamdmachine.s_add_m0_i32 %m0, %step
          : (!waveamdmachine.m0, !waveamdmachine.imm)
            -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %dma = waveamdmachine.buffer_load_lds_b32 %spill, %desc, %zero, %next
          after %tok3
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
             !waveamdmachine.imm, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_rebuilds_non_dominating_base(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[OFF:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-NEXT: [[FRESH_LANE:%.*]] = waveamdmachine.v_readfirstlane_b32 [[OFF]]
    // CHECK: [[FRESH_SHIFT:%.*]] = waveamdmachine.imm 2
    // CHECK: [[FRESH_BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32 [[FRESH_LANE]], [[FRESH_SHIFT]]
    // CHECK: [[ORIGINAL_LANE:%.*]] = waveamdmachine.v_readfirstlane_b32 [[OFF]]
    // CHECK-NEXT: [[SPILL:%.*]] = waveamdmachine.v_mov_b32_tuple [[ORIGINAL_LANE]]
    // CHECK-NEXT: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[FRESH_BASE]]
    // CHECK-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]], [[SPILL]]
    // CHECK: [[DEPENDENT_LANE:%.*]] = waveamdmachine.v_readfirstlane_b32 [[SPILL]]
    // CHECK: waveamdmachine.s_lshl_b32 [[DEPENDENT_LANE]],
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[FRESH_BASE]]
    // CHECK-NEXT: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    // CHECK: waveamdmachine.v_add_u32 [[RELOAD]],
    func.func @lds_relief_rebuilds_non_dominating_base()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %lane = waveamdmachine.v_readfirstlane_b32 %off
          {waveamdmachine.regalloc_debug_temp}
          : (!waveamdmachine.reg<vgpr, 1, 0>)
            -> !waveamdmachine.reg<sgpr, 1>
      %spill = waveamdmachine.v_mov_b32_tuple %lane
          {waveamdmachine.regalloc_sgpr_to_vgpr_pinned,
           waveamdmachine.regalloc_sgpr_to_vgpr_temp}
          : (!waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %dependent_lane = waveamdmachine.v_readfirstlane_b32 %spill
          : (!waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<sgpr, 1>
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %dependent_base, %unused_scc =
          waveamdmachine.s_lshl_b32 %dependent_lane, %two
          {waveamdmachine.lds_addtid_base_bytes = 0 : i64,
           waveamdmachine.regalloc_debug_temp}
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<scc, 1>)
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %a, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %b, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %a, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_accounts_multiple_waves(
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 512 : i64
    // CHECK: waveamdmachine.ds_store_addtid_b32
    // CHECK: waveamdmachine.ds_load_addtid_b32
    func.func @lds_relief_accounts_multiple_waves()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 1, 1>,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_after_fixed_and_dynamic_lds(
    // CHECK-SAME: wave.dynamic_lds_size = 512 : i64
    // CHECK-SAME: wave.lds_size = 2048 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[WAVE_BASE:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
    // CHECK: [[USER_BYTES:%.*]] = waveamdmachine.imm 2560
    // CHECK: [[SPILL_BASE:%.*]], {{%.*}} = waveamdmachine.s_add_i32 [[WAVE_BASE]], [[USER_BYTES]]
    // CHECK: [[STORE_M0:%.*]] = waveamdmachine.s_mov_m0 [[SPILL_BASE]]
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_addtid_b32 [[STORE_M0]],
    // CHECK: [[LOAD_M0:%.*]] = waveamdmachine.s_mov_m0 [[SPILL_BASE]]
    // CHECK: waveamdmachine.ds_load_addtid_b32 [[LOAD_M0]] after [[STORE]]
    func.func @lds_relief_after_fixed_and_dynamic_lds()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.lds_size = 2048 : i64,
                    wave.dynamic_lds_size = 512 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_rejects_mixed_lds_over_budget(
    // CHECK-SAME: wave.dynamic_lds_size = 1 : i64
    // CHECK-SAME: wave.lds_size = 261888 : i64
    // CHECK-SAME: waveamdmachine.regalloc_transform_state
    // CHECK-NOT: waveamdmachine.lds_spill_bytes
    // CHECK-NOT: waveamdmachine.ds_store_addtid_b32
    // CHECK-NOT: waveamdmachine.ds_load_addtid_b32
    func.func @lds_relief_rejects_mixed_lds_over_budget()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    wave.lds_size = 261888 : i64,
                    wave.dynamic_lds_size = 1 : i64,
                    waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
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
      %use = waveamdmachine.v_add_u32 %spill, %sum
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.s_endpgm
      return
    }

    // CHECK-LABEL: func.func @lds_relief_machine_lds_multi_slot_offsets(
    // CHECK-SAME: waveamdmachine.lds_size = 2304 : i64
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-NOT: waveamdmachine.lds_spill_bytes
    // CHECK-NOT: waveamdmachine.ds_store_addtid_b32
    // CHECK-NOT: waveamdmachine.ds_load_addtid_b32
    func.func @lds_relief_machine_lds_multi_slot_offsets()
        attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.lds_size = 2304 : i64,
                    waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
      %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
      %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
      %spill, %tok1 = waveamdmachine.global_load_tuple_b32 %off, %base after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2>,
             !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
      %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      %sum = waveamdmachine.v_or_b32 %a, %b
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
  }
}
