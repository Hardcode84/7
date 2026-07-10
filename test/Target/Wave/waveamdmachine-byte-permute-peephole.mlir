// RUN: wave-opt --split-input-file --waveamd-form-fused-int %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @halfword_bridges
// CHECK-SAME: ([[A:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK-NOT: waveamdmachine.v_lshl_add_u32
// CHECK-NOT: waveamdmachine.v_lshrrev_b32
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK: [[LOW_IMM:%.*]] = waveamdmachine.imm 84148480
// CHECK-NEXT: [[LOW_SEL:%.*]] = waveamdmachine.s_mov_b32_value [[LOW_IMM]]
// CHECK-NEXT: [[LOW:%.*]] = waveamdmachine.v_perm_b32 [[B]], [[A]], [[LOW_SEL]]
// CHECK: [[HIGH_IMM:%.*]] = waveamdmachine.imm 117834498
// CHECK-NEXT: [[HIGH_SEL:%.*]] = waveamdmachine.s_mov_b32_value [[HIGH_IMM]]
// CHECK-NEXT: [[HIGH:%.*]] = waveamdmachine.v_perm_b32 [[B]], [[A]], [[HIGH_SEL]]
// CHECK: return [[LOW]], [[HIGH]]
func.func @halfword_bridges(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) {
  %shift16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %low_mask = waveamdmachine.imm 65535 : !waveamdmachine.imm
  %high_mask = waveamdmachine.imm -65536 : !waveamdmachine.imm
  %a_low = waveamdmachine.v_and_b32 %a, %low_mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b_low_high = waveamdmachine.v_lshlrev_b32 %b, %shift16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %low = waveamdmachine.v_add_u32 %b_low_high, %a_low
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %a_high_low = waveamdmachine.v_lshrrev_b32 %a, %shift16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b_high = waveamdmachine.v_and_b32 %high_mask, %b
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %high = waveamdmachine.v_or_b32 %b_high, %a_high_low
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %low, %high : !waveamdmachine.reg<vgpr, 1>,
                       !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @arbitrary_bytes
// CHECK-SAME: ([[A:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK-NOT: waveamdmachine.v_lshrrev_b32
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK: [[SEL_IMM:%.*]] = waveamdmachine.imm 100729859
// CHECK-NEXT: [[SEL:%.*]] = waveamdmachine.s_mov_b32_value [[SEL_IMM]]
// CHECK-NEXT: [[PERM:%.*]] = waveamdmachine.v_perm_b32 [[B]], [[A]], [[SEL]]
// CHECK: return [[PERM]]
func.func @arbitrary_bytes(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %c8 = waveamdmachine.imm 8 : !waveamdmachine.imm
  %c24 = waveamdmachine.imm 24 : !waveamdmachine.imm
  %mask0 = waveamdmachine.imm 255 : !waveamdmachine.imm
  %mask1 = waveamdmachine.imm 65280 : !waveamdmachine.imm
  %mask2 = waveamdmachine.imm 16711680 : !waveamdmachine.imm
  %a3 = waveamdmachine.v_lshrrev_b32 %a, %c24
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b0 = waveamdmachine.v_and_b32 %b, %mask0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b0_at1 = waveamdmachine.v_lshlrev_b32 %b0, %c8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %a1 = waveamdmachine.v_and_b32 %a, %mask1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %a1_at2 = waveamdmachine.v_lshlrev_b32 %a1, %c8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b2 = waveamdmachine.v_and_b32 %b, %mask2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b2_at3 = waveamdmachine.v_lshlrev_b32 %b2, %c8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %low = waveamdmachine.v_or_b32 %a3, %b0_at1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %high = waveamdmachine.v_or_b32 %a1_at2, %b2_at3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_or_b32 %low, %high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @reject_nibble_mix
// CHECK-NOT: waveamdmachine.v_perm_b32
func.func @reject_nibble_mix(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %low_nibbles = waveamdmachine.imm 252645135 : !waveamdmachine.imm
  %high_nibbles = waveamdmachine.imm -252645136 : !waveamdmachine.imm
  %a_low = waveamdmachine.v_and_b32 %a, %low_nibbles
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b_high = waveamdmachine.v_and_b32 %b, %high_nibbles
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_or_b32 %a_low, %b_high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @reject_add_carry
// CHECK-NOT: waveamdmachine.v_perm_b32
// CHECK: waveamdmachine.v_lshl_add_u32
func.func @reject_add_carry(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %shift16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %shifted = waveamdmachine.v_lshlrev_b32 %b, %shift16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_u32 %shifted, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @reject_three_sources
// CHECK-NOT: waveamdmachine.v_perm_b32
func.func @reject_three_sources(%a: !waveamdmachine.reg<vgpr, 1>,
                                %b: !waveamdmachine.reg<vgpr, 1>,
                                %c: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %mask0 = waveamdmachine.imm 255 : !waveamdmachine.imm
  %mask1 = waveamdmachine.imm 65280 : !waveamdmachine.imm
  %mask23 = waveamdmachine.imm -65536 : !waveamdmachine.imm
  %a0 = waveamdmachine.v_and_b32 %a, %mask0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b1 = waveamdmachine.v_and_b32 %b, %mask1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %c23 = waveamdmachine.v_and_b32 %c, %mask23
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %low = waveamdmachine.v_or_b32 %a0, %b1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_or_b32 %low, %c23
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @literal_selector
// CHECK-SAME: ([[A:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NOT: waveamdmachine.s_mov_b32_value
// CHECK: [[SEL:%.*]] = waveamdmachine.imm 84148480
// CHECK-NEXT: [[PERM:%.*]] = waveamdmachine.v_perm_b32 [[B]], [[A]], [[SEL]]
// CHECK: return [[PERM]]
func.func @literal_selector(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %shift16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %low_mask = waveamdmachine.imm 65535 : !waveamdmachine.imm
  %a_low = waveamdmachine.v_and_b32 %a, %low_mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %b_low_high = waveamdmachine.v_lshlrev_b32 %b, %shift16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_or_b32 %a_low, %b_low_high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @constant_bytes
// CHECK-SAME: ([[A:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NOT: waveamdmachine.v_and_b32
// CHECK-NOT: waveamdmachine.v_or_b32
// CHECK: [[SEL:%.*]] = waveamdmachine.imm 67046400
// CHECK-NEXT: [[PERM:%.*]] = waveamdmachine.v_perm_b32 [[A]], [[A]], [[SEL]]
// CHECK: return [[PERM]]
func.func @constant_bytes(%a: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1> {
  %source_mask = waveamdmachine.imm -16776961 : !waveamdmachine.imm
  %ones = waveamdmachine.imm 16711680 : !waveamdmachine.imm
  %source_bytes = waveamdmachine.v_and_b32 %a, %source_mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_or_b32 %source_bytes, %ones
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

}
