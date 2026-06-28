// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUNDTRIP-LABEL: func.func @ds_lane_ops
// ROUNDTRIP: %[[SWIZZLE:.*]] = waveamdmachine.ds_swizzle_b32 {{.*}} offset 31
// ROUNDTRIP: %[[PERMUTE:.*]] = waveamdmachine.ds_permute_b32 {{.*}} offset 4
// ROUNDTRIP: %[[BPERMUTE:.*]] = waveamdmachine.ds_bpermute_b32 {{.*}} offset 8
// ROUNDTRIP: waveamdmachine.ds_store_addtid_b32 {{.*}} offset 16
// ROUNDTRIP: %{{.*}}, %{{.*}} = waveamdmachine.ds_load_addtid_b32 {{.*}} offset 16

// ASM-LABEL: ds_lane_ops:
// ASM: ds_swizzle_b32 {{v[0-9]+}}, {{v[0-9]+}} offset:swizzle
// ASM: ds_permute_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}} offset:4
// ASM: ds_bpermute_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}} offset:8
// ASM: ds_write_addtid_b32 {{v[0-9]+}} offset:16
// ASM: ds_read_addtid_b32 {{v[0-9]+}} offset:16
// ASM: s_endpgm
func.func @ds_lane_ops() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %addr
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %token0 = waveamdmachine.token : !waveamdmachine.mem.token
  %swizzle = waveamdmachine.ds_swizzle_b32 %addr offset 31
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %permute = waveamdmachine.ds_permute_b32 %addr, %data offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %bpermute = waveamdmachine.ds_bpermute_b32 %addr, %data offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %token1 = waveamdmachine.ds_store_addtid_b32 %m0, %data after %token0 offset 16
      : (!waveamdmachine.m0, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loaded, %token2 = waveamdmachine.ds_load_addtid_b32 %m0 after %token1 offset 16
      : (!waveamdmachine.m0, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
