// RUN: wave-opt %s --wavemeta-specialize -split-input-file | FileCheck %s

// Module-level `wavemeta.params` dict binds `unroll` to 4. The
// pre-bound `use_lds` already had `$value` attached; both fold to
// arith.constant via the dialect's materialiser.

// CHECK-LABEL: func.func @bound_via_dict
// CHECK-NOT: wavemeta.param
// CHECK: %[[C:.+]] = arith.constant 4 : index
// CHECK: return %[[C]] : index

// CHECK-LABEL: func.func @bound_via_attr
// CHECK-NOT: wavemeta.param
// CHECK: %[[T:.+]] = arith.constant true
// CHECK: return %[[T]] : i1

module attributes {wavemeta.params = {unroll = 4 : index, use_lds = true}} {
  func.func @bound_via_dict() -> index {
    %v = wavemeta.param "unroll" : index
    return %v : index
  }

  func.func @bound_via_attr() -> i1 {
    %v = wavemeta.param "use_lds" : i1
    return %v : i1
  }
}

// -----

// Parametric ptuple width: the type carries `"n"` as a StringAttr.
// The pre-phase looks up `n` in the `wavemeta.params` dict, swaps
// the width for the concrete int, and the existing decompose phase
// then expands it. After specialise, no `wavemeta.ptuple` survives.

// CHECK-LABEL: func.func @parametric_width
// CHECK-SAME: (%[[A:.+]]: i32) -> (i32, i32, i32)
// CHECK-NOT: wavemeta.ptuple
// CHECK: return %[[A]], %[[A]], %[[A]] : i32, i32, i32

module attributes {wavemeta.params = {n = 3 : index}} {
  func.func @parametric_width(%init: i32) -> !wavemeta.ptuple<i32, "n"> {
    %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, "n">
    return %t : !wavemeta.ptuple<i32, "n">
  }
}
