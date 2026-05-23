// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics --split-input-file | FileCheck %s

// Happy path: bind into a module with no prior `wavemeta.params`.
// The dict is created with the single new entry; printing the module
// confirms the attribute landed.

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {unroll = 4 : i64}
module attributes {transform.with_named_sequence} {
  func.func @sink() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %v = transform.param.constant 4 : i64 -> !transform.param<i64>
    wave.transform.bind_param %root "unroll" = %v
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }
}

// -----

// Replace an existing entry: the prior `tile = 2` survives, `unroll`
// gets overwritten.

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {tile = 2 : i64, unroll = 8 : i64}
module attributes {transform.with_named_sequence,
                   wavemeta.params = {tile = 2 : i64, unroll = 1 : i64}} {
  func.func @sink() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %v = transform.param.constant 8 : i64 -> !transform.param<i64>
    wave.transform.bind_param %root "unroll" = %v
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }
}

// -----

// Add a second entry alongside an existing unrelated one.

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {pre = 9 : i64, tile = 16 : i64}
module attributes {transform.with_named_sequence,
                   wavemeta.params = {pre = 9 : i64}} {
  func.func @sink() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %v = transform.param.constant 16 : i64 -> !transform.param<i64>
    wave.transform.bind_param %root "tile" = %v
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }
}

// -----

// Negative: target must be a `builtin.module`. The transform
// interpreter targets the top-level module by default, so match a
// nested func op via `transform.structured.match` and pass that.

module attributes {transform.with_named_sequence} {
  func.func @not_a_module() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %f = transform.structured.match ops{["func.func"]} in %root
        : (!transform.any_op) -> !transform.any_op
    %v = transform.param.constant 1 : i64 -> !transform.param<i64>
    // expected-error @below {{target must be a `builtin.module` op}}
    wave.transform.bind_param %f "x" = %v
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }
}
