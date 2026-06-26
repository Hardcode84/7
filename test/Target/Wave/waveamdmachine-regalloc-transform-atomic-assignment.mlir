// RUN: not wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=linear_scan})' --mlir-print-ir-after-failure 2>&1 | FileCheck %s

// CHECK: regalloc assignment map is incomplete
// CHECK: note: see current operation:
// CHECK: "func.func"()
// CHECK: ^bb0([[ARG:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>):
// CHECK: "waveamdmachine.uninit"() : () -> !waveamdmachine.reg<vgpr, 1>
// CHECK: "func.return"([[ARG]]) : (!waveamdmachine.reg<vgpr, 1>) -> ()

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
    func.func @missing_assignment_no_partial_index(
        %arg0: !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
        attributes {waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{end = 1 : i64, offset = 0 : i64, start = 0 : i64,
                         value = 0 : i64, width = 1 : i64}],
             width = 1 : i64}
          ],
          values = [
            {class = "vgpr", end = 1 : i64, id = 0 : i64,
             kind = "block_arg", number = 0 : i64, offset = 0 : i64,
             path = [0 : i64, 0 : i64], set = 0 : i64, start = 0 : i64,
             width = 1 : i64},
            {class = "vgpr", end = 1 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0 : i64, 0 : i64, 0 : i64], set = 1 : i64,
             start = 1 : i64, width = 1 : i64}
          ]}} {
      %extra = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
      return %arg0 : !waveamdmachine.reg<vgpr, 1>
    }
  }
}
