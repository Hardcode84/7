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

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @nonfixed_avoids_later_fixed(
    // CHECK-SAME: [[LIVE:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, 1>
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = [{base = 1 : i64, class = "vgpr"
    // CHECK-SAME: {base = 0 : i64, class = "vgpr"
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: [[FIXED:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK: return [[LIVE]], [[FIXED]]
    func.func @nonfixed_avoids_later_fixed(
        %live: !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1, 0>) {
      %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
      %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
      return %live, %fixed
          : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1, 0>
    }
  }
}
