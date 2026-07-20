// RUN: wave-opt %s --split-input-file --waveamd-barrier-cleanup --verify-diagnostics
// RUN: wave-opt %s --split-input-file --waveamd-finalize-barrier-protocols --verify-diagnostics

func.func @reject_different_barrier_lineage(
    %cond: !waveamdmachine.reg<scc, 1>,
    %token: !waveamdmachine.mem.token) {
  // expected-error@+1 {{'waveamdmachine.uniform_if' op barrier protocols differ between arms}}
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ready = waveamdmachine.s_barrier %token
          {waveamdmachine.barrier_sites = array<i64: 0>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ready = waveamdmachine.s_barrier %token
          {waveamdmachine.barrier_sites = array<i64: 1>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

func.func @reject_different_split_handles(
    %cond: !waveamdmachine.reg<scc, 1>,
    %token: !waveamdmachine.mem.token) {
  %left = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %right = waveamdmachine.barrier_init : !waveamdmachine.barrier
  // expected-error@+1 {{'waveamdmachine.uniform_if' op split barrier handles differ between arms}}
  waveamdmachine.uniform_if %cond {
    %ticket, %arrived = waveamdmachine.barrier_arrive %left after %token
        {waveamdmachine.barrier_sites = array<i64: 2>}
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %ready = waveamdmachine.barrier_wait %left, %ticket after %arrived
        {waveamdmachine.barrier_sites = array<i64: 2>}
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } otherwise {
    %ticket, %arrived = waveamdmachine.barrier_arrive %right after %token
        {waveamdmachine.barrier_sites = array<i64: 2>}
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %ready = waveamdmachine.barrier_wait %right, %ticket after %arrived
        {waveamdmachine.barrier_sites = array<i64: 2>}
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

func.func @reject_unpaired_lineage(%token: !waveamdmachine.mem.token) {
  // expected-error@+1 {{barrier lineage requires a paired uniform_if}}
  %ready = waveamdmachine.s_barrier %token
      {waveamdmachine.barrier_sites = array<i64: 3>}
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

func.func @reject_overlapping_lineage(
    %cond: !waveamdmachine.reg<scc, 1>,
    %token: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_if %cond {
    %first = waveamdmachine.s_barrier %token
        {waveamdmachine.barrier_sites = array<i64: 4>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    // expected-error@+1 {{paired barrier lineage overlaps another site}}
    %second = waveamdmachine.s_barrier %first
        {waveamdmachine.barrier_sites = array<i64: 4, 5>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } otherwise {
    %first = waveamdmachine.s_barrier %token
        {waveamdmachine.barrier_sites = array<i64: 4>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %second = waveamdmachine.s_barrier %first
        {waveamdmachine.barrier_sites = array<i64: 5>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}
