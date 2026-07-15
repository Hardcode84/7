// RUN: wave-opt %s --waveamd-machine-cleanup \
// RUN:   --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-cleanup \
// RUN:   --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: m0_increment_chain_codegen:
// ASM: s_mov_b32 m0, s8
// ASM-NEXT: s_nop 0
// ASM-NEXT: buffer_load_dwordx4 v0, s[4:7], 0 offen lds
// ASM-NEXT: s_add_i32 m0, m0, 0x2000
// ASM-NEXT: s_nop 0
// ASM-NEXT: buffer_load_dwordx4 v1, s[4:7], 0 offen lds
// ASM-NEXT: s_endpgm
func.func @m0_increment_chain_codegen() attributes {wave.kernel} {
  %off0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %off1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %step = waveamdmachine.imm 8192 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> !waveamdmachine.m0
  %first = waveamdmachine.buffer_load_lds_b128
      %off0, %desc, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %next, %scc = waveamdmachine.s_add_m0_i32 %base, %step
      : (!waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.imm)
        -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
  %second = waveamdmachine.buffer_load_lds_b128
      %off1, %desc, %zero, %next after %first
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
