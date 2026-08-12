// RUN: wave-opt --split-input-file --wave-generate-index-exprs %s | FileCheck %s

// CHECK-LABEL: func.func @ptr_add_binary_offset
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<index, 32>)
func.func @ptr_add_binary_offset(%out: !wave.ptr<#wave.global, f32>,
                                 %idx: !wave.simd<index, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c4 = arith.constant 4 : index
  // CHECK: [[OFF:%.*]] = wave.index_expr <"4 + raw0"> ["raw0"](%[[IDX]]) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %s4 = wave.splat %c4 : index -> !wave.simd<index, 32>
  %sum = wave.binary addi %idx, %s4 overflow<nsw> : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
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
  %sum = wave.binary addi %x, %s1 overflow<nsw> : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  // CHECK: [[IDX:%.*]] = wave.index_expr <"8 + K + 8*raw0"> ["K", "raw0"](%[[K]], %[[X]]) : (index, !wave.simd<index, 32>) -> !wave.simd<index, 32>
  %idx = wave.index_expr <"K + 8*x"> ["K", "x"](%k, %sum) : (index, !wave.simd<index, 32>) -> !wave.simd<index, 32>
  return %idx : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_scalar_index_binary
func.func @ptr_add_scalar_index_binary(%out: !wave.ptr<#wave.global, f32>,
                                       %base: index) -> !wave.ptr<#wave.global, f32> {
  %c16 = arith.constant 16 : index
  %sum = wave.binary addi %base, %c16 overflow<nsw> : index, index -> index
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

// Runtime div/rem stay as SSA leaves so both operations use the ordinary
// integer div/rem expansion instead of being duplicated as symbolic nodes.
// CHECK-LABEL: func.func @dynamic_div_rem_stay_bound
func.func @dynamic_div_rem_stay_bound(
    %out: !wave.ptr<#wave.global, i8>, %x_raw: i32, %d_raw: i32)
    -> !wave.ptr<#wave.global, i8> {
  %x = wave.assume %x_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %d = wave.assume %d_raw as "d"
      [#wave.pred<"d >= 1">, #wave.pred<"d <= 1023">] : i32
  // CHECK: [[DIV:%.*]] = wave.binary divui
  %quotient = wave.binary divui %x, %d : i32, i32 -> i32
  // CHECK: [[REM:%.*]] = wave.binary remui
  %remainder = wave.binary remui %x, %d : i32, i32 -> i32
  %offset = wave.binary addi %quotient, %remainder overflow<nsw, nuw>
      : i32, i32 -> i32
  // CHECK: [[INDEX:%.*]] = wave.index_expr <"raw0 + raw1">
  // CHECK-SAME: ["raw0", "raw1"]([[DIV]], [[REM]])
  // CHECK: wave.ptr_add %{{.*}}, [[INDEX]]
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
  return %ptr : !wave.ptr<#wave.global, i8>
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
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
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
  // CHECK: [[IDX:%.*]] = wave.index_expr <"8*floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (index) -> index
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
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-8589934590 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (i64) -> index
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
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-8 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (i64) -> index
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

// CHECK-LABEL: func.func @unflagged_index_binary_stays_raw
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<index, 32>)
func.func @unflagged_index_binary_stays_raw(%out: !wave.ptr<#wave.global, f32>,
                                            %idx: !wave.simd<index, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c4 = arith.constant 4 : index
  %s4 = wave.splat %c4 : index -> !wave.simd<index, 32>
  // CHECK: [[SUM:%.*]] = wave.binary addi %[[IDX]]
  %sum = wave.binary addi %idx, %s4
      : !wave.simd<index, 32>, !wave.simd<index, 32>
      -> !wave.simd<index, 32>
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[SUM]]
  %ptr = wave.ptr_add %out, %sum
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @range_proven_i32_binary
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @range_proven_i32_binary(%out: !wave.ptr<#wave.global, f32>,
                                   %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c4 = arith.constant 4 : i32
  %c8 = arith.constant 8 : i32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %s8 = wave.splat %c8 : i32 -> !wave.simd<i32, 32>
  %scaled = wave.binary muli %idx, %s8
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %scaled, %s4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"4 + 8*raw0"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %sum
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_unsigned_shift_right_nonnegative
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_unsigned_shift_right_nonnegative(
    %out: !wave.ptr<#wave.global, f32>, %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c1 = arith.constant 1 : i32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %half = wave.binary shrui %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_power_of_two_mask_nonnegative
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_power_of_two_mask_nonnegative(
    %out: !wave.ptr<#wave.global, f32>, %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  %c15 = arith.constant 15 : i32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s15 = wave.splat %c15 : i32 -> !wave.simd<i32, 32>
  %masked = wave.binary andi %idx, %s15
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"Mod(raw0, 16)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %masked
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_dynamic_bitwise_offsets
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, i32>, %[[LHS:.*]]: !wave.simd<i32, 32>, %[[RHS:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_dynamic_bitwise_offsets(
    %out: !wave.ptr<#wave.global, i32>, %lhs: !wave.simd<i32, 32>,
    %rhs: !wave.simd<i32, 32>)
    -> (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
        !wave.simd<!wave.ptr<#wave.global, i32>, 32>) {
  %and = wave.binary andi %lhs, %rhs
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %or = wave.binary ori %lhs, %rhs
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK-NOT: wave.binary andi
  // CHECK-NOT: wave.binary ori
  // CHECK: [[AND:%.*]] = wave.index_expr <"raw0 & raw1">
  // CHECK: [[AND_PTR:%.*]] = wave.ptr_add %{{.*}}, [[AND]]
  %and_ptr = wave.ptr_add %out, %and
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  // CHECK: [[OR:%.*]] = wave.index_expr <"raw0 | raw1">
  // CHECK: [[OR_PTR:%.*]] = wave.ptr_add %{{.*}}, [[OR]]
  %or_ptr = wave.ptr_add %out, %or
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  return %and_ptr, %or_ptr
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
        !wave.simd<!wave.ptr<#wave.global, i32>, 32>
}

// -----

// CHECK-LABEL: func.func @workitem_id_without_known_size_uses_range_fallback
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>)
func.func @workitem_id_without_known_size_uses_range_fallback(
    %out: !wave.ptr<#wave.global, f32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 64> {
  %c1 = arith.constant 1 : i32
  // CHECK: [[WI:%.*]] = wave.workitem_id
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %half = wave.binary shrui %wi, %s1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0 & -2147483647 + raw0 <= 0">] ["raw0"]([[WI]]) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 64>
}

// -----

// CHECK-LABEL: func.func @shared_i32_mask_offset_synthesizes
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.shared, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @shared_i32_mask_offset_synthesizes(
    %out: !wave.ptr<#wave.shared, f32>, %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.shared, f32>, 32> {
  %c15 = arith.constant 15 : i32
  // CHECK: [[ASSUME:%.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s15 = wave.splat %c15 : i32 -> !wave.simd<i32, 32>
  %masked = wave.binary andi %idx, %s15
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"Mod(raw0, 16)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"]([[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %masked
      : !wave.ptr<#wave.shared, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.shared, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @shared_i32_xor_offset_keeps_storage_range
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.shared, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @shared_i32_xor_offset_keeps_storage_range(
    %out: !wave.ptr<#wave.shared, f32>, %idx: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.shared, f32>, 32> {
  %c1 = arith.constant 1 : i32
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %offset = wave.binary xori %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"xor(1, raw0)"> assuming [#wave.pred<"2147483648 + raw0 >= 0 & -2147483647 + raw0 <= 0">] ["raw0"](%[[IDX]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.shared, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.shared, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_select_offset
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>, %[[LIMIT:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_select_offset(
    %out: !wave.ptr<#wave.global, f32>, %idx_raw: !wave.simd<i32, 32>,
    %limit_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  // CHECK: [[IDX_ASSUME:%.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  // CHECK: [[LIMIT_ASSUME:%.*]] = wave.assume %[[LIMIT]]
  %limit = wave.assume %limit_raw as "y" [#wave.pred<"y >= 0">, #wave.pred<"y <= 31">] : !wave.simd<i32, 32>
  %mask = wave.cmpi slt %idx, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %selected = wave.select %mask, %idx, %limit
      : !wave.mask<32>, !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"Piecewise(
  // CHECK-SAME: raw0
  // CHECK-SAME: raw1
  // CHECK-SAME: assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">, #wave.pred<"raw1 >= 0">, #wave.pred<"-31 + raw1 <= 0">] ["raw0", "raw1"]([[IDX_ASSUME]], [[LIMIT_ASSUME]]) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %selected
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @ptr_add_assumed_select_offset
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>, %[[LIMIT:.*]]: !wave.simd<i32, 32>)
func.func @ptr_add_assumed_select_offset(
    %out: !wave.ptr<#wave.global, f32>, %idx_raw: !wave.simd<i32, 32>,
    %limit_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, f32>, 32> {
  // CHECK: [[IDX_ASSUME:%.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  // CHECK: [[LIMIT_ASSUME:%.*]] = wave.assume %[[LIMIT]]
  %limit = wave.assume %limit_raw as "y" [#wave.pred<"y >= 0">, #wave.pred<"y <= 31">] : !wave.simd<i32, 32>
  %mask = wave.cmpi ult %idx, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %selected_raw = wave.select %mask, %idx, %limit
      : !wave.mask<32>, !wave.simd<i32, 32>
  %selected = wave.assume %selected_raw as "z" [#wave.pred<"z >= 0">, #wave.pred<"z <= 31">] : !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"Piecewise(
  // CHECK-SAME: raw0
  // CHECK-SAME: raw1
  // CHECK-SAME: assuming {{.*}} ["raw0", "raw1"]([[IDX_ASSUME]], [[LIMIT_ASSUME]]) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %selected
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @standalone_i32_cmp_arithmetic_stays_i32
// CHECK-SAME: (%[[IDX:.*]]: !wave.simd<i32, 32>, %[[LIMIT:.*]]: !wave.simd<i32, 32>)
func.func @standalone_i32_cmp_arithmetic_stays_i32(
    %idx: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>)
    -> !wave.mask<32> {
  %c1 = arith.constant 1 : i32
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  // CHECK: [[SUM:%.*]] = wave.binary addi %[[IDX]], %{{.*}} : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.cmpi slt [[SUM]], %[[LIMIT]] : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %mask = wave.cmpi slt %sum, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %mask : !wave.mask<32>
}

// -----

// CHECK-LABEL: func.func @index_expr_assumed_select_binding_expands
// CHECK-SAME: (%[[IDX:.*]]: !wave.simd<i32, 32>, %[[LIMIT:.*]]: !wave.simd<i32, 32>)
func.func @index_expr_assumed_select_binding_expands(
    %idx_raw: !wave.simd<i32, 32>, %limit_raw: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  // CHECK: [[IDX_ASSUME:%.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  // CHECK: [[LIMIT_ASSUME:%.*]] = wave.assume %[[LIMIT]]
  %limit = wave.assume %limit_raw as "y" [#wave.pred<"y >= 0">, #wave.pred<"y <= 31">] : !wave.simd<i32, 32>
  %mask = wave.cmpi ult %idx, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %selected_raw = wave.select %mask, %idx, %limit
      : !wave.mask<32>, !wave.simd<i32, 32>
  %selected = wave.assume %selected_raw as "z" [#wave.pred<"z >= 0">, #wave.pred<"z <= 31">] : !wave.simd<i32, 32>
  // CHECK-NOT: wave.select
  // CHECK: [[OUT:%.*]] = wave.index_expr <"2*Piecewise(
  // CHECK-SAME: raw0
  // CHECK-SAME: raw1
  // CHECK-SAME: assuming {{.*}} ["raw0", "raw1"]([[IDX_ASSUME]], [[LIMIT_ASSUME]]) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %out = wave.index_expr <"2*z"> ["z"](%selected)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %out : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @assumed_existing_index_expr_binding_expands
// CHECK-SAME: (%[[ORIGIN:.*]]: i32, %[[LANE:.*]]: !wave.simd<i32, 32>)
func.func @assumed_existing_index_expr_binding_expands(
    %origin: i32, %lane: !wave.simd<i32, 32>) -> !wave.simd<index, 32> {
  %inner = wave.index_expr <"origin + xor(1, lid)">
      ["origin", "lid"](%origin, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %bounded = wave.assume %inner as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<index, 32>
  // CHECK: [[OUT:%.*]] = wave.index_expr <"2*(origin + xor(1, lid))"> assuming
  // CHECK-SAME: #wave.pred<"origin + xor(1, lid) >= 0">
  // CHECK-SAME: #wave.pred<"-31 + origin + xor(1, lid) <= 0">
  // CHECK-SAME: ["origin", "lid"](%[[ORIGIN]], %[[LANE]]) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %outer = wave.index_expr <"2*x"> ["x"](%bounded)
      : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  return %outer : !wave.simd<index, 32>
}

// -----

// Private singleton: preserve producer identity as one symbolic root.
// CHECK-LABEL: func.func @private_singleton_assume_stays_atomic
// CHECK-SAME: (%[[ORIGIN:.*]]: !wave.simd<i32, 32>, %{{.*}}: !wave.simd<i32, 32>)
// CHECK: wave.index_expr <"1 + raw0"> assuming
// CHECK-SAME: ["raw0"](%[[ORIGIN]])
func.func @private_singleton_assume_stays_atomic(
    %origin: !wave.simd<i32, 32>, %next: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32>
    attributes {wave.address_arithmetic_no_overflow} {
  %delta = wave.binary subi %next, %origin
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %unit = wave.assume %delta as "x"
      [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x <= 0">]
      : !wave.simd<i32, 32>
  %normalized = wave.binary addi %origin, %unit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %out = wave.index_expr <"y"> ["y"](%normalized)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %out : !wave.simd<index, 32>
}

// -----

// Exact singleton definition eliminates origin and its duplicate delta path.
// CHECK-LABEL: func.func @shared_singleton_assume_normalizes_definition
// CHECK-SAME: (%[[ORIGIN:.*]]: !wave.simd<i32, 32>, %[[NEXT:.*]]: !wave.simd<i32, 32>)
// CHECK: wave.index_expr <"1 + raw1"> assuming
// CHECK-SAME: ["raw1"](%[[NEXT]])
func.func @shared_singleton_assume_normalizes_definition(
    %origin: !wave.simd<i32, 32>, %next: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32>
    attributes {wave.address_arithmetic_no_overflow} {
  %delta = wave.binary subi %next, %origin
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %unit = wave.assume %delta as "x"
      [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x <= 0">]
      : !wave.simd<i32, 32>
  %normalized = wave.binary addi %origin, %unit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %combined = wave.binary addi %normalized, %delta
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %out = wave.index_expr <"y"> ["y"](%combined)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %out : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @rewritten_index_expr_range_expands
// CHECK-SAME: (%[[X_RAW:.*]]: i32, %[[Y_RAW:.*]]: i32)
func.func @rewritten_index_expr_range_expands(
    %x_raw: i32, %y_raw: i32) -> index {
  %c2 = arith.constant 2 : i32
  // CHECK: %[[X:.*]] = wave.assume %[[X_RAW]]
  %x = wave.assume %x_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 3">] : i32
  // CHECK: %[[Y:.*]] = wave.assume %[[Y_RAW]]
  %y = wave.assume %y_raw as "y"
      [#wave.pred<"y >= 0">, #wave.pred<"y <= 3">] : i32
  %twice = wave.binary muli %x, %c2 : i32, i32 -> i32
  %base = wave.index_expr <"65536*slot"> ["slot"](%twice)
      : (i32) -> index
  %lane = wave.index_expr <"lane"> ["lane"](%y) : (i32) -> index
  %sum = wave.binary addi %base, %lane : index, index -> index
  // CHECK-NOT: wave.binary
  // CHECK: wave.index_expr <"4*(lane + 131072*raw0)">
  // CHECK-SAME: ["raw0", "lane"](%[[X]], %[[Y]]) : (i32, i32) -> index
  %out = wave.index_expr <"4*orig"> ["orig"](%sum) : (index) -> index
  return %out : index
}

// -----

// CHECK-LABEL: func.func @multi_use_binding_expands
// CHECK-SAME: (%{{.*}}: !wave.simd<i32, 32>)
func.func @multi_use_binding_expands(%idx_raw: !wave.simd<i32, 32>)
    -> (!wave.simd<index, 32>, !wave.simd<index, 32>) {
  %c1 = arith.constant 1 : i32
  // CHECK: [[ASSUME:%.*]] = wave.assume
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK-NOT: wave.binary addi
  // CHECK: wave.index_expr <"2*(1 + raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"]([[ASSUME]])
  %a = wave.index_expr <"2*x"> ["x"](%sum)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.index_expr <"3*(1 + raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"]([[ASSUME]])
  %b = wave.index_expr <"3*y"> ["y"](%sum)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %a, %b : !wave.simd<index, 32>, !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @multi_use_ptr_add_offset_stays_shared
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global, f32>, %{{.*}}: !wave.ptr<#wave.global, f32>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @multi_use_ptr_add_offset_stays_shared(
    %out_a: !wave.ptr<#wave.global, f32>,
    %out_b: !wave.ptr<#wave.global, f32>,
    %idx_raw: !wave.simd<i32, 32>)
    -> (!wave.simd<!wave.ptr<#wave.global, f32>, 32>,
        !wave.simd<!wave.ptr<#wave.global, f32>, 32>) {
  %c1 = arith.constant 1 : i32
  %idx = wave.assume %idx_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  // CHECK: [[SUM:%.*]] = wave.binary addi
  %sum = wave.binary addi %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[SUM]]
  %a = wave.ptr_add %out_a, %sum
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  // CHECK: wave.ptr_add %{{.*}}, [[SUM]]
  %b = wave.ptr_add %out_b, %sum
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return %a, %b
      : !wave.simd<!wave.ptr<#wave.global, f32>, 32>,
        !wave.simd<!wave.ptr<#wave.global, f32>, 32>
}

// -----

// CHECK-LABEL: func.func @multi_use_scalar_ptr_add_offset_expands
func.func @multi_use_scalar_ptr_add_offset_expands(
    %out_a: !wave.ptr<#wave.global, f32>,
    %out_b: !wave.ptr<#wave.global, f32>,
    %idx_raw: i32)
    -> (!wave.ptr<#wave.global, f32>, !wave.ptr<#wave.global, f32>) {
  %c128 = arith.constant 128 : i32
  %idx = wave.assume %idx_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %offset = wave.binary muli %idx, %c128 : i32, i32 -> i32
  // CHECK: [[A_OFF:%.*]] = wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[A_OFF]]
  %a = wave.ptr_add %out_a, %offset
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#wave.global, f32>
  // CHECK: [[B_OFF:%.*]] = wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[B_OFF]]
  %b = wave.ptr_add %out_b, %offset
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#wave.global, f32>
  return %a, %b : !wave.ptr<#wave.global, f32>, !wave.ptr<#wave.global, f32>
}

// -----

// CHECK-LABEL: func.func @address_contract_keeps_unbounded_uniform_i32_global
func.func @address_contract_keeps_unbounded_uniform_i32_global(
    %out: !wave.ptr<#wave.global, i8>, %x: i32, %y: i32)
    -> !wave.ptr<#wave.global, i8>
    attributes {wave.address_arithmetic_no_overflow} {
  // CHECK: [[SUM:%.*]] = wave.binary addi
  %sum = wave.binary addi %x, %y : i32, i32 -> i32
  // CHECK-NOT: wave.index_expr
  // CHECK: wave.ptr_add %{{.*}}, [[SUM]]
  %ptr = wave.ptr_add %out, %sum
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
  return %ptr : !wave.ptr<#wave.global, i8>
}

// -----

// CHECK-LABEL: func.func @address_contract_widens_bounded_uniform_i32_global
func.func @address_contract_widens_bounded_uniform_i32_global(
    %out: !wave.ptr<#wave.global, i8>, %x: i32, %y: i32)
    -> !wave.ptr<#wave.global, i8>
    attributes {wave.address_arithmetic_no_overflow} {
  %sum = wave.binary addi %x, %y : i32, i32 -> i32
  %bounded = wave.assume %sum as "offset"
      [#wave.pred<"offset >= 0">, #wave.pred<"offset <= 31">] : i32
  // CHECK: [[OFF:%.*]] = wave.index_expr <"raw0 + raw1">
  // CHECK-SAME: assuming
  // CHECK-SAME: #wave.pred<"raw0 + raw1 >= 0">
  // CHECK-SAME: #wave.pred<"-31 + raw0 + raw1 <= 0">
  // CHECK-SAME: ["raw0", "raw1"](%{{.*}}, %{{.*}}) : (i32, i32) -> index
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %bounded
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
  return %ptr : !wave.ptr<#wave.global, i8>
}

// -----

// CHECK-LABEL: func.func @address_contract_expands_unflagged_simd_arithmetic
func.func @address_contract_expands_unflagged_simd_arithmetic(
    %out: !wave.ptr<#wave.global, i8>, %x: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    attributes {wave.address_arithmetic_no_overflow} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %s2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %scaled = wave.binary muli %x, %s2
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %shifted = wave.binary shli %scaled, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %offset = wave.binary addi %shifted, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"1 + 4*raw0">
  // CHECK: wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  return %ptr : !wave.simd<!wave.ptr<#wave.global, i8>, 32>
}

// -----

// CHECK-LABEL: func.func @address_contract_expands_index_expr_binding
func.func @address_contract_expands_index_expr_binding(%x: i32, %y: i32)
    -> index attributes {wave.address_arithmetic_no_overflow} {
  %sum = wave.binary addi %x, %y : i32, i32 -> i32
  // CHECK: wave.index_expr <"2*(raw0 + raw1)">
  // CHECK-SAME: ["raw0", "raw1"](%arg0, %arg1) : (i32, i32) -> index
  %index = wave.index_expr <"2*z"> ["z"](%sum) : (i32) -> index
  return %index : index
}

// -----

// CHECK-LABEL: func.func @multi_use_identity_binding_stays_shared
func.func @multi_use_identity_binding_stays_shared(
    %idx_raw: !wave.simd<i32, 32>)
    -> (!wave.simd<index, 32>, !wave.simd<index, 32>) {
  %c1 = arith.constant 1 : i32
  %idx = wave.assume %idx_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  // CHECK: [[SUM:%.*]] = wave.binary addi
  %sum = wave.binary addi %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  // CHECK: wave.index_expr <"x"> ["x"]([[SUM]])
  %a = wave.index_expr <"x"> ["x"](%sum)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.index_expr <"y"> ["y"]([[SUM]])
  %b = wave.index_expr <"y"> ["y"](%sum)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %a, %b : !wave.simd<index, 32>, !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @dead_scalar_binding_dropped
func.func @dead_scalar_binding_dropped(%out: !wave.ptr<#wave.global, f32>,
                                       %base: index) -> !wave.ptr<#wave.global, f32> {
  %zero = wave.binary subi %base, %base overflow<nsw> : index, index -> index
  // CHECK: [[OFF:%.*]] = wave.index_expr <"0"> []() : () -> index
  // CHECK: [[PTR:%.*]] = wave.ptr_add %{{.*}}, [[OFF]]
  %ptr = wave.ptr_add %out, %zero : !wave.ptr<#wave.global, f32>, index -> !wave.ptr<#wave.global, f32>
  return %ptr : !wave.ptr<#wave.global, f32>
}

// -----

// CHECK-LABEL: func.func @index_expr_extract_pack_alias
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: wave.index_expr <"2*(1 + raw0)"> assuming
// CHECK-SAME: ["raw0"](%[[X]])
func.func @index_expr_extract_pack_alias(%x: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %packet = wave.pack %zero, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %packet[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%alias)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Item-local redistribution preserves source packet element identity.
// CHECK-LABEL: func.func @index_expr_extract_redistribute_alias
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: wave.index_expr <"2*(1 + raw0)"> assuming
// CHECK-SAME: ["raw0"](%[[X]])
func.func @index_expr_extract_redistribute_alias(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %packet = wave.pack %zero, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %packet,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %moved[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %bounded = wave.assume %alias as "value"
      [#wave.pred<"value >= 0">, #wave.pred<"value <= 31">]
      : !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%bounded)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Constant source slot broadcasts still identify the scalar source.
// CHECK-LABEL: func.func @index_expr_extract_redistribute_broadcast_alias
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: wave.index_expr <"2*(1 + raw0)"> assuming
// CHECK-SAME: ["raw0"](%[[X]])
func.func @index_expr_extract_redistribute_broadcast_alias(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %broadcast = wave.redistribute %next,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "0">
      : !wave.simd<i32, 32> -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %broadcast[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%alias)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Cross-item mappings cannot preserve an item-local root.
// CHECK-LABEL: func.func @index_expr_cross_item_redistribute_stays_opaque
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[NEXT:.*]] = wave.binary addi %[[X]],
// CHECK: %[[MOVED:.*]] = wave.redistribute %[[NEXT]],
// CHECK: wave.index_expr <"2*y"> ["y"](%[[MOVED]])
func.func @index_expr_cross_item_redistribute_stays_opaque(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %moved = wave.redistribute %next,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%moved)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Constant block is local only in a single-block relation.
// CHECK-LABEL: func.func @index_expr_multiblock_redistribute_stays_opaque
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[NEXT:.*]] = wave.binary addi %[[X]],
// CHECK: %[[MOVED:.*]] = wave.redistribute %[[NEXT]],
// CHECK: wave.index_expr <"2*y"> ["y"](%[[MOVED]])
func.func @index_expr_multiblock_redistribute_stays_opaque(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %moved = wave.redistribute %next,
      <blocks = 2, items = 32, source_block = "0",
       source_item = "item", source_slot = "slot">
      : !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%moved)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Item-varying slot selection stays opaque after slot substitution.
// CHECK-LABEL: func.func @index_expr_varying_slot_redistribute_stays_opaque
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[PACKET:.*]] = wave.pack
// CHECK: %[[MOVED:.*]] = wave.redistribute %[[PACKET]],
// CHECK: %[[ALIAS:.*]] = wave.extract %[[MOVED]][1]
// CHECK: wave.index_expr <"2*y"> ["y"](%[[ALIAS]])
func.func @index_expr_varying_slot_redistribute_stays_opaque(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %packet = wave.pack %zero, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %packet,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "Mod(item, 2)">
      : !wave.simd<vector<2xi32>, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %moved[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%alias)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}

// -----

// Extract inside a packed input cannot alias that whole input.
// CHECK-LABEL: func.func @index_expr_nonboundary_pack_extract_stays_opaque
// CHECK-SAME: (%[[X:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[INNER:.*]] = wave.pack
// CHECK: %[[OUTER:.*]] = wave.pack %[[INNER]],
// CHECK: %[[ALIAS:.*]] = wave.extract %[[OUTER]][1]
// CHECK: wave.index_expr <"2*y"> ["y"](%[[ALIAS]])
func.func @index_expr_nonboundary_pack_extract_stays_opaque(
    %x: !wave.simd<i32, 32>) -> !wave.simd<index, 32> {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %x, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %inner = wave.pack %zero, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %other = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %outer = wave.pack %inner, %other
      : !wave.simd<vector<2xi32>, 32>, !wave.simd<vector<2xi32>, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %alias = wave.extract %outer[1]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %index = wave.index_expr <"2*y"> ["y"](%alias)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %index : !wave.simd<index, 32>
}
