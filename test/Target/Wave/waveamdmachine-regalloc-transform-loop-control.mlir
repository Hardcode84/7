// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=restart_once})' | FileCheck %s
// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=never_progresses})' 2>&1 | FileCheck %s --check-prefix=NO-PROGRESS
// RUN: wave-opt %s --mlir-print-op-generic | FileCheck %s --check-prefix=DEFAULT

module attributes {transform.with_named_sequence} {
  transform.named_sequence @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @iteration(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    %next = transform.alternatives %root : !transform.any_op -> !transform.any_op {
    ^bb0(%candidate: !transform.any_op):
      transform.match.operation_name %candidate ["func.func"] : !transform.any_op
      %r0 = wave.transform.regalloc_build_alias_state from %candidate
          : (!transform.any_op) -> !transform.any_op
      %r1 = wave.transform.regalloc_linear_scan from %r0
          : (!transform.any_op) -> !transform.any_op
      transform.yield %r1 : !transform.any_op
    }, {
    ^bb0(%candidate: !transform.any_op):
      transform.match.operation_name %candidate ["builtin.module"] : !transform.any_op
      %func = transform.collect_matching @match_func in %candidate
          : (!transform.any_op) -> !transform.any_op
      transform.yield %func : !transform.any_op
    }
    transform.yield %next : !transform.any_op
  }

  transform.named_sequence @no_progress_iteration(
      %root: !transform.any_op {transform.consumed}) -> !transform.any_op {
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence @default_limit(
      %root: !transform.any_op {transform.consumed}) {
    // DEFAULT: "wave.transform.regalloc_loop"
    // DEFAULT-SAME: max_iterations = 512 : i64
    %r = wave.transform.regalloc_loop from %root body = @no_progress_iteration
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @never_progresses(
      %root: !transform.any_op {transform.consumed}) {
    // NO-PROGRESS: regalloc transform loop exceeded max_iterations = 2
    %r = wave.transform.regalloc_loop from %root body = @no_progress_iteration
        {max_iterations = 2 : i64}
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @restart_once(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %parent = transform.get_parent_op %func {op_name = "builtin.module"}
        : (!transform.any_op) -> !transform.any_op
    %r = wave.transform.regalloc_loop from %parent body = @iteration
        {max_iterations = 2 : i64}
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  module @payload_module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
    // CHECK-LABEL: func.func @payload
    // CHECK-SAME: !waveamdmachine.reg<vgpr, 1, 0>
    // CHECK-SAME: waveamdmachine.regalloc_assignments
    // CHECK-SAME: iteration = 1 : i64
    // CHECK-SAME: stage = "linear-scan-success"
    func.func @payload(%arg0: !waveamdmachine.reg<vgpr, 1>)
        attributes {waveamdmachine.regalloc_transform_state = {stage = "linear-scan-success"}} {
      return
    }
  }
}
