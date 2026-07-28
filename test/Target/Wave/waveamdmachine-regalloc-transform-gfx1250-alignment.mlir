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

  module @payload_module attributes {
    waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
  } {
    // CHECK-LABEL: func.func @uses_two_register_tuple_alignment
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    // CHECK: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 254, 0>
    // CHECK: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 254>
    func.func @uses_two_register_tuple_alignment()
        -> (!waveamdmachine.reg<vgpr, 254, 0>,
            !waveamdmachine.reg<vgpr, 4>) {
      %reserved = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 254, 0>
      %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
      return %reserved, %wide
          : !waveamdmachine.reg<vgpr, 254, 0>,
            !waveamdmachine.reg<vgpr, 4>
    }

    // CHECK-LABEL: func.func @accepts_even_fixed_tuple
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    func.func @accepts_even_fixed_tuple()
        -> !waveamdmachine.reg<vgpr, 4, 254> {
      %wide = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 4, 254>
      return %wide : !waveamdmachine.reg<vgpr, 4, 254>
    }

    // CHECK-LABEL: func.func @accepts_last_addressable_vgpr
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: stage = "linear-scan-success"
    func.func @accepts_last_addressable_vgpr()
        -> !waveamdmachine.reg<vgpr, 1, 1023> {
      %last = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 1, 1023>
      return %last : !waveamdmachine.reg<vgpr, 1, 1023>
    }

    // CHECK-LABEL: func.func @rejects_fixed_vgpr_past_addressable_range
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: budget_mode = "target_addressable"
    // CHECK-SAME: limit = 1024 : i64
    // CHECK-SAME: reason = "pressure"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @rejects_fixed_vgpr_past_addressable_range()
        -> !waveamdmachine.reg<vgpr, 1, 1024> {
      %past = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 1, 1024>
      return %past : !waveamdmachine.reg<vgpr, 1, 1024>
    }

    // CHECK-LABEL: func.func @rejects_odd_fixed_tuple
    // CHECK-NOT: waveamdmachine.regalloc_assignments
    // CHECK-SAME: assignments = []
    // CHECK-SAME: reason = "fixed-alignment"
    // CHECK-SAME: stage = "linear-scan-failure"
    func.func @rejects_odd_fixed_tuple()
        -> !waveamdmachine.reg<vgpr, 4, 255> {
      %wide = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 4, 255>
      return %wide : !waveamdmachine.reg<vgpr, 4, 255>
    }
  }
}
