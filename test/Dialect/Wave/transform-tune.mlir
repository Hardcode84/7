// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics --split-input-file | FileCheck %s

// Trivial: one enum variable, body writes the value into the
// module's `wavemeta.params`, score returns the same value. The
// winning trial is the one with the largest value (4).

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {tile = 4 : i64}
module attributes {transform.with_named_sequence} {
  func.func @sink() {
    return
  }

  transform.named_sequence @body(
      %mod: !transform.any_op {transform.readonly},
      %tile: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "tile" = %tile
        : (!transform.any_op, !transform.param<i64>) -> ()
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
      variables = {tile = #wave.tune_enum<[1, 2, 4]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}

// -----

// Pow2 + range cross-product. Score yields just `%a`, so winner has
// max(a) = 8. Ties on `a` break by lower enumeration index. With `a`
// as the inner (fastest) axis, the first config with `a = 8` lands at
// `b = 0`, so that's the winner.

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {a = 8 : i64, b = 0 : i64}
module attributes {transform.with_named_sequence} {
  func.func @sink() {
    return
  }

  transform.named_sequence @body(
      %mod: !transform.any_op {transform.readonly},
      %a: !transform.param<i64> {transform.readonly},
      %b: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "a" = %a
        : (!transform.any_op, !transform.param<i64>) -> ()
    wave.transform.bind_param %mod "b" = %b
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %a: !transform.param<i64> {transform.readonly},
      %b: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    %sum = transform.param.constant 0 : i64 -> !transform.param<i64>
    // The transform dialect doesn't ship a `param.add` op in this
    // build; emulate by yielding `a` -- the test pins the per-variable
    // winners by other means below. Use `a` alone: tune picks max(a),
    // ties broken by lower index, which means b = first valid b.
    transform.yield %a : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %w, %s = wave.transform.tune %root body = @body score = @score {
      variables = {a = #wave.tune_pow2_in<[1, 8]>,
                   b = #wave.tune_range<0, 8, 2>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}

// -----

// Feasibility assumption prunes configs: only odd values pass. Body
// records the chosen value; score returns it. With domain [1, 2, 3, 4]
// and assumes "value % 2 == 1", winner is 3.

// CHECK-LABEL: module
// CHECK-SAME: wavemeta.params = {v = 3 : i64}
module attributes {transform.with_named_sequence} {
  func.func @sink() {
    return
  }

  transform.named_sequence @assumes(
      %v: !transform.param<i64> {transform.readonly}) {
    %one = transform.param.constant 1 : i64 -> !transform.param<i64>
    %two = transform.param.constant 2 : i64 -> !transform.param<i64>
    // Compute `v % 2` via a dedicated op; the upstream
    // `transform.match.param.cmpi` only does equality / order. v1 of
    // the tune op pins odd-ness via two passes: reject `v == 2` and
    // reject `v == 4` explicitly. Crude but exercises soft-fail.
    transform.match.param.cmpi ne %v, %two : !transform.param<i64>
    %four = transform.param.constant 4 : i64 -> !transform.param<i64>
    transform.match.param.cmpi ne %v, %four : !transform.param<i64>
    transform.yield
  }

  transform.named_sequence @body(
      %mod: !transform.any_op {transform.readonly},
      %v: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "v" = %v
        : (!transform.any_op, !transform.param<i64>) -> ()
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %v: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    transform.yield %v : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %w, %s = wave.transform.tune %root
        body = @body score = @score assumes = @assumes {
      variables = {v = #wave.tune_enum<[1, 2, 3, 4]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}

// -----

// No feasible trial: assumes rejects everything. Tune op fails loudly.

module attributes {transform.with_named_sequence} {
  func.func @sink() {
    return
  }

  transform.named_sequence @assumes(
      %v: !transform.param<i64> {transform.readonly}) {
    %k = transform.param.constant 999 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %v, %k : !transform.param<i64>
    transform.yield
  }

  transform.named_sequence @body(
      %mod: !transform.any_op {transform.readonly},
      %v: !transform.param<i64> {transform.readonly}) {
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %v: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    transform.yield %v : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    // expected-error @below {{no feasible tune trial}}
    %w, %s = wave.transform.tune %root
        body = @body score = @score assumes = @assumes {
      variables = {v = #wave.tune_enum<[1, 2, 3]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}
