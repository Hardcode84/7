// RUN: wave-opt %s --wavemeta-specialize --split-input-file | FileCheck %s

// Trip-count zero: replaced by the iter_args.

// CHECK-LABEL: func.func @for_trip_zero
// CHECK-NOT: wavemeta.static_for
// CHECK: return %arg0 : i32
func.func @for_trip_zero(%init: i32) -> i32 {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %r = wavemeta.static_for %c0 to %c0 step %c1 iter_args(%init : i32) {
  ^bb0(%iv: index, %a: i32):
    wavemeta.yield %a : i32
  } -> i32
  return %r : i32
}

// -----

// Single iteration: the body is cloned once, the IV becomes a
// constant, the iter_arg threads through.

// CHECK-LABEL: func.func @for_trip_one
// CHECK-NOT: wavemeta.static_for
// CHECK: return %arg0 : index
func.func @for_trip_one(%init: index) -> index {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %r = wavemeta.static_for %c0 to %c1 step %c1 iter_args(%init : index) {
  ^bb0(%iv: index, %a: index):
    %next = arith.addi %a, %iv : index
    wavemeta.yield %next : index
  } -> index
  return %r : index
}

// -----

// Trip count four: four cloned bodies, accumulator threaded. The IV
// constants 0, 1, 2, 3 each appear once.

// CHECK-LABEL: func.func @for_trip_four
// CHECK-NOT: wavemeta.static_for
// CHECK-DAG: %[[C1:.+]] = arith.constant 1 : index
// CHECK-DAG: %[[C2:.+]] = arith.constant 2 : index
// CHECK-DAG: %[[C3:.+]] = arith.constant 3 : index
func.func @for_trip_four(%init: index) -> index {
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %r = wavemeta.static_for %c0 to %c4 step %c1 iter_args(%init : index) {
  ^bb0(%iv: index, %a: index):
    %next = arith.addi %a, %iv : index
    wavemeta.yield %next : index
  } -> index
  return %r : index
}

// -----

// Bare loop with side-effecting body: no iter_args, no results.
// Three iterations get inlined; no static_for survives.

// CHECK-LABEL: func.func @for_bare
// CHECK-NOT: wavemeta.static_for
// CHECK-COUNT-3: arith.addi
// CHECK: return
func.func @for_bare(%a: i32, %b: i32, %out: memref<3xi32>) {
  %c0 = arith.constant 0 : index
  %c3 = arith.constant 3 : index
  %c1 = arith.constant 1 : index
  wavemeta.static_for %c0 to %c3 step %c1 {
  ^bb0(%iv: index):
    %sum = arith.addi %a, %b : i32
    memref.store %sum, %out[%iv] : memref<3xi32>
    wavemeta.yield
  }
  return
}

// -----

// Bounds driven by params: the binding folds them to arith.constant,
// then the for unrolls.

// CHECK-LABEL: func.func @for_param_bounds
// CHECK-NOT: wavemeta.static_for
// CHECK-NOT: wavemeta.param
// CHECK-DAG: arith.constant 1 : index
module attributes {wavemeta.params = {n = 2 : index}} {
  func.func @for_param_bounds(%init: index) -> index {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %n = wavemeta.param "n" : index
    %r = wavemeta.static_for %c0 to %n step %c1 iter_args(%init : index) {
    ^bb0(%iv: index, %a: index):
      %next = arith.addi %a, %iv : index
      wavemeta.yield %next : index
    } -> index
    return %r : index
  }
}

// -----

// Nested static_for: outer two iterations, inner two iterations =
// four cloned innermost bodies. None of the wavemeta.static_for
// survives.

// CHECK-LABEL: func.func @for_nested
// CHECK-NOT: wavemeta.static_for
// CHECK: return
func.func @for_nested(%init: index) -> index {
  %c0 = arith.constant 0 : index
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %r = wavemeta.static_for %c0 to %c2 step %c1 iter_args(%init : index) {
  ^bb0(%ivo: index, %ao: index):
    %inner = wavemeta.static_for %c0 to %c2 step %c1 iter_args(%ao : index) {
    ^bb1(%ivi: index, %ai: index):
      %sum = arith.addi %ai, %ivi : index
      wavemeta.yield %sum : index
    } -> index
    wavemeta.yield %inner : index
  } -> index
  return %r : index
}
