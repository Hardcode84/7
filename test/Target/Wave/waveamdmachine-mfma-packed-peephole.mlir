// RUN: wave-opt --split-input-file --waveamd-mfma-packed-peephole %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @unpack_round_trip(
// CHECK-SAME: %[[ADD_MMA_A:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 4>
// CHECK-SAME: %[[ADD_MMA_B:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 4>
// CHECK-SAME: %[[ADD_ACC:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 16>
// CHECK-SAME: %[[ADD_LHS0:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[ADD_LHS1:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[ADD_RHS0:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[ADD_RHS1:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: waveamdmachine.mfma_f32_32x32x16_f16
// CHECK-NEXT: %[[ADD_SIGN:.*]] = waveamdmachine.imm 2147483648
// CHECK-NEXT: %[[ADD_NEG_RHS0:.*]] = waveamdmachine.v_xor_b32 %[[ADD_RHS0]], %[[ADD_SIGN]]
// CHECK-NEXT: %[[ADD_LO:.*]] = waveamdmachine.v_add_f32 %[[ADD_LHS1]], %[[ADD_NEG_RHS0]]
// CHECK-NEXT: %[[ADD_NEG_RHS1:.*]] = waveamdmachine.v_xor_b32 %[[ADD_RHS1]], %[[ADD_SIGN]]
// CHECK-NEXT: %[[ADD_HI:.*]] = waveamdmachine.v_add_f32 %[[ADD_LHS0]], %[[ADD_NEG_RHS1]]
// CHECK-NEXT: return %[[ADD_LO]], %[[ADD_HI]]
// CHECK-NOT: waveamdmachine.v_pk_add_f32
func.func @unpack_round_trip(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 16>,
    %lhs0: !waveamdmachine.reg<vgpr, 1>,
    %lhs1: !waveamdmachine.reg<vgpr, 1>,
    %rhs0: !waveamdmachine.reg<vgpr, 1>,
    %rhs1: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %lhs = waveamdmachine.tuple_from_elements %lhs0, %lhs1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %rhs = waveamdmachine.tuple_from_elements %rhs0, %rhs1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 16>) -> !waveamdmachine.reg<vgpr, 16>
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs
      {neg_hi = 2 : i64, neg_lo = 2 : i64, op_sel = 1 : i64,
       op_sel_hi = 2 : i64}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %packed
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>)
  return %parts#0, %parts#1
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @unpack_fma_modifiers(
// CHECK-SAME: %[[FMA_MMA_A:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 4>
// CHECK-SAME: %[[FMA_MMA_B:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 4>
// CHECK-SAME: %[[FMA_ACC:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 16>
// CHECK-SAME: %[[FMA_A0:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1, 20>
// CHECK-SAME: %[[FMA_A1:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1, 21>
// CHECK-SAME: %[[FMA_B0:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[FMA_B1:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[FMA_C0:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-SAME: %[[FMA_C1:[a-zA-Z0-9_]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK-NOT: waveamdmachine.tuple_
// CHECK: waveamdmachine.mfma_f32_32x32x16_f16
// CHECK-NEXT: %[[FMA_SIGN:.*]] = waveamdmachine.imm 2147483648
// CHECK-NEXT: %[[FMA_NEGA:.*]] = waveamdmachine.v_xor_b32 %[[FMA_A0]], %[[FMA_SIGN]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1>
// CHECK-NEXT: %[[FMA_LO:.*]] = waveamdmachine.v_fma_f32 %[[FMA_NEGA]], %[[FMA_B0]], %[[FMA_C0]]
// CHECK-NEXT: %[[FMA_NEGC:.*]] = waveamdmachine.v_xor_b32 %[[FMA_C1]], %[[FMA_SIGN]]
// CHECK-NEXT: %[[FMA_HI:.*]] = waveamdmachine.v_fma_f32 %[[FMA_A1]], %[[FMA_B1]], %[[FMA_NEGC]]
// CHECK-NEXT: return %[[FMA_LO]], %[[FMA_HI]]
// CHECK-NOT: waveamdmachine.v_pk_fma_f32
func.func @unpack_fma_modifiers(
    %mma_a: !waveamdmachine.reg<vgpr, 4>,
    %mma_b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 16>,
    %a0: !waveamdmachine.reg<vgpr, 1, 20>,
    %a1: !waveamdmachine.reg<vgpr, 1, 21>,
    %b0: !waveamdmachine.reg<vgpr, 1>,
    %b1: !waveamdmachine.reg<vgpr, 1>,
    %c0: !waveamdmachine.reg<vgpr, 1>,
    %c1: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %a = waveamdmachine.tuple_from_elements %a0, %a1
      : (!waveamdmachine.reg<vgpr, 1, 20>,
         !waveamdmachine.reg<vgpr, 1, 21>)
        -> !waveamdmachine.reg<vgpr, 2, 20>
  %b = waveamdmachine.tuple_from_elements %b0, %b1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %c = waveamdmachine.tuple_from_elements %c0, %c1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %mma_a, %mma_b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 16>)
        -> !waveamdmachine.reg<vgpr, 16>
  %packed = waveamdmachine.v_pk_fma_f32 %a, %b, %c
      {neg_hi = 4 : i64, neg_lo = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 2, 20>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %packed
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>)
  return %parts#0, %parts#1
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @unpack_mul(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[MASK:.*]] = waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.v_xor_b32 {{.*}}, %[[MASK]]
// CHECK-NEXT: %[[MUL_LHS:.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: %[[MUL_RHS:.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-NEXT: %[[MUL_LO:.*]] = waveamdmachine.v_mul_f32 %[[MUL_LHS]]#0, %[[MUL_RHS]]#0
// CHECK-NEXT: %[[MUL_HI:.*]] = waveamdmachine.v_mul_f32 %[[MUL_LHS]]#1, %[[MUL_RHS]]#1
// CHECK-NEXT: return %[[MUL_LO]], %[[MUL_HI]]
// CHECK-NOT: waveamdmachine.v_pk_mul_f32
func.func @unpack_mul(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>,
    %x: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mask = waveamdmachine.imm 1 : !waveamdmachine.imm
  %xor = waveamdmachine.v_xor_b32 %x, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %packed = waveamdmachine.v_pk_mul_f32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %packed
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>)
  return %parts#0, %parts#1
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @keep_outside_window(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_add_f32
// CHECK-NEXT: waveamdmachine.v_add_f32
// CHECK-NEXT: waveamdmachine.v_add_f32
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_add_f32
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_outside_window(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>,
    %x0: !waveamdmachine.reg<vgpr, 1>,
    %x1: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %fill0 = waveamdmachine.v_add_f32 %x0, %x1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill1 = waveamdmachine.v_add_f32 %x0, %x1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill2 = waveamdmachine.v_add_f32 %x0, %x1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %packed : !waveamdmachine.reg<vgpr, 2>
}

// CHECK-LABEL: func.func @keep_clamped(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_mul_f32
// CHECK-SAME: clamp = true
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_clamped(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %packed = waveamdmachine.v_pk_mul_f32 %lhs, %rhs {clamp = true}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %packed : !waveamdmachine.reg<vgpr, 2>
}

// CHECK-LABEL: func.func @keep_mfma_dependent(
// CHECK: %[[MFMA:.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[PARTS:.*]]:2 = waveamdmachine.tuple_to_elements %[[MFMA]]
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_add_f32 %[[PARTS]]#0
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_mfma_dependent(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %rhs: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %parts:2 = waveamdmachine.tuple_to_elements %mfma
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.reg<vgpr, 2>)
  %packed = waveamdmachine.v_pk_add_f32 %parts#0, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %packed : !waveamdmachine.reg<vgpr, 2>
}

// CHECK-LABEL: func.func @keep_fixed_clobber(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_add_f32
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_fixed_clobber(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2, 12>,
    %rhs: !waveamdmachine.reg<vgpr, 2, 14>)
    -> !waveamdmachine.reg<vgpr, 2, 12> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs {op_sel_hi = 0 : i64}
      : (!waveamdmachine.reg<vgpr, 2, 12>,
         !waveamdmachine.reg<vgpr, 2, 14>)
        -> !waveamdmachine.reg<vgpr, 2, 12>
  return %packed : !waveamdmachine.reg<vgpr, 2, 12>
}

// CHECK-LABEL: func.func @keep_fixed_mfma_overlap(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_add_f32
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_fixed_mfma_overlap(
    %a: !waveamdmachine.reg<vgpr, 4, 0>,
    %b: !waveamdmachine.reg<vgpr, 4, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4, 8>,
    %lhs: !waveamdmachine.reg<vgpr, 2, 8>,
    %rhs: !waveamdmachine.reg<vgpr, 2, 12>)
    -> !waveamdmachine.reg<vgpr, 2, 14> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>,
         !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>)
        -> !waveamdmachine.reg<vgpr, 4, 8>
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 2, 8>,
         !waveamdmachine.reg<vgpr, 2, 12>)
        -> !waveamdmachine.reg<vgpr, 2, 14>
  return %packed : !waveamdmachine.reg<vgpr, 2, 14>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_without_restriction(
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: %[[PACKED:.*]] = waveamdmachine.v_pk_add_f32
// CHECK-NEXT: return %[[PACKED]]
func.func @keep_without_restriction(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vgpr, 2> {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %packed = waveamdmachine.v_pk_add_f32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %packed : !waveamdmachine.reg<vgpr, 2>
}

}
