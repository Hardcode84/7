// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: ds_pair_emit:
// ASM: ds_load_2addr_b32 v[1:2], v0 offset0:1 offset1:2
// ASM: s_waitcnt lgkmcnt(0)
// ASM: ds_store_2addr_b32 v0, v3, v4 offset0:3 offset1:4
func.func @ds_pair_emit() {
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 4>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %lt = waveamdmachine.ds_load2_b32 %addr after %root offsets(1, 2)
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2, 1>, !waveamdmachine.mem.token)
  %st = waveamdmachine.ds_store2_b32 %addr, %v0, %v1 after %lt offsets(3, 4)
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

// ASM-LABEL: ds_pair_emit_st64:
// ASM: ds_load_2addr_stride64_b64 v[8:11], v0 offset1:64
// ASM: s_waitcnt lgkmcnt(0)
// ASM: ds_store_2addr_stride64_b64 v0, v[3:4], v[5:6] offset1:64
func.func @ds_pair_emit_st64() {
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 3>
  %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 5>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %lt = waveamdmachine.ds_load2_b64 %addr after %root
      offsets(0, 64) {st64 = true}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4, 8>, !waveamdmachine.mem.token)
  %st = waveamdmachine.ds_store2_b64 %addr, %v0, %v1 after %lt
      offsets(0, 64) {st64 = true}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2, 3>,
         !waveamdmachine.reg<vgpr, 2, 5>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}
