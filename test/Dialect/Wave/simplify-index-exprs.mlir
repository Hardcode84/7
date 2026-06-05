// RUN: wave-opt --split-input-file --wave-simplify-index-exprs %s | FileCheck %s

// CHECK-LABEL: func.func @range_folds_bound_symbol
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: %[[OFF:.*]] = wave.index_expr <"16 + lid"> ["lid"](%[[LANE]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: return %[[OFF]] : !wave.simd<index, 32>
func.func @range_folds_bound_symbol(%x: i32) -> !wave.simd<index, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %k = wave.assume %x as "x" [#wave.pred<"x >= 16">, #wave.pred<"x <= 16">] : i32
  %off = wave.index_expr <"K + lid"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @range_cancels_symbol
// CHECK-SAME: (%[[KRAW:.*]]: i32, %[[X:.*]]: i32)
// CHECK: %[[OFF:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: return %[[OFF]] : index
func.func @range_cancels_symbol(%k_raw: i32, %x: i32) -> index {
  %k = wave.assume %k_raw as "x" [#wave.pred<"x >= 5">, #wave.pred<"x <= 5">] : i32
  %off = wave.index_expr <"K*x - 5*x"> ["K", "x"](%k, %x) : (i32, i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @divisibility_folds_mod
// CHECK-SAME: (%[[KRAW:.*]]: i32)
// CHECK: %[[OFF:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: return %[[OFF]] : index
func.func @divisibility_folds_mod(%k_raw: i32) -> index {
  %k = wave.assume %k_raw as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
  %off = wave.index_expr <"Mod(K, 8)"> ["K"](%k) : (i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @expands_scaled_sum
// CHECK-SAME: (%[[K:.*]]: i32)
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: %[[OFF:.*]] = wave.index_expr <"256*K + 4*lid"> ["K", "lid"](%[[K]], %[[LANE]]) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: return %[[OFF]] : !wave.simd<index, 32>
func.func @expands_scaled_sum(%k: i32) -> !wave.simd<index, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"4*(64*K + lid)"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}
