// RUN: wave-opt --waveamd-cross-lane-peepholes %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-cross-lane-peepholes %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: permute_xor_to_swizzle_codegen:
// ASM-NOT: ds_permute_b32
// ASM: ds_swizzle_b32
// ASM: s_endpgm
func.func @permute_xor_to_swizzle_codegen() attributes {wave.kernel} {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.imm 16 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_xor_b32 %lane, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
