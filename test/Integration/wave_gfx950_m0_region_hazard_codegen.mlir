// RUN: wave-opt %s --waveamd-hazard-repair --waveamd-preserve-hw-regs \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-hazard-repair --waveamd-preserve-hw-regs \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: m0_region_hazard_codegen:
// ASM: s_mov_b32 m0, s8
// ASM-NEXT: s_and_saveexec_b64
// ASM-NEXT: s_cbranch_execz
// ASM-NEXT: buffer_load_dwordx4
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @m0_region_hazard_codegen() attributes {wave.kernel} {
  %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %token = waveamdmachine.exec_if %cond {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 8>) -> !waveamdmachine.m0
    %loaded = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %zero, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield %loaded : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 2, 0> -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
