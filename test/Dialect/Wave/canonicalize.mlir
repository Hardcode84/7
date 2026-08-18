// RUN: wave-opt %s --canonicalize | FileCheck %s

// CHECK-LABEL: func.func @dead_alloc
// CHECK-NOT: wave.alloc
// CHECK: return
func.func @dead_alloc() {
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64} : !wave.ptr<#wave.shared, i8>
  return
}

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

// CHECK-LABEL: func.func @pack_extract_slice_low_i8
// CHECK-SAME: (%[[V:.*]]: !wave.simd<vector<8xi8>, 64>)
// CHECK-NOT: -> !wave.simd<i8, 64>
// CHECK-NOT: wave.pack
// CHECK: %[[SLICE:.*]] = wave.extract %[[V]][0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: return %[[SLICE]] : !wave.simd<vector<4xi8>, 64>
func.func @pack_extract_slice_low_i8(%v: !wave.simd<vector<8xi8>, 64>)
    -> !wave.simd<vector<4xi8>, 64> {
  %a = wave.extract %v[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %b = wave.extract %v[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %c = wave.extract %v[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %d = wave.extract %v[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %p = wave.pack %a, %b, %c, %d : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
  return %p : !wave.simd<vector<4xi8>, 64>
}

// CHECK-LABEL: func.func @pack_extract_slice_high_i8
// CHECK-SAME: (%[[V:.*]]: !wave.simd<vector<8xi8>, 64>)
// CHECK-NOT: -> !wave.simd<i8, 64>
// CHECK-NOT: wave.pack
// CHECK: %[[SLICE:.*]] = wave.extract %[[V]][4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: return %[[SLICE]] : !wave.simd<vector<4xi8>, 64>
func.func @pack_extract_slice_high_i8(%v: !wave.simd<vector<8xi8>, 64>)
    -> !wave.simd<vector<4xi8>, 64> {
  %a = wave.extract %v[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %b = wave.extract %v[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %c = wave.extract %v[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %d = wave.extract %v[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %p = wave.pack %a, %b, %c, %d : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
  return %p : !wave.simd<vector<4xi8>, 64>
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

// CHECK-LABEL: func.func @extract_pack_chunk_results
// CHECK-SAME: (%[[A:.*]]: vector<4xi8>, %[[B:.*]]: vector<4xi8>)
// CHECK-NOT: wave.pack
// CHECK: %[[ELEMENT:.*]] = wave.extract %[[B]][2] : vector<4xi8> -> i8
// CHECK: %[[SLICE:.*]] = wave.extract %[[B]][1] : vector<4xi8> -> vector<2xi8>
// CHECK: return %[[ELEMENT]], %[[SLICE]], %[[B]] : i8, vector<2xi8>, vector<4xi8>
func.func @extract_pack_chunk_results(%a: vector<4xi8>, %b: vector<4xi8>)
    -> (i8, vector<2xi8>, vector<4xi8>) {
  %packed = wave.pack %a, %b : vector<4xi8>, vector<4xi8> -> vector<8xi8>
  %element = wave.extract %packed[6] : vector<8xi8> -> i8
  %slice = wave.extract %packed[5] : vector<8xi8> -> vector<2xi8>
  %chunk = wave.extract %packed[4] : vector<8xi8> -> vector<4xi8>
  return %element, %slice, %chunk : i8, vector<2xi8>, vector<4xi8>
}

// CHECK-LABEL: func.func @extract_pack_simd_chunk_boundary
// CHECK-SAME: (%[[A:.*]]: !wave.simd<vector<4xi8>, 32>, %[[B:.*]]: !wave.simd<vector<4xi8>, 32>)
// CHECK: %[[PACKED:.*]] = wave.pack %[[A]], %[[B]]
// CHECK: %[[SLICE:.*]] = wave.extract %[[B]][1] : !wave.simd<vector<4xi8>, 32> -> !wave.simd<vector<2xi8>, 32>
// CHECK: %[[CROSS:.*]] = wave.extract %[[PACKED]][3] : !wave.simd<vector<8xi8>, 32> -> !wave.simd<vector<2xi8>, 32>
// CHECK: return %[[SLICE]], %[[CROSS]]
func.func @extract_pack_simd_chunk_boundary(
    %a: !wave.simd<vector<4xi8>, 32>,
    %b: !wave.simd<vector<4xi8>, 32>)
    -> (!wave.simd<vector<2xi8>, 32>, !wave.simd<vector<2xi8>, 32>) {
  %packed = wave.pack %a, %b
      : !wave.simd<vector<4xi8>, 32>, !wave.simd<vector<4xi8>, 32>
        -> !wave.simd<vector<8xi8>, 32>
  %slice = wave.extract %packed[5]
      : !wave.simd<vector<8xi8>, 32> -> !wave.simd<vector<2xi8>, 32>
  %cross = wave.extract %packed[3]
      : !wave.simd<vector<8xi8>, 32> -> !wave.simd<vector<2xi8>, 32>
  return %slice, %cross
      : !wave.simd<vector<2xi8>, 32>, !wave.simd<vector<2xi8>, 32>
}

// CHECK-LABEL: func.func @extract_pack_unit_vector_stays
// CHECK-SAME: (%[[A:.*]]: !wave.simd<i32, 32>, %[[B:.*]]: !wave.simd<i32, 32>)
// CHECK: %[[PACKED:.*]] = wave.pack %[[A]], %[[B]]
// CHECK: %[[SLICE:.*]] = wave.extract %[[PACKED]][0] : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
// CHECK: return %[[SLICE]]
func.func @extract_pack_unit_vector_stays(
    %a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 32>)
    -> !wave.simd<vector<1xi32>, 32> {
  %packed = wave.pack %a, %b
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<vector<2xi32>, 32>
  %slice = wave.extract %packed[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %slice : !wave.simd<vector<1xi32>, 32>
}

// CHECK-LABEL: func.func @pack_loop_carried_i8
// CHECK-SAME: (%[[LB:.*]]: i32, %[[UB:.*]]: i32, %[[STEP:.*]]: i32
// CHECK-SAME: %[[A0:.*]]: !wave.simd<i8, 64>, %[[A1:.*]]: !wave.simd<i8, 64>, %[[A2:.*]]: !wave.simd<i8, 64>, %[[A3:.*]]: !wave.simd<i8, 64>, %[[KEEP:.*]]: !wave.simd<i8, 64>)
// CHECK: %[[INIT:.*]] = wave.pack %[[A0]], %[[A1]], %[[A2]], %[[A3]] : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: %[[LOOP:.*]] = scf.for %{{.*}} = %[[LB]] to %[[UB]] step %[[STEP]] iter_args(%[[PACK_ARG:.*]] = %[[INIT]]) -> (!wave.simd<vector<4xi8>, 64>)
// CHECK: %[[E0:.*]] = wave.extract %[[PACK_ARG]][0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
// CHECK: %[[E1:.*]] = wave.extract %[[PACK_ARG]][1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
// CHECK: %[[E2:.*]] = wave.extract %[[PACK_ARG]][2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
// CHECK: %[[E3:.*]] = wave.extract %[[PACK_ARG]][3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
// CHECK: %[[YIELD_PACK:.*]] = wave.pack %[[E1]], %[[E2]], %[[E3]], %[[E0]] : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: scf.yield %[[YIELD_PACK]] : !wave.simd<vector<4xi8>, 64>
// CHECK: %[[SIDE_IN:.*]] = wave.extract %[[LOOP]][2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
// CHECK: %[[SIDE:.*]] = wave.binary addi %[[SIDE_IN]], %[[KEEP]] : !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<i8, 64>
// CHECK-NOT: wave.pack %[[LOOP]]
// CHECK: return %[[LOOP]], %[[SIDE]] : !wave.simd<vector<4xi8>, 64>, !wave.simd<i8, 64>
func.func @pack_loop_carried_i8(%lb: i32, %ub: i32, %step: i32,
                                %a0: !wave.simd<i8, 64>,
                                %a1: !wave.simd<i8, 64>,
                                %a2: !wave.simd<i8, 64>,
                                %a3: !wave.simd<i8, 64>,
                                %keep: !wave.simd<i8, 64>)
    -> (!wave.simd<vector<4xi8>, 64>, !wave.simd<i8, 64>) {
  %r:5 = scf.for %i = %lb to %ub step %step
      iter_args(%x0 = %a0, %x1 = %a1, %x2 = %a2, %x3 = %a3,
                %carry = %keep)
      -> (!wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
          !wave.simd<i8, 64>, !wave.simd<i8, 64>)  : i32 {
    scf.yield %x1, %x2, %x3, %x0, %carry : !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>
  }
  %side = wave.binary addi %r#2, %r#4 : !wave.simd<i8, 64>,
      !wave.simd<i8, 64> -> !wave.simd<i8, 64>
  %p = wave.pack %r#0, %r#1, %r#2, %r#3 : !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> ->
      !wave.simd<vector<4xi8>, 64>
  return %p, %side : !wave.simd<vector<4xi8>, 64>, !wave.simd<i8, 64>
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

// CHECK-LABEL: func.func @single_input_join
// CHECK: %[[TOK:.*]] = wave.token : !wave.mem.token
// CHECK-NOT: wave.join
// CHECK: return %[[TOK]] : !wave.mem.token
func.func @single_input_join() -> !wave.mem.token {
  %tok = wave.token : !wave.mem.token
  %joined = wave.join %tok : !wave.mem.token -> !wave.mem.token
  return %joined : !wave.mem.token
}

// CHECK-LABEL: func.func @token_select
// CHECK-SAME: (%[[PRED:.*]]: i1, %[[TRUE:.*]]: !wave.mem.token, %[[FALSE:.*]]: !wave.mem.token)
// CHECK: %[[SELECTED:.*]] = wave.select %[[PRED]], %[[TRUE]], %[[FALSE]] : !wave.mem.token
// CHECK-NOT: wave.join
// CHECK: return %[[SELECTED]] : !wave.mem.token
func.func @token_select(%pred: i1, %true: !wave.mem.token,
                        %false: !wave.mem.token) -> !wave.mem.token {
  %selected = wave.select %pred, %true, %false : !wave.mem.token
  return %selected : !wave.mem.token
}

// CHECK-LABEL: func.func @constant_token_select
// CHECK-SAME: (%[[TRUE:.*]]: !wave.mem.token, %[[FALSE:.*]]: !wave.mem.token)
// CHECK-NOT: wave.select
// CHECK-NOT: wave.join
// CHECK: return %[[TRUE]], %[[FALSE]] : !wave.mem.token, !wave.mem.token
func.func @constant_token_select(%true: !wave.mem.token,
                                 %false: !wave.mem.token)
    -> (!wave.mem.token, !wave.mem.token) {
  %yes = arith.constant true
  %no = arith.constant false
  %selected_true = wave.select %yes, %true, %false : !wave.mem.token
  %selected_false = wave.select %no, %true, %false : !wave.mem.token
  return %selected_true, %selected_false : !wave.mem.token, !wave.mem.token
}

// CHECK-LABEL: func.func @constant_scalar_select
// CHECK-SAME: (%[[TRUE:.*]]: i32, %[[FALSE:.*]]: i32)
// CHECK-NOT: wave.select
// CHECK: return %[[TRUE]], %[[FALSE]] : i32, i32
func.func @constant_scalar_select(%true: i32, %false: i32) -> (i32, i32) {
  %yes = arith.constant true
  %no = arith.constant false
  %selected_true = wave.select %yes, %true, %false : i32
  %selected_false = wave.select %no, %true, %false : i32
  return %selected_true, %selected_false : i32, i32
}

// CHECK-LABEL: func.func @constant_mask_select
// CHECK-SAME: (%[[TRUE:.*]]: !wave.simd<i32, 32>, %[[FALSE:.*]]: !wave.simd<i32, 32>)
// CHECK-NOT: wave.select
// CHECK: return %[[TRUE]], %[[FALSE]] : !wave.simd<i32, 32>, !wave.simd<i32, 32>
func.func @constant_mask_select(%true: !wave.simd<i32, 32>,
                                %false: !wave.simd<i32, 32>)
    -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>) {
  %all = wave.constant true -> !wave.mask<32>
  %none = wave.constant false -> !wave.mask<32>
  %selected_true = wave.select %all, %true, %false
      : !wave.mask<32>, !wave.simd<i32, 32>
  %selected_false = wave.select %none, %true, %false
      : !wave.mask<32>, !wave.simd<i32, 32>
  return %selected_true, %selected_false
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
}

// CHECK-LABEL: func.func @constant_select_splats
// CHECK-SAME: (%[[TRUE:.*]]: i32, %[[FALSE:.*]]: i32, %[[TRUE_VEC:.*]]: vector<2xi32>, %[[FALSE_VEC:.*]]: vector<2xi32>)
// CHECK: %[[TRUE_SPLAT:.*]] = wave.splat %[[TRUE]] : i32 -> !wave.simd<i32, 32>
// CHECK: %[[FALSE_VEC_SPLAT:.*]] = wave.splat %[[FALSE_VEC]] : vector<2xi32> -> !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.select
// CHECK: return %[[TRUE_SPLAT]], %[[FALSE_VEC_SPLAT]] : !wave.simd<i32, 32>, !wave.simd<vector<2xi32>, 32>
func.func @constant_select_splats(%true: i32, %false: i32,
                                  %true_vec: vector<2xi32>,
                                  %false_vec: vector<2xi32>)
    -> (!wave.simd<i32, 32>, !wave.simd<vector<2xi32>, 32>) {
  %yes = arith.constant true
  %no = arith.constant false
  %true_splat = wave.splat %true : i32 -> !wave.simd<i32, 32>
  %false_splat = wave.splat %false : i32 -> !wave.simd<i32, 32>
  %true_vec_splat = wave.splat %true_vec
      : vector<2xi32> -> !wave.simd<vector<2xi32>, 32>
  %false_vec_splat = wave.splat %false_vec
      : vector<2xi32> -> !wave.simd<vector<2xi32>, 32>
  %selected_splat = wave.select %yes, %true_splat, %false_splat
      : !wave.simd<i32, 32>
  %selected_vec_splat = wave.select %no, %true_vec_splat, %false_vec_splat
      : !wave.simd<vector<2xi32>, 32>
  return %selected_splat, %selected_vec_splat
      : !wave.simd<i32, 32>, !wave.simd<vector<2xi32>, 32>
}

// CHECK-LABEL: func.func @cmpi_boolean_select
// CHECK-SAME: (%[[MASK:.*]]: !wave.mask<32>)
// CHECK-NOT: wave.select
// CHECK-NOT: wave.cmpi
// CHECK: return %[[MASK]], %[[MASK]], %[[MASK]], %[[MASK]]
func.func @cmpi_boolean_select(%mask: !wave.mask<32>)
    -> (!wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>) {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %zero = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %bits = wave.select %mask, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %lhs = wave.cmpi ne %bits, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %rhs = wave.cmpi ne %zero, %bits
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>

  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %five = wave.constant 5 : i32 -> !wave.simd<i32, 32>
  %seven = wave.constant 7 : i32 -> !wave.simd<i32, 32>
  %range = wave.select %mask, %seven, %three
      : !wave.mask<32>, !wave.simd<i32, 32>
  %greater = wave.cmpi sgt %range, %five
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %reversed = wave.cmpi slt %five, %range
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %lhs, %rhs, %greater, %reversed
      : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
}

// CHECK-LABEL: func.func @cmpi_boolean_select_truth_table_stays
// CHECK-SAME: (%[[MASK:.*]]: !wave.mask<32>)
// CHECK: %[[BITS:.*]] = wave.select %[[MASK]]
// CHECK: %[[INVERTED:.*]] = wave.cmpi eq %[[BITS]]
// CHECK: %[[ALWAYS:.*]] = wave.cmpi uge %[[BITS]]
// CHECK: return %[[INVERTED]], %[[ALWAYS]]
func.func @cmpi_boolean_select_truth_table_stays(%mask: !wave.mask<32>)
    -> (!wave.mask<32>, !wave.mask<32>) {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %zero = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %bits = wave.select %mask, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %inverted = wave.cmpi eq %bits, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %always = wave.cmpi uge %bits, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %inverted, %always : !wave.mask<32>, !wave.mask<32>
}

// CHECK-LABEL: func.func @cmpi_scalar_select_condition_stays
// CHECK-SAME: (%[[COND:.*]]: i1)
// CHECK: %[[BITS:.*]] = wave.select %[[COND]]
// CHECK: %[[CMP:.*]] = wave.cmpi ne %[[BITS]]
// CHECK: return %[[CMP]]
func.func @cmpi_scalar_select_condition_stays(%cond: i1) -> !wave.mask<32> {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %zero = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %bits = wave.select %cond, %one, %zero : !wave.simd<i32, 32>
  %cmp = wave.cmpi ne %bits, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %cmp : !wave.mask<32>
}

// CHECK-LABEL: func.func @join_drops_dummy_and_duplicates
// CHECK-SAME: (%[[A:.*]]: !wave.mem.token, %[[B:.*]]: !wave.mem.token)
// CHECK-NOT: wave.token
// CHECK: %[[JOIN:.*]] = wave.join %[[A]], %[[B]] : !wave.mem.token, !wave.mem.token -> !wave.mem.token
// CHECK: return %[[JOIN]] : !wave.mem.token
func.func @join_drops_dummy_and_duplicates(%a: !wave.mem.token,
                                           %b: !wave.mem.token)
    -> !wave.mem.token {
  %dummy0 = wave.token : !wave.mem.token
  %dummy1 = wave.token : !wave.mem.token
  %joined = wave.join %dummy0, %a, %b, %a, %dummy1, %b
      : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token,
        !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return %joined : !wave.mem.token
}

// CHECK-LABEL: func.func @duplicate_input_join
// CHECK-SAME: (%[[TOK:.*]]: !wave.mem.token)
// CHECK-NOT: wave.join
// CHECK: return %[[TOK]] : !wave.mem.token
func.func @duplicate_input_join(%tok: !wave.mem.token) -> !wave.mem.token {
  %joined = wave.join %tok, %tok
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return %joined : !wave.mem.token
}

// CHECK-LABEL: func.func @dummy_only_join
// CHECK: %[[TOK:.*]] = wave.token : !wave.mem.token
// CHECK-NOT: wave.join
// CHECK: return %[[TOK]] : !wave.mem.token
func.func @dummy_only_join() -> !wave.mem.token {
  %dummy0 = wave.token : !wave.mem.token
  %dummy1 = wave.token : !wave.mem.token
  %joined = wave.join %dummy0, %dummy1
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return %joined : !wave.mem.token
}

// CHECK-LABEL: func.func @empty_join
// CHECK: %[[TOK:.*]] = wave.token : !wave.mem.token
// CHECK-NOT: wave.join
// CHECK: return %[[TOK]] : !wave.mem.token
func.func @empty_join() -> !wave.mem.token {
  %joined = "wave.join"() : () -> !wave.mem.token
  return %joined : !wave.mem.token
}

// CHECK-LABEL: func.func @binary_scalar_constant_fold
// CHECK-NOT: wave.binary
// CHECK-DAG: %[[C7:.*]] = wave.constant 7 : i32
// CHECK-DAG: %[[C28:.*]] = wave.constant 28 : i32
// CHECK-DAG: %[[C3:.*]] = wave.constant 3 : index
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

// CHECK-LABEL: func.func @binary_simd_constant_fold
// CHECK-NOT: wave.splat
// CHECK-NOT: wave.binary
// CHECK: %[[C7:.*]] = wave.constant 7 : i32 -> !wave.simd<i32, 32>
// CHECK: return %[[C7]] : !wave.simd<i32, 32>
func.func @binary_simd_constant_fold() -> !wave.simd<i32, 32> {
  %c3 = arith.constant 3 : i32
  %c4 = arith.constant 4 : i32
  %v3 = wave.splat %c3 : i32 -> !wave.simd<i32, 32>
  %v4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %v3, %v4 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %sum : !wave.simd<i32, 32>
}

// CHECK-LABEL: func.func @fadd_fmul_contract_fuses
// CHECK-SAME: (%[[A:.*]]: !wave.simd<f32, 32>, %[[B:.*]]: !wave.simd<f32, 32>, %[[C:.*]]: !wave.simd<f32, 32>)
// CHECK-NOT: wave.fmul
// CHECK: %[[FMA:.*]] = wave.fma %[[A]], %[[B]], %[[C]] fastmath<contract>
// CHECK: return %[[FMA]]
func.func @fadd_fmul_contract_fuses(%a: !wave.simd<f32, 32>,
                                    %b: !wave.simd<f32, 32>,
                                    %c: !wave.simd<f32, 32>)
    -> !wave.simd<f32, 32> {
  %mul = wave.fmul %a, %b fastmath<nnan,contract>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %sum = wave.fadd %mul, %c fastmath<contract>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  return %sum : !wave.simd<f32, 32>
}

// CHECK-LABEL: func.func @fadd_fmul_without_mul_contract_stays_split
// CHECK-NOT: wave.fma
// CHECK: wave.fmul
// CHECK: wave.fadd
func.func @fadd_fmul_without_mul_contract_stays_split(
    %a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>,
    %c: !wave.simd<f32, 32>) -> !wave.simd<f32, 32> {
  %mul = wave.fmul %a, %b fastmath<nnan>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %sum = wave.fadd %c, %mul fastmath<contract>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  return %sum : !wave.simd<f32, 32>
}

// CHECK-LABEL: func.func @cast_scalar_constant_fold
// CHECK-NOT: wave.cast
// CHECK-DAG: %[[C255_I64:.*]] = wave.constant 255 : i64
// CHECK-DAG: %[[C255_I16:.*]] = wave.constant 255 : i16
// CHECK-DAG: %[[C42:.*]] = wave.constant 42 : i32
// CHECK: return %[[C255_I64]], %[[C255_I16]], %[[C42]] : i64, i16, i32
func.func @cast_scalar_constant_fold() -> (i64, i16, i32) {
  %c255 = arith.constant 255 : i32
  %wide = wave.cast intconvert %c255 policy {extension = #wave.cast_extension<zero>} : i32 -> i64
  %narrow = wave.cast intconvert %wide : i64 -> i16
  %f42 = arith.constant 4.200000e+01 : f32
  %i42 = wave.cast fp_to_int %f42 policy {signedness = #wave.cast_signedness<signed>} : f32 -> i32
  return %wide, %narrow, %i42 : i64, i16, i32
}

// CHECK-LABEL: func.func @cast_simd_constant_fold
// CHECK-NOT: wave.splat
// CHECK-NOT: wave.cast
// CHECK: %[[C255:.*]] = wave.constant 255 : i64 -> !wave.simd<i64, 32>
// CHECK: return %[[C255]] : !wave.simd<i64, 32>
func.func @cast_simd_constant_fold() -> !wave.simd<i64, 32> {
  %c255 = arith.constant 255 : i32
  %v255 = wave.splat %c255 : i32 -> !wave.simd<i32, 32>
  %wide = wave.cast intconvert %v255 policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 32> -> !wave.simd<i64, 32>
  return %wide : !wave.simd<i64, 32>
}

// Match upstream arith.trunci(extui/extsi(x)) canonicalization for Wave's
// index-aware integer cast.
// CHECK-LABEL: func.func @cast_widen_narrow_fold
// CHECK-SAME: (%[[X:.*]]: i32)
// CHECK-NOT: wave.cast
// CHECK: return %[[X]] : i32
func.func @cast_widen_narrow_fold(%x: i32) -> i32 {
  %wide = wave.cast intconvert %x
      policy {extension = #wave.cast_extension<sign>} : i32 -> index
  %narrow = wave.cast intconvert %wide : index -> i32
  return %narrow : i32
}

// CHECK-LABEL: func.func @cast_nested_trunc_fold
// CHECK-SAME: (%[[X:.*]]: i64)
// CHECK: %[[NARROW:.*]] = wave.cast intconvert %[[X]] : i64 -> i16
// CHECK-NOT: i64 -> i32
// CHECK: return %[[NARROW]] : i16
func.func @cast_nested_trunc_fold(%x: i64) -> i16 {
  %i32 = wave.cast intconvert %x : i64 -> i32
  %i16 = wave.cast intconvert %i32 : i32 -> i16
  return %i16 : i16
}

// CHECK-LABEL: func.func @ballot_cmpi_constant_fold
// CHECK-NOT: wave.cmpi
// CHECK-NOT: wave.ballot
// CHECK-DAG: %[[ALL:.*]] = wave.constant -1 : i32
// CHECK-DAG: %[[ZERO:.*]] = wave.constant 0 : i64
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

// CHECK-LABEL: func.func @mask_vote_constant_fold
// CHECK-NOT: wave.mask_all
// CHECK-NOT: wave.mask_any
// CHECK: %[[TRUE:.*]] = wave.constant true
// CHECK: %[[FALSE:.*]] = wave.constant false
// CHECK: return %[[TRUE]], %[[FALSE]] : i1, i1
func.func @mask_vote_constant_fold() -> (i1, i1) {
  %true_mask = wave.constant true -> !wave.mask<64>
  %false_mask = wave.constant false -> !wave.mask<64>
  %all = wave.mask_all %true_mask : !wave.mask<64>
  %any = wave.mask_any %false_mask : !wave.mask<64>
  return %all, %any : i1, i1
}

// CHECK-LABEL: func.func @cmpi_mask_constant_fold
// CHECK-NOT: wave.splat
// CHECK-NOT: wave.cmpi
// CHECK: %[[MASK:.*]] = wave.constant true -> !wave.mask<32>
// CHECK: return %[[MASK]] : !wave.mask<32>
func.func @cmpi_mask_constant_fold() -> !wave.mask<32> {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %v2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %v1, %v2 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %mask : !wave.mask<32>
}

// CHECK-LABEL: func.func @redistribute_identity_fold
// CHECK-SAME: (%[[PACKET:.*]]: !wave.simd<vector<4xi32>, 64>)
// CHECK-NOT: wave.redistribute
// CHECK: return %[[PACKET]], %[[PACKET]]
func.func @redistribute_identity_fold(
    %packet: !wave.simd<vector<4xi32>, 64>)
    -> (!wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>) {
  %symbolic = wave.redistribute %packet,
      <blocks = 2, items = 128, source_block = "block",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  %literal = wave.redistribute %packet,
      <blocks = 1, items = 256, source_block = "0",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  return %symbolic, %literal
      : !wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>
}

// CHECK-LABEL: func.func @redistribute_nonidentity_stays
// CHECK-COUNT-5: wave.redistribute
func.func @redistribute_nonidentity_stays(
    %packet: !wave.simd<vector<4xi32>, 64>)
    -> (!wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>,
        !wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>,
        !wave.simd<vector<2xi32>, 64>) {
  %constant_block = wave.redistribute %packet,
      <blocks = 2, items = 128, source_block = "0",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  %changed_block = wave.redistribute %packet,
      <blocks = 2, items = 128, source_block = "1 - block",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  %changed_item = wave.redistribute %packet,
      <blocks = 1, items = 256, source_block = "0",
       source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  %changed_slot = wave.redistribute %packet,
      <blocks = 1, items = 256, source_block = "0",
       source_item = "item", source_slot = "3 - slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<4xi32>, 64>
  %changed_type = wave.redistribute %packet,
      <blocks = 1, items = 256, source_block = "0",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 64>
        -> !wave.simd<vector<2xi32>, 64>
  return %constant_block, %changed_block, %changed_item, %changed_slot,
      %changed_type
      : !wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>,
        !wave.simd<vector<4xi32>, 64>, !wave.simd<vector<4xi32>, 64>,
        !wave.simd<vector<2xi32>, 64>
}

// CHECK-LABEL: func.func @extract_whole_packet_fold
// CHECK-SAME: (%[[PACKET:.*]]: !wave.simd<vector<16xf32>, 64>)
// CHECK-NOT: wave.extract
// CHECK: return %[[PACKET]] : !wave.simd<vector<16xf32>, 64>
func.func @extract_whole_packet_fold(
    %packet: !wave.simd<vector<16xf32>, 64>)
    -> !wave.simd<vector<16xf32>, 64> {
  %identity = wave.extract %packet[0]
      : !wave.simd<vector<16xf32>, 64>
        -> !wave.simd<vector<16xf32>, 64>
  return %identity : !wave.simd<vector<16xf32>, 64>
}

// CHECK-LABEL: func.func @extract_partial_packet_stays
// CHECK: %[[SLICE:.*]] = wave.extract %{{.*}}[0]
// CHECK: return %[[SLICE]] : !wave.simd<vector<8xf32>, 64>
func.func @extract_partial_packet_stays(
    %packet: !wave.simd<vector<16xf32>, 64>)
    -> !wave.simd<vector<8xf32>, 64> {
  %slice = wave.extract %packet[0]
      : !wave.simd<vector<16xf32>, 64>
        -> !wave.simd<vector<8xf32>, 64>
  return %slice : !wave.simd<vector<8xf32>, 64>
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
// CHECK: %[[ZERO:.*]] = wave.constant 0 : index -> !wave.simd<index, 32>
// CHECK: return %[[ZERO]] : !wave.simd<index, 32>
func.func @index_expr_scalarizes_to_splat(%lane: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %off = wave.index_expr <"floor(1/32*lid)"> assuming [#wave.pred<"lid >= 0 & -31 + lid <= 0">] ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %off : !wave.simd<index, 32>
}

// CHECK-LABEL: func.func @mma_scale_repack_from_dword
// CHECK-NOT: wave.pack
// CHECK: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %{{[A-Za-z0-9_]+}}, %[[SCALE:[A-Za-z0-9_]+]], %{{[A-Za-z0-9_]+}}, %[[SCALE]], %{{[A-Za-z0-9_]+}} {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64}
func.func @mma_scale_repack_from_dword(
    %a: !waveamd.fragment<0, i8, 16, 16, 64, 4>,
    %b: !waveamd.fragment<1, i8, 16, 16, 64, 4>,
    %acc: !waveamd.fragment<2, f32, 16, 16, 64, 4>,
    %src: !wave.simd<vector<4xi8>, 64>,
    %z: !wave.simd<i8, 64>) -> !waveamd.fragment<2, f32, 16, 16, 64, 4> {
  %a_scale = wave.extract %src[2]
      : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
  %b_scale = wave.extract %src[3]
      : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
  %a_pack = wave.pack %a_scale, %z, %z, %z, %z, %z, %z, %z
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<8xi8>, 64>
  %b_pack = wave.pack %z, %z, %b_scale, %z, %z, %z, %z, %z
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<8xi8>, 64>
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
      %a, %a_pack, %b, %b_pack, %acc {scale_idx_b = 2 : i64}
      : !waveamd.fragment<0, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<1, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return %result : !waveamd.fragment<2, f32, 16, 16, 64, 4>
}

// CHECK-LABEL: func.func @mma_scale_repack_from_upper_dword
// CHECK-DAG: %[[E4:[A-Za-z0-9_]+]] = wave.extract %[[SRC:[A-Za-z0-9_]+]][4]
// CHECK-DAG: %[[E5:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][5]
// CHECK-DAG: %[[E6:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][6]
// CHECK-DAG: %[[E7:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][7]
// CHECK-DAG: %[[E0:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][0]
// CHECK-DAG: %[[E1:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][1]
// CHECK-DAG: %[[E2:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][2]
// CHECK-DAG: %[[E3:[A-Za-z0-9_]+]] = wave.extract %[[SRC]][3]
// CHECK: %[[UPPER:[A-Za-z0-9_]+]] = wave.pack %[[E4]], %[[E5]], %[[E6]], %[[E7]], %[[E0]], %[[E1]], %[[E2]], %[[E3]]
// CHECK: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %{{[A-Za-z0-9_]+}}, %[[UPPER]], %{{[A-Za-z0-9_]+}}, %[[SRC]], %{{[A-Za-z0-9_]+}} {scale_idx_a = 1 : i64}
func.func @mma_scale_repack_from_upper_dword(
    %a: !waveamd.fragment<0, i8, 16, 16, 64, 4>,
    %b: !waveamd.fragment<1, i8, 16, 16, 64, 4>,
    %acc: !waveamd.fragment<2, f32, 16, 16, 64, 4>,
    %src: !wave.simd<vector<8xi8>, 64>,
    %z: !wave.simd<i8, 64>) -> !waveamd.fragment<2, f32, 16, 16, 64, 4> {
  %a_scale = wave.extract %src[5]
      : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
  %a_pack = wave.pack %a_scale, %z, %z, %z, %z, %z, %z, %z
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<8xi8>, 64>
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
      %a, %a_pack, %b, %src, %acc
      : !waveamd.fragment<0, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<1, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  return %result : !waveamd.fragment<2, f32, 16, 16, 64, 4>
}
