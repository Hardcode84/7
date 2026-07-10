// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: memory_prefetch_schedule_codegen:
// ASM: global_load_dword v4, v0, s[0:1]
// ASM-NEXT: v_add_u32_e32 v5
// ASM-NEXT: v_add_u32_e32 v6
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: v_add_u32_e32 v7, v6, v4
func.func @memory_prefetch_schedule_codegen() attributes {wave.kernel} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %ptr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %y = waveamdmachine.v_add_u32 %x, %c
      : (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  %loaded, %tok = waveamdmachine.global_load_b32 %off, %ptr after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %y, %loaded
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  waveamdmachine.s_endpgm
  return
}

}
