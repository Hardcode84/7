// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @fused_int_ops
// ROUND: [[ADD3:%.*]] = waveamdmachine.v_add3_u32
// ROUND: [[MADI24:%.*]] = waveamdmachine.v_mad_i32_i24 [[ADD3]],
// ROUND: [[MADU24:%.*]] = waveamdmachine.v_mad_u32_u24 [[MADI24]],
// ROUND: [[LSHADD:%.*]] = waveamdmachine.v_lshl_add_u32 [[MADU24]],
// ROUND: [[ADDLSH:%.*]] = waveamdmachine.v_add_lshl_u32 [[LSHADD]],
// ROUND: [[ANDOR:%.*]] = waveamdmachine.v_and_or_b32 [[ADDLSH]],
// ROUND: [[OR3:%.*]] = waveamdmachine.v_or3_b32 [[ANDOR]],
// ROUND: waveamdmachine.v_xad_u32 [[OR3]],
// ASM-LABEL: fused_int_ops:
// ASM: v_add3_u32 v3, v0, v1, v2
// ASM: v_mad_i32_i24 v4, v3, v1, v0
// ASM: v_mad_u32_u24 v5, v4, 1, v2
// ASM: v_lshl_add_u32 v6, v5, 1, v0
// ASM: v_add_lshl_u32 v7, v6, v1, 1
// ASM: v_and_or_b32 v8, v7, v1, v2
// ASM: v_or3_b32 v9, v8, v0, v2
// ASM: v_xad_u32 v10, v9, v1, v0
// ASM: v_readfirstlane_b32 s0, v10
func.func @fused_int_ops(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                         %b: !waveamdmachine.reg<vgpr, 1, 1>,
                         %c: !waveamdmachine.reg<vgpr, 1, 2>)
    -> !waveamdmachine.reg<sgpr, 1, 0> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %add3 = waveamdmachine.v_add3_u32 %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %madi24 = waveamdmachine.v_mad_i32_i24 %add3, %b, %a
      : (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 4>
  %madu24 = waveamdmachine.v_mad_u32_u24 %madi24, %one, %c
      : (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 5>
  %lshadd = waveamdmachine.v_lshl_add_u32 %madu24, %one, %a
      : (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 6>
  %addlsh = waveamdmachine.v_add_lshl_u32 %lshadd, %b, %one
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  %andor = waveamdmachine.v_and_or_b32 %addlsh, %b, %c
      : (!waveamdmachine.reg<vgpr, 1, 7>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 8>
  %or3 = waveamdmachine.v_or3_b32 %andor, %a, %c
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 9>
  %xad = waveamdmachine.v_xad_u32 %or3, %b, %a
      : (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 10>
  %first = waveamdmachine.v_readfirstlane_b32 %xad
      : (!waveamdmachine.reg<vgpr, 1, 10>) -> !waveamdmachine.reg<sgpr, 1, 0>
  waveamdmachine.s_endpgm
  return %first : !waveamdmachine.reg<sgpr, 1, 0>
}

// ROUND-LABEL: func.func @s_add_m0_i32
// ROUND: waveamdmachine.s_add_m0_i32
// ASM-LABEL: s_add_m0_i32:
// ASM: s_add_i32 m0, s0, 0x10000
func.func @s_add_m0_i32(%base: !waveamdmachine.reg<sgpr, 1, 0>) {
  %literal = waveamdmachine.imm 65536 : !waveamdmachine.imm
  %m0, %scc = waveamdmachine.s_add_m0_i32 %base, %literal
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: fused_int_wide_sources:
// ASM-NOT: v[0:1]
// ASM: v_mul_lo_u32 v3, v0, 7
// ASM-NOT: v[0:1]
// ASM: v_lshlrev_b32_e32 v4, 1, v0
// ASM-NOT: v[0:1]
// ASM: v_lshl_add_u32 v5, v0, 1, v2
func.func @fused_int_wide_sources(%wide: !waveamdmachine.reg<vgpr, 2, 0>,
                                  %b: !waveamdmachine.reg<vgpr, 1, 2>)
    -> !waveamdmachine.reg<sgpr, 1, 0> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %mul = waveamdmachine.v_mul_lo_u32 %wide, %seven
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %shift = waveamdmachine.v_lshlrev_b32 %wide, %one
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %lshadd = waveamdmachine.v_lshl_add_u32 %wide, %one, %b
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %sum0 = waveamdmachine.v_add_u32 %mul, %shift
      : (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %lshadd
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 5>)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  %first = waveamdmachine.v_readfirstlane_b32 %sum1
      : (!waveamdmachine.reg<vgpr, 1, 7>) -> !waveamdmachine.reg<sgpr, 1, 0>
  waveamdmachine.s_endpgm
  return %first : !waveamdmachine.reg<sgpr, 1, 0>
}

}
