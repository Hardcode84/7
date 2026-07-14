// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=remat_relief})' | FileCheck %s

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @remat_relief(
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
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
    // CHECK-LABEL: func.func @remat_relief_rebuilds_after_pressure(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[RESEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // CHECK-NEXT: [[REROOT:%.*]] = waveamdmachine.v_add_u32 [[RESEED]], [[ONE]]
    // CHECK: waveamdmachine.v_add_u32 [[REROOT]], [[ZERO]]
    // CHECK: waveamdmachine.v_add_u32 [[REROOT]], [[ONE]]
    func.func @remat_relief_rebuilds_after_pressure()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %root = waveamdmachine.v_add_u32 %seed, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use0 = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %use1 = waveamdmachine.v_add_u32 %root, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use1 : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_bitop3_after_pressure(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[RESEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // CHECK-NEXT: [[ROOT:%.*]] = waveamdmachine.v_bitop3_b32 [[RESEED]], [[ZERO]], [[ONE]] bitop3 106 {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[ROOT]], [[ONE]]
    func.func @remat_relief_rebuilds_bitop3_after_pressure()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %root = waveamdmachine.v_bitop3_b32 %seed, %zero, %one bitop3 106
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
             !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %root, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_failed_request(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK-SAME: [[LONG:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // CHECK-SAME: [[DIE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // CHECK: waveamdmachine.v_add_u32 [[DIE]]
    // CHECK-NEXT: [[ROOT:%.*]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 1 : i64, waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[USE:%.*]] = waveamdmachine.v_add_u32 [[ROOT]]
    // CHECK: return [[LONG]], [[USE]]
    func.func @remat_relief_rebuilds_failed_request(
        %long: !waveamdmachine.reg<vgpr, 1>,
        %dies: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %root = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %drop = waveamdmachine.v_add_u32 %dies, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %long, %use
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_scalar_operand(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[SG:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[SG]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_add_u32 [[SUM]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[USE:%.*]] = waveamdmachine.v_add_u32 [[ADDR]], [[ONE]]
    // CHECK: return {{.*}}, [[USE]]
    func.func @remat_relief_rebuilds_scalar_operand(
        %long: !waveamdmachine.reg<vgpr, 1>,
        %dies: !waveamdmachine.reg<vgpr, 1>,
        %sg: !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %sum, %scc = waveamdmachine.s_add_i32 %sg, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %addr = waveamdmachine.v_add_u32 %sum, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %drop = waveamdmachine.v_add_u32 %dies, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %use = waveamdmachine.v_add_u32 %addr, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %keep, %scc2 = waveamdmachine.s_add_i32 %sg, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      return %long, %use
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_undominated_use_groups(
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: return
    func.func @remat_relief_rebuilds_undominated_use_groups()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %root = waveamdmachine.v_add_u32 %seed, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %root, %a
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_address_used_at_load_failure(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TID:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[MID:%.*]] = waveamdmachine.v_and_b32 [[TID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_lshrrev_b32 [[MID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.ds_read_tr_b64_b16 [[ADDR]]
    // CHECK: return
    func.func @remat_relief_rebuilds_address_used_at_load_failure(
        %long: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %mid = waveamdmachine.v_and_b32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %addr = waveamdmachine.v_lshrrev_b32 %mid, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %ld, %tok = waveamdmachine.ds_read_tr_b64_b16 %addr offset 0
            : (!waveamdmachine.reg<vgpr, 1>)
              -> (!waveamdmachine.reg<vgpr, 2>,
                  !waveamdmachine.mem.token)
        %parts:2 = waveamdmachine.tuple_to_elements %ld
            : (!waveamdmachine.reg<vgpr, 2>)
              -> (!waveamdmachine.reg<vgpr, 1>,
                  !waveamdmachine.reg<vgpr, 1>)
        %sum = waveamdmachine.v_add_u32 %parts#0, %long
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return %long : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rematerializes_tuple_alias_set(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[RESEED0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // CHECK-NEXT: [[REROOT0:%.*]] = waveamdmachine.v_add_u32 [[RESEED0]], [[ONE]]
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[REROOT0]], [[ZERO]]
    // CHECK: [[RESEED1:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // CHECK-NEXT: [[REROOT1:%.*]] = waveamdmachine.v_add_u32 [[RESEED1]], [[ONE]]
    // CHECK-NEXT: [[RETUPLE:%.*]] = waveamdmachine.tuple_from_elements [[REROOT1]]
    // CHECK-NEXT: [[PART:%.*]] = waveamdmachine.tuple_to_elements [[RETUPLE]]
    func.func @remat_relief_rematerializes_tuple_alias_set()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %root = waveamdmachine.v_add_u32 %seed, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %tuple = waveamdmachine.tuple_from_elements %root
          : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use0 = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %part:1 = waveamdmachine.tuple_to_elements %tuple
          : (!waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>)
      %use1 = waveamdmachine.v_add_u32 %part#0, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use1 : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rematerializes_tuple_projection_alias_set(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[RESEED0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
    // CHECK-NEXT: [[REROOT0:%.*]] = waveamdmachine.v_add_u32 [[RESEED0]], [[ONE]]
    // CHECK-NEXT: [[RETUPLE:%.*]] = waveamdmachine.tuple_from_elements [[REROOT0]]
    // CHECK-NEXT: [[REPART:%.*]] = waveamdmachine.tuple_to_elements [[RETUPLE]]
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[REPART]], [[ZERO]]
    func.func @remat_relief_rematerializes_tuple_projection_alias_set()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %seed0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %root0 = waveamdmachine.v_add_u32 %seed0, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %tuple = waveamdmachine.tuple_from_elements %root0
          : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
      %part:1 = waveamdmachine.tuple_to_elements %tuple
          : (!waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>)
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %part#0, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rejects_unfixed_anchored_workitem(
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.v_workitem_id_x
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-NOT: waveamdmachine.regalloc_remat_temp
    // CHECK: return
    func.func @remat_relief_rejects_unfixed_anchored_workitem()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
      %root = waveamdmachine.v_add_u32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rejects_equal_pressure_fixed_workitem(
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.v_workitem_id_x
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-NOT: waveamdmachine.regalloc_remat_temp
    // CHECK: return
    func.func @remat_relief_rejects_equal_pressure_fixed_workitem()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %addr = waveamdmachine.v_lshrrev_b32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %addr, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_bundles_shared_lane_dag(
    // CHECK-SAME: name = "wave.regalloc.remat.dwords", value = 2 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TWO:%.*]] = waveamdmachine.imm 2
    // CHECK: [[TID:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-NOT: waveamdmachine.v_and_b32
    // CHECK-NOT: waveamdmachine.v_xor_b32
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[SHARED:%.*]] = waveamdmachine.v_and_b32 [[TID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[SHARED]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[SHARED]], [[TWO]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT_SUM:%.*]] = waveamdmachine.v_add_u32 [[ROOT0]], [[ROOT1]]
    // CHECK-NOT: waveamdmachine.v_and_b32
    func.func @remat_relief_bundles_shared_lane_dag()
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %shared = waveamdmachine.v_and_b32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root0 = waveamdmachine.v_xor_b32 %shared, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root1 = waveamdmachine.v_xor_b32 %shared, %two
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %ab = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %rootSum = waveamdmachine.v_add_u32 %root0, %root1
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %keep = waveamdmachine.v_add_u32 %ab, %rootSum
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @remat_relief_keeps_shared_dag_site_local(
    // CHECK-SAME: name = "wave.regalloc.remat.dwords", value = 2 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TWO:%.*]] = waveamdmachine.imm 2
    // CHECK: [[TID:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-NOT: waveamdmachine.v_and_b32
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[SHARED0:%.*]] = waveamdmachine.v_and_b32 [[TID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[SHARED0]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[USE0:%.*]] = waveamdmachine.v_add_u32 [[ROOT0]], [[ONE]]
    // CHECK-NEXT: [[SHARED1:%.*]] = waveamdmachine.v_and_b32 [[TID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[SHARED1]], [[TWO]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[USE1:%.*]] = waveamdmachine.v_add_u32 [[ROOT1]], [[TWO]]
    func.func @remat_relief_keeps_shared_dag_site_local()
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %shared = waveamdmachine.v_and_b32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root0 = waveamdmachine.v_xor_b32 %shared, %one
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root1 = waveamdmachine.v_xor_b32 %shared, %two
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %pressure = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %use0 = waveamdmachine.v_add_u32 %root0, %one
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
              -> !waveamdmachine.reg<vgpr, 1>
        %use1 = waveamdmachine.v_add_u32 %root1, %two
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
              -> !waveamdmachine.reg<vgpr, 1>
        %keep = waveamdmachine.v_add_u32 %use0, %use1
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @remat_relief_bundle_makes_partial_progress(
    // CHECK-SAME: name = "wave.regalloc.remat.dwords", value = 2 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TWO:%.*]] = waveamdmachine.imm 2
    // CHECK: [[TID:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK-NOT: waveamdmachine.v_xor_b32
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp} : !waveamdmachine.reg<vgpr, 3>
    // CHECK: [[ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[TID]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[TID]], [[TWO]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[ROOT0]], [[ROOT1]]
    func.func @remat_relief_bundle_makes_partial_progress()
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %root0 = waveamdmachine.v_xor_b32 %tid, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root1 = waveamdmachine.v_xor_b32 %tid, %two
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %wide = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 3>
        %rootSum = waveamdmachine.v_add_u32 %root0, %root1
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @remat_relief_rejects_disjoint_lane_leaves(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state
    // CHECK-NOT: name = "wave.regalloc.remat.dwords"
    // CHECK: [[TIDX:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[TIDY:%.*]] = waveamdmachine.v_workitem_id_y
    // CHECK: waveamdmachine.v_xor_b32 [[TIDX]],
    // CHECK: waveamdmachine.v_xor_b32 [[TIDY]],
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-NOT: waveamdmachine.v_xor_b32
    // CHECK: return
    func.func @remat_relief_rejects_disjoint_lane_leaves()
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %tidx = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %tidy = waveamdmachine.v_workitem_id_y
          : !waveamdmachine.reg<vgpr, 1, 1>
      %root0 = waveamdmachine.v_xor_b32 %tidx, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root1 = waveamdmachine.v_xor_b32 %tidy, %two
          : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %ab = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %rootSum = waveamdmachine.v_add_u32 %root0, %root1
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %keep = waveamdmachine.v_add_u32 %ab, %rootSum
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @remat_relief_bundles_three_roots_two_leaves(
    // CHECK-SAME: name = "wave.regalloc.remat.dwords", value = 3 : i64
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TWO:%.*]] = waveamdmachine.imm 2
    // CHECK: [[TIDX:%.*]] = waveamdmachine.v_workitem_id_x
    // CHECK: [[TIDY:%.*]] = waveamdmachine.v_workitem_id_y
    // CHECK-NOT: waveamdmachine.v_xor_b32
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[ROOT0:%.*]] = waveamdmachine.v_xor_b32 [[TIDX]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT1:%.*]] = waveamdmachine.v_xor_b32 [[TIDX]], [[TIDY]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ROOT2:%.*]] = waveamdmachine.v_xor_b32 [[TIDY]], [[TWO]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.v_add3_u32 [[ROOT0]], [[ROOT1]], [[ROOT2]]
    func.func @remat_relief_bundles_three_roots_two_leaves()
        attributes {waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %tidx = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %tidy = waveamdmachine.v_workitem_id_y
          : !waveamdmachine.reg<vgpr, 1, 1>
      %root0 = waveamdmachine.v_xor_b32 %tidx, %one
          : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %root1 = waveamdmachine.v_xor_b32 %tidx, %tidy
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<vgpr, 1, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %root2 = waveamdmachine.v_xor_b32 %tidy, %two
          : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
            : !waveamdmachine.reg<vgpr, 1>
        %ab = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %rootSum = waveamdmachine.v_add3_u32 %root0, %root1, %root2
            : (!waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1>,
               !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        %keep = waveamdmachine.v_add_u32 %ab, %rootSum
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @remat_relief_rejects_equal_pressure_sgpr_leaf(
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-NOT: waveamdmachine.regalloc_remat_temp
    // CHECK: return
    func.func @remat_relief_rejects_equal_pressure_sgpr_leaf(
        %sg: !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %root = waveamdmachine.v_add_u32 %sg, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use = waveamdmachine.v_add_u32 %root, %zero
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<vgpr, 1>
      return %use : !waveamdmachine.reg<vgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_extends_sgpr_leaf_for_wide_root(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[SG:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[WIDE:%.*]] = waveamdmachine.v_mov_b32_tuple [[SG]] {registers = 2 : i64, waveamdmachine.regalloc_remat_temp}
    // CHECK: return [[WIDE]]
    func.func @remat_relief_extends_sgpr_leaf_for_wide_root(
        %sg: !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %wide = waveamdmachine.v_mov_b32_tuple %sg {registers = 2 : i64}
          : (!waveamdmachine.reg<sgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 2>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return %wide : !waveamdmachine.reg<vgpr, 2>
    }

    // CHECK-LABEL: func.func @remat_relief_extends_fixed_workitem_for_wide_root(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[TID:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[WIDE:%.*]] = waveamdmachine.v_mov_b32_tuple [[TID]] {registers = 2 : i64, waveamdmachine.regalloc_remat_temp}
    // CHECK: return [[WIDE]]
    func.func @remat_relief_extends_fixed_workitem_for_wide_root()
        -> !waveamdmachine.reg<vgpr, 2>
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %tid = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %wide = waveamdmachine.v_mov_b32_tuple %tid {registers = 2 : i64}
          : (!waveamdmachine.reg<vgpr, 1, 0>)
            -> !waveamdmachine.reg<vgpr, 2>
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
        %sum = waveamdmachine.v_add_u32 %a, %b
            : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
              -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      return %wide : !waveamdmachine.reg<vgpr, 2>
    }

    // CHECK-LABEL: func.func @remat_relief_rebuilds_sgpr_scaled_address(
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK-SAME: [[STRIDE:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: [[TWO:%.*]] = waveamdmachine.imm 2
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[PROD:%.*]] = waveamdmachine.s_mul_i32 [[STRIDE]], [[TWO]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[ADDR:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[PROD]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: [[USE:%.*]], %{{.*}} = waveamdmachine.s_add_i32 [[ADDR]], [[ONE]]
    // CHECK: return [[STRIDE]], [[USE]]
    func.func @remat_relief_rebuilds_sgpr_scaled_address(
        %stride: !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        attributes {waveamdmachine.sgpr_count_max = 2 : i64,
                    waveamdmachine.vgpr_count_max = 4 : i64,
                    waveamdmachine.agpr_count_max = 0 : i64} {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %two = waveamdmachine.imm 2 : !waveamdmachine.imm
      %prod = waveamdmachine.s_mul_i32 %stride, %two
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<sgpr, 1>
      %addr, %scc0 = waveamdmachine.s_add_i32 %prod, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
          : (!waveamdmachine.imm, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
        %a = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
        %b = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
        %sum, %scc1 = waveamdmachine.s_add_i32 %a, %b
            : (!waveamdmachine.reg<sgpr, 1>,
               !waveamdmachine.reg<sgpr, 1>)
              -> (!waveamdmachine.reg<sgpr, 1>,
                  !waveamdmachine.reg<scc, 1>)
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      }
      %use, %scc2 = waveamdmachine.s_add_i32 %addr, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      return %stride, %use
          : !waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<sgpr, 1>
    }

    // CHECK-LABEL: func.func @remat_relief_rejects_unaddressable_default_sgpr(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state
    // CHECK-SAME: budget_mode = "target_addressable"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @remat_relief_rejects_unaddressable_default_sgpr()
        -> !waveamdmachine.reg<sgpr, 1, 120> {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %fixed = waveamdmachine.s_mov_b32_value %zero
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 120>
      return %fixed : !waveamdmachine.reg<sgpr, 1, 120>
    }
  }
}
