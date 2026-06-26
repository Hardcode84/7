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
    // CHECK: [[SPILL:%.*]], [[SPILLTOK:%.*]] = waveamdmachine.global_load_b32 [[OFF]]
    // CHECK: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[OFF]]
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_b32 [[ADDR]], [[SPILL]] after [[SPILLTOK]]
    // CHECK: [[RELOAD_ADDR:%.*]] = waveamdmachine.v_lshlrev_b32
    // CHECK: [[RELOAD:%.*]], {{%.*}} = waveamdmachine.ds_load_b32 [[RELOAD_ADDR]] after [[STORE]]
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

    // CHECK-LABEL: func.func @lds_relief_accounts_dynamic_lds(
    // CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
    // CHECK-SAME: waveamdmachine.lds_spill_bytes = 256 : i64
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_b32
    // CHECK-SAME: offset 1024
    // CHECK: waveamdmachine.ds_load_b32 {{.*}} after [[STORE]]
    // CHECK-SAME: offset 1024
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
    // CHECK: waveamdmachine.ds_store_b32
    // CHECK: waveamdmachine.ds_load_b32
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
    // CHECK: [[STORE:%.*]] = waveamdmachine.ds_store_b32
    // CHECK-SAME: offset 2560
    // CHECK: waveamdmachine.ds_load_b32 {{.*}} after [[STORE]]
    // CHECK-SAME: offset 2560
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
  }
}
