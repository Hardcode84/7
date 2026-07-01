// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: accvgpr_write_inline_zero:
// ASM-NOT: v_mov_b32
// ASM: v_accvgpr_write_b32 a0, 0
// ASM-NEXT: v_accvgpr_write_b32 a1, 0
// ASM-NEXT: v_accvgpr_write_b32 a2, 0
// ASM-NEXT: v_accvgpr_write_b32 a3, 0
// ASM: v_accvgpr_read_b32 v8, a0
// ASM: global_store_dwordx4 v4, v[8:11], s[0:1]
// ASM: s_endpgm
func.func @accvgpr_write_inline_zero(%off: !waveamdmachine.reg<vgpr, 1, 4>,
                                     %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %dead = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4, 12>
  %agpr = waveamdmachine.v_accvgpr_write_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 4, 0>
  %value = waveamdmachine.v_accvgpr_read_b32_tuple %agpr
      : (!waveamdmachine.reg<agpr, 4, 0>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %token = waveamdmachine.global_store_b128 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 4, 8>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
