// RUN: wave-opt --pass-pipeline='builtin.module(canonicalize,wave-lower-token-selects,canonicalize)' %s | FileCheck %s

// CHECK-LABEL: func.func @canonicalized_condition_drops_arm
// CHECK-SAME: (%[[VALUE:.*]]: i32, %[[TRUE:.*]]: !wave.mem.token, %[[FALSE:.*]]: !wave.mem.token)
// CHECK-NOT: arith.cmpi
// CHECK-NOT: wave.select
// CHECK-NOT: wave.join
// CHECK: return %[[TRUE]], %[[FALSE]] : !wave.mem.token, !wave.mem.token
func.func @canonicalized_condition_drops_arm(
    %value: i32, %true: !wave.mem.token, %false: !wave.mem.token)
    -> (!wave.mem.token, !wave.mem.token) {
  %yes = arith.cmpi eq, %value, %value : i32
  %no = arith.cmpi ne, %value, %value : i32
  %selected_true = wave.select %yes, %true, %false : !wave.mem.token
  %selected_false = wave.select %no, %true, %false : !wave.mem.token
  return %selected_true, %selected_false : !wave.mem.token, !wave.mem.token
}

// CHECK-LABEL: func.func @lowering_drops_dead_condition
// CHECK-SAME: (%[[LHS:.*]]: i32, %[[RHS:.*]]: i32, %[[TRUE:.*]]: !wave.mem.token, %[[FALSE:.*]]: !wave.mem.token)
// CHECK-NOT: arith.cmpi
// CHECK-NOT: wave.select
// CHECK: %[[JOINED:.*]] = wave.join %[[TRUE]], %[[FALSE]] : !wave.mem.token, !wave.mem.token -> !wave.mem.token
// CHECK: return %[[JOINED]] : !wave.mem.token
func.func @lowering_drops_dead_condition(
    %lhs: i32, %rhs: i32, %true: !wave.mem.token,
    %false: !wave.mem.token) -> !wave.mem.token {
  %condition = arith.cmpi eq, %lhs, %rhs : i32
  %selected = wave.select %condition, %true, %false : !wave.mem.token
  return %selected : !wave.mem.token
}

// CHECK-LABEL: func.func @lowering_enables_join_cleanup
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[DEP:.*]]: !wave.mem.token)
// CHECK-NOT: wave.token
// CHECK-NOT: wave.select
// CHECK-NOT: wave.join
// CHECK: return %[[DEP]] : !wave.mem.token
func.func @lowering_enables_join_cleanup(%pred: i1, %dep: !wave.mem.token)
    -> !wave.mem.token {
  %dummy = wave.token : !wave.mem.token
  %selected = wave.select %pred, %dep, %dummy : !wave.mem.token
  return %selected : !wave.mem.token
}
