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

    // CHECK-LABEL: func.func @combined_target_waves_granularity_failure
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = []
    // CHECK-SAME: failure = {budget_mode = "target_waves_combined_vgpr_agpr", class = "vgpr_agpr"
    // CHECK-SAME: limit = 128 : i64
    // CHECK-SAME: overlaps = [{base = 0 : i64, class = "agpr"
    // CHECK-SAME: pressure = 129 : i64
    // CHECK-SAME: reason = "pressure"
    // CHECK-SAME: request = 7 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @combined_target_waves_granularity_failure(
        %agpr: !waveamdmachine.reg<agpr, 121>,
        %vgpr: !waveamdmachine.reg<vgpr, 7>)
        attributes {waveamdmachine.target_waves = 4 : i64} {
      return
    }

    // CHECK-LABEL: func.func @combined_target_waves_footprint_failure
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = []
    // CHECK-SAME: failure = {budget_mode = "target_waves_combined_vgpr_agpr", class = "vgpr_agpr"
    // CHECK-SAME: limit = 128 : i64
    // CHECK-SAME: overlaps = [{base = 0 : i64, class = "agpr"
    // CHECK-SAME: pressure = 240 : i64
    // CHECK-SAME: reason = "allocated-footprint"
    // CHECK-SAME: request = 120 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @combined_target_waves_footprint_failure()
        attributes {waveamdmachine.target_waves = 4 : i64} {
      %agpr = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
      %parts:2 = waveamdmachine.tuple_to_elements %agpr
          : (!waveamdmachine.reg<agpr, 120>)
          -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
      %vgpr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 120>
      return
    }

    // CHECK-LABEL: func.func @target_waves_keeps_vgpr_addressable_limit
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: failure = {budget_mode = "target_addressable", class = "vgpr"
    // CHECK-SAME: limit = 256 : i64
    // CHECK-SAME: pressure = 257 : i64
    // CHECK-SAME: reason = "pressure"
    // CHECK-SAME: request = 257 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @target_waves_keeps_vgpr_addressable_limit()
        attributes {waveamdmachine.target_waves = 1 : i64} {
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 257>
      return
    }

    // CHECK-LABEL: func.func @uniform_if_late_results_reuse_branch_storage(
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 64, 0>
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.uniform_if
    // CHECK: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 128, 0>
    // CHECK-NEXT: [[THEN:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
    // CHECK-NEXT: waveamdmachine.yield [[THEN]] : !waveamdmachine.reg<vgpr, 64, 0>
    // CHECK: otherwise
    // CHECK-NEXT: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 128, 0>
    // CHECK-NEXT: [[ELSE:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
    // CHECK-NEXT: waveamdmachine.yield [[ELSE]] : !waveamdmachine.reg<vgpr, 64, 0>
    func.func @uniform_if_late_results_reuse_branch_storage(
        %cond: !waveamdmachine.reg<scc, 1>)
        -> !waveamdmachine.reg<vgpr, 64>
        attributes {waveamdmachine.target_waves = 4 : i64} {
      %selected = waveamdmachine.uniform_if %cond {
        %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 128>
        %then = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
        waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 64>
      } otherwise {
        %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 128>
        %else = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
        waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 64>
      } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 64>
      return %selected : !waveamdmachine.reg<vgpr, 64>
    }
  }
}
