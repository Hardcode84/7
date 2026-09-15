// RUN: wave-opt --pass-pipeline='builtin.module(canonicalize,wave-convert-arith-selects,wave-lower-token-selects,canonicalize)' %s | FileCheck %s

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

// CHECK-LABEL: func.func @converted_arith_select_drops_dead_condition
// CHECK-SAME: (%[[LHS:.*]]: i32, %[[RHS:.*]]: i32, %[[TRUE:.*]]: !wave.mem.token, %[[FALSE:.*]]: !wave.mem.token)
// CHECK-NOT: arith.cmpi
// CHECK-NOT: arith.select
// CHECK: %[[JOINED:.*]] = wave.join %[[TRUE]], %[[FALSE]] : !wave.mem.token, !wave.mem.token -> !wave.mem.token
// CHECK: return %[[JOINED]] : !wave.mem.token
func.func @converted_arith_select_drops_dead_condition(
    %lhs: i32, %rhs: i32, %true: !wave.mem.token,
    %false: !wave.mem.token) -> !wave.mem.token {
  %condition = arith.cmpi eq, %lhs, %rhs : i32
  %selected = arith.select %condition, %true, %false : !wave.mem.token
  return %selected : !wave.mem.token
}

// CHECK-LABEL: func.func @convert_wave_value_select
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[TRUE:.*]]: !wave.simd<i32, 64>, %[[FALSE:.*]]: !wave.simd<i32, 64>)
// CHECK-NOT: arith.select
// CHECK: %[[SELECTED:.*]] = wave.select %[[PRED]], %[[TRUE]], %[[FALSE]] : !wave.simd<i32, 64>
// CHECK: return %[[SELECTED]] : !wave.simd<i32, 64>
func.func @convert_wave_value_select(
    %pred: i1, %true: !wave.simd<i32, 64>, %false: !wave.simd<i32, 64>)
    -> !wave.simd<i32, 64> {
  %selected = arith.select %pred, %true, %false : !wave.simd<i32, 64>
  return %selected : !wave.simd<i32, 64>
}

// CHECK-LABEL: func.func @convert_wave_mask_select
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[TRUE:.*]]: !wave.mask<64>, %[[FALSE:.*]]: !wave.mask<64>)
// CHECK-NOT: arith.select
// CHECK: %[[SELECTED:.*]] = wave.select %[[PRED]], %[[TRUE]], %[[FALSE]] : !wave.mask<64>
// CHECK: return %[[SELECTED]] : !wave.mask<64>
func.func @convert_wave_mask_select(
    %pred: i1, %true: !wave.mask<64>, %false: !wave.mask<64>)
    -> !wave.mask<64> {
  %selected = arith.select %pred, %true, %false : !wave.mask<64>
  return %selected : !wave.mask<64>
}

// CHECK-LABEL: func.func @convert_wave_pointer_select
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[TRUE:.*]]: !wave.ptr<#wave.global, i32>, %[[FALSE:.*]]: !wave.ptr<#wave.global, i32>)
// CHECK-NOT: arith.select
// CHECK: %[[SELECTED:.*]] = wave.select %[[PRED]], %[[TRUE]], %[[FALSE]] : !wave.ptr<#wave.global, i32>
// CHECK: return %[[SELECTED]] : !wave.ptr<#wave.global, i32>
func.func @convert_wave_pointer_select(
    %pred: i1, %true: !wave.ptr<#wave.global, i32>,
    %false: !wave.ptr<#wave.global, i32>) -> !wave.ptr<#wave.global, i32> {
  %selected = arith.select %pred, %true, %false
      : !wave.ptr<#wave.global, i32>
  return %selected : !wave.ptr<#wave.global, i32>
}

// CHECK-LABEL: func.func @keep_builtin_value_select
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[TRUE:.*]]: i32, %[[FALSE:.*]]: i32)
// CHECK: %[[SELECTED:.*]] = arith.select %[[PRED]], %[[TRUE]], %[[FALSE]] : i32
// CHECK-NOT: wave.select
// CHECK: return %[[SELECTED]] : i32
func.func @keep_builtin_value_select(
    %pred: i1, %true: i32, %false: i32) -> i32 {
  %selected = arith.select %pred, %true, %false : i32
  return %selected : i32
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
