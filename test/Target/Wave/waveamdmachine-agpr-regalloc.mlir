// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REGALLOC-LABEL: func.func @agpr_kernel
// REGALLOC-SAME: waveamdmachine.agpr_count = 1 : i64
// REGALLOC: %[[AGPR:.+]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
// REGALLOC: %[[VGPR:.+]] = waveamdmachine.v_accvgpr_read_b32_tuple %[[AGPR]]
// REGALLOC: waveamdmachine.global_store_b32 {{.*}}, %[[VGPR]],
// ASM-LABEL: agpr_kernel:
// ASM: v_accvgpr_read_b32 [[READ:v[0-9]+]], [[AGPR:a[0-9]+]]
// ASM: global_store_dword {{v[0-9]+}}, [[READ]], {{s\[[0-9]+:[0-9]+\]}}
// ASM: .amdhsa_kernel agpr_kernel
// ASM: .amdhsa_next_free_vgpr 5
// ASM: .amdhsa_accum_offset 4
// ASM: .set .Lagpr_kernel.num_vgpr, 2
// ASM: .set .Lagpr_kernel.num_agpr, 1
// ASM: .vgpr_count:     5
// ASM: .agpr_count:     1
func.func @agpr_kernel() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %agpr = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
  %value = waveamdmachine.v_accvgpr_read_b32_tuple %agpr
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
