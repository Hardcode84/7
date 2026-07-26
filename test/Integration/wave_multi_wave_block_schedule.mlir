// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' | FileCheck %s --implicit-check-not=waveamdmachine.multi_wave_schedule
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @block_schedule(
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.sched_barrier
// CHECK-NEXT: waveamdmachine.exec_if
// CHECK: waveamdmachine.v_xor_b32
// CHECK: } otherwise {
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.sched_barrier
// CHECK-NEXT: waveamdmachine.exec_if
// CHECK: waveamdmachine.v_xor_b32
// CHECK: } otherwise {
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.v_add_u32
func.func @block_schedule(
    %exec: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  waveamdmachine.uniform_loop {
    %pre = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.sched_barrier
    waveamdmachine.exec_if %exec {
      %then = waveamdmachine.v_xor_b32 %pre, %b
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield
    } otherwise {
      %else = waveamdmachine.v_add_u32 %pre, %a
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 1>
    %post = waveamdmachine.v_add_u32 %pre, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// CHECK-LABEL: func.func @two_slot_replay_cohorts(
// CHECK: waveamdmachine.imm 8
// CHECK: waveamdmachine.v_workitem_id_x
// CHECK: waveamdmachine.v_readfirstlane_b32
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
// CHECK-NEXT: waveamdmachine.s_add_i32
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.v_xor_b32
// CHECK-NEXT: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.dma_issue_delay
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK: } otherwise {
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// CHECK-NEXT: waveamdmachine.s_mov_m0
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
// CHECK-NEXT: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.s_add_i32
// CHECK-NEXT: waveamdmachine.v_xor_b32
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK-NEXT: waveamdmachine.dma_issue_delay
// DIAG: waveamd-machine-schedule region func=two_slot_replay_cohorts
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_refinements=3
// DIAG-NEXT: waveamd-machine-schedule region func=two_slot_replay_cohorts
// DIAG-SAME: action=apply reason=latency_priority
// DIAG-SAME: steady_state_refinements=3
func.func @two_slot_replay_cohorts(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 1>,
    %root: !waveamdmachine.mem.token,
    %ma: !waveamdmachine.reg<vgpr, 4>,
    %mb: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %sx: !waveamdmachine.reg<sgpr, 1>,
    %sy: !waveamdmachine.reg<sgpr, 1>)
    attributes {gpu.known_block_size = array<i32: 512, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 512, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 2 : i64} {
  waveamdmachine.uniform_loop {
    %v0 = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %loaded, %load = waveamdmachine.ds_load_b32 %addr after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %sum, %sum_scc = waveamdmachine.s_add_i32 %sx, %sy
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<scc, 1>)
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %ma, %mb, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %v1 = waveamdmachine.v_add_u32 %v0, %a
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %v2 = waveamdmachine.v_xor_b32 %v1, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %delayed = waveamdmachine.dma_issue_delay %dma, %m0
        {cycles = 46 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    %loaded_use = waveamdmachine.v_add_u32 %loaded, %a
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// CHECK-LABEL: func.func @multi_workgroup_block_schedule(
// CHECK: waveamdmachine.s_getreg_hw_id offset 0 width 1
// CHECK: waveamdmachine.uniform_if
// CHECK-COUNT-2: waveamdmachine.uniform_loop
func.func @multi_workgroup_block_schedule(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    attributes {gpu.known_block_size = array<i32: 512, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 512, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 4 : i64} {
  waveamdmachine.uniform_loop {
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.v_cmpx_eq_u32 %sum, %sum
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

}
