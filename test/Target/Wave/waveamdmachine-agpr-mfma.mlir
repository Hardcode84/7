// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REGALLOC-LABEL: func.func @agpr_mfma_chain
// REGALLOC-SAME: waveamdmachine.agpr_count = 12 : i64
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
// ASM: .amdhsa_next_free_vgpr 28
// ASM: .amdhsa_accum_offset 16
// ASM: .set .Lagpr_mfma_chain.num_agpr, 12
// ASM: .agpr_count:     12
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

// REGALLOC-LABEL: func.func @shared_mfma_acc
// REGALLOC: %[[COPY0:[A-Za-z0-9_]+]] = waveamdmachine.v_mov_b32_tuple %[[ACC:[A-Za-z0-9_]+]]
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[COPY0]]
// REGALLOC: %[[COPY1:[A-Za-z0-9_]+]] = waveamdmachine.v_mov_b32_tuple %[[ACC]]
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[COPY1]]
func.func @shared_mfma_acc() {
  %a0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %a1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a0, %b0, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a1, %b1, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// REGALLOC-LABEL: func.func @mfma_accumulator_tuple_slot
// REGALLOC: %[[PARTS:[A-Za-z0-9_]+]]:2 = waveamdmachine.tuple_to_elements
// REGALLOC-SAME: -> (!waveamdmachine.reg<agpr, 4, {{[0-9]+}}>, !waveamdmachine.reg<agpr, 4, [[ACC_SLOT:[0-9]+]]>)
// REGALLOC: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, {{.*}}, %[[PARTS]]#1
// REGALLOC-SAME: -> !waveamdmachine.reg<agpr, 4, [[ACC_SLOT]]>
func.func @mfma_accumulator_tuple_slot() {
  %lo = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %hi = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %tuple = waveamdmachine.tuple_from_elements %lo, %hi
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
      -> !waveamdmachine.reg<agpr, 8>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<agpr, 8>)
      -> (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>)
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %parts#1
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %read_lo = waveamdmachine.v_accvgpr_read_b32_tuple %parts#0
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %read_mfma = waveamdmachine.v_accvgpr_read_b32_tuple %mfma
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
