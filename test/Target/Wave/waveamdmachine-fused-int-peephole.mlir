// RUN: wave-opt --split-input-file --waveamd-form-fused-int %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @add_add
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_add3_u32
func.func @add_add(%a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %ab = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %abc = waveamdmachine.v_add_u32 %ab, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %abc : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @shift_add
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_lshl_add_u32
func.func @shift_add(%a: !waveamdmachine.reg<vgpr, 1>,
                     %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %a, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %shifted, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @shift_add_multi_use
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: [[OUT0:%.*]] = waveamdmachine.v_lshl_add_u32
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: [[OUT1:%.*]] = waveamdmachine.v_lshl_add_u32
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: return [[OUT0]], [[OUT1]]
func.func @shift_add_multi_use(%a: !waveamdmachine.reg<vgpr, 1>,
                               %b: !waveamdmachine.reg<vgpr, 1>,
                               %c: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %a, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add_u32 %shifted, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add_u32 %c, %shifted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1 : !waveamdmachine.reg<vgpr, 1>,
                        !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @add_shift
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_add_lshl_u32
func.func @add_shift(%a: !waveamdmachine.reg<vgpr, 1>,
                     %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_lshlrev_b32 %sum, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @and_or
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_and_or_b32
func.func @and_or(%a: !waveamdmachine.reg<vgpr, 1>,
                  %b: !waveamdmachine.reg<vgpr, 1>,
                  %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %and = waveamdmachine.v_and_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_or_b32 %and, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @or_or
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_or3_b32
func.func @or_or(%a: !waveamdmachine.reg<vgpr, 1>,
                 %b: !waveamdmachine.reg<vgpr, 1>,
                 %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %or0 = waveamdmachine.v_or_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_or_b32 %or0, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @xor_add
// CHECK-NOT: waveamdmachine.v_xor_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_xad_u32
func.func @xor_add(%a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %xor = waveamdmachine.v_xor_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %xor, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @mad_u24_masked
// CHECK-NOT: waveamdmachine.v_mul_lo_u32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_mad_u32_u24
func.func @mad_u24_masked(%a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>,
                          %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %mask = waveamdmachine.imm 16777215 : !waveamdmachine.imm
  %am = waveamdmachine.v_and_b32 %a, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %bm = waveamdmachine.v_and_b32 %b, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_mul_lo_u32 %am, %bm
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @mad_i24_signed_imm
// CHECK-NOT: waveamdmachine.v_mul_lo_u32
// CHECK: [[NEG:%.*]] = waveamdmachine.imm -3
// CHECK: [[OUT:%.*]] = waveamdmachine.v_mad_i32_i24 [[NEG]],
func.func @mad_i24_signed_imm(%c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %neg = waveamdmachine.imm -3 : !waveamdmachine.imm
  %five = waveamdmachine.imm 5 : !waveamdmachine.imm
  %mul = waveamdmachine.v_mul_lo_u32 %neg, %five
      : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @mad_reject_out_of_range
// CHECK-NOT: waveamdmachine.v_mad
// CHECK: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.v_add_u32
func.func @mad_reject_out_of_range(%c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %wide = waveamdmachine.imm 16777216 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mul = waveamdmachine.v_mul_lo_u32 %wide, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @multi_use
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: [[INNER:%.*]] = waveamdmachine.v_add_u32
// CHECK: waveamdmachine.v_add_u32 [[INNER]]
// CHECK: waveamdmachine.v_add_u32 [[INNER]]
func.func @multi_use(%a: !waveamdmachine.reg<vgpr, 1>,
                     %b: !waveamdmachine.reg<vgpr, 1>,
                     %c: !waveamdmachine.reg<vgpr, 1>,
                     %d: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %ab = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %abc = waveamdmachine.v_add_u32 %ab, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %abd = waveamdmachine.v_add_u32 %ab, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %abc, %abd : !waveamdmachine.reg<vgpr, 1>,
                      !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @shift_add_multi_use_mixed_reject
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32
// CHECK: [[ADD:%.*]] = waveamdmachine.v_add_u32 [[SHIFTED]]
// CHECK: [[OR:%.*]] = waveamdmachine.v_or_b32 [[SHIFTED]]
// CHECK: return [[ADD]], [[OR]]
func.func @shift_add_multi_use_mixed_reject(%a: !waveamdmachine.reg<vgpr, 1>,
                                            %b: !waveamdmachine.reg<vgpr, 1>,
                                            %c: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %a, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add_u32 %shifted, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_or_b32 %shifted, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1 : !waveamdmachine.reg<vgpr, 1>,
                        !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @shift_add_multi_use_same_add_reject
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32
// CHECK: [[ADD:%.*]] = waveamdmachine.v_add_u32 [[SHIFTED]], [[SHIFTED]]
// CHECK: waveamdmachine.v_add_u32 [[SHIFTED]]
// CHECK: return [[ADD]],
func.func @shift_add_multi_use_same_add_reject(%a: !waveamdmachine.reg<vgpr, 1>,
                                               %b: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %a, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add_u32 %shifted, %shifted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add_u32 %shifted, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1 : !waveamdmachine.reg<vgpr, 1>,
                        !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @scalar_stays_scalar
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
func.func @scalar_stays_scalar(%a: !waveamdmachine.reg<sgpr, 1>,
                               %b: !waveamdmachine.reg<sgpr, 1>,
                               %c: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1> {
  %ab, %scc0 = waveamdmachine.s_add_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %abc, %scc1 = waveamdmachine.s_add_i32 %ab, %c
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %abc : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @mad_requires_range_or_target
// CHECK-NOT: waveamdmachine.v_mad
// CHECK: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.v_add_u32
func.func @mad_requires_range_or_target(%a: !waveamdmachine.reg<vgpr, 1>,
                                        %b: !waveamdmachine.reg<vgpr, 1>,
                                        %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %mul = waveamdmachine.v_mul_lo_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @scalar_add_m0
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.s_add_m0_i32
func.func @scalar_add_m0(%s: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.m0 {
  %literal = waveamdmachine.imm 65536 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s, %literal
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %m0 = waveamdmachine.s_mov_m0 %sum
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  return %m0 : !waveamdmachine.m0
}

// CHECK-LABEL: func.func @scalar_add_m0_live_scc
// CHECK-NOT: waveamdmachine.s_add_m0_i32
// CHECK: [[SUM:%.*]], [[SCC:%.*]] = waveamdmachine.s_add_i32
// CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0 [[SUM]]
// CHECK: waveamdmachine.s_cbranch_scc1 [[SCC]]
func.func @scalar_add_m0_live_scc(%s: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.m0 {
  %literal = waveamdmachine.imm 65536 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s, %literal
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %m0 = waveamdmachine.s_mov_m0 %sum
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return %m0 : !waveamdmachine.m0
}

// CHECK-LABEL: func.func @scalar_add_vector_add
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add3_u32
func.func @scalar_add_vector_add(%s: !waveamdmachine.reg<sgpr, 1>,
                                 %v: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out = waveamdmachine.v_add_u32 %sum, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @scalar_add_live_scc
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: [[SUM:%.*]], [[SCC:%.*]] = waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add_u32 [[SUM]]
// CHECK: waveamdmachine.s_cbranch_scc1 [[SCC]]
func.func @scalar_add_live_scc(%s: !waveamdmachine.reg<sgpr, 1>,
                               %v: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out = waveamdmachine.v_add_u32 %sum, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @scalar_add_gfx9_literal_reject
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: [[SUM:%.*]], %{{.*}} = waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add_u32 [[SUM]]
func.func @scalar_add_gfx9_literal_reject(%s: !waveamdmachine.reg<sgpr, 1>,
                                          %v: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %literal = waveamdmachine.imm 256 : !waveamdmachine.imm
  %sum, %scc = waveamdmachine.s_add_i32 %s, %literal
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out = waveamdmachine.v_add_u32 %sum, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @constant_bus_reject
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: [[INNER:%.*]] = waveamdmachine.v_add_u32
// CHECK: waveamdmachine.v_add_u32 [[INNER]]
func.func @constant_bus_reject(%s0: !waveamdmachine.reg<sgpr, 1>,
                               %s1: !waveamdmachine.reg<sgpr, 1>,
                               %v: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %sum = waveamdmachine.v_add_u32 %s0, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %sum, %s1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @constant_bus_same_sgpr
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.v_add3_u32
func.func @constant_bus_same_sgpr(%s: !waveamdmachine.reg<sgpr, 1>,
                                  %v: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %sum = waveamdmachine.v_add_u32 %s, %v
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %sum, %s
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @gfx9_literal_reject
// CHECK-NOT: waveamdmachine.v_lshl_add_u32
// CHECK: [[SHIFTED:%.*]] = waveamdmachine.v_lshlrev_b32
// CHECK: waveamdmachine.v_add_u32 [[SHIFTED]]
func.func @gfx9_literal_reject(%a: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %shift = waveamdmachine.imm 2 : !waveamdmachine.imm
  %literal = waveamdmachine.imm 256 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %a, %shift
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %shifted, %literal
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @mad_gfx9_literal_reject
// CHECK-NOT: waveamdmachine.v_mad
// CHECK: [[MUL:%.*]] = waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.v_add_u32 [[MUL]]
func.func @mad_gfx9_literal_reject(%a: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %literal = waveamdmachine.imm 100000 : !waveamdmachine.imm
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %mul = waveamdmachine.v_mul_lo_u32 %literal, %two
      : (!waveamdmachine.imm, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_add_u32 %mul, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @scalar_add_base_factor
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: [[BASE:%.*]] = waveamdmachine.v_add_u32 %{{.*}}, %{{.*}} {waveamdmachine.local_base = 0 : i64} : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: [[ADDR0:%.*]] = waveamdmachine.v_add_u32 %{{.*}}, [[BASE]]
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: [[ADDR1:%.*]] = waveamdmachine.v_add_u32 %{{.*}}, [[BASE]]
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: [[ADDR2:%.*]] = waveamdmachine.v_add_u32 %{{.*}}, [[BASE]]
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: return [[ADDR0]], [[ADDR1]], [[ADDR2]]
func.func @scalar_add_base_factor(%off0: !waveamdmachine.reg<sgpr, 1>,
                                  %off1: !waveamdmachine.reg<sgpr, 1>,
                                  %off2: !waveamdmachine.reg<sgpr, 1>,
                                  %scale: !waveamdmachine.reg<sgpr, 1>,
                                  %lane: !waveamdmachine.reg<vgpr, 1>,
                                  %m0src: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %sum0, %scc0 = waveamdmachine.s_add_i32 %off0, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr0 = waveamdmachine.v_add_u32 %sum0, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %m0src
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %sum1, %scc1 = waveamdmachine.s_add_i32 %off1, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr1 = waveamdmachine.v_add_u32 %sum1, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %m1 = waveamdmachine.s_mov_m0 %m0src
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %sum2, %scc2 = waveamdmachine.s_add_i32 %off2, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr2 = waveamdmachine.v_add_u32 %sum2, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %addr0, %addr1, %addr2 : !waveamdmachine.reg<vgpr, 1>,
                                  !waveamdmachine.reg<vgpr, 1>,
                                  !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @scalar_add_base_factor_exec_boundary_reject
// CHECK-NOT: waveamdmachine.local_base
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_andn2_exec_b32
// CHECK-NOT: waveamdmachine.local_base
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.v_add_u32
// CHECK-NOT: waveamdmachine.local_base
// CHECK: return
func.func @scalar_add_base_factor_exec_boundary_reject(
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %off1: !waveamdmachine.reg<sgpr, 1>,
    %off2: !waveamdmachine.reg<sgpr, 1>,
    %scale: !waveamdmachine.reg<sgpr, 1>,
    %lane: !waveamdmachine.reg<vgpr, 1>,
    %exec0: !waveamdmachine.reg<sgpr, 1>,
    %exec1: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %sum0, %scc0 = waveamdmachine.s_add_i32 %off0, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr0 = waveamdmachine.v_add_u32 %sum0, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %scc_exec = waveamdmachine.s_andn2_exec_b32 %exec0, %exec1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
  %sum1, %scc1 = waveamdmachine.s_add_i32 %off1, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr1 = waveamdmachine.v_add_u32 %sum1, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %sum2, %scc2 = waveamdmachine.s_add_i32 %off2, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr2 = waveamdmachine.v_add_u32 %sum2, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %addr0, %addr1, %addr2 : !waveamdmachine.reg<vgpr, 1>,
                                  !waveamdmachine.reg<vgpr, 1>,
                                  !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @scalar_add_base_factor_two_uses_reject
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
func.func @scalar_add_base_factor_two_uses_reject(
    %off0: !waveamdmachine.reg<sgpr, 1>,
    %off1: !waveamdmachine.reg<sgpr, 1>,
    %scale: !waveamdmachine.reg<sgpr, 1>,
    %lane: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %sum0, %scc0 = waveamdmachine.s_add_i32 %off0, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr0 = waveamdmachine.v_add_u32 %sum0, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %sum1, %scc1 = waveamdmachine.s_add_i32 %off1, %scale
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %addr1 = waveamdmachine.v_add_u32 %sum1, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %addr0, %addr1 : !waveamdmachine.reg<vgpr, 1>,
                          !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @v_add3_common_tail_factor
// CHECK: [[BASE0:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, %{{.*}}, %{{.*}} {waveamdmachine.local_base = 0 : i64}
// CHECK: [[BASE1:%.*]] = waveamdmachine.v_add3_u32 [[BASE0]], %{{.*}}, %{{.*}} {waveamdmachine.local_base = 0 : i64}
// CHECK: [[BASE2:%.*]] = waveamdmachine.v_add3_u32 [[BASE1]], %{{.*}}, %{{.*}} {waveamdmachine.local_base = 0 : i64}
// CHECK: [[OUT0:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE2]], %{{.*}}
// CHECK: [[OUT1:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE2]], %{{.*}}
// CHECK: [[OUT2:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE2]], %{{.*}}
// CHECK-NOT: waveamdmachine.v_add3_u32
// CHECK: return [[OUT0]], [[OUT1]], [[OUT2]]
func.func @v_add3_common_tail_factor(
    %seed0: !waveamdmachine.reg<sgpr, 1>,
    %seed1: !waveamdmachine.reg<sgpr, 1>,
    %seed2: !waveamdmachine.reg<sgpr, 1>,
    %v0: !waveamdmachine.reg<vgpr, 1>,
    %v1: !waveamdmachine.reg<vgpr, 1>,
    %v2: !waveamdmachine.reg<vgpr, 1>,
    %v3: !waveamdmachine.reg<vgpr, 1>,
    %v4: !waveamdmachine.reg<vgpr, 1>,
    %v5: !waveamdmachine.reg<vgpr, 1>,
    %v6: !waveamdmachine.reg<vgpr, 1>,
    %v7: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %a0 = waveamdmachine.v_add3_u32 %seed0, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a1 = waveamdmachine.v_add3_u32 %a0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %a2 = waveamdmachine.v_add3_u32 %a1, %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add3_u32 %a2, %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b0 = waveamdmachine.v_add3_u32 %seed1, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b1 = waveamdmachine.v_add3_u32 %b0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b2 = waveamdmachine.v_add3_u32 %b1, %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add3_u32 %b2, %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c0 = waveamdmachine.v_add3_u32 %seed2, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.v_add3_u32 %c0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.v_add3_u32 %c1, %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out2 = waveamdmachine.v_add3_u32 %c2, %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1, %out2 : !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @mixed_add_chain_commutative_factor
// CHECK: [[BASE:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, %{{.*}}, %{{.*}} {waveamdmachine.local_base = 0 : i64}
// CHECK: [[OUT0:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE]], %{{.*}}
// CHECK: [[OUT1:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE]], %{{.*}}
// CHECK: [[OUT2:%.*]] = waveamdmachine.v_add3_u32 %{{.*}}, [[BASE]], %{{.*}}
// CHECK-NOT: waveamdmachine.v_add
// CHECK: return [[OUT0]], [[OUT1]], [[OUT2]]
func.func @mixed_add_chain_commutative_factor(
    %seed0: !waveamdmachine.reg<sgpr, 1>,
    %seed1: !waveamdmachine.reg<sgpr, 1>,
    %seed2: !waveamdmachine.reg<sgpr, 1>,
    %v0: !waveamdmachine.reg<vgpr, 1>,
    %v1: !waveamdmachine.reg<vgpr, 1>,
    %v2: !waveamdmachine.reg<vgpr, 1>,
    %v3: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %a0 = waveamdmachine.v_add_u32 %seed0, %v0
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %a1 = waveamdmachine.v_add3_u32 %a0, %v1, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add_u32 %a1, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %b0 = waveamdmachine.v_add3_u32 %v2, %seed1, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b1 = waveamdmachine.v_add_u32 %v0, %b0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add_u32 %v3, %b1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %c0 = waveamdmachine.v_add_u32 %v3, %seed2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.v_add3_u32 %v1, %c0, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out2 = waveamdmachine.v_add_u32 %v2, %c1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1, %out2 : !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @v_add3_common_tail_two_uses_reject
// CHECK-NOT: waveamdmachine.local_base
// CHECK: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.v_add3_u32
// CHECK-NOT: waveamdmachine.local_base
// CHECK: return
func.func @v_add3_common_tail_two_uses_reject(
    %seed0: !waveamdmachine.reg<sgpr, 1>,
    %seed1: !waveamdmachine.reg<sgpr, 1>,
    %v0: !waveamdmachine.reg<vgpr, 1>,
    %v1: !waveamdmachine.reg<vgpr, 1>,
    %v2: !waveamdmachine.reg<vgpr, 1>,
    %v3: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %a0 = waveamdmachine.v_add3_u32 %seed0, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add3_u32 %a0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %b0 = waveamdmachine.v_add3_u32 %seed1, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add3_u32 %b0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1 : !waveamdmachine.reg<vgpr, 1>,
                        !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @v_add3_common_tail_exec_boundary_reject
// CHECK-NOT: waveamdmachine.local_base
// CHECK: waveamdmachine.v_add3_u32
// CHECK: waveamdmachine.s_andn2_exec_b32
// CHECK-NOT: waveamdmachine.local_base
// CHECK: return
func.func @v_add3_common_tail_exec_boundary_reject(
    %seed0: !waveamdmachine.reg<sgpr, 1>,
    %seed1: !waveamdmachine.reg<sgpr, 1>,
    %seed2: !waveamdmachine.reg<sgpr, 1>,
    %v0: !waveamdmachine.reg<vgpr, 1>,
    %v1: !waveamdmachine.reg<vgpr, 1>,
    %v2: !waveamdmachine.reg<vgpr, 1>,
    %v3: !waveamdmachine.reg<vgpr, 1>,
    %exec0: !waveamdmachine.reg<sgpr, 1>,
    %exec1: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>) {
  %a0 = waveamdmachine.v_add3_u32 %seed0, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out0 = waveamdmachine.v_add3_u32 %a0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %scc_exec = waveamdmachine.s_andn2_exec_b32 %exec0, %exec1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
  %b0 = waveamdmachine.v_add3_u32 %seed1, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out1 = waveamdmachine.v_add3_u32 %b0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %c0 = waveamdmachine.v_add3_u32 %seed2, %v0, %v1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %out2 = waveamdmachine.v_add3_u32 %c0, %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %out0, %out1, %out2 : !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>,
                               !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @bitop3_xor_and_or
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK-NOT: waveamdmachine.v_xor_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_bitop3_b32 {{.*}} bitop3 58
// CHECK: return [[OUT]]
func.func @bitop3_xor_and_or(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>,
                             %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %and = waveamdmachine.v_and_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %or = waveamdmachine.v_or_b32 %c, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_xor_b32 %and, %or
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @bitop3_or_and_xor
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK-NOT: waveamdmachine.v_xor_b32
// CHECK-NOT: waveamdmachine.v_and_or_b32
// CHECK: [[OUT:%.*]] = waveamdmachine.v_bitop3_b32 {{.*}} bitop3 218
// CHECK: return [[OUT]]
func.func @bitop3_or_and_xor(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>,
                             %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %and = waveamdmachine.v_and_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %xor = waveamdmachine.v_xor_b32 %c, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_or_b32 %and, %xor
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @bitop3_gfx11_reject
// CHECK-NOT: waveamdmachine.v_bitop3_b32
// CHECK: waveamdmachine.v_and_b32
// CHECK: waveamdmachine.v_or_b32
// CHECK: waveamdmachine.v_xor_b32
func.func @bitop3_gfx11_reject(%a: !waveamdmachine.reg<vgpr, 1>,
                               %b: !waveamdmachine.reg<vgpr, 1>,
                               %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %and = waveamdmachine.v_and_b32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %or = waveamdmachine.v_or_b32 %c, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %out = waveamdmachine.v_xor_b32 %and, %or
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %out : !waveamdmachine.reg<vgpr, 1>
}

}
