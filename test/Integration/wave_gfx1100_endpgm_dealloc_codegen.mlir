// RUN: wave-opt %s --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-insert-ticket-waits \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: sed 's/gfx1100/gfx950/g' %s \
// RUN:   | wave-opt --waveamd-insert-ticket-waits \
// RUN:     --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=GFX950
// RUN: sed 's/gfx1100/gfx950/g' %s \
// RUN:   | wave-opt --waveamd-insert-ticket-waits \
// RUN:     --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: endpgm_dealloc_codegen:
// ASM: global_store_b32 v0, v97, s[0:1]
// ASM-NOT: s_waitcnt
// ASM-NEXT: s_nop 0
// ASM-NEXT: s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
// ASM-NEXT: s_endpgm
// GFX950-LABEL: endpgm_dealloc_codegen:
// GFX950: global_store_dword v0, v97, s[0:1]
// GFX950-NOT: s_waitcnt
// GFX950-NOT: s_sendmsg
// GFX950-NEXT: s_endpgm
func.func @endpgm_dealloc_codegen() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 97>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 97>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
