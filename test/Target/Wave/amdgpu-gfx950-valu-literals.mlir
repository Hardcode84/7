// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"

// CHECK-LABEL: literal_valu_operands:
// CHECK: v_add_u32_e32 v1, 0x100, v0
// CHECK: v_mov_b32_e32 v2, 0x100
// CHECK: v_mul_hi_u32 v2, v2, v1
func.func @literal_valu_operands(%a: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 2> {
  %imm = waveamdmachine.imm 256 : !waveamdmachine.imm
  %sum = waveamdmachine.v_add_u32 %a, %imm
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  %hi = waveamdmachine.v_mul_hi_u32 %sum, %imm
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 2>
  return %hi : !waveamdmachine.reg<vgpr, 1, 2>
}

}
