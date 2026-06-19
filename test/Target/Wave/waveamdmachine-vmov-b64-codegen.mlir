// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: vmov_b64_zero_codegen:
// ASM: v_mov_b64_e32 v[2:3], 0
// ASM-NOT: v_mov_b32_e32 v2, 0
// ASM: global_store_dwordx2
// ASM: s_endpgm
func.func @vmov_b64_zero_codegen(%addr: !waveamdmachine.reg<vgpr, 1, 0>,
                                 %base: !waveamdmachine.reg<sgpr, 2, 6>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b64_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 2>
  waveamdmachine.global_store_b64 %addr, %wide, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2, 2>,
         !waveamdmachine.reg<sgpr, 2, 6>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
