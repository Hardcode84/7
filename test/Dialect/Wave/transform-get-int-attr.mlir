// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics --split-input-file

// Happy path: pull the module's `waveamdmachine.vgpr_count_max` and
// assert the value via a constant match.

module attributes {transform.with_named_sequence,
                   waveamdmachine.vgpr_count_max = 42 : i64} {
  func.func @hello() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %p = wave.transform.get_int_attr "waveamdmachine.vgpr_count_max" from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 42 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %p, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Same op, with the assertion checking a non-matching constant: the
// silenceable cmpi failure should surface as a remark on the failing
// sequence.

module attributes {transform.with_named_sequence,
                   waveamdmachine.vgpr_count_max = 7 : i64} {
  func.func @assert_mismatch() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    // expected-note @below {{value # 0 associated with the parameter defined here}}
    %p = wave.transform.get_int_attr "waveamdmachine.vgpr_count_max" from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 42 : i64 -> !transform.param<i64>
    // expected-error @below {{expected parameter to be equal to 42, got 7}}
    transform.match.param.cmpi eq %p, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Negative: missing attribute is a definite failure.

module attributes {transform.with_named_sequence} {
  func.func @no_attr() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    // expected-error @below {{target op missing IntegerAttr `waveamdmachine.vgpr_count_max`}}
    %p = wave.transform.get_int_attr "waveamdmachine.vgpr_count_max" from %root
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield
  }
}

// -----

// Negative: attribute exists but is the wrong kind (StringAttr).

module attributes {transform.with_named_sequence,
                   waveamdmachine.vgpr_count_max = "oops"} {
  func.func @wrong_type() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    // expected-error @below {{target op missing IntegerAttr `waveamdmachine.vgpr_count_max`}}
    %p = wave.transform.get_int_attr "waveamdmachine.vgpr_count_max" from %root
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield
  }
}
