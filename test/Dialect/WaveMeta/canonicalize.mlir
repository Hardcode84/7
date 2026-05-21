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
