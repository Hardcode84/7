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

// CHECK-LABEL: func.func @ptr_add_signed_div_nonnegative
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_signed_div_nonnegative(%out: !wave.ptr<#wave.global, f32>,
                                          %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c2 = arith.constant 2 : i32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %half = wave.binary divsi %idx, %s2 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %half : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @index_expr_signed_div_binding
// CHECK-SAME: (%[[X:.*]]: index)
func.func @index_expr_signed_div_binding(%x_raw: index) -> index {
  %c2 = arith.constant 2 : index
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[X]]
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : index
  %half = wave.binary divsi %x, %c2 : index, index -> index
  // CHECK: [[IDX:%.*]] = wave.index_expr <"8*floor(1/2*raw0)"> ["raw0"](%[[ASSUME]]) : (index) -> index
  %idx = wave.index_expr <"8*y"> ["y"](%half) : (index) -> index
  return %idx : index
}

// -----

// CHECK-LABEL: func.func @signed_div_unknown_stays_raw
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @signed_div_unknown_stays_raw(%out: !wave.ptr<#wave.global, f32>,
                                        %idx: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c2 = arith.constant 2 : i32
  %s2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  // CHECK: [[DIV:%.*]] = wave.binary divsi %[[IDX]]
  %half = wave.binary divsi %idx, %s2 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[DIV]]
  %ptr = wave.ptr_add %out, %half : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @i64_signed_div_global
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, i8>, %[[IDX:.*]]: i64)
func.func @i64_signed_div_global(%out: !wave.ptr<#wave.global, i8>,
                                 %idx_raw: i64)
    -> !wave.ptr<#wave.global, i8> {
  %c2 = arith.constant 2 : i64
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8589934590">] : i64
  %half = wave.binary divsi %idx, %c2 : i64, i64 -> i64
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> ["raw0"](%[[ASSUME]]) : (i64) -> index
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, i8>, i64 -> !wave.ptr<#wave.global, i8>
  return %ptr : !wave.ptr<#wave.global, i8>
}

// -----

// CHECK-LABEL: func.func @i64_signed_div_xor_global
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, i8>, %[[IDX:.*]]: i64)
func.func @i64_signed_div_xor_global(%out: !wave.ptr<#wave.global, i8>,
                                     %idx_raw: i64)
    -> !wave.ptr<#wave.global, i8> {
  %c1 = arith.constant 1 : i64
  %c2 = arith.constant 2 : i64
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8">] : i64
  %xor = wave.binary xori %idx, %c1 : i64, i64 -> i64
  %half = wave.binary divsi %xor, %c2 : i64, i64 -> i64
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*xor(1, raw0))"> ["raw0"](%[[ASSUME]]) : (i64) -> index
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, i8>, i64 -> !wave.ptr<#wave.global, i8>
  return %ptr : !wave.ptr<#wave.global, i8>
}

// -----

// CHECK-LABEL: func.func @i64_signed_div_buffer_stays_raw
// CHECK-SAME: (%{{.*}}: !wave.ptr<#waveamd.buffer, i8>, %[[IDX:.*]]: i64)
func.func @i64_signed_div_buffer_stays_raw(%out: !wave.ptr<#waveamd.buffer, i8>,
                                           %idx_raw: i64)
    -> !wave.ptr<#waveamd.buffer, i8> {
  %c2 = arith.constant 2 : i64
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8589934590">] : i64
  // CHECK: [[DIV:%.*]] = wave.binary divsi %[[ASSUME]]
  %half = wave.binary divsi %idx, %c2 : i64, i64 -> i64
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[DIV]]
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#waveamd.buffer, i8>, i64 -> !wave.ptr<#waveamd.buffer, i8>
  return %ptr : !wave.ptr<#waveamd.buffer, i8>
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
