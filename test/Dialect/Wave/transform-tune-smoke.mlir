// End-to-end smoke test for `wave.transform.tune`. Body sequence
// binds a wavemeta param into the cloned module and runs the
// real `wavemeta-specialize` pass on the clone. Score yields the
// tile value, so the winning trial is the largest tile in the
// domain. After tune runs, the original module's body has been
// replaced with the winning clone's specialised IR -- no more
// `wavemeta.param` ops, an `arith.constant` with the winning
// value, and `wavemeta.params = {tile = 8}` on the module.

// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' | FileCheck %s

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {tile = 8 : index}
// CHECK-LABEL: func.func @kernel
// CHECK-NOT: wavemeta.param
// CHECK: %[[C:.+]] = arith.constant 8 : index
// CHECK: return %[[C]] : index

module attributes {transform.with_named_sequence} {
  func.func @kernel() -> index {
    %v = wavemeta.param "tile" : index
    return %v : index
  }

  transform.named_sequence @body(
      %mod: !transform.any_op {transform.consumed},
      %tile: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "tile" = %tile as index
        : (!transform.any_op, !transform.param<i64>) -> ()
    %m1 = transform.apply_registered_pass "wavemeta-specialize" to %mod
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %tile: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    transform.yield %tile : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %w, %s = wave.transform.tune %root body = @body score = @score {
      variables = {tile = #wave.tune_enum<[1, 2, 4, 8]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}
