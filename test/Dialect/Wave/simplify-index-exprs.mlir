// RUN: wave-opt --split-input-file --wave-simplify-index-exprs %s | FileCheck %s

// CHECK-LABEL: func.func @range_folds_bound_symbol
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: %[[OFF:.*]] = wave.index_expr <"16 + lid"> ["lid"](%[[LANE]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: return %[[OFF]] : !wave.simd<index, 32>
func.func @range_folds_bound_symbol(%x: i32) -> !wave.simd<index, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %k = wave.assume_range %x, [16, 16] : i32
  %off = wave.index_expr <"K + lid"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @range_cancels_symbol
// CHECK-SAME: (%[[KRAW:.*]]: i32, %[[X:.*]]: i32)
// CHECK: %[[OFF:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: return %[[OFF]] : index
func.func @range_cancels_symbol(%k_raw: i32, %x: i32) -> index {
  %k = wave.assume_range %k_raw, [5, 5] : i32
  %off = wave.index_expr <"K*x - 5*x"> ["K", "x"](%k, %x) : (i32, i32) -> index
  return %off : index
}
