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
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
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
    // CHECK-NOT: waveamdmachine.regalloc_transform_state
    // CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
    // CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
    // CHECK: waveamdmachine.uniform_loop
    // CHECK: [[LOOP_SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]] {{.*waveamdmachine.regalloc_remat_temp}}
    // CHECK-NEXT: [[LOOP_ROOT:%.*]] = waveamdmachine.v_add_u32 [[LOOP_SEED]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[LOOP_ROOT]]
    // CHECK: [[EXIT_SEED:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]] {{.*waveamdmachine.regalloc_remat_temp}}
    // CHECK-NEXT: [[EXIT_ROOT:%.*]] = waveamdmachine.v_add_u32 [[EXIT_SEED]], [[ONE]] {waveamdmachine.regalloc_remat_temp}
    // CHECK-NEXT: waveamdmachine.v_add_u32 [[EXIT_ROOT]], [[ZERO]]
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
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
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
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
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
        attributes {waveamdmachine.vgpr_count_max = 3 : i64,
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
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: stage = "linear-scan-failure"
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
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: stage = "linear-scan-failure"
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

    // CHECK-LABEL: func.func @remat_relief_rejects_equal_pressure_sgpr_leaf(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: stage = "linear-scan-failure"
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
        attributes {waveamdmachine.vgpr_count_max = 4 : i64,
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
        attributes {waveamdmachine.vgpr_count_max = 4 : i64,
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
  }
}
