// RUN: wave-opt %s --wavemeta-specialize --split-input-file | FileCheck %s

// ptuple as a function arg / return: the signature expands to N
// scalars. After specialisation no `!wavemeta.ptuple` survives.

// CHECK-LABEL: func.func @passthrough_tuple
// CHECK-SAME: (%[[A0:.+]]: i32, %[[A1:.+]]: i32, %[[A2:.+]]: i32, %[[A3:.+]]: i32) -> (i32, i32, i32, i32)
// CHECK-NOT: wavemeta.tuple_
// CHECK-NOT: wavemeta.ptuple
// CHECK: return %[[A0]], %[[A1]], %[[A2]], %[[A3]] : i32, i32, i32, i32
func.func @passthrough_tuple(%t: !wavemeta.ptuple<i32, 4>) -> !wavemeta.ptuple<i32, 4> {
  return %t : !wavemeta.ptuple<i32, 4>
}

// -----

// `tuple_get` against a function-arg ptuple: a constant index picks
// the matching scalar after the signature expands.

// CHECK-LABEL: func.func @get_of_arg
// CHECK-SAME: (%[[A0:.+]]: i32, %[[A1:.+]]: i32, %[[A2:.+]]: i32, %[[A3:.+]]: i32) -> i32
// CHECK: return %[[A2]] : i32
func.func @get_of_arg(%t: !wavemeta.ptuple<i32, 4>) -> i32 {
  %i = arith.constant 2 : index
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %v : i32
}

// -----

// CHECK-LABEL: func.func @get_of_parametric_arg
// CHECK-SAME: (%[[A0:.+]]: i32, %[[A1:.+]]: i32, %[[A2:.+]]: i32, %[[A3:.+]]: i32) -> i32
// CHECK-NOT: wave.index_expr
// CHECK-NOT: wavemeta.
// CHECK: return %[[A2]] : i32
module attributes {wavemeta.params = {n = 4 : index}} {
  func.func @get_of_parametric_arg(%t: !wavemeta.ptuple<i32, "n">) -> i32 {
    %n = wavemeta.param "n" : index
    %i = wave.index_expr <"n - 2"> ["n"](%n) : (index) -> index
    %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, "n"> -> i32
    return %v : i32
  }
}

// -----

// `tuple_set` against a function-arg ptuple with constant index:
// produces the new operand list where the target slot is the
// supplied value.

// CHECK-LABEL: func.func @set_of_arg
// CHECK-SAME: (%[[A0:.+]]: i32, %[[A1:.+]]: i32, %[[A2:.+]]: i32, %[[A3:.+]]: i32, %[[V:.+]]: i32) -> (i32, i32, i32, i32)
// CHECK: return %[[A0]], %[[V]], %[[A2]], %[[A3]] : i32, i32, i32, i32
func.func @set_of_arg(%t: !wavemeta.ptuple<i32, 4>, %v: i32) -> !wavemeta.ptuple<i32, 4> {
  %i = arith.constant 1 : index
  %t2 = wavemeta.tuple_set %t[%i], %v : !wavemeta.ptuple<i32, 4>, i32
  return %t2 : !wavemeta.ptuple<i32, 4>
}

// -----

// ptuple as an scf.for iter_arg: the iter_arg slot expands to N
// scalars; the yield carries them; the result slot expands too.
// The body's `tuple_get` against the iter-arg ptuple folds to the
// matching scalar after expansion.

// CHECK-LABEL: func.func @ptuple_as_iter_arg
// CHECK-NOT: wavemeta.ptuple
// CHECK: scf.for
// CHECK-SAME: iter_args(%{{.+}} = %arg0, %{{.+}} = %arg1) -> (i32, i32)
// CHECK: scf.yield %{{.+}}, %{{.+}} : i32, i32
func.func @ptuple_as_iter_arg(%a: i32, %b: i32, %lb: index, %ub: index, %step: index) -> i32 {
  %t = wavemeta.tuple_make %a, %b : (i32, i32) -> !wavemeta.ptuple<i32, 2>
  %r = scf.for %iv = %lb to %ub step %step iter_args(%acc = %t) -> !wavemeta.ptuple<i32, 2> {
    %i = arith.constant 0 : index
    %lo = wavemeta.tuple_get %acc[%i] : !wavemeta.ptuple<i32, 2> -> i32
    %j = arith.constant 1 : index
    %hi = wavemeta.tuple_get %acc[%j] : !wavemeta.ptuple<i32, 2> -> i32
    %new = wavemeta.tuple_make %hi, %lo : (i32, i32) -> !wavemeta.ptuple<i32, 2>
    scf.yield %new : !wavemeta.ptuple<i32, 2>
  }
  %k = arith.constant 0 : index
  %out = wavemeta.tuple_get %r[%k] : !wavemeta.ptuple<i32, 2> -> i32
  return %out : i32
}

// -----

// ptuple as an scf.if result.

// CHECK-LABEL: func.func @ptuple_as_if_result
// CHECK-NOT: wavemeta.ptuple
// CHECK: scf.if
// CHECK: scf.yield %{{.+}}, %{{.+}} : i32, i32
// CHECK: } else {
// CHECK: scf.yield %{{.+}}, %{{.+}} : i32, i32
func.func @ptuple_as_if_result(%c: i1, %a: i32, %b: i32) -> i32 {
  %r = scf.if %c -> !wavemeta.ptuple<i32, 2> {
    %t = wavemeta.tuple_make %a, %b : (i32, i32) -> !wavemeta.ptuple<i32, 2>
    scf.yield %t : !wavemeta.ptuple<i32, 2>
  } else {
    %t = wavemeta.tuple_make %b, %a : (i32, i32) -> !wavemeta.ptuple<i32, 2>
    scf.yield %t : !wavemeta.ptuple<i32, 2>
  }
  %i = arith.constant 1 : index
  %out = wavemeta.tuple_get %r[%i] : !wavemeta.ptuple<i32, 2> -> i32
  return %out : i32
}

// -----

// ptuple as a callee operand and result: both call sites and the
// callee's signature expand.

// CHECK-LABEL: func.func @callee
// CHECK-SAME: (%[[A0:.+]]: i32, %[[A1:.+]]: i32) -> (i32, i32)
// CHECK: return %[[A0]], %[[A1]] : i32, i32

// CHECK-LABEL: func.func @caller
// CHECK-SAME: (%[[A:.+]]: i32, %[[B:.+]]: i32) -> i32
// CHECK: %[[R:.+]]:2 = call @callee(%[[A]], %[[B]]) : (i32, i32) -> (i32, i32)
// CHECK: return %[[R]]#0 : i32
func.func @callee(%t: !wavemeta.ptuple<i32, 2>) -> !wavemeta.ptuple<i32, 2> {
  return %t : !wavemeta.ptuple<i32, 2>
}

func.func @caller(%a: i32, %b: i32) -> i32 {
  %t = wavemeta.tuple_make %a, %b : (i32, i32) -> !wavemeta.ptuple<i32, 2>
  %r = func.call @callee(%t) : (!wavemeta.ptuple<i32, 2>) -> !wavemeta.ptuple<i32, 2>
  %i = arith.constant 0 : index
  %out = wavemeta.tuple_get %r[%i] : !wavemeta.ptuple<i32, 2> -> i32
  return %out : i32
}
