// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' | FileCheck %s
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @cohort_mfma_coissue_resource_fill(
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK: } otherwise {
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.v_pk_add_f32
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=cohort_mfma_coissue_resource_fill
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=3
// DIAG-NEXT: waveamd-machine-schedule region func=cohort_mfma_coissue_resource_fill
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=3
func.func @cohort_mfma_coissue_resource_fill(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>,
    %x0: !waveamdmachine.reg<vgpr, 2>,
    %y0: !waveamdmachine.reg<vgpr, 2>,
    %x1: !waveamdmachine.reg<vgpr, 2>,
    %y1: !waveamdmachine.reg<vgpr, 2>,
    %x2: !waveamdmachine.reg<vgpr, 2>,
    %y2: !waveamdmachine.reg<vgpr, 2>)
    attributes {gpu.known_block_size = array<i32: 512, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 512, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 2 : i64} {
  waveamdmachine.uniform_loop {
    %m0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %m1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %p0 = waveamdmachine.v_pk_add_f32 %x0, %y0
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %p1 = waveamdmachine.v_pk_add_f32 %x1, %y1
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %p2 = waveamdmachine.v_pk_add_f32 %x2, %y2
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

}
