// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REGALLOC-LABEL: func.func @agpr_mfma_chain
// REGALLOC-SAME: waveamdmachine.agpr_count = 16 : i64
// REGALLOC: %[[A:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[B:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[ACC:.+]] = waveamdmachine.v_accvgpr_write_b32_tuple
// REGALLOC: %[[RESULT:.+]] = waveamdmachine.mfma_f32_16x16x32_f16 %[[A]], %[[B]], %[[ACC]]
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4
// REGALLOC: waveamdmachine.v_accvgpr_read_b32_tuple %[[RESULT]]

// ASM-LABEL: agpr_mfma_chain:
// ASM: v_accvgpr_write_b32 [[A0:a[0-9]+]], {{v[0-9]+}}
// ASM: v_accvgpr_write_b32 [[B0:a[0-9]+]], {{v[0-9]+}}
// ASM: v_mfma_f32_16x16x32_f16 [[DST:a\[[0-9]+:[0-9]+\]]], [[A:a\[[0-9]+:[0-9]+\]]], [[B:a\[[0-9]+:[0-9]+\]]], [[C:a\[[0-9]+:[0-9]+\]]]
// ASM: v_accvgpr_read_b32 {{v[0-9]+}}, {{a[0-9]+}}
// ASM: .amdhsa_next_free_vgpr 32
// ASM: .amdhsa_accum_offset 16
// ASM: .set .Lagpr_mfma_chain.num_agpr, 16
// ASM: .agpr_count:     16
func.func @agpr_mfma_chain() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a = waveamdmachine.v_accvgpr_write_b32_tuple %a_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.v_accvgpr_write_b32_tuple %b_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %result = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %result
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %elem:4 = waveamdmachine.tuple_to_elements %read
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %token = waveamdmachine.global_store_b32 %off, %elem#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
