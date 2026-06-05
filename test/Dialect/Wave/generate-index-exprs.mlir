// RUN: wave-opt --split-input-file --wave-generate-index-exprs %s | FileCheck %s

// CHECK-LABEL: func.func @ptr_add_binary_offset
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<index, 32>)
func.func @ptr_add_binary_offset(%out: !wave.ptr<#wave.global, f32>,
                                 %idx: !wave.simd<index, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c4 = arith.constant 4 : index
  // CHECK: [[OFF:%.*]] = wave.index_expr <"4 + raw0"> ["raw0"](%[[IDX]]) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %s4 = wave.splat %c4 : index -> !wave.simd<index, 32>
  %sum = wave.binary addi %idx, %s4 : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %sum : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @index_expr_binary_binding
// CHECK-SAME: (%[[K:.*]]: index, %[[X:.*]]: !wave.simd<index, 32>)
func.func @index_expr_binary_binding(%k: index, %x: !wave.simd<index, 32>) -> !wave.simd<index, 32> {
  %c1 = arith.constant 1 : index
  %s1 = wave.splat %c1 : index -> !wave.simd<index, 32>
  %sum = wave.binary addi %x, %s1 : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  // CHECK: [[IDX:%.*]] = wave.index_expr <"8 + K + 8*raw0"> ["K", "raw0"](%[[K]], %[[X]]) : (index, !wave.simd<index, 32>) -> !wave.simd<index, 32>
  %idx = wave.index_expr <"K + 8*x"> ["K", "x"](%k, %sum) : (index, !wave.simd<index, 32>) -> !wave.simd<index, 32>
  return %idx : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_scalar_index_binary
func.func @ptr_add_scalar_index_binary(%out: !wave.ptr<#wave.global, f32>,
                                       %base: index) -> !wave.ptr<#wave.global, f32> {
  %c16 = arith.constant 16 : index
  %sum = wave.binary addi %base, %c16 : index, index -> index
  // CHECK: [[OFF:%.*]] = wave.index_expr <"16 + raw0"> ["raw0"](%{{.*}}) : (index) -> index
  // CHECK: [[PTR:%.*]] = wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %sum : !wave.ptr<#wave.global, f32>, index -> !wave.ptr<#wave.global, f32>
  return %ptr : !wave.ptr<#wave.global, f32>
}

// -----

// CHECK-LABEL: func.func @unsupported_binary_stays_raw
func.func @unsupported_binary_stays_raw(%out: !wave.ptr<#wave.global, f32>,
                                        %x: index, %y: index) -> !wave.ptr<#wave.global, f32> {
  // CHECK: [[REM:%.*]] = wave.binary remui
  %rem = wave.binary remui %x, %y : index, index -> index
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[REM]]
  %ptr = wave.ptr_add %out, %rem : !wave.ptr<#wave.global, f32>, index -> !wave.ptr<#wave.global, f32>
  return %ptr : !wave.ptr<#wave.global, f32>
}

// -----

// CHECK-LABEL: func.func @i32_binary_stays_raw
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @i32_binary_stays_raw(%out: !wave.ptr<#wave.global, f32>,
                                %idx: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c4 = arith.constant 4 : i32
  %s4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  // CHECK: [[SUM:%.*]] = wave.binary addi %[[IDX]]
  %sum = wave.binary addi %idx, %s4 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[SUM]]
  %ptr = wave.ptr_add %out, %sum : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @dead_scalar_binding_dropped
func.func @dead_scalar_binding_dropped(%out: !wave.ptr<#wave.global, f32>,
                                       %base: index) -> !wave.ptr<#wave.global, f32> {
  %zero = wave.binary subi %base, %base : index, index -> index
  // CHECK: [[OFF:%.*]] = wave.index_expr <"0"> []() : () -> index
  // CHECK: [[PTR:%.*]] = wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %zero : !wave.ptr<#wave.global, f32>, index -> !wave.ptr<#wave.global, f32>
  return %ptr : !wave.ptr<#wave.global, f32>
}
