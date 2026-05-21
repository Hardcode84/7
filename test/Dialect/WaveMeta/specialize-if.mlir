// RUN: wave-opt %s --wavemeta-specialize --split-input-file | FileCheck %s

// True condition: only the then-region body remains, untaken else
// region is dropped, results are the then-yield operands.

// CHECK-LABEL: func.func @if_true
// CHECK-NOT: wavemeta.static_if
// CHECK: return %arg0 : i32
func.func @if_true(%a: i32, %b: i32) -> i32 {
  %c = arith.constant true
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// -----

// False condition: only the else-region body remains.

// CHECK-LABEL: func.func @if_false
// CHECK-NOT: wavemeta.static_if
// CHECK: return %arg1 : i32
func.func @if_false(%a: i32, %b: i32) -> i32 {
  %c = arith.constant false
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// -----

// No-results form: the void branch just disappears.

// CHECK-LABEL: func.func @if_void
// CHECK-NOT: wavemeta.static_if
// CHECK-NEXT: return
func.func @if_void() {
  %c = arith.constant true
  wavemeta.static_if %c {
    wavemeta.yield
  }
  return
}

// -----

// Param-driven condition: the bound `i1` param folds via
// `arith.constant`, the if then folds.

// CHECK-LABEL: func.func @if_param_driven
// CHECK-NOT: wavemeta.static_if
// CHECK-NOT: wavemeta.param
// CHECK: return %arg0 : i32
module attributes {wavemeta.params = {use_then = true}} {
  func.func @if_param_driven(%a: i32, %b: i32) -> i32 {
    %c = wavemeta.param "use_then" : i1
    %r = wavemeta.static_if %c -> (i32) {
      wavemeta.yield %a : i32
    } else {
      wavemeta.yield %b : i32
    }
    return %r : i32
  }
}

// -----

// Nested static_if: the outer fold exposes the inner condition; the
// inner then folds in the same greedy fixpoint.

// CHECK-LABEL: func.func @if_nested
// CHECK-NOT: wavemeta.static_if
// CHECK: return %arg2 : i32
func.func @if_nested(%a: i32, %b: i32, %c: i32) -> i32 {
  %t = arith.constant true
  %f = arith.constant false
  %r = wavemeta.static_if %t -> (i32) {
    %inner = wavemeta.static_if %f -> (i32) {
      wavemeta.yield %a : i32
    } else {
      wavemeta.yield %c : i32
    }
    wavemeta.yield %inner : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}
