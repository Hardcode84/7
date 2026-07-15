// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=build_alias_state})' | FileCheck %s
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=build_alias_state_no_mfma_coalesce})' | FileCheck %s --check-prefix=NO-MFMA-COALESCE
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan})' | FileCheck %s --check-prefix=SCAN
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan_no_mfma_coalesce})' | FileCheck %s --check-prefix=SCAN-NO-MFMA-COALESCE

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @build_alias_state(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @build_alias_state_no_mfma_coalesce(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r = wave.transform.regalloc_build_alias_state from %func
        {coalesce_mfma_acc_result = false}
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @linear_scan(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @linear_scan_no_mfma_coalesce(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_build_alias_state from %func
        {coalesce_mfma_acc_result = false}
        : (!transform.any_op) -> !transform.any_op
    %r1 = wave.transform.regalloc_linear_scan from %r0
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @duplicate_loop_inits_alias_state(
    // CHECK-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 4>
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 6 : i64, alias_sets = 2 : i64, ops = 6 : i64, values = 8 : i64}
    // CHECK: [[DUP:%.*]] = waveamdmachine.copy_tuple [[INIT]]
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-SAME: carries([[INIT]], [[DUP]] : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
    // SCAN-LABEL: func.func @duplicate_loop_inits_alias_state(
    // SCAN-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[INIT_BASE:[0-9]+]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: [[DUP:%.*]] = waveamdmachine.copy_tuple [[INIT]] : (!waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>) -> !waveamdmachine.reg<vgpr, 4, [[DUP_BASE:[0-9]+]]>
    // SCAN: waveamdmachine.uniform_loop
    // SCAN-SAME: carries([[INIT]], [[DUP]] : !waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>, !waveamdmachine.reg<vgpr, 4, [[DUP_BASE]]>)
    // SCAN: ^bb0([[ACC0:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>, [[ACC1:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[DUP_BASE]]>):
    func.func @duplicate_loop_inits_alias_state(
        %init: !waveamdmachine.reg<vgpr, 4>,
        %cond: !waveamdmachine.reg<scc, 1>) {
      %loop:2 = waveamdmachine.uniform_loop if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%init, %init : !waveamdmachine.reg<vgpr, 4>,
                  !waveamdmachine.reg<vgpr, 4>) {
      ^bb0(%acc0: !waveamdmachine.reg<vgpr, 4>,
           %acc1: !waveamdmachine.reg<vgpr, 4>):
        %next0 = waveamdmachine.v_mov_b32_tuple %acc0 {registers = 4 : i64}
            : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
        %next1 = waveamdmachine.v_mov_b32_tuple %acc1 {registers = 4 : i64}
            : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
            carries(%next0, %next1 : !waveamdmachine.reg<vgpr, 4>,
                    !waveamdmachine.reg<vgpr, 4>)
      } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
      return
    }

    // SCAN-LABEL: func.func @nested_loop_inits_get_local_copies(
    // SCAN-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[INIT_BASE:[0-9]+]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: waveamdmachine.uniform_loop
    // SCAN: [[COPY0:%.*]] = waveamdmachine.copy_tuple [[INIT]]
    // SCAN-SAME: (!waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>) -> !waveamdmachine.reg<vgpr, 4, [[COPY0_BASE:[0-9]+]]>
    // SCAN: [[COPY1:%.*]] = waveamdmachine.copy_tuple [[INIT]]
    // SCAN-SAME: (!waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>) -> !waveamdmachine.reg<vgpr, 4, [[COPY1_BASE:[0-9]+]]>
    // SCAN: waveamdmachine.uniform_loop
    // SCAN-SAME: carries([[COPY0]], [[COPY1]] : !waveamdmachine.reg<vgpr, 4, [[COPY0_BASE]]>, !waveamdmachine.reg<vgpr, 4, [[COPY1_BASE]]>)
    // SCAN: ^bb0([[ACC0:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[COPY0_BASE]]>, [[ACC1:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[COPY1_BASE]]>):
    // SCAN: waveamdmachine.mfma_f32_16x16x32_f16
    // SCAN-SAME: [[ACC0]]
    // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 4, [[COPY0_BASE]]>
    func.func @nested_loop_inits_get_local_copies(
        %init: !waveamdmachine.reg<vgpr, 4>,
        %a: !waveamdmachine.reg<vgpr, 4>,
        %b: !waveamdmachine.reg<vgpr, 4>,
        %outer_cond: !waveamdmachine.reg<scc, 1>,
        %inner_cond: !waveamdmachine.reg<scc, 1>) {
      waveamdmachine.uniform_loop if %outer_cond
          : !waveamdmachine.reg<scc, 1> {
      ^bb0:
        %inner:2 = waveamdmachine.uniform_loop if %inner_cond
            : !waveamdmachine.reg<scc, 1>
            carries(%init, %init : !waveamdmachine.reg<vgpr, 4>,
                    !waveamdmachine.reg<vgpr, 4>) {
        ^bb0(%acc0: !waveamdmachine.reg<vgpr, 4>,
             %acc1: !waveamdmachine.reg<vgpr, 4>):
          %next0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
              : (!waveamdmachine.reg<vgpr, 4>,
                 !waveamdmachine.reg<vgpr, 4>,
                 !waveamdmachine.reg<vgpr, 4>)
              -> !waveamdmachine.reg<vgpr, 4>
          %next1 = waveamdmachine.v_mov_b32_tuple %acc1 {registers = 4 : i64}
              : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
          waveamdmachine.continue_if %inner_cond
              : !waveamdmachine.reg<scc, 1>
              carries(%next0, %next1 : !waveamdmachine.reg<vgpr, 4>,
                      !waveamdmachine.reg<vgpr, 4>)
        } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
        waveamdmachine.continue_if %outer_cond
            : !waveamdmachine.reg<scc, 1>
      }
      return
    }

    // CHECK-LABEL: func.func @update_tuple_alias_state(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 3 : i64
    // SCAN-LABEL: func.func @update_tuple_alias_state(
    // SCAN-SAME: [[BASE:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[#BASE_REG:]]>
    // SCAN-SAME: [[LO:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[#BASE_REG]]>
    // SCAN-SAME: [[HI:%[^:]+]]: !waveamdmachine.reg<vgpr, 2, [[#BASE_REG+2]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN: [[UPDATED:%.*]] = waveamdmachine.update_tuple [[BASE]], [[LO]], [[HI]]
    // SCAN-SAME: offsets = [0, 2]
    // SCAN-SAME: -> !waveamdmachine.reg<vgpr, 4, [[#BASE_REG]]>
    func.func @update_tuple_alias_state(
        %base: !waveamdmachine.reg<vgpr, 4>,
        %lo: !waveamdmachine.reg<vgpr, 1>,
        %hi: !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4> {
      %updated = waveamdmachine.update_tuple %base, %lo, %hi
          {offsets = [0 : i64, 2 : i64]}
          : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
      return %updated : !waveamdmachine.reg<vgpr, 4>
    }

    // CHECK-LABEL: func.func @loop_invariant_body_use_alias_state(
    // CHECK-SAME: [[INV:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 3 : i64, alias_sets = 3 : i64, ops = 5 : i64, values = 6 : i64}
    // CHECK-SAME: packed = #wave.regalloc_state<version = 1
    // CHECK-SAME: values = [1, 0, -1, 0, 0, 3, 1
    // CHECK: [[USE:%.*]] = waveamdmachine.v_mov_b32_tuple [[INV]] {registers = 1 : i64}
    // SCAN-LABEL: func.func @loop_invariant_body_use_alias_state(
    // SCAN-SAME: [[INV:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[INV_BASE:[0-9]+]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: [[USE:%.*]] = waveamdmachine.v_mov_b32_tuple [[INV]] {registers = 1 : i64} : (!waveamdmachine.reg<vgpr, 1, [[INV_BASE]]>) -> !waveamdmachine.reg<vgpr, 1
    func.func @loop_invariant_body_use_alias_state(
        %invariant: !waveamdmachine.reg<vgpr, 1>,
        %carry: !waveamdmachine.reg<vgpr, 1>,
        %cond: !waveamdmachine.reg<scc, 1>) {
      %loop = waveamdmachine.uniform_loop if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 1>) {
      ^bb0(%acc: !waveamdmachine.reg<vgpr, 1>):
        %use = waveamdmachine.v_mov_b32_tuple %invariant {registers = 1 : i64}
            : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
        %next = waveamdmachine.v_mov_b32_tuple %acc {registers = 1 : i64}
            : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
            carries(%next : !waveamdmachine.reg<vgpr, 1>)
      } -> !waveamdmachine.reg<vgpr, 1>
      return
    }

    // CHECK-LABEL: func.func @loop_carry_hole_reuse(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: packed = #wave.regalloc_state<version = 1
    // CHECK-SAME: value_ranges = [0, 1, 1, 2, 3, 4, 5, 6, 6, 6]
    // CHECK-SAME: alias_members = [0, 1, 4, 3, 2]
    // SCAN-LABEL: func.func @loop_carry_hole_reuse(
    // SCAN-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<sgpr, 1, 0>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: waveamdmachine.uniform_loop
    // SCAN-SAME: carries([[INIT]] : !waveamdmachine.reg<sgpr, 1, 0>)
    // SCAN: ^bb0([[IV:%[^:]+]]: !waveamdmachine.reg<sgpr, 1, 0>):
    // SCAN: waveamdmachine.s_mov_b32_value {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
    func.func @loop_carry_hole_reuse(
        %init: !waveamdmachine.reg<sgpr, 1>,
        %cond: !waveamdmachine.reg<scc, 1>) {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %loop = waveamdmachine.uniform_loop if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%init : !waveamdmachine.reg<sgpr, 1>) {
      ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
        %early = waveamdmachine.s_cmp_lt_i32 %iv, %zero
            : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
        %tmp = waveamdmachine.s_mov_b32_value %zero
            : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
        %use_tmp = waveamdmachine.s_cmp_lt_i32 %tmp, %zero
            : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
            -> !waveamdmachine.reg<scc, 1>
        %next = waveamdmachine.s_mov_b32_value %zero
            : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
            carries(%next : !waveamdmachine.reg<sgpr, 1>)
      } -> !waveamdmachine.reg<sgpr, 1>
      return
    }

    // CHECK-LABEL: func.func @mfma_acc_result_coalescing_flag(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 1 : i64, alias_sets = 3 : i64, ops = 2 : i64, values = 4 : i64}
    // NO-MFMA-COALESCE-LABEL: func.func @mfma_acc_result_coalescing_flag(
    // NO-MFMA-COALESCE-SAME: waveamdmachine.regalloc_coalesce_mfma_acc_result = false
    // NO-MFMA-COALESCE-SAME: waveamdmachine.regalloc_transform_state =
    // NO-MFMA-COALESCE-SAME: debug = {alias_edges = 0 : i64, alias_sets = 4 : i64, ops = 2 : i64, values = 4 : i64}
    func.func @mfma_acc_result_coalescing_flag(
        %a: !waveamdmachine.reg<vgpr, 4>,
        %b: !waveamdmachine.reg<vgpr, 4>,
        %acc: !waveamdmachine.reg<vgpr, 4>)
        -> !waveamdmachine.reg<vgpr, 4> {
      %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
          : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
             !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
      return %mfma : !waveamdmachine.reg<vgpr, 4>
    }

    // SCAN-NO-MFMA-COALESCE-LABEL: func.func @mfma_destructive_reuse_without_alias(
    // SCAN-NO-MFMA-COALESCE-SAME: [[A:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[A_BASE:[0-9]+]]>, [[B:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[B_BASE:[0-9]+]]>, [[ACC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[ACC_BASE:[0-9]+]]>
    // SCAN-NO-MFMA-COALESCE-SAME: waveamdmachine.regalloc_assignments
    // SCAN-NO-MFMA-COALESCE-SAME: stage = "linear-scan-success"
    // SCAN-NO-MFMA-COALESCE: waveamdmachine.mfma_f32_16x16x32_f16
    // SCAN-NO-MFMA-COALESCE-SAME: [[ACC]]
    // SCAN-NO-MFMA-COALESCE-SAME: -> !waveamdmachine.reg<vgpr, 4, [[ACC_BASE]]>
    func.func @mfma_destructive_reuse_without_alias(
        %a: !waveamdmachine.reg<vgpr, 4>,
        %b: !waveamdmachine.reg<vgpr, 4>,
        %acc: !waveamdmachine.reg<vgpr, 4>)
        -> !waveamdmachine.reg<vgpr, 4> {
      %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
          : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
             !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
      return %mfma : !waveamdmachine.reg<vgpr, 4>
    }

    // CHECK-LABEL: func.func @loop_invariant_mfma_acc_alias_state(
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 3 : i64, alias_sets = 5 : i64, ops = 5 : i64, values = 8 : i64}
    // CHECK: waveamdmachine.mfma_f32_16x16x32_f16
    // SCAN-LABEL: func.func @loop_invariant_mfma_acc_alias_state(
    // SCAN-SAME: [[ACC:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[ACC_BASE:[0-9]+]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: waveamdmachine.mfma_f32_16x16x32_f16
    // SCAN-SAME: [[ACC]]
    func.func @loop_invariant_mfma_acc_alias_state(
        %a: !waveamdmachine.reg<vgpr, 4>,
        %b: !waveamdmachine.reg<vgpr, 4>,
        %acc: !waveamdmachine.reg<vgpr, 4>,
        %carry: !waveamdmachine.reg<vgpr, 4>,
        %cond: !waveamdmachine.reg<scc, 1>) {
      %loop = waveamdmachine.uniform_loop if %cond
          : !waveamdmachine.reg<scc, 1>
          carries(%carry : !waveamdmachine.reg<vgpr, 4>) {
      ^bb0(%iter: !waveamdmachine.reg<vgpr, 4>):
        %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
            : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
               !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
        %next = waveamdmachine.v_mov_b32_tuple %iter {registers = 4 : i64}
            : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
        waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
            carries(%next : !waveamdmachine.reg<vgpr, 4>)
      } -> !waveamdmachine.reg<vgpr, 4>
      return
    }
  }
}
