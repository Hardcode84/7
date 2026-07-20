// RUN: wave-opt %s --split-input-file --waveamd-barrier-cleanup | FileCheck %s --check-prefix=PAIR
// RUN: wave-opt %s --split-input-file --waveamd-barrier-cleanup --waveamd-barrier-cleanup --waveamd-finalize-barrier-protocols | FileCheck %s --check-prefix=FINAL --implicit-check-not=waveamdmachine.barrier_sites --implicit-check-not=waveamdmachine.paired_barriers

// PAIR-LABEL: func.func @merge_full_in_both_cloned_loops
// PAIR-SAME: [[FULL_COND:%.*]]: !waveamdmachine.reg<scc, 1>, [[FULL_A:%.*]]: !waveamdmachine.mem.token, [[FULL_B:%.*]]: !waveamdmachine.mem.token
// PAIR: waveamdmachine.uniform_if
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.s_barrier [[FULL_A]], [[FULL_B]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 0, 1>
// PAIR-NOT: waveamdmachine.s_barrier
// PAIR: waveamdmachine.continue_if
// PAIR: } otherwise {
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.s_barrier [[FULL_B]], [[FULL_A]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 0, 1>
// PAIR-NOT: waveamdmachine.s_barrier
// PAIR: waveamdmachine.continue_if
// PAIR: waveamdmachine.paired_barriers
// FINAL-LABEL: func.func @merge_full_in_both_cloned_loops
// FINAL: waveamdmachine.uniform_if
// FINAL: return
func.func @merge_full_in_both_cloned_loops(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.mem.token,
    %b: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %a
          {waveamdmachine.barrier_sites = array<i64: 0>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %joined = waveamdmachine.token_join %first, %b
          : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      %second = waveamdmachine.s_barrier %joined
          {waveamdmachine.barrier_sites = array<i64: 1>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %b
          {waveamdmachine.barrier_sites = array<i64: 0>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %joined = waveamdmachine.token_join %first, %a
          : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      %second = waveamdmachine.s_barrier %joined
          {waveamdmachine.barrier_sites = array<i64: 1>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

// PAIR-LABEL: func.func @keep_full_when_one_cloned_loop_blocks
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 10>
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 11>
// PAIR: } otherwise {
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 10>
// PAIR: waveamdmachine.v_add_u32
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 11>
// PAIR: waveamdmachine.paired_barriers
// FINAL-LABEL: func.func @keep_full_when_one_cloned_loop_blocks
// FINAL: waveamdmachine.uniform_if
// FINAL: return
func.func @keep_full_when_one_cloned_loop_blocks(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.mem.token,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %a
          {waveamdmachine.barrier_sites = array<i64: 10>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %second = waveamdmachine.s_barrier %first
          {waveamdmachine.barrier_sites = array<i64: 11>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %first = waveamdmachine.s_barrier %a
          {waveamdmachine.barrier_sites = array<i64: 10>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      %sum = waveamdmachine.v_add_u32 %x, %y
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %second = waveamdmachine.s_barrier %first
          {waveamdmachine.barrier_sites = array<i64: 11>}
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

// PAIR-LABEL: func.func @merge_split_in_both_cloned_loops
// PAIR-SAME: [[SPLIT_COND:%.*]]: !waveamdmachine.reg<scc, 1>, [[SPLIT_A:%.*]]: !waveamdmachine.mem.token, [[SPLIT_B:%.*]]: !waveamdmachine.mem.token
// PAIR-NOT: waveamdmachine.barrier_init
// PAIR: waveamdmachine.uniform_loop
// PAIR-NOT: waveamdmachine.barrier_arrive
// PAIR: waveamdmachine.s_barrier [[SPLIT_A]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 20>
// PAIR-NOT: waveamdmachine.barrier_wait
// PAIR: } otherwise {
// PAIR: waveamdmachine.uniform_loop
// PAIR-NOT: waveamdmachine.barrier_arrive
// PAIR: waveamdmachine.s_barrier [[SPLIT_B]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 20>
// PAIR-NOT: waveamdmachine.barrier_wait
// PAIR: waveamdmachine.paired_barriers
// FINAL-LABEL: func.func @merge_split_in_both_cloned_loops
// FINAL: waveamdmachine.uniform_if
// FINAL: return
func.func @merge_split_in_both_cloned_loops(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.mem.token,
    %b: !waveamdmachine.mem.token) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
          {waveamdmachine.barrier_sites = array<i64: 20>}
          : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
          {waveamdmachine.barrier_sites = array<i64: 20>}
          : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ticket, %arrived = waveamdmachine.barrier_arrive %state after %b
          {waveamdmachine.barrier_sites = array<i64: 20>}
          : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
          {waveamdmachine.barrier_sites = array<i64: 20>}
          : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

// PAIR-LABEL: func.func @keep_split_when_one_cloned_loop_blocks
// PAIR: [[STATE:%.*]] = waveamdmachine.barrier_init
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.barrier_arrive [[STATE]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 30>
// PAIR: waveamdmachine.barrier_wait [[STATE]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 30>
// PAIR: } otherwise {
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.barrier_arrive [[STATE]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 30>
// PAIR: waveamdmachine.v_add_u32
// PAIR: waveamdmachine.barrier_wait [[STATE]]
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 30>
// PAIR: waveamdmachine.paired_barriers
// FINAL-LABEL: func.func @keep_split_when_one_cloned_loop_blocks
// FINAL: waveamdmachine.uniform_if
// FINAL: return
func.func @keep_split_when_one_cloned_loop_blocks(
    %cond: !waveamdmachine.reg<scc, 1>,
    %a: !waveamdmachine.mem.token,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
          {waveamdmachine.barrier_sites = array<i64: 30>}
          : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
          {waveamdmachine.barrier_sites = array<i64: 30>}
          : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } otherwise {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
          {waveamdmachine.barrier_sites = array<i64: 30>}
          : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
            -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
      %sum = waveamdmachine.v_add_u32 %x, %y
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
          {waveamdmachine.barrier_sites = array<i64: 30>}
          : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}

// -----

// PAIR-LABEL: func.func @ignore_barrier_free_region_difference
// PAIR: waveamdmachine.uniform_loop
// PAIR: waveamdmachine.continue_if
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 40>
// PAIR: } otherwise {
// PAIR: waveamdmachine.s_barrier
// PAIR-SAME: waveamdmachine.barrier_sites = array<i64: 40>
// FINAL-LABEL: func.func @ignore_barrier_free_region_difference
// FINAL: waveamdmachine.uniform_if
// FINAL: return
func.func @ignore_barrier_free_region_difference(
    %cond: !waveamdmachine.reg<scc, 1>,
    %token: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_if %cond {
    waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
    }
    %ready = waveamdmachine.s_barrier %token
        {waveamdmachine.barrier_sites = array<i64: 40>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } otherwise {
    %ready = waveamdmachine.s_barrier %token
        {waveamdmachine.barrier_sites = array<i64: 40>}
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  } {waveamdmachine.paired_barriers} : !waveamdmachine.reg<scc, 1>
  return
}
