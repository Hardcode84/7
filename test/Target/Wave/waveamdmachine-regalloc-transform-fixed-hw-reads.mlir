// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan},waveamd-resource-info)' | FileCheck %s

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

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @overlapping_fixed_workitem_reads
    // CHECK: [[WI0:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: [[WI1:%.*]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: waveamdmachine.v_add_u32 [[WI0]], [[WI1]]
    // CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 1>
    func.func @overlapping_fixed_workitem_reads()
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.vgpr_count_max = 2 : i64} {
      %wi0 = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %wi1 = waveamdmachine.v_workitem_id_x
          : !waveamdmachine.reg<vgpr, 1, 0>
      %sum = waveamdmachine.v_add_u32 %wi0, %wi1
          : (!waveamdmachine.reg<vgpr, 1, 0>,
             !waveamdmachine.reg<vgpr, 1, 0>)
          -> !waveamdmachine.reg<vgpr, 1>
      return %sum : !waveamdmachine.reg<vgpr, 1>
    }
  }
}
