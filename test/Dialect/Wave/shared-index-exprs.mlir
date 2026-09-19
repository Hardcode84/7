// RUN: wave-opt --split-input-file --wave-generate-index-exprs --canonicalize --cse %s | FileCheck %s

// CHECK-LABEL: func.func @shared_cancellation
// CHECK-NOT: wave.binary
// CHECK: %[[INDEX:.*]] = wave.index_expr <"raw0">
// CHECK: %[[A:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK-NOT: wave.index_expr
// CHECK: %[[B:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK: return %[[A]], %[[B]]
func.func @shared_cancellation(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>) -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>) {
  %twice = wave.binary addi %x, %x overflow<nsw> : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary subi %twice, %x overflow<nsw> : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  return %a, %b : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
}

// -----

// CHECK-LABEL: func.func @shared_sum
// CHECK-NOT: wave.binary
// CHECK: %[[INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK: %[[A:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK-NOT: wave.index_expr
// CHECK: %[[B:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK: return %[[A]], %[[B]]
func.func @shared_sum(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>) -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>) {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %x, %one overflow<nsw> : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  return %a, %b : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
}

// -----

// CHECK-LABEL: func.func @shared_sum_with_typed_user
// CHECK: %[[SUM:.*]] = wave.binary addi
// CHECK: %[[INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK: %[[A:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK-NOT: wave.index_expr
// CHECK: %[[B:.*]] = wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK: return %[[A]], %[[B]], %[[SUM]]
func.func @shared_sum_with_typed_user(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>) -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<i32, 32>) {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %x, %one overflow<nsw> : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  return %a, %b, %sum : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @shared_identity_binding
// CHECK-NOT: wave.binary
// CHECK: %[[INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK-NOT: wave.index_expr
// CHECK: return %[[INDEX]], %[[INDEX]]
func.func @shared_identity_binding(%x: !wave.simd<i32, 32>) -> (!wave.simd<index, 32>, !wave.simd<index, 32>) {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %x, %one overflow<nsw> : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.index_expr <"a"> ["a"](%sum) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %b = wave.index_expr <"b"> ["b"](%sum) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %a, %b : !wave.simd<index, 32>, !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @shared_wrapping_sum
// CHECK: %[[SUM:.*]] = wave.binary addi
// CHECK-NOT: wave.index_expr
// CHECK: wave.ptr_add %{{.*}}, %[[SUM]]
// CHECK: wave.ptr_add %{{.*}}, %[[SUM]]
func.func @shared_wrapping_sum(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>) -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>) {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %x, %one : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  return %a, %b : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
}

// -----

// CHECK-LABEL: func.func @scoped_shared_offsets
// CHECK: scf.if
// CHECK: %[[POS:.*]] = wave.assume
// CHECK: %[[POS_INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK-SAME: ["raw0"](%[[POS]])
// CHECK: wave.ptr_add %{{.*}}, %[[POS_INDEX]]
// CHECK-NOT: wave.index_expr
// CHECK: wave.ptr_add %{{.*}}, %[[POS_INDEX]]
// CHECK: } else {
// CHECK: %[[NEG:.*]] = wave.assume
// CHECK: %[[NEG_INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK-SAME: ["raw0"](%[[NEG]])
// CHECK: wave.ptr_add %{{.*}}, %[[NEG_INDEX]]
// CHECK-NOT: wave.index_expr
// CHECK: wave.ptr_add %{{.*}}, %[[NEG_INDEX]]
func.func @scoped_shared_offsets(%cond: i1, %p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>) -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>) {
  %result:2 = scf.if %cond -> (!wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>) {
    %bounded = wave.assume %x as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
    %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %sum = wave.binary addi %bounded, %one : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    scf.yield %a, %b : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  } else {
    %bounded = wave.assume %x as "x" [#wave.pred<"x >= -32">, #wave.pred<"x <= -1">] : !wave.simd<i32, 32>
    %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %sum = wave.binary addi %bounded, %one : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    scf.yield %a, %b : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  }
  return %result#0, %result#1 : !wave.simd<!wave.ptr<#wave.global, i8>, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>
}

// -----

// CHECK-LABEL: func.func @shared_scalar_sum
// CHECK-NOT: wave.binary
// CHECK: %[[INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK: wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK: wave.ptr_add %{{.*}}, %[[INDEX]]
func.func @shared_scalar_sum(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: index) -> (!wave.ptr<#wave.global, i8>, !wave.ptr<#wave.global, i8>) {
  %one = arith.constant 1 : index
  %sum = wave.binary addi %x, %one overflow<nsw> : index, index -> index
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, index -> !wave.ptr<#wave.global, i8>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, index -> !wave.ptr<#wave.global, i8>
  return %a, %b : !wave.ptr<#wave.global, i8>, !wave.ptr<#wave.global, i8>
}

// -----

// CHECK-LABEL: func.func @shared_scalar_i64_sum
// CHECK-NOT: wave.binary
// CHECK: %[[INDEX:.*]] = wave.index_expr <"1 + raw0">
// CHECK: wave.ptr_add %{{.*}}, %[[INDEX]]
// CHECK: wave.ptr_add %{{.*}}, %[[INDEX]]
func.func @shared_scalar_i64_sum(%p: !wave.ptr<#wave.global, i8>, %q: !wave.ptr<#wave.global, i8>, %x: i64) -> (!wave.ptr<#wave.global, i8>, !wave.ptr<#wave.global, i8>) {
  %one = arith.constant 1 : i64
  %sum = wave.binary addi %x, %one overflow<nsw> : i64, i64 -> i64
  %a = wave.ptr_add %p, %sum : !wave.ptr<#wave.global, i8>, i64 -> !wave.ptr<#wave.global, i8>
  %b = wave.ptr_add %q, %sum : !wave.ptr<#wave.global, i8>, i64 -> !wave.ptr<#wave.global, i8>
  return %a, %b : !wave.ptr<#wave.global, i8>, !wave.ptr<#wave.global, i8>
}
