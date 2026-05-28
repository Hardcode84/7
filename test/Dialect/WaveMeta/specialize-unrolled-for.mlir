// RUN: wave-opt %s --wavemeta-specialize --split-input-file | FileCheck %s

// CHECK-LABEL: func.func @unrolled_main_and_tail
// CHECK-NOT: wavemeta.unrolled_for
// CHECK-NOT: wavemeta.static_for
// CHECK: %[[C8:.+]] = arith.constant 8 : index
// CHECK: %[[C4:.+]] = arith.constant 4 : index
// CHECK: %[[MAIN:.+]] = scf.for %[[MAIN_IV:.+]] = {{.*}} to %[[C8]] step %[[C4]] iter_args
// CHECK:   arith.addi
// CHECK:   scf.yield
// CHECK: %[[TAIL:.+]] = scf.for %[[TAIL_IV:.+]] = %[[C8]] to {{.*}} step {{.*}} iter_args({{.*}} = %[[MAIN]])
// CHECK:   %[[TAIL_NEXT:.+]] = arith.addi {{.*}}, %[[TAIL_IV]] : index
// CHECK:   scf.yield %[[TAIL_NEXT]] : index
// CHECK: return %[[TAIL]] : index
func.func @unrolled_main_and_tail(%init: index) -> index {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %c10 = arith.constant 10 : index
  %r = wavemeta.unrolled_for %c0 to %c10 step %c1 unroll %c4 iter_args(%init : index) {
  ^bb0(%iv: index, %acc: index):
    %next = arith.addi %acc, %iv : index
    wavemeta.yield %next : index
  } -> index
  return %r : index
}

// -----

module attributes {wavemeta.params = {u = 2 : index}} {
  // CHECK-LABEL: func.func @unrolled_with_bound_param
  // CHECK-NOT: wavemeta.param
  // CHECK-NOT: wavemeta.unrolled_for
  // CHECK-NOT: wavemeta.static_for
  // CHECK: %[[C4:.+]] = arith.constant 4 : index
  // CHECK: %[[C2:.+]] = arith.constant 2 : index
  // CHECK: scf.for {{.*}} to %[[C4]] step %[[C2]]
  // CHECK: scf.for {{.*}} = %[[C4]] to
  func.func @unrolled_with_bound_param(%init: index) -> index {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c5 = arith.constant 5 : index
    %u = wavemeta.param "u" : index
    %r = wavemeta.unrolled_for %c0 to %c5 step %c1 unroll %u iter_args(%init : index) {
    ^bb0(%iv: index, %acc: index):
      %next = arith.addi %acc, %iv : index
      wavemeta.yield %next : index
    } -> index
    return %r : index
  }
}

// -----

// CHECK-LABEL: func.func @unrolled_bare
// CHECK-NOT: wavemeta.unrolled_for
// CHECK-NOT: wavemeta.static_for
// CHECK: scf.for
// CHECK: scf.for
// CHECK: return
func.func @unrolled_bare(%out: memref<?xindex>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c5 = arith.constant 5 : index
  wavemeta.unrolled_for %c0 to %c5 step %c1 unroll %c2 {
  ^bb0(%iv: index):
    memref.store %iv, %out[%iv] : memref<?xindex>
    wavemeta.yield
  }
  return
}
