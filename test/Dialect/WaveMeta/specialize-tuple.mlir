// RUN: wave-opt %s --wavemeta-specialize --split-input-file | FileCheck %s

// Broadcast with concrete width: expand to N copies via the rewriter,
// then a constant-index tuple_get folds to the broadcasted init.

// CHECK-LABEL: func.func @get_of_broadcast
// CHECK-NOT: wavemeta.tuple_
// CHECK: return %arg0 : i32
func.func @get_of_broadcast(%init: i32) -> i32 {
  %i = arith.constant 1 : index
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, 4>
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %v : i32
}

// -----

// `tuple_get` of a concrete `tuple_make` with constant index folds to
// the matching operand.

// CHECK-LABEL: func.func @get_of_make
// CHECK-NOT: wavemeta.tuple_
// CHECK: return %arg2 : i32
func.func @get_of_make(%a: i32, %b: i32, %c: i32, %d: i32) -> i32 {
  %i = arith.constant 2 : index
  %t = wavemeta.tuple_make %a, %b, %c, %d : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4>
  %v = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %v : i32
}

// -----

// `tuple_set` with constant index rebuilds the tuple; subsequent
// `tuple_get` at the same index returns the new value.

// CHECK-LABEL: func.func @set_then_get
// CHECK-NOT: wavemeta.tuple_
// CHECK: return %arg4 : i32
func.func @set_then_get(%a: i32, %b: i32, %c: i32, %d: i32, %v: i32) -> i32 {
  %t = wavemeta.tuple_make %a, %b, %c, %d : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4>
  %i = arith.constant 1 : index
  %t2 = wavemeta.tuple_set %t[%i], %v : !wavemeta.ptuple<i32, 4>, i32
  %r = wavemeta.tuple_get %t2[%i] : !wavemeta.ptuple<i32, 4> -> i32
  return %r : i32
}

// -----

// Broadcast with parameter-named width whose binding resolves: the
// param folds to a... wait, the width is in the type system, not in
// SSA. Phase 2's BroadcastExpand pattern fires only on concrete
// IntegerAttr widths, so parameter-named widths must already be
// concrete in the type before this pass runs. We just smoke-test the
// concrete case where the rewriter expands an explicit broadcast.

// CHECK-LABEL: func.func @broadcast_expand_then_set
// CHECK-NOT: wavemeta.tuple_
// CHECK: return %arg1 : i32
func.func @broadcast_expand_then_set(%init: i32, %v: i32) -> i32 {
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, 3>
  %i = arith.constant 0 : index
  %t2 = wavemeta.tuple_set %t[%i], %v : !wavemeta.ptuple<i32, 3>, i32
  %r = wavemeta.tuple_get %t2[%i] : !wavemeta.ptuple<i32, 3> -> i32
  return %r : i32
}

// -----

// Tuple of size zero: tuple_make with no elements is well-formed
// (per the verifier); a get against it can never fold but a tuple
// that's just constructed and never used DCE-s.

// CHECK-LABEL: func.func @empty_tuple_unused
// CHECK-NOT: wavemeta.tuple_
// CHECK-NEXT: return
func.func @empty_tuple_unused() {
  %t = wavemeta.tuple_make : () -> !wavemeta.ptuple<i32, 0>
  return
}
