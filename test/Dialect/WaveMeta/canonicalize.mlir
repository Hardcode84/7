// RUN: wave-opt %s --canonicalize | FileCheck %s

// A bound `wavemeta.param` is `ConstantLike` and its folder returns
// the `$value` attribute. The dialect's constant materialiser
// rewrites the use site to an `arith.constant` of the same type
// and the now-dead param op gets DCE-d.

// CHECK-LABEL: func.func @bound_param_folds
// CHECK-NOT: wavemeta.param
// CHECK: %[[C:.+]] = arith.constant 4 : index
// CHECK: return %[[C]] : index
func.func @bound_param_folds() -> index {
  %v = wavemeta.param "unroll" {value = 4 : index} : index
  return %v : index
}

// Unbound params do NOT fold; they stay in the IR until a binding
// pass attaches a `$value`.
// CHECK-LABEL: func.func @unbound_param_stays
// CHECK: %[[V:.+]] = wavemeta.param "unroll" : index
// CHECK: return %[[V]] : index
func.func @unbound_param_stays() -> index {
  %v = wavemeta.param "unroll" : index
  return %v : index
}

// The bound value's type drives the materialised constant's type.
// i1 fold to a `true` (or `false`) constant; the canonicaliser may
// further inline it into the user.
// CHECK-LABEL: func.func @bound_param_i1
// CHECK-NOT: wavemeta.param
// CHECK: %[[T:.+]] = arith.constant true
// CHECK: return %[[T]] : i1
func.func @bound_param_i1() -> i1 {
  %v = wavemeta.param "use_lds" {value = true} : i1
  return %v : i1
}

// `tuple_get` of a `tuple_make_broadcast` collapses to the
// broadcasted init regardless of the index.
// CHECK-LABEL: func.func @get_of_broadcast
// CHECK-NOT: wavemeta.tuple_make_broadcast
// CHECK-NOT: wavemeta.tuple_get
// CHECK: return %arg0 : i32
func.func @get_of_broadcast(%init: i32, %i: index) -> i32 {
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, "n">
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, "n"> -> i32
  return %v : i32
}

// `tuple_get` of a concrete `tuple_make` with a constant index folds
// to the matching element.
// CHECK-LABEL: func.func @get_of_make_const_index
// CHECK-NOT: wavemeta.tuple_make
// CHECK-NOT: wavemeta.tuple_get
// CHECK: return %arg2 : i32
func.func @get_of_make_const_index(%a: i32, %b: i32, %c: i32, %d: i32) -> i32 {
  %t = wavemeta.tuple_make %a, %b, %c, %d : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4>
  %i = arith.constant 2 : index
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %v : i32
}

// `tuple_get` with a non-constant index does NOT fold; the op
// survives until the index becomes a constant via specialisation.
// CHECK-LABEL: func.func @get_dynamic_index_stays
// CHECK: %[[T:.+]] = wavemeta.tuple_make
// CHECK: %[[V:.+]] = wavemeta.tuple_get %[[T]][%arg4]
// CHECK: return %[[V]]
func.func @get_dynamic_index_stays(%a: i32, %b: i32, %c: i32, %d: i32, %i: index) -> i32 {
  %t = wavemeta.tuple_make %a, %b, %c, %d : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4>
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %v : i32
}
