// RUN: wave-opt %s --wave-materialize-memory-variants -o %t.once
// RUN: wave-opt %t.once --wave-materialize-memory-variants -o %t.twice
// RUN: diff %t.once %t.twice
// RUN: FileCheck %s < %t.once

// CHECK-LABEL: func.func @pointer_choice
// CHECK: [[INDEX:%.*]] = wave.index_expr
// CHECK: [[INTEGER:%.*]] = wave.constant
// CHECK: [[SYMBOLIC:%.*]] = wave.ptr_add {{%.*}}, [[INDEX]]
// CHECK: [[RAW:%.*]] = wave.ptr_add {{%.*}}, [[INTEGER]]
// CHECK-NEXT: [[V0:%.*]], [[T0:%.*]] = wave.load [[SYMBOLIC]]
// CHECK-NEXT: [[V1:%.*]], [[T1:%.*]] = wave.load [[RAW]]
// CHECK-NEXT: [[VALUE:%.*]] = wave.materialization_variants [[V0]], [[V1]]
// CHECK-NEXT: [[TOKEN:%.*]] = wave.materialization_variants [[T0]], [[T1]]
// CHECK-NEXT: return [[VALUE]], [[TOKEN]]
func.func @pointer_choice(%base: !wave.ptr<#wave.global, i32>)
    -> (!wave.simd<i32, 32>, !wave.mem.token) {
  %index = wave.index_expr <"0"> []() : () -> index
  %integer = wave.constant 0 : i32 -> i32
  %symbolic = wave.ptr_add %base, %index
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %raw = wave.ptr_add %base, %integer
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %choice = wave.materialization_variants %symbolic, %raw
      : !wave.ptr<#wave.global, i32>
  %value, %token = wave.load %choice
      : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return %value, %token : !wave.simd<i32, 32>, !wave.mem.token
}

// CHECK-LABEL: func.func @offset_choice_with_value_use
// CHECK: [[OFFSET:%.*]] = wave.materialization_variants
// CHECK: [[V0:%.*]], [[T0:%.*]] = wave.load
// CHECK-NEXT: [[V1:%.*]], [[T1:%.*]] = wave.load
// CHECK-NEXT: [[VALUE:%.*]] = wave.materialization_variants [[V0]], [[V1]]
// CHECK-NEXT: [[TOKEN:%.*]] = wave.materialization_variants [[T0]], [[T1]]
// CHECK-NEXT: return [[OFFSET]], [[VALUE]], [[TOKEN]]
func.func @offset_choice_with_value_use(%base: !wave.ptr<#wave.global, i32>,
    %x: i32) -> (i32, !wave.simd<i32, 32>, !wave.mem.token) {
  %zero = wave.constant 0 : i32 -> i32
  %sum = wave.binary addi %x, %zero : i32, i32 -> i32
  %offset = wave.materialization_variants %x, %sum : i32
  %ptr = wave.ptr_add %base, %offset
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %value, %token = wave.load %ptr
      : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return %offset, %value, %token : i32, !wave.simd<i32, 32>, !wave.mem.token
}
