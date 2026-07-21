// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-machine-schedule{apply-schedule=true require-selected-input=true})' | FileCheck %s --implicit-check-not=waveamdmachine.multi_wave_schedule

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

}
