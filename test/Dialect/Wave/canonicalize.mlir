// RUN: wave-opt %s --canonicalize | FileCheck %s

// CHECK-LABEL: func.func @extract_pack_f16
// CHECK-SAME: (%[[A:.*]]: f16, %[[B:.*]]: f16)
// CHECK-NOT: wave.pack
// CHECK-NOT: wave.extract
// CHECK: return %[[A]], %[[B]] : f16, f16
func.func @extract_pack_f16(%a: f16, %b: f16) -> (f16, f16) {
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  %x = wave.extract %p[0] : vector<2xf16> -> f16
  %y = wave.extract %p[1] : vector<2xf16> -> f16
  return %x, %y : f16, f16
}

// CHECK-LABEL: func.func @extract_pack_i16
// CHECK-SAME: (%[[A:.*]]: !wave.simd<i16, 32>, %[[B:.*]]: !wave.simd<i16, 32>)
// CHECK-NOT: wave.pack
// CHECK-NOT: wave.extract
// CHECK: return %[[B]], %[[A]] : !wave.simd<i16, 32>, !wave.simd<i16, 32>
func.func @extract_pack_i16(%a: !wave.simd<i16, 32>,
                            %b: !wave.simd<i16, 32>)
    -> (!wave.simd<i16, 32>, !wave.simd<i16, 32>) {
  %p = wave.pack %a, %b : !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.simd<vector<2xi16>, 32>
  %x = wave.extract %p[1] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %y = wave.extract %p[0] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  return %x, %y : !wave.simd<i16, 32>, !wave.simd<i16, 32>
}

// CHECK-LABEL: func.func @pack_extract_rebuild_f16
// CHECK-SAME: (%[[V:.*]]: vector<2xf16>)
// CHECK-NOT: wave.extract
// CHECK-NOT: wave.pack
// CHECK: return %[[V]] : vector<2xf16>
func.func @pack_extract_rebuild_f16(%v: vector<2xf16>) -> vector<2xf16> {
  %a = wave.extract %v[0] : vector<2xf16> -> f16
  %b = wave.extract %v[1] : vector<2xf16> -> f16
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  return %p : vector<2xf16>
}

// CHECK-LABEL: func.func @pack_extract_rebuild_i16
// CHECK-SAME: (%[[V:.*]]: !wave.simd<vector<2xi16>, 32>)
// CHECK-NOT: wave.extract
// CHECK-NOT: wave.pack
// CHECK: return %[[V]] : !wave.simd<vector<2xi16>, 32>
func.func @pack_extract_rebuild_i16(%v: !wave.simd<vector<2xi16>, 32>)
    -> !wave.simd<vector<2xi16>, 32> {
  %a = wave.extract %v[0] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %b = wave.extract %v[1] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %p = wave.pack %a, %b : !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.simd<vector<2xi16>, 32>
  return %p : !wave.simd<vector<2xi16>, 32>
}

// CHECK-LABEL: func.func @pack_extract_swapped_stays
// CHECK: wave.extract
// CHECK: wave.extract
// CHECK: wave.pack
func.func @pack_extract_swapped_stays(%v: vector<2xf16>) -> vector<2xf16> {
  %a = wave.extract %v[1] : vector<2xf16> -> f16
  %b = wave.extract %v[0] : vector<2xf16> -> f16
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  return %p : vector<2xf16>
}

// CHECK-LABEL: func.func @read_first_splat
// CHECK-SAME: (%[[VALUE:.*]]: i32)
// CHECK-NOT: wave.splat
// CHECK-NOT: wave.read_first
// CHECK: return %[[VALUE]] : i32
func.func @read_first_splat(%value: i32) -> i32 {
  %splat = wave.splat %value : i32 -> !wave.simd<i32, 32>
  %first = wave.read_first %splat : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// CHECK-LABEL: func.func @index_expr_substitute_const
// CHECK-SAME: (%[[LANE:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[OFF:.*]] = wave.index_expr <"4 + 2*lid"> ["lid"](%[[LANE]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: return %[[OFF]] : !wave.simd<index, 32>
func.func @index_expr_substitute_const(%lane: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %k = arith.constant 4 : i32
  %off = wave.index_expr <"K + 2*lid"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// CHECK-LABEL: func.func @index_expr_const_cancels_symbol
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK: %[[OFF:.*]] = arith.constant 0 : index
// CHECK: return %[[OFF]] : index
func.func @index_expr_const_cancels_symbol(%x: i32) -> index {
  %k = arith.constant 5 : i32
  %off = wave.index_expr <"K*x - 5*x"> ["K", "x"](%k, %x) : (i32, i32) -> index
  return %off : index
}

// CHECK-LABEL: func.func @index_expr_argless_literal
// CHECK: %[[OFF:.*]] = arith.constant 42 : index
// CHECK: return %[[OFF]] : index
func.func @index_expr_argless_literal() -> index {
  %off = wave.index_expr <"42"> []() : () -> index
  return %off : index
}

// CHECK-LABEL: func.func @assume_chain_merge
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK-NEXT: %[[A:.*]] = wave.assume %[[X]] as "y" [#wave.pred<"y >= 0">, #wave.pred<"-10 + y <= 0">] : i32
// CHECK-NEXT: return %[[A]] : i32
func.func @assume_chain_merge(%x: i32) -> i32 {
  %lo = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %bounded = wave.assume %lo as "y" [#wave.pred<"y <= 10">] : i32
  return %bounded : i32
}

// CHECK-LABEL: func.func @index_expr_scalarizes_to_splat
// CHECK-SAME: (%[[LANE:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[ZERO:.*]] = arith.constant 0 : index
// CHECK: %[[SPLAT:.*]] = wave.splat %[[ZERO]] : index -> !wave.simd<index, 32>
// CHECK: return %[[SPLAT]] : !wave.simd<index, 32>
func.func @index_expr_scalarizes_to_splat(%lane: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %off = wave.index_expr <"floor(1/32*lid)"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}
