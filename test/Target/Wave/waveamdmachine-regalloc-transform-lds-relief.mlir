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
    // CHECK-SAME: waveamdmachine.regalloc_transform_state
    // CHECK-NOT: waveamdmachine.lds_spill_bytes
    // CHECK-NOT: waveamdmachine.ds_store_addtid_b32
    // CHECK-NOT: waveamdmachine.ds_load_addtid_b32
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
