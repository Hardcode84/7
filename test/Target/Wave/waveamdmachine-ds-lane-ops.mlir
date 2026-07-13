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

// ROUNDTRIP-LABEL: func.func @permlane32_swap_tuple
// ROUNDTRIP: waveamdmachine.v_permlane32_swap_b32_tuple
// ROUNDTRIP-SAME: !waveamdmachine.reg<vgpr, 4, 0>
// ASM-LABEL: permlane32_swap_tuple:
// ASM: v_permlane32_swap_b32_e32 v0, v2
// ASM-NEXT: v_permlane32_swap_b32_e32 v1, v3
func.func @permlane32_swap_tuple() attributes {wave.kernel} {
  %source = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
  %result = waveamdmachine.v_permlane32_swap_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 4, 0>)
      -> !waveamdmachine.reg<vgpr, 4, 0>
  %parts:4 = waveamdmachine.tuple_to_elements %result
      : (!waveamdmachine.reg<vgpr, 4, 0>)
      -> (!waveamdmachine.reg<vgpr, 1, 0>,
          !waveamdmachine.reg<vgpr, 1, 1>,
          !waveamdmachine.reg<vgpr, 1, 2>,
          !waveamdmachine.reg<vgpr, 1, 3>)
  %first = waveamdmachine.v_readfirstlane_b32 %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  waveamdmachine.s_mov_b32 "s21", %first
      : (!waveamdmachine.reg<sgpr, 1, 20>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ROUNDTRIP-LABEL: func.func @ds_agpr_load_store
// ROUNDTRIP: waveamdmachine.ds_load_b128
// ROUNDTRIP-SAME: -> (!waveamdmachine.reg<agpr, 4, 0>, !waveamdmachine.mem.token)
// ROUNDTRIP: waveamdmachine.ds_store_b128
// ROUNDTRIP-SAME: !waveamdmachine.reg<agpr, 4, 0>

// ASM-LABEL: ds_agpr_load_store:
// ASM: ds_read_b128 a[0:3], v0
// ASM: ds_write_b128 v0, a[0:3] offset:16
func.func @ds_agpr_load_store() attributes {wave.kernel} {
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok0 = waveamdmachine.ds_load_b128 %addr after %token
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<agpr, 4, 0>, !waveamdmachine.mem.token)
  %tok1 = waveamdmachine.ds_store_b128 %addr, %loaded after %tok0 offset 16
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<agpr, 4, 0>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
