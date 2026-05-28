// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @param_float() -> f32 {
  // expected-error @below {{result #0 must be index or signless integer, but got 'f32'}}
  %v = wavemeta.param "unroll" : f32
  return %v : f32
}

// -----

func.func @param_vector() -> vector<4xi32> {
  // expected-error @below {{result #0 must be index or signless integer, but got 'vector<4xi32>'}}
  %v = wavemeta.param "x" : vector<4xi32>
  return %v : vector<4xi32>
}

// -----

func.func @param_signed_int() -> si32 {
  // expected-error @below {{result #0 must be index or signless integer, but got 'si32'}}
  %v = wavemeta.param "x" : si32
  return %v : si32
}

// -----

func.func @param_value_type_mismatch() -> index {
  // expected-error @below {{value attribute type must match result type}}
  %v = wavemeta.param "u" {value = 4 : i64} : index
  return %v : index
}

// -----

// Body block missing the induction-var argument.
func.func @for_missing_iv(%lb: index, %ub: index, %step: index, %init: i32) -> i32 {
  // expected-error @below {{body block expects 2 arguments (induction var + iter args), got 1}}
  %r = "wavemeta.static_for"(%lb, %ub, %step, %init) ({
  ^bb0(%acc: i32):
    "wavemeta.yield"(%acc) : (i32) -> ()
  }) : (index, index, index, i32) -> i32
  return %r : i32
}

// -----

// Iter-arg type does not match the corresponding body block arg type.
func.func @for_iter_type_mismatch(%lb: index, %ub: index, %step: index, %init: i32) -> i32 {
  // expected-error @below {{body block arg #1 type 'i64' must match iter_args type 'i32'}}
  %r = "wavemeta.static_for"(%lb, %ub, %step, %init) ({
  ^bb0(%iv: index, %acc: i64):
    %z = arith.constant 0 : i32
    "wavemeta.yield"(%z) : (i32) -> ()
  }) : (index, index, index, i32) -> i32
  return %r : i32
}

// -----

// Yield in static_for has the wrong operand count.
func.func @for_yield_arity_mismatch(%lb: index, %ub: index, %step: index, %init: i32) -> i32 {
  // expected-error @below {{yield operand count must equal iter_args count}}
  %r = wavemeta.static_for %lb to %ub step %step iter_args(%init : i32) {
  ^bb0(%iv: index, %acc: i32):
    wavemeta.yield
  } -> i32
  return %r : i32
}

// -----

// static_if with results requires both regions.
func.func @if_results_no_else(%c: i1, %a: i32) -> i32 {
  // expected-error @below {{else region is required when the op has results}}
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  }
  return %r : i32
}

// -----

// Yield in the then region has the wrong type for the op result.
func.func @if_then_type_mismatch(%c: i1) -> i32 {
  %a = arith.constant 0 : i64
  // expected-error @below {{then region yield operand #0 type 'i64' must match result type 'i32'}}
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i64
  } else {
    %z = arith.constant 0 : i32
    wavemeta.yield %z : i32
  }
  return %r : i32
}

// -----

// Induction-var slot in the body block has the wrong type.
func.func @for_iv_not_index(%lb: index, %ub: index, %step: index) {
  // expected-error @below {{body block first argument type 'i32' must match IV type 'index'}}
  "wavemeta.static_for"(%lb, %ub, %step) ({
  ^bb0(%iv: i32):
    "wavemeta.yield"() : () -> ()
  }) : (index, index, index) -> ()
  return
}

// -----

// Body terminator is not wavemeta.yield. `scf.yield` is also a
// region terminator and satisfies the "body has a terminator"
// invariant, so the parent op's verifier is the right place to
// catch the wrong kind.
func.func @for_wrong_terminator(%lb: index, %ub: index, %step: index) {
  // expected-error @below {{body must be terminated by wavemeta.yield}}
  "wavemeta.static_for"(%lb, %ub, %step) ({
  ^bb0(%iv: index):
    "scf.yield"() : () -> ()
  }) : (index, index, index) -> ()
  return
}

// -----

// static_if then region terminator is not wavemeta.yield.
func.func @if_then_wrong_terminator(%c: i1) {
  // expected-error @below {{then region must be terminated by wavemeta.yield}}
  "wavemeta.static_if"(%c) ({
    "scf.yield"() : () -> ()
  }, {}) : (i1) -> ()
  return
}

// -----

// static_if then-region yield operand count doesn't match the op's
// result count (yield has zero operands, op expects 1 result).
func.func @if_then_arity_mismatch(%c: i1) -> i32 {
  // expected-error @below {{then region yield operand count must match op result count}}
  %r = "wavemeta.static_if"(%c) ({
    "wavemeta.yield"() : () -> ()
  }, {
    %z = arith.constant 0 : i32
    "wavemeta.yield"(%z) : (i32) -> ()
  }) : (i1) -> i32
  return %r : i32
}

// -----

// ptuple width attribute must be a StringAttr or IntegerAttr.
// expected-error @below {{width must be a StringAttr (parameter name) or IntegerAttr (concrete width)}}
func.func private @bad_ptuple_width(!wavemeta.ptuple<i32, [0, 1]>) -> ()

// -----

// Concrete ptuple width cannot be negative.
// expected-error @below {{concrete width must be non-negative, got -1}}
func.func private @negative_ptuple_width(!wavemeta.ptuple<i32, -1>) -> ()

// -----

// tuple_make_broadcast: init's type must match the result's element type.
func.func @broadcast_type_mismatch(%init: i32) -> !wavemeta.ptuple<i64, "n"> {
  // expected-error @below {{init type 'i32' must match result tuple element type 'i64'}}
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i64, "n">
  return %t : !wavemeta.ptuple<i64, "n">
}

// -----

// tuple_make: parameter-named width is rejected (need concrete N).
func.func @make_parametric_width(%a: i32) -> !wavemeta.ptuple<i32, "n"> {
  // expected-error @below {{result tuple width must be concrete; parameter-named widths are only valid for tuple_make_broadcast}}
  %t = wavemeta.tuple_make %a : (i32) -> !wavemeta.ptuple<i32, "n">
  return %t : !wavemeta.ptuple<i32, "n">
}

// -----

// tuple_make: operand count must match the concrete width.
func.func @make_arity_mismatch(%a: i32, %b: i32) -> !wavemeta.ptuple<i32, 4> {
  // expected-error @below {{operand count (2) must match concrete tuple width (4)}}
  %t = wavemeta.tuple_make %a, %b : (i32, i32) -> !wavemeta.ptuple<i32, 4>
  return %t : !wavemeta.ptuple<i32, 4>
}

// -----

// tuple_make: operand type must match the element type.
func.func @make_elt_type_mismatch(%a: i64) -> !wavemeta.ptuple<i32, 1> {
  // expected-error @below {{operand type 'i64' must match result tuple element type 'i32'}}
  %t = wavemeta.tuple_make %a : (i64) -> !wavemeta.ptuple<i32, 1>
  return %t : !wavemeta.ptuple<i32, 1>
}

// -----

// tuple_get: result type must match the tuple's element type.
func.func @get_type_mismatch(%t: !wavemeta.ptuple<i32, "n">, %i: index) -> i64 {
  // expected-error @below {{result type 'i64' must match tuple element type 'i32'}}
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, "n"> -> i64
  return %v : i64
}

// -----

// tuple_set: value type must match the tuple's element type.
func.func @set_value_type_mismatch(%t: !wavemeta.ptuple<i32, "n">, %i: index, %v: i64) -> !wavemeta.ptuple<i32, "n"> {
  // expected-error @below {{value type 'i64' must match tuple element type 'i32'}}
  %r = wavemeta.tuple_set %t[%i], %v : !wavemeta.ptuple<i32, "n">, i64
  return %r : !wavemeta.ptuple<i32, "n">
}
