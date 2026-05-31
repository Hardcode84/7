// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUND-LABEL: func.func @fused_int_ops
// ROUND: [[ADD3:%.*]] = waveamdmachine.v_add3_u32
// ROUND: [[LSHADD:%.*]] = waveamdmachine.v_lshl_add_u32 [[ADD3]],
// ROUND: [[ADDLSH:%.*]] = waveamdmachine.v_add_lshl_u32 [[LSHADD]],
// ROUND: [[ANDOR:%.*]] = waveamdmachine.v_and_or_b32 [[ADDLSH]],
// ROUND: [[OR3:%.*]] = waveamdmachine.v_or3_b32 [[ANDOR]],
// ROUND: waveamdmachine.v_xad_u32 [[OR3]],
// ASM-LABEL: fused_int_ops:
// ASM: v_add3_u32 v3, v0, v1, v2
// ASM: v_lshl_add_u32 v4, v3, 1, v0
// ASM: v_add_lshl_u32 v5, v4, v1, 1
// ASM: v_and_or_b32 v6, v5, v1, v2
// ASM: v_or3_b32 v7, v6, v0, v2
// ASM: v_xad_u32 v8, v7, v1, v0
// ASM: v_readfirstlane_b32 s0, v8
func.func @fused_int_ops(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                         %b: !waveamdmachine.reg<vgpr, 1, 1>,
                         %c: !waveamdmachine.reg<vgpr, 1, 2>)
    -> !waveamdmachine.reg<sgpr, 1, 0> {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %add3 = waveamdmachine.v_add3_u32 %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %lshadd = waveamdmachine.v_lshl_add_u32 %add3, %one, %a
      : (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 4>
  %addlsh = waveamdmachine.v_add_lshl_u32 %lshadd, %b, %one
      : (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 5>
  %andor = waveamdmachine.v_and_or_b32 %addlsh, %b, %c
      : (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 6>
  %or3 = waveamdmachine.v_or3_b32 %andor, %a, %c
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 7>
  %xad = waveamdmachine.v_xad_u32 %or3, %b, %a
      : (!waveamdmachine.reg<vgpr, 1, 7>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 8>
  %first = waveamdmachine.v_readfirstlane_b32 %xad
      : (!waveamdmachine.reg<vgpr, 1, 8>) -> !waveamdmachine.reg<sgpr, 1, 0>
  waveamdmachine.s_endpgm
  return %first : !waveamdmachine.reg<sgpr, 1, 0>
}

}
