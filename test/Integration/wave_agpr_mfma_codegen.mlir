// RUN: wave-opt --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: agpr_mfma_codegen:
// ASM: v_accvgpr_write_b32
// ASM: v_mfma_f32_16x16x32_f16 {{a\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}
// ASM: v_accvgpr_read_b32
// ASM: global_store_dword
// ASM: .amdhsa_next_free_vgpr 28
// ASM: .set .Lagpr_mfma_codegen.num_agpr, 12
func.func @agpr_mfma_codegen() attributes {wave.kernel} {
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

// ASM-LABEL: mfma_f16_32x32x16_agpr_codegen:
// ASM: v_accvgpr_write_b32
// ASM: v_mfma_f32_32x32x16_f16 {{a\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{a\[[0-9]+:[0-9]+\]}}
// ASM: v_accvgpr_read_b32
func.func @mfma_f16_32x32x16_agpr_codegen() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 16>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 16>) -> !waveamdmachine.reg<agpr, 16>
  %result = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<agpr, 16>) -> !waveamdmachine.reg<agpr, 16>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %result
      : (!waveamdmachine.reg<agpr, 16>) -> !waveamdmachine.reg<vgpr, 16>
  %token = waveamdmachine.global_store_tuple_b32 %off, %read, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 16>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: mfma_bf16_32x32x16_vgpr_codegen:
// ASM: v_mfma_f32_32x32x16_bf16 {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}
func.func @mfma_bf16_32x32x16_vgpr_codegen() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 16>
  %result = waveamdmachine.mfma_f32_32x32x16_bf16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 16>) -> !waveamdmachine.reg<vgpr, 16>
  %token = waveamdmachine.global_store_tuple_b32 %off, %result, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 16>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: shared_mfma_acc_codegen:
// ASM-COUNT-2: v_mfma_f32_16x16x32_f16
// ASM: global_store_dword
func.func @shared_mfma_acc_codegen() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %a0_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b0_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a1_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b1_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc_v = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a0 = waveamdmachine.v_accvgpr_write_b32_tuple %a0_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %b0 = waveamdmachine.v_accvgpr_write_b32_tuple %b0_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %a1 = waveamdmachine.v_accvgpr_write_b32_tuple %a1_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %b1 = waveamdmachine.v_accvgpr_write_b32_tuple %b1_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %acc_v
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %read0 = waveamdmachine.v_accvgpr_read_b32_tuple %mfma0
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %read1 = waveamdmachine.v_accvgpr_read_b32_tuple %mfma1
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %elem0:4 = waveamdmachine.tuple_to_elements %read0
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %elem1:4 = waveamdmachine.tuple_to_elements %read1
      : (!waveamdmachine.reg<vgpr, 4>) -> (!waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
          !waveamdmachine.reg<vgpr, 1>)
  %token0 = waveamdmachine.global_store_b32 %off, %elem0#0, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %token1 = waveamdmachine.global_store_b32 %off, %elem1#0, %base after %token0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
