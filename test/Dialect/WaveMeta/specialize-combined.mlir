// RUN: wave-opt %s --wavemeta-specialize | FileCheck %s

// A small template: parameters drive both the loop bounds and the
// element values via a tuple. After specialisation the whole thing
// collapses to a flat sequence of arith ops; nothing wavemeta
// survives.

// CHECK-LABEL: func.func @template
// CHECK-NOT: wavemeta.
// CHECK: arith.addi
// CHECK: arith.addi
// CHECK: arith.addi
// CHECK: return

module attributes {wavemeta.params = {n = 3 : index}} {
  func.func @template(%base: i32, %x0: i32, %x1: i32, %x2: i32) -> i32 {
    %t = wavemeta.tuple_make %x0, %x1, %x2 : (i32, i32, i32) -> !wavemeta.ptuple<i32, 3>
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %n = wavemeta.param "n" : index
    %r = wavemeta.static_for %c0 to %n step %c1 iter_args(%base : i32) {
    ^bb0(%iv: index, %a: i32):
      %e = wavemeta.tuple_get %t[%iv] : !wavemeta.ptuple<i32, 3> -> i32
      %next = arith.addi %a, %e : i32
      wavemeta.yield %next : i32
    } -> i32
    return %r : i32
  }
}
