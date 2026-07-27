// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-mfma-packed-peephole \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-mfma-packed-peephole \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:     -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-mfma-packed-peephole \
// RUN:   2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: mfma_packed_coissue_schedule_codegen:
// ASM: v_mfma_f32_16x16x32_f16
// ASM-NEXT: v_add_f32_e32
// ASM-NEXT: v_add_f32_e32
// ASM-NEXT: v_add_f32_e32
// ASM-NEXT: v_pk_add_f32
// DIAG: waveamd-machine-schedule region func=mfma_packed_coissue_schedule_codegen
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=3
func.func @mfma_packed_coissue_schedule_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 8>
  %packed_lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 12>
  %packed_rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 14>
  %x0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 16>
  %y0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 17>
  %x1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 18>
  %y1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 19>
  %x2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 20>
  %y2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 21>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 0>,
         !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<vgpr, 4, 8>)
        -> !waveamdmachine.reg<vgpr, 4, 8>
  %packed = waveamdmachine.v_pk_add_f32 %packed_lhs, %packed_rhs
      : (!waveamdmachine.reg<vgpr, 2, 12>,
         !waveamdmachine.reg<vgpr, 2, 14>)
        -> !waveamdmachine.reg<vgpr, 2, 12>
  %fill0 = waveamdmachine.v_add_f32 %x0, %y0
      : (!waveamdmachine.reg<vgpr, 1, 16>,
         !waveamdmachine.reg<vgpr, 1, 17>)
        -> !waveamdmachine.reg<vgpr, 1, 16>
  %fill1 = waveamdmachine.v_add_f32 %x1, %y1
      : (!waveamdmachine.reg<vgpr, 1, 18>,
         !waveamdmachine.reg<vgpr, 1, 19>)
        -> !waveamdmachine.reg<vgpr, 1, 18>
  %fill2 = waveamdmachine.v_add_f32 %x2, %y2
      : (!waveamdmachine.reg<vgpr, 1, 20>,
         !waveamdmachine.reg<vgpr, 1, 21>)
        -> !waveamdmachine.reg<vgpr, 1, 20>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: mfma_packed_peephole_codegen:
// ASM: v_mfma_f32_16x16x32_f16
// ASM-NEXT: v_add_f32_e32
// ASM-NEXT: v_add_f32_e32
// ASM-NOT: v_pk_add_f32
func.func @mfma_packed_peephole_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 24>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 28>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 32>
  %packed_lhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 36>
  %packed_rhs = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 38>
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4, 24>,
         !waveamdmachine.reg<vgpr, 4, 28>,
         !waveamdmachine.reg<vgpr, 4, 32>)
        -> !waveamdmachine.reg<vgpr, 4, 32>
  %packed = waveamdmachine.v_pk_add_f32 %packed_lhs, %packed_rhs
      : (!waveamdmachine.reg<vgpr, 2, 36>,
         !waveamdmachine.reg<vgpr, 2, 38>)
        -> !waveamdmachine.reg<vgpr, 2, 36>
  waveamdmachine.s_endpgm
  return
}

}
