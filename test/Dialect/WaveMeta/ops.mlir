// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @param_index
// CHECK: %[[V:.+]] = wavemeta.param "unroll" : index
// CHECK: return %[[V]] : index
func.func @param_index() -> index {
  %v = wavemeta.param "unroll" : index
  return %v : index
}

// CHECK-LABEL: func.func @param_i1
// CHECK: %[[V:.+]] = wavemeta.param "use_lds" : i1
// CHECK: return %[[V]] : i1
func.func @param_i1() -> i1 {
  %v = wavemeta.param "use_lds" : i1
  return %v : i1
}

// CHECK-LABEL: func.func @param_i32
// CHECK: %[[V:.+]] = wavemeta.param "tile_m" : i32
// CHECK: return %[[V]] : i32
func.func @param_i32() -> i32 {
  %v = wavemeta.param "tile_m" : i32
  return %v : i32
}

// CHECK-LABEL: func.func @param_i64
// CHECK: %[[V:.+]] = wavemeta.param "depth" : i64
// CHECK: return %[[V]] : i64
func.func @param_i64() -> i64 {
  %v = wavemeta.param "depth" : i64
  return %v : i64
}

// Bound form: `$value` attribute attached, type matches the result.
// CHECK-LABEL: func.func @param_bound
// CHECK: %[[V:.+]] = wavemeta.param "unroll" {value = 4 : index} : index
// CHECK: return %[[V]] : index
func.func @param_bound() -> index {
  %v = wavemeta.param "unroll" {value = 4 : index} : index
  return %v : index
}

// static_for with iter_args: body block has IV + per-iter-arg block
// args, terminated by wavemeta.yield with matching operand types.
// CHECK-LABEL: func.func @for_with_iter_args
// CHECK: %[[R:.+]] = wavemeta.static_for %{{.+}} to %{{.+}} step %{{.+}} iter_args(%{{.+}} : i32) {
// CHECK-NEXT: ^bb0(%{{.+}}: index, %[[ACC:.+]]: i32):
// CHECK-NEXT:   wavemeta.yield %[[ACC]] : i32
// CHECK-NEXT: } -> i32
// CHECK: return %[[R]] : i32
func.func @for_with_iter_args(%lb: index, %ub: index, %step: index, %init: i32) -> i32 {
  %r = wavemeta.static_for %lb to %ub step %step iter_args(%init : i32) {
  ^bb0(%iv: index, %acc: i32):
    wavemeta.yield %acc : i32
  } -> i32
  return %r : i32
}

// static_for without iter_args / results: bare loop, yield takes no
// operands.
// CHECK-LABEL: func.func @for_bare
// CHECK: wavemeta.static_for %{{.+}} to %{{.+}} step %{{.+}} {
// CHECK-NEXT: ^bb0(%{{.+}}: index):
// CHECK-NEXT:   wavemeta.yield
// CHECK-NEXT: }
func.func @for_bare(%lb: index, %ub: index, %step: index) {
  wavemeta.static_for %lb to %ub step %step {
  ^bb0(%iv: index):
    wavemeta.yield
  }
  return
}

// static_for with two iter_args of different types.
// CHECK-LABEL: func.func @for_multi_iter
// CHECK: %[[R:.+]]:2 = wavemeta.static_for %{{.+}} to %{{.+}} step %{{.+}} iter_args(%{{.+}}, %{{.+}} : i32, i64) {
// CHECK-NEXT: ^bb0(%{{.+}}: index, %[[A:.+]]: i32, %[[B:.+]]: i64):
// CHECK-NEXT:   wavemeta.yield %[[A]], %[[B]] : i32, i64
// CHECK-NEXT: } -> i32, i64
func.func @for_multi_iter(%lb: index, %ub: index, %step: index, %i32: i32, %i64: i64) -> (i32, i64) {
  %r:2 = wavemeta.static_for %lb to %ub step %step iter_args(%i32, %i64 : i32, i64) {
  ^bb0(%iv: index, %a: i32, %b: i64):
    wavemeta.yield %a, %b : i32, i64
  } -> i32, i64
  return %r#0, %r#1 : i32, i64
}

// CHECK-LABEL: func.func @unrolled_for_with_iter_args
// CHECK: %[[R:.+]] = wavemeta.unrolled_for %{{.+}} to %{{.+}} step %{{.+}} unroll %{{.+}} iter_args(%{{.+}} : index) {
// CHECK-NEXT: ^bb0(%[[IV:.+]]: index, %[[ACC:.+]]: index):
// CHECK-NEXT:   %[[NEXT:.+]] = arith.addi %[[ACC]], %[[IV]] : index
// CHECK-NEXT:   wavemeta.yield %[[NEXT]] : index
// CHECK-NEXT: } -> index
// CHECK: return %[[R]] : index
func.func @unrolled_for_with_iter_args(%lb: index, %ub: index, %step: index,
                                       %unroll: index, %init: index) -> index {
  %r = wavemeta.unrolled_for %lb to %ub step %step unroll %unroll iter_args(%init : index) {
  ^bb0(%iv: index, %acc: index):
    %next = arith.addi %acc, %iv : index
    wavemeta.yield %next : index
  } -> index : index, index, index, index
  return %r : index
}

// static_if with results: both regions yield matching types.
// CHECK-LABEL: func.func @if_with_results
// CHECK: %[[R:.+]] = wavemeta.static_if %{{.+}} -> (i32) {
// CHECK-NEXT:   wavemeta.yield %{{.+}} : i32
// CHECK-NEXT: } else {
// CHECK-NEXT:   wavemeta.yield %{{.+}} : i32
// CHECK-NEXT: }
// CHECK: return %[[R]] : i32
func.func @if_with_results(%c: i1, %a: i32, %b: i32) -> i32 {
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// static_if with no results, no else: void branch.
// CHECK-LABEL: func.func @if_no_results
// CHECK: wavemeta.static_if %{{.+}} {
// CHECK-NEXT:   wavemeta.yield
// CHECK-NEXT: }
func.func @if_no_results(%c: i1) {
  wavemeta.static_if %c {
    wavemeta.yield
  }
  return
}

// tuple_make_broadcast: parameter-named width is fine; init's type
// must match the result's element type.
// CHECK-LABEL: func.func @tuple_make_broadcast
// CHECK: %[[T:.+]] = wavemeta.tuple_make_broadcast %{{.+}} : i32 -> <i32, "unroll">
// CHECK: return %[[T]]
func.func @tuple_make_broadcast(%init: i32) -> !wavemeta.ptuple<i32, "unroll"> {
  %t = wavemeta.tuple_make_broadcast %init : i32 -> !wavemeta.ptuple<i32, "unroll">
  return %t : !wavemeta.ptuple<i32, "unroll">
}

// tuple_make: concrete width N, exactly N operands of the element type.
// CHECK-LABEL: func.func @tuple_make
// CHECK: %[[T:.+]] = wavemeta.tuple_make {{.+}} : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4 : i64>
func.func @tuple_make(%a: i32, %b: i32, %c: i32, %d: i32) -> !wavemeta.ptuple<i32, 4> {
  %t = wavemeta.tuple_make %a, %b, %c, %d : (i32, i32, i32, i32) -> !wavemeta.ptuple<i32, 4>
  return %t : !wavemeta.ptuple<i32, 4>
}

// tuple_make with zero elements + concrete width 0.
// CHECK-LABEL: func.func @tuple_make_empty
// CHECK: %[[T:.+]] = wavemeta.tuple_make : () -> !wavemeta.ptuple<i32, 0 : i64>
func.func @tuple_make_empty() -> !wavemeta.ptuple<i32, 0> {
  %t = wavemeta.tuple_make : () -> !wavemeta.ptuple<i32, 0>
  return %t : !wavemeta.ptuple<i32, 0>
}

// tuple_get / tuple_set: static index access; result of set has same
// tuple type as input.
// CHECK-LABEL: func.func @tuple_get_set
// CHECK: %[[G:.+]] = wavemeta.tuple_get %{{.+}}[%{{.+}}] : <i32, "n"> -> i32
// CHECK: %[[S:.+]] = wavemeta.tuple_set %{{.+}}[%{{.+}}], %{{.+}} : <i32, "n">, i32
// CHECK: return %[[S]]
func.func @tuple_get_set(%t: !wavemeta.ptuple<i32, "n">, %i: index, %v: i32) -> !wavemeta.ptuple<i32, "n"> {
  %g = wavemeta.tuple_get %t[%i] : !wavemeta.ptuple<i32, "n"> -> i32
  %s = wavemeta.tuple_set %t[%i], %v : !wavemeta.ptuple<i32, "n">, i32
  return %s : !wavemeta.ptuple<i32, "n">
}
