// RUN: wave-opt --split-input-file --wave-simplify-index-exprs %s | FileCheck %s
// RUN: wave-opt --split-input-file --canonicalize %s | FileCheck %s --check-prefix=CANON

// CHECK-LABEL: func.func @range_folds_bound_symbol
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: %[[OFF:.*]] = wave.index_expr <"16 + lid"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%[[LANE]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
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

// CHECK-LABEL: func.func @divisibility_survives_on_live_symbol
// CHECK-SAME: (%[[KRAW:.*]]: i32)
// CHECK: %[[K:.*]] = wave.assume %[[KRAW]]
// CHECK: %[[OFF:.*]] = wave.index_expr <"1 + K"> assuming [#wave.pred<"Mod(K, 16) == 0">] ["K"](%[[K]]) : (i32) -> index
// CHECK: return %[[OFF]] : index
func.func @divisibility_survives_on_live_symbol(%k_raw: i32) -> index {
  %k = wave.assume %k_raw as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
  %off = wave.index_expr <"K + 1"> ["K"](%k) : (i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @preserves_equal_cost_scaled_sum
// CHECK-SAME: (%[[K:.*]]: i32)
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: %[[OFF:.*]] = wave.index_expr <"4*(64*K + lid)"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["K", "lid"](%[[K]], %[[LANE]]) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: return %[[OFF]] : !wave.simd<index, 32>
func.func @preserves_equal_cost_scaled_sum(%k: i32)
    -> !wave.simd<index, 32> {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"4*(64*K + lid)"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @preserves_xor_bit_permutation
// CHECK-SAME: (%[[A:.*]]: i32, %[[B:.*]]: i32, %[[C:.*]]: i32)
// CHECK: %[[OFF:.*]] = wave.index_expr <"xor(16*a, xor(32 + 4*b, 8*c))">
// CHECK: return %[[OFF]] : index
// CANON-LABEL: func.func @preserves_xor_bit_permutation
// CANON: %[[OFF:.*]] = wave.index_expr <"xor(16*a, xor(32 + 4*b, 8*c))">
// CANON: return %[[OFF]] : index
func.func @preserves_xor_bit_permutation(%a: i32, %b: i32, %c: i32)
    -> index {
  %off = wave.index_expr <"xor(16*a, xor(32 + 4*b, 8*c))">
      assuming [#wave.pred<"a >= 0 & -1 + a <= 0">,
                #wave.pred<"b >= 0 & -1 + b <= 0">,
                #wave.pred<"c >= 0 & -1 + c <= 0">]
      ["a", "b", "c"](%a, %b, %c) : (i32, i32, i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @accepts_cheaper_mod_fold
// CHECK: %[[OFF:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: return %[[OFF]] : index
// CANON-LABEL: func.func @accepts_cheaper_mod_fold
// CANON: %[[ZERO:.*]] = arith.constant 0 : index
// CANON: return %[[ZERO]] : index
func.func @accepts_cheaper_mod_fold(%k: i32) -> index {
  %off = wave.index_expr <"Mod(K, 8)">
      assuming [#wave.pred<"Mod(K, 16) == 0">] ["K"](%k)
      : (i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @accepts_materializable_unknown_baseline
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK: %[[OFF:.*]] = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">] ["x"](%[[X]])
// CHECK: return %[[OFF]] : index
// CANON-LABEL: func.func @accepts_materializable_unknown_baseline
// CANON-SAME: (%[[X:.*]]: i32)
// CANON: %[[OFF:.*]] = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">] ["x"](%[[X]])
// CANON: return %[[OFF]] : index
func.func @accepts_materializable_unknown_baseline(%x: i32) -> index {
  %off = wave.index_expr <"Max(0, x)">
      assuming [#wave.pred<"x >= 0">] ["x"](%x) : (i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @preserves_costlier_expansion
// CHECK: %[[OFF:.*]] = wave.index_expr <"(a + b)*(c + d)">
// CHECK: return %[[OFF]] : index
// CANON-LABEL: func.func @preserves_costlier_expansion
// CANON: %[[OFF:.*]] = wave.index_expr <"(a + b)*(c + d)">
// CANON: return %[[OFF]] : index
func.func @preserves_costlier_expansion(%a: i32, %b: i32, %c: i32,
                                         %d: i32) -> index {
  %off = wave.index_expr <"(a + b)*(c + d)">
      ["a", "b", "c", "d"](%a, %b, %c, %d)
      : (i32, i32, i32, i32) -> index
  return %off : index
}

// -----

// CHECK-LABEL: func.func @scalarized_simd_result_is_splatted
// CHECK-SAME: (%[[LANE:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[OFF:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: %[[SPLAT:.*]] = wave.splat %[[OFF]] : index -> !wave.simd<index, 32>
// CHECK: return %[[SPLAT]] : !wave.simd<index, 32>
func.func @scalarized_simd_result_is_splatted(%lane: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %off = wave.index_expr <"floor(1/32*lid)"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// -----

// CHECK-LABEL: func.func @producer_range_proves_bound_symbol
// CHECK: %[[LANE:.*]] = wave.lane_id : !wave.simd<i32, 64>
// CHECK: %[[DIM0:.*]] = wave.index_expr <"floor(1/2*lane)"> assuming [#wave.pred<"lane >= 0 & -63 + lane <= 0">] ["lane"](%[[LANE]]) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
// CHECK: %[[OFF:.*]] = wave.index_expr <"floor(1/4*dim0)"> assuming [#wave.pred<"dim0 >= 0 & -31 + dim0 <= 0">] ["dim0"](%[[DIM0]]) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
// CHECK: return %[[OFF]] : !wave.simd<index, 64>
func.func @producer_range_proves_bound_symbol() -> !wave.simd<index, 64> {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %dim0 = wave.index_expr <"floor(1/2*lane)"> assuming [#wave.pred<"lane >= 0 & -63 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off = wave.index_expr <"floor(1/4*dim0)"> ["dim0"](%dim0)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  return %off : !wave.simd<index, 64>
}

// -----

// CHECK-LABEL: func.func @producer_range_drops_stale_lower_assumption
// CHECK-NOT: -272 + dim0
// CHECK: %[[OFF:.*]] = wave.index_expr <"floor(1/4*dim0)"> assuming [#wave.pred<"-2281701631 + dim0 <= 0">, #wave.pred<"dim0 >= 0 & -31 + dim0 <= 0">]
// CHECK-NOT: -272 + dim0
// CHECK: return %[[OFF]] : !wave.simd<index, 64>
func.func @producer_range_drops_stale_lower_assumption(%lane: !wave.simd<i32, 64>)
    -> !wave.simd<index, 64> {
  %dim0 = wave.index_expr <"floor(1/2*lane)"> assuming [#wave.pred<"lane >= 0 & -63 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off = wave.index_expr <"floor(1/4*dim0)"> assuming [#wave.pred<"-272 + dim0 >= 0 & -2281701631 + dim0 <= 0">] ["dim0"](%dim0)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  return %off : !wave.simd<index, 64>
}

// -----

// Unknown siblings survive stale producer-fact removal.
// CHECK-LABEL: func.func @producer_range_preserves_unknown_siblings
// CHECK-NOT: -272 + dim0
// CHECK: %[[OFF:.*]] = wave.index_expr <"d + dim0"> assuming [#wave.pred<"-1 + d >= 0 & Mod(dim0, d) == 0">, #wave.pred<"dim0 >= 0 & -31 + dim0 <= 0">]
// CHECK-NOT: -272 + dim0
// CHECK: return %[[OFF]] : !wave.simd<index, 64>
func.func @producer_range_preserves_unknown_siblings(
    %lane: !wave.simd<i32, 64>, %d: !wave.simd<index, 64>)
    -> !wave.simd<index, 64> {
  %dim0 = wave.index_expr <"floor(1/2*lane)"> assuming [#wave.pred<"lane >= 0 & -63 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off = wave.index_expr <"dim0 + d"> assuming [#wave.pred<"-272 + dim0 >= 0 & Mod(dim0, d) == 0 & -1 + d >= 0">] ["dim0", "d"](%dim0, %d)
      : (!wave.simd<index, 64>, !wave.simd<index, 64>)
      -> !wave.simd<index, 64>
  return %off : !wave.simd<index, 64>
}

// -----

// CHECK-LABEL: func.func @preserves_result_range_when_binding_folds
// CHECK-SAME: (%[[K:.*]]: i32, %[[XRAW:.*]]: i32)
// CHECK: %[[X:.*]] = wave.assume %[[XRAW]]
// CHECK: %[[OFF:.*]] = wave.index_expr <"32 + 2*K"> assuming [#wave.pred<"32 + 2*K >= 0 & -68 + 2*K <= 0">] ["K"](%[[K]]) : (i32) -> index
// CHECK: return %[[OFF]] : index
func.func @preserves_result_range_when_binding_folds(%k: i32, %x_raw: i32)
    -> index {
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0 & -3 + x <= 0">] : i32
  %off = wave.index_expr <"2*(16 + K + floor(1/4*x))"> assuming [#wave.pred<"32 + 2*K + 2*floor(1/4*x) >= 0 & -68 + 2*K + 2*floor(1/4*x) <= 0">] ["K", "x"](%k, %x) : (i32, i32) -> index
  return %off : index
}
