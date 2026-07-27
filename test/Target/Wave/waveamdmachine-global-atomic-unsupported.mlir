// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_global_atomic() {
  %offset = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  // CHECK: error: agent-scoped acquire-release global atomic requires gfx940+
  %old, %token = waveamdmachine.global_atomic_add_acq_rel_u32
      %offset, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}
}
