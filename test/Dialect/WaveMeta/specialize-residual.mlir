// RUN: wave-opt %s --wavemeta-specialize --split-input-file --verify-diagnostics

// Param with no binding: diagnose and fail.
func.func @unbound_param() -> index {
  // expected-error@+1 {{parameter 'unroll' has no binding}}
  %v = wavemeta.param "unroll" : index
  return %v : index
}

// -----

// static_for whose bound is an unbound param: bounds never fold to
// constants and the param itself is unresolved.
func.func @unfolded_loop(%init: i32) -> i32 {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  // expected-error@+1 {{parameter 'n' has no binding}}
  %n = wavemeta.param "n" : index
  // expected-error@+1 {{static_for bounds do not fold to constants}}
  %r = wavemeta.static_for %c0 to %n step %c1 iter_args(%init : i32) {
  ^bb0(%iv: index, %x: i32):
    wavemeta.yield %x : i32
  } -> i32
  return %r : i32
}

// -----

// static_if whose condition is dynamic (an i1 SSA value, not a
// constant): pass leaves it intact, diagnostic fires.
func.func @dynamic_if(%c: i1, %a: i32, %b: i32) -> i32 {
  // expected-error@+1 {{static_if condition does not fold to a constant}}
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// -----

func.func @unresolved_unrolled_for(%init: index) -> index {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c8 = arith.constant 8 : index
  // expected-error@+1 {{parameter 'u' has no binding}}
  %u = wavemeta.param "u" : index
  // expected-error@+1 {{unrolled_for needs a positive constant unroll factor}}
  %r = wavemeta.unrolled_for %c0 to %c8 step %c1 unroll %u iter_args(%init : index) {
  ^bb0(%iv: index, %acc: index):
    %next = arith.addi %acc, %iv : index
    wavemeta.yield %next : index
  } -> index : index, index, index, index
  return %r : index
}

// -----

// tuple_get with a non-constant index against a tuple_make: the
// folder cannot fire; phase 3 can't pick a slot either.
func.func @nonconst_index(%a: i32, %b: i32, %i: index) -> i32 {
  %t = wavemeta.tuple_make %a, %b : (i32, i32) -> !wavemeta.ptuple<i32, 2>
  // expected-error@+1 {{tuple operation depends on a non-constant index or parametric width}}
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 2> -> i32
  return %v : i32
}

// -----

// Broadcast with parameter-named width: pass leaves it; diagnostic
// pinpoints the unresolved width. The function signature is also
// flagged because the returned ptuple is parametric.
// expected-error@+1 {{function signature retains unresolved parametric tuple type}}
func.func @parametric_broadcast(%init: i32) -> !wavemeta.ptuple<i32, "n"> {
  // expected-error@+1 {{broadcast has parameter-named width that did not resolve}}
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, "n">
  return %t : !wavemeta.ptuple<i32, "n">
}

// -----

// Name matches but the bound attribute's type doesn't match the
// ParamOp's result type. Used to be silently dropped, leading to a
// confusing "no binding" downstream. Now flagged with the actual
// type mismatch so autotuners feeding `i64` into an `index` param
// see the real cause.
module attributes {wavemeta.params = {tile = 4 : i64}} {
  func.func @type_mismatch() -> index {
    // expected-error@+1 {{wavemeta.params['tile'] has type 'i64', expected 'index'}}
    %v = wavemeta.param "tile" : index
    return %v : index
  }
}
