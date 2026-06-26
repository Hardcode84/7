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
  }
}
