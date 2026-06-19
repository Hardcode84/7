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

// CHECK-LABEL: func.func @binary_scalar_constant_fold
// CHECK-NOT: wave.binary
// CHECK-DAG: %[[C7:.*]] = arith.constant 7 : i32
// CHECK-DAG: %[[C28:.*]] = arith.constant 28 : i32
// CHECK-DAG: %[[C3:.*]] = arith.constant 3 : index
// CHECK: return %[[C7]], %[[C28]], %[[C3]] : i32, i32, index
func.func @binary_scalar_constant_fold() -> (i32, i32, index) {
  %c3 = arith.constant 3 : i32
  %c4 = arith.constant 4 : i32
  %c2 = arith.constant 2 : i32
  %sum = wave.binary addi %c3, %c4 : i32, i32 -> i32
  %shift = wave.binary shli %sum, %c2 : i32, i32 -> i32
  %i10 = arith.constant 10 : index
  %i7 = arith.constant 7 : index
  %diff = wave.binary subi %i10, %i7 : index, index -> index
  return %sum, %shift, %diff : i32, i32, index
}

// CHECK-LABEL: func.func @binary_simd_identity_fold
// CHECK-SAME: (%[[V:.*]]: !wave.simd<i32, 32>)
// CHECK-NOT: wave.binary
// CHECK: return %[[V]], %[[V]], %[[V]] : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
func.func @binary_simd_identity_fold(%v: !wave.simd<i32, 32>)
    -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>) {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %all = arith.constant -1 : i32
  %sum = wave.binary addi %v, %zero : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %prod = wave.binary muli %one, %v : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %and = wave.binary andi %v, %all : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  return %sum, %prod, %and : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
}

// CHECK-LABEL: func.func @cast_scalar_constant_fold
// CHECK-NOT: wave.cast
// CHECK-DAG: %[[C255_I64:.*]] = arith.constant 255 : i64
// CHECK-DAG: %[[C255_I16:.*]] = arith.constant 255 : i16
// CHECK-DAG: %[[C42:.*]] = arith.constant 42 : i32
// CHECK: return %[[C255_I64]], %[[C255_I16]], %[[C42]] : i64, i16, i32
func.func @cast_scalar_constant_fold() -> (i64, i16, i32) {
  %c255 = arith.constant 255 : i32
  %wide = wave.cast intconvert %c255 policy {extension = #wave.cast_extension<zero>} : i32 -> i64
  %narrow = wave.cast intconvert %wide : i64 -> i16
  %f42 = arith.constant 4.200000e+01 : f32
  %i42 = wave.cast fp_to_int %f42 policy {signedness = #wave.cast_signedness<signed>} : f32 -> i32
  return %wide, %narrow, %i42 : i64, i16, i32
}

// CHECK-LABEL: func.func @ballot_cmpi_constant_fold
// CHECK-NOT: wave.cmpi
// CHECK-NOT: wave.ballot
// CHECK-DAG: %[[ALL:.*]] = arith.constant -1 : i32
// CHECK-DAG: %[[ZERO:.*]] = arith.constant 0 : i64
// CHECK: return %[[ALL]], %[[ZERO]] : i32, i64
func.func @ballot_cmpi_constant_fold() -> (i32, i64) {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %v2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %true_mask = wave.cmpi ult %v1, %v2 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %all = wave.ballot %true_mask : !wave.mask<32> -> i32
  %v64 = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %false_mask = wave.cmpi ne %v64, %v64 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %zero = wave.ballot %false_mask : !wave.mask<64> -> i64
  return %all, %zero : i32, i64
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
