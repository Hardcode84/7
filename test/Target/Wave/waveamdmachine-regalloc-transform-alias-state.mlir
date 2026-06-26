// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=build_alias_state})' | FileCheck %s

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

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @duplicate_loop_inits_alias_state
    // CHECK-SAME: waveamdmachine.regalloc_transform_state =
    // CHECK-SAME: debug = {alias_edges = 5 : i64, alias_sets = 2 : i64, ops = 5 : i64, values = 7 : i64}
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
