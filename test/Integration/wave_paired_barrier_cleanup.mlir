// RUN: wave-opt %s --waveamd-barrier-cleanup --waveamd-barrier-cleanup --waveamd-finalize-barrier-protocols | FileCheck %s --implicit-check-not=waveamdmachine.barrier_sites --implicit-check-not=waveamdmachine.paired_barriers

// CHECK-LABEL: func.func @paired_barrier_cleanup
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.s_barrier
// CHECK: waveamdmachine.continue_if
// CHECK: } otherwise {
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.s_barrier
// CHECK: waveamdmachine.continue_if
// CHECK: return
func.func @paired_barrier_cleanup(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.mem.token,
    %b: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %a
          {waveamdmachine.barrier_sites = array<i64: 0>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %second = waveamdmachine.s_barrier %first, %b
          {waveamdmachine.barrier_sites = array<i64: 1>}
          : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %b
          {waveamdmachine.barrier_sites = array<i64: 0>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %second = waveamdmachine.s_barrier %first, %a
          {waveamdmachine.barrier_sites = array<i64: 1>}
          : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}
