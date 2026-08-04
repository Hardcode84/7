// RUN: wave-opt %s --waveamd-split-barriers | FileCheck %s

// CHECK-LABEL: func.func @keep_wave_conditional_barrier
// CHECK: [[STATE:%.*]] = waveamdmachine.barrier_init
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[ROOT]]
// CHECK-NEXT: [[READY:%.*]] = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.s_barrier [[READY]]
// CHECK-NOT: waveamdmachine.barrier_init
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @keep_wave_conditional_barrier(
      %cond: !waveamdmachine.reg<scc, 1>)
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : ui4,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.uniform_if %cond {
      %conditional = waveamdmachine.s_barrier %ready
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield
    } otherwise {
      waveamdmachine.yield
    } : !waveamdmachine.reg<scc, 1>
    return
  }
}
