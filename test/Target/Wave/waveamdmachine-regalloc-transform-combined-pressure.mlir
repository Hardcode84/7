// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan})' | FileCheck %s

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
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

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {
    // CHECK-LABEL: func.func @combined_target_waves_failure
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = []
    // CHECK-SAME: failure = {budget_mode = "target_waves_combined_vgpr_agpr", class = "vgpr_agpr"
    // CHECK-SAME: limit = 128 : i64
    // CHECK-SAME: overlaps = [{base = 0 : i64, class = "agpr"
    // CHECK-SAME: pressure = 240 : i64
    // CHECK-SAME: request = 120 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @combined_target_waves_failure(
        %agpr: !waveamdmachine.reg<agpr, 120>,
        %vgpr: !waveamdmachine.reg<vgpr, 120>)
        attributes {waveamdmachine.target_waves = 4 : i64} {
      return
    }
  }
}
