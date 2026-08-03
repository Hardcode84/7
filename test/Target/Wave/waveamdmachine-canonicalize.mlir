// RUN: wave-opt --split-input-file --canonicalize %s | FileCheck %s

// CHECK-LABEL: func.func @packed_add_splat_low(
// CHECK-SAME: [[SOURCE:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[RHS:%.*]]: !waveamdmachine.reg<vgpr, 2>)
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_pk_add_f32 [[SOURCE]], [[RHS]] {op_sel_hi = 2 : i64}
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: return [[RESULT]]
func.func @packed_add_splat_low(
    %source: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %parts:2 = waveamdmachine.tuple_to_elements %source
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %splat = waveamdmachine.tuple_from_elements %parts#0, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %result = waveamdmachine.v_pk_add_f32 %splat, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %result : !waveamdmachine.reg<vgpr, 2>
}

// -----

// CHECK-LABEL: func.func @packed_mul_splat_high(
// CHECK-SAME: [[LHS:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[SOURCE:%.*]]: !waveamdmachine.reg<vgpr, 2>)
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_pk_mul_f32 [[LHS]], [[SOURCE]] {op_sel = 3 : i64}
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: return [[RESULT]]
func.func @packed_mul_splat_high(
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %source: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %parts:2 = waveamdmachine.tuple_to_elements %source
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %splat = waveamdmachine.tuple_from_elements %parts#1, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %result = waveamdmachine.v_pk_mul_f32 %lhs, %splat
      {op_sel = 1, op_sel_hi = 1}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %result : !waveamdmachine.reg<vgpr, 2>
}

// -----

// CHECK-LABEL: func.func @packed_fma_repack_all_operands(
// CHECK-SAME: [[A:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[C:%.*]]: !waveamdmachine.reg<vgpr, 2>)
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_pk_fma_f32 [[A]], [[B]], [[C]] {neg_hi = 4 : i64, neg_lo = 2 : i64, op_sel = 6 : i64, op_sel_hi = 3 : i64}
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: return [[RESULT]]
func.func @packed_fma_repack_all_operands(
    %a: !waveamdmachine.reg<vgpr, 2>,
    %b: !waveamdmachine.reg<vgpr, 2>,
    %c: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %a_parts:2 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %a_swap = waveamdmachine.tuple_from_elements %a_parts#1, %a_parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %b_parts:2 = waveamdmachine.tuple_to_elements %b
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %b_high = waveamdmachine.tuple_from_elements %b_parts#1, %b_parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %c_parts:2 = waveamdmachine.tuple_to_elements %c
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %c_roundtrip = waveamdmachine.tuple_from_elements %c_parts#0, %c_parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %result = waveamdmachine.v_pk_fma_f32 %a_swap, %b_high, %c_roundtrip
      {neg_hi = 4, neg_lo = 2, op_sel = 5, op_sel_hi = 2}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  return %result : !waveamdmachine.reg<vgpr, 2>
}

// -----

// CHECK-LABEL: func.func @keep_mixed_source_tuple(
// CHECK: [[A_PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements [[A:%.*]]
// CHECK: [[B_PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements [[B:%.*]]
// CHECK: [[MIXED:%.*]] = waveamdmachine.tuple_from_elements [[A_PARTS]]#0, [[B_PARTS]]#1
// CHECK: waveamdmachine.v_pk_add_f32 [[MIXED]],
func.func @keep_mixed_source_tuple(
    %a: !waveamdmachine.reg<vgpr, 2>,
    %b: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %a_parts:2 = waveamdmachine.tuple_to_elements %a
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %b_parts:2 = waveamdmachine.tuple_to_elements %b
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %mixed = waveamdmachine.tuple_from_elements %a_parts#0, %b_parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %result = waveamdmachine.v_pk_add_f32 %mixed, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %result : !waveamdmachine.reg<vgpr, 2>
}
