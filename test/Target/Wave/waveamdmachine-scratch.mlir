// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: scratch_ops:
// ASM: scratch_store_b32 off, v1, s6 offset:4
// ASM: scratch_load_b32 v2, off, s6 offset:4
// ASM: scratch_store_b32 off, v2, s6 offset:8
func.func @scratch_ops() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 8 : i64,
    waveamdmachine.sgpr_count = 7 : i64,
    waveamdmachine.uses_flat_scratch = true
  } {
  %off = waveamdmachine.imm 0 : !waveamdmachine.imm
  %saddr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 6>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %store = waveamdmachine.scratch_store_b32 %off, %value, %saddr offset 4
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 1, 6>) -> !waveamdmachine.mem.token
  %load, %token = waveamdmachine.scratch_load_b32 %off, %saddr after %store
      offset 4
      : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1, 6>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.mem.token)
  %store2 = waveamdmachine.scratch_store_b32 %off, %load, %saddr after %token
      offset 8
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 1, 6>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
