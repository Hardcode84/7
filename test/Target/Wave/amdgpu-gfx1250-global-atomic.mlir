// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj -o %t.o %t.s 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o > %t.dis
// RUN: FileCheck %s --check-prefix=DIS < %t.dis
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.dis

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: gfx1250_global_atomic:
// ASM: s_wait_loadcnt 0x0
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: global_wb scope:SCOPE_DEV
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: s_wait_xcnt 0x0
// ASM-NEXT: s_wait_loadcnt_dscnt 0x0
// ASM-NEXT: global_atomic_add_u32 v2, v0, v1, s[0:1] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM-NEXT: global_inv scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM-NEXT: s_endpgm
// DIS-LABEL: <gfx1250_global_atomic>:
// DIS-NEXT: s_wait_loadcnt 0x0
// DIS-NEXT: s_wait_storecnt 0x0
// DIS-NEXT: global_wb scope:SCOPE_DEV
// DIS-NEXT: s_wait_storecnt 0x0
// DIS-NEXT: s_wait_xcnt 0x0
// DIS-NEXT: s_wait_loadcnt_dscnt 0x0
// DIS-NEXT: global_atomic_add_u32 v2, v0, v1, s[0:1] th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// DIS-NEXT: s_wait_loadcnt 0x0
// DIS-NEXT: global_inv scope:SCOPE_DEV
// DIS-NEXT: s_wait_loadcnt 0x0
// DIS-NEXT: s_endpgm
func.func @gfx1250_global_atomic() {
  %offset = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %value = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %old, %token = waveamdmachine.global_atomic_add_acq_rel_u32
      %offset, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> (!waveamdmachine.reg<vgpr, 1, 2>,
            !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
