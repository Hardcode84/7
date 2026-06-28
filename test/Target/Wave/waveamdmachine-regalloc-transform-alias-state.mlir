// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=build_alias_state})' | FileCheck %s
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan})' | FileCheck %s --check-prefix=SCAN

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

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @duplicate_loop_inits_alias_state(
    // CHECK-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 4>
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 6 : i64, alias_sets = 2 : i64, ops = 6 : i64, values = 8 : i64}
    // CHECK: [[DUP:%.*]] = waveamdmachine.v_mov_b32_tuple [[INIT]] {registers = 4 : i64}
    // CHECK: waveamdmachine.uniform_loop
    // CHECK-SAME: carries([[INIT]], [[DUP]] : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
    // SCAN-LABEL: func.func @duplicate_loop_inits_alias_state(
    // SCAN-SAME: [[INIT:%[^:]+]]: !waveamdmachine.reg<vgpr, 4, [[INIT_BASE:[0-9]+]]>
    // SCAN-SAME: waveamdmachine.regalloc_assignments
    // SCAN-SAME: stage = "linear-scan-success"
    // SCAN: [[DUP:%.*]] = waveamdmachine.v_mov_b32_tuple [[INIT]] {registers = 4 : i64} : (!waveamdmachine.reg<vgpr, 4, [[INIT_BASE]]>) -> !waveamdmachine.reg<vgpr, 4, [[DUP_BASE:[0-9]+]]>
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

    // CHECK-LABEL: func.func @loop_invariant_body_use_alias_state(
    // CHECK-SAME: [[INV:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 3 : i64, alias_sets = 3 : i64, ops = 5 : i64, values = 6 : i64}
    // CHECK-SAME: values = [{class = "vgpr", end = 3 : i64, id = 0 : i64
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
    // CHECK-SAME: ranges = [{end = 1 : i64, start = 0 : i64}], set = 0 : i64, start = 0 : i64
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
