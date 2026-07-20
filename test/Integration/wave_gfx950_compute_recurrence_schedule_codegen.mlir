// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits \
// RUN:   --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:     -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: compute_recurrence_schedule_codegen:
// ASM: .Lcompute_recurrence_schedule_codegen.loop_head_0:
// ASM-NEXT: v_mfma_f32_16x16x32_f16 v[8:11], v[0:3], v[4:7], v[8:11]
// ASM-NEXT: v_xor_b32_e32 v16, v14, v15
// ASM-NEXT: s_waitcnt lgkmcnt(0)
// ASM-NEXT: ds_read_b32 v17, v12
// DIAG: waveamd-machine-schedule region func=compute_recurrence_schedule_codegen index=1
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves=1
func.func @compute_recurrence_schedule_codegen() attributes {wave.kernel} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 8>
  %init = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 12>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 14>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 15>
  %lhs = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 0>
  %rhs = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 1, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %result:2 = waveamdmachine.uniform_loop
      carries(%init, %acc : !waveamdmachine.reg<vgpr, 2, 12>,
              !waveamdmachine.reg<vgpr, 4, 8>) {
  ^bb0(%address: !waveamdmachine.reg<vgpr, 2, 12>,
       %acc_iter: !waveamdmachine.reg<vgpr, 4, 8>):
    %parts:2 = waveamdmachine.tuple_to_elements %address
        : (!waveamdmachine.reg<vgpr, 2, 12>)
          -> (!waveamdmachine.reg<vgpr, 1, 12>,
              !waveamdmachine.reg<vgpr, 1, 13>)
    %independent = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 14>,
           !waveamdmachine.reg<vgpr, 1, 15>)
          -> !waveamdmachine.reg<vgpr, 1, 16>
    %loaded, %token = waveamdmachine.ds_load_b32 %parts#0
        : (!waveamdmachine.reg<vgpr, 1, 12>)
          -> (!waveamdmachine.reg<vgpr, 1, 17>,
              !waveamdmachine.mem.token)
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc_iter
        : (!waveamdmachine.reg<vgpr, 4, 0>,
           !waveamdmachine.reg<vgpr, 4, 4>,
           !waveamdmachine.reg<vgpr, 4, 8>)
          -> !waveamdmachine.reg<vgpr, 4, 8>
    %mfma_parts:4 = waveamdmachine.tuple_to_elements %mfma
        : (!waveamdmachine.reg<vgpr, 4, 8>)
          -> (!waveamdmachine.reg<vgpr, 1, 8>,
              !waveamdmachine.reg<vgpr, 1, 9>,
              !waveamdmachine.reg<vgpr, 1, 10>,
              !waveamdmachine.reg<vgpr, 1, 11>)
    %next0 = waveamdmachine.v_add_u32 %parts#0, %mfma_parts#0
        : (!waveamdmachine.reg<vgpr, 1, 12>,
           !waveamdmachine.reg<vgpr, 1, 8>)
          -> !waveamdmachine.reg<vgpr, 1, 12>
    %next = waveamdmachine.tuple_from_elements %next0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1, 12>,
           !waveamdmachine.reg<vgpr, 1, 13>)
          -> !waveamdmachine.reg<vgpr, 2, 12>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next, %mfma : !waveamdmachine.reg<vgpr, 2, 12>,
                !waveamdmachine.reg<vgpr, 4, 8>)
  } -> !waveamdmachine.reg<vgpr, 2, 12>,
       !waveamdmachine.reg<vgpr, 4, 8>
  waveamdmachine.s_endpgm
  return
}

}
