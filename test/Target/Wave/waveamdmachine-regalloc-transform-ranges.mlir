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
    %r = wave.transform.regalloc_linear_scan from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @unordered_value_ranges(
    // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK-SAME: stage = "linear-scan-success"
    func.func @unordered_value_ranges(%arg0: !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{end = 3 : i64, offset = 0 : i64, start = 0 : i64,
                         value = 0 : i64, width = 1 : i64}],
             width = 1 : i64}
          ],
          values = [
            {class = "vgpr", end = 3 : i64, id = 0 : i64,
             kind = "block_arg", number = 0 : i64, offset = 0 : i64,
             path = [0 : i64, 0 : i64],
             ranges = [{end = 3 : i64, start = 2 : i64},
                       {end = 1 : i64, start = 0 : i64}],
             set = 0 : i64, start = 0 : i64, width = 1 : i64}
          ]}} {
      return
    }
  }

  module @combined_payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {
    // CHECK-LABEL: func.func @combined_pressure_skips_range_hole(
    // CHECK-SAME: failure = {budget_mode = "target_waves_combined_vgpr_agpr"
    // CHECK-SAME: pressure = 240 : i64
    // CHECK-SAME: reason = "allocated-footprint"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @combined_pressure_skips_range_hole(
        %arg0: !waveamdmachine.reg<agpr, 120>,
        %arg1: !waveamdmachine.reg<vgpr, 120>)
        attributes {
          waveamdmachine.target_waves = 4 : i64,
          waveamdmachine.regalloc_transform_state = {
            alias_sets = [
              {class = "agpr", id = 0 : i64,
               members = [{end = 2 : i64, offset = 0 : i64, start = 0 : i64,
                           value = 0 : i64, width = 120 : i64}],
               width = 120 : i64},
              {class = "vgpr", id = 1 : i64,
               members = [{end = 1 : i64, offset = 0 : i64, start = 1 : i64,
                           value = 1 : i64, width = 120 : i64}],
               width = 120 : i64}
            ],
            values = [
              {class = "agpr", end = 2 : i64, id = 0 : i64,
               kind = "block_arg", number = 0 : i64, offset = 0 : i64,
               path = [0 : i64, 0 : i64],
               ranges = [{end = 0 : i64, start = 0 : i64},
                         {end = 2 : i64, start = 2 : i64}],
               set = 0 : i64, start = 0 : i64, width = 120 : i64},
              {class = "vgpr", end = 1 : i64, id = 1 : i64,
               kind = "block_arg", number = 1 : i64, offset = 0 : i64,
               path = [0 : i64, 0 : i64],
               ranges = [{end = 1 : i64, start = 1 : i64}],
               set = 1 : i64, start = 1 : i64, width = 120 : i64}
            ]}} {
      return
    }
  }
}
