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
    %state = wave.transform.regalloc_build_alias_state from %func
        : (!transform.any_op) -> !transform.any_op
    %allocated = wave.transform.regalloc_linear_scan from %state
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload attributes {
    waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
  } {
    // CHECK-LABEL: func.func @full_architectural_file
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1024, 0>
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: width = 1024 : i64
    // CHECK-SAME: stage = "linear-scan-success"
    func.func @full_architectural_file()
        -> !waveamdmachine.reg<vgpr, 1024>
        attributes {waveamdmachine.target_waves = 1 : i64} {
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1024>
      return %wide : !waveamdmachine.reg<vgpr, 1024>
    }

    // CHECK-LABEL: func.func @target_waves_clamps_explicit_budget
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: failure = {budget_mode = "target_waves", class = "vgpr"
    // CHECK-SAME: limit = 256 : i64
    // CHECK-SAME: pressure = 257 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @target_waves_clamps_explicit_budget()
        attributes {waveamdmachine.target_waves = 4 : i64,
                    waveamdmachine.vgpr_count_max = 2048 : i64} {
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 257>
      return
    }

    // CHECK-LABEL: func.func @occupancy_uses_target_granule
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: failure = {budget_mode = "target_waves", class = "vgpr"
    // CHECK-SAME: limit = 192 : i64
    // CHECK-SAME: pressure = 193 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @occupancy_uses_target_granule()
        attributes {waveamdmachine.target_waves = 5 : i64} {
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 193>
      return
    }

    // CHECK-LABEL: func.func @explicit_budget_clamps_to_architecture
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: failure = {budget_mode = "target_addressable", class = "vgpr"
    // CHECK-SAME: limit = 1024 : i64
    // CHECK-SAME: pressure = 1025 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @explicit_budget_clamps_to_architecture()
        attributes {waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.vgpr_count_max = 2048 : i64} {
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1025>
      return
    }

    // CHECK-LABEL: func.func @gfx1250_rejects_agpr
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: failure = {budget_mode = "target_addressable", class = "agpr"
    // CHECK-SAME: limit = 0 : i64
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @gfx1250_rejects_agpr() {
      %acc = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
      return
    }
  }
}
