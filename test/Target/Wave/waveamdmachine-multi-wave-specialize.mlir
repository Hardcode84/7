// RUN: wave-opt %s --waveamd-machine-multi-wave-specialize | FileCheck %s --check-prefix=ENABLED
// RUN: wave-opt %s --waveamd-machine-multi-wave-specialize | FileCheck %s --check-prefix=DISABLED
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' | FileCheck %s --check-prefix=SCHEDULED
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ENABLED-LABEL: func.func @specialize(
// ENABLED: [[HW_ID:%.*]] = waveamdmachine.s_getreg_hw_id offset 4 width 1
// ENABLED: [[ZERO:%.*]] = waveamdmachine.imm 0
// ENABLED: [[CLASS:%.*]] = waveamdmachine.s_cmp_eq_u32 [[HW_ID]], [[ZERO]]
// ENABLED: waveamdmachine.uniform_if [[CLASS]]
// ENABLED-COUNT-2: waveamdmachine.uniform_loop
// ENABLED: } {waveamdmachine.multi_wave_schedule}

// SCHEDULED-LABEL: func.func @specialize(
// SCHEDULED-NOT: waveamdmachine.schedule_input
// SCHEDULED: waveamdmachine.s_getreg_hw_id offset 4 width 1
// SCHEDULED: waveamdmachine.uniform_if
// SCHEDULED-COUNT-2: waveamdmachine.uniform_loop
// SCHEDULED-NOT: waveamdmachine.multi_wave_schedule
func.func @specialize(%cond: !waveamdmachine.reg<scc, 1>,
                      %init: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1>
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 8 : !waveamdmachine.imm
  %result = waveamdmachine.uniform_loop
      carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%value: !waveamdmachine.reg<sgpr, 1>):
    %next, %unused = waveamdmachine.s_add_i32 %value, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %again = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %again : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return %result : !waveamdmachine.reg<sgpr, 1>
}

// SCHEDULED-LABEL: func.func @barrier_first(
// SCHEDULED: waveamdmachine.uniform_if
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.s_barrier
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.s_barrier
// SCHEDULED-NOT: waveamdmachine.multi_wave_schedule
func.func @barrier_first(%root: !waveamdmachine.mem.token,
                         %cond: !waveamdmachine.reg<scc, 1>)
    -> !waveamdmachine.mem.token
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %result = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%root : !waveamdmachine.mem.token) {
  ^bb0(%token: !waveamdmachine.mem.token):
    %ready = waveamdmachine.s_barrier %token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%ready : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return %result : !waveamdmachine.mem.token
}

// SCHEDULED-LABEL: func.func @shared_dma_saturation(
// SCHEDULED: waveamdmachine.uniform_if
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.s_barrier
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.buffer_load_lds_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.ds_load_b128
// SCHEDULED-NEXT: {{.*}} = waveamdmachine.mfma_f32_16x16x32_f16
// SCHEDULED-NOT: waveamdmachine.multi_wave_schedule
func.func @shared_dma_saturation(
    %iter: !waveamdmachine.reg<sgpr, 1>,
    %step: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %root: !waveamdmachine.mem.token,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %cond: !waveamdmachine.reg<scc, 1>)
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  %result = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%iter : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next, %unused = waveamdmachine.s_add_i32 %iv, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma0 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %load0, %loadtok0 = waveamdmachine.ds_load_b128 %off after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %load0, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %ready1 = waveamdmachine.s_barrier %dma0, %loadtok0
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %dma1 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %ready1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %load1, %loadtok1 = waveamdmachine.ds_load_b128 %off after %ready1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %load1, %b, %mfma0
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %ready2 = waveamdmachine.s_barrier %dma1, %loadtok1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %dma2 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %ready2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %load2, %loadtok2 = waveamdmachine.ds_load_b128 %off after %ready2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %mfma2 = waveamdmachine.mfma_f32_16x16x32_f16 %load2, %b, %mfma1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// SCHEDULED-LABEL: func.func @sched_barrier_blocks(
// SCHEDULED: waveamdmachine.uniform_if
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED-NEXT: waveamdmachine.sched_barrier
// SCHEDULED-NEXT: waveamdmachine.v_xor_b32
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED-NEXT: waveamdmachine.sched_barrier
// SCHEDULED-NEXT: waveamdmachine.v_xor_b32
// SCHEDULED-NOT: waveamdmachine.multi_wave_schedule
func.func @sched_barrier_blocks(
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
    %before = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.sched_barrier
    %after = waveamdmachine.v_xor_b32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// SCHEDULED-LABEL: func.func @nested_regions(
// SCHEDULED: waveamdmachine.uniform_if
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED-NEXT: waveamdmachine.exec_if
// SCHEDULED: waveamdmachine.v_xor_b32
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.uniform_loop
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED-NEXT: waveamdmachine.exec_if
// SCHEDULED: waveamdmachine.v_xor_b32
// SCHEDULED: } otherwise {
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED: waveamdmachine.v_add_u32
// SCHEDULED-NOT: waveamdmachine.multi_wave_schedule
func.func @nested_regions(
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

// DIAG: waveamd-machine-schedule region func=pressure_fallback
// DIAG-SAME: action=keep reason=pressure
// DIAG-NEXT: waveamd-machine-schedule region func=pressure_fallback
// DIAG-SAME: action=apply reason=loop_wait
func.func @pressure_fallback(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %d0: !waveamdmachine.reg<sgpr, 1>,
    %d1: !waveamdmachine.reg<sgpr, 1>,
    %d2: !waveamdmachine.reg<sgpr, 1>,
    %d3: !waveamdmachine.reg<sgpr, 1>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token)
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.enable_multi_wave_specialization,
                waveamdmachine.schedule_input,
                waveamdmachine.sgpr_count_max = 1 : i64,
                waveamdmachine.target_waves = 1 : i64} {
  %init = waveamdmachine.ds_store_b32 %addr, %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %x : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iv: !waveamdmachine.reg<sgpr, 1>):
    %desc = waveamdmachine.tuple_from_elements %d0, %d1, %d2, %d3
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 4>
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %sum, %scc = waveamdmachine.s_add_i32 %iv, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %sum : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1>
  return
}

// DISABLED-LABEL: func.func @unmarked(
// DISABLED-NOT: waveamdmachine.s_getreg_hw_id
// DISABLED-NOT: waveamdmachine.uniform_if
// DISABLED-COUNT-1: waveamdmachine.uniform_loop
func.func @unmarked(%cond: !waveamdmachine.reg<scc, 1>)
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.kernel,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.schedule_input,
                waveamdmachine.target_waves = 1 : i64} {
  waveamdmachine.uniform_loop {
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

}
