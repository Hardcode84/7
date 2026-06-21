// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: repeated_literal_ternary:
// CHECK: v_add3_u32 v1, 0x100, 0x100, v0
func.func @repeated_literal_ternary(
    %lane: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  %lit = waveamdmachine.imm 256 : !waveamdmachine.imm
  %out = waveamdmachine.v_add3_u32 %lit, %lit, %lane
      : (!waveamdmachine.imm, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}
