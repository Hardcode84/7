// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | wave-opt --waveamd-insert-ticket-waits -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @matching_wait_completes_election(
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK-NEXT: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK-NEXT: [[SMEM:%.*]] = waveamdmachine.s_load_b32 [[ZERO]]
// CHECK-NEXT: [[SEED:%.*]] = waveamdmachine.s_cmp_eq_u32_barrier_seed
// CHECK-NEXT: [[FIRST:%.*]], [[ARRIVED:%.*]] = waveamdmachine.s_barrier_signal_isfirst [[SEED]]
// CHECK-NEXT: [[READY:%.*]] = waveamdmachine.s_barrier_wait [[ARRIVED]]
// CHECK-NEXT: waveamdmachine.uniform_if [[FIRST]]
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_add_i32 [[SMEM]], [[ONE]]
func.func @matching_wait_completes_election() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 4>
  %seed = waveamdmachine.s_cmp_eq_u32_barrier_seed
      : !waveamdmachine.reg<scc, 1>
  %first, %arrived = waveamdmachine.s_barrier_signal_isfirst %seed
      : (!waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.s_barrier_wait %arrived
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.uniform_if %first {
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  %sum, %unused = waveamdmachine.s_add_i32 %smem, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @partial_km_wait_keeps_election_ticket(
// CHECK: [[FIRST:%.*]], {{%.*}} = waveamdmachine.s_barrier_signal_isfirst
// CHECK-NEXT: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(1)
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.uniform_if [[FIRST]]
func.func @partial_km_wait_keeps_election_ticket() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %seed = waveamdmachine.s_cmp_eq_u32_barrier_seed
      : !waveamdmachine.reg<scc, 1>
  %first, %arrived = waveamdmachine.s_barrier_signal_isfirst %seed
      : (!waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 4>
  waveamdmachine.s_waitcnt_split kmcnt(1)
  waveamdmachine.uniform_if %first {
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @smem_forces_full_election_wait(
// CHECK: [[FIRST:%.*]], {{%.*}} = waveamdmachine.s_barrier_signal_isfirst
// CHECK-NEXT: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.uniform_if [[FIRST]]
func.func @smem_forces_full_election_wait() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %seed = waveamdmachine.s_cmp_eq_u32_barrier_seed
      : !waveamdmachine.reg<scc, 1>
  %first, %arrived = waveamdmachine.s_barrier_signal_isfirst %seed
      : (!waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 4>
  waveamdmachine.uniform_if %first {
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @mismatched_wait_keeps_election_ticket(
// CHECK: [[FIRST:%.*]], [[ARRIVED:%.*]] = waveamdmachine.s_barrier_signal_isfirst
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier_wait [[ARRIVED]] scope cluster
func.func @mismatched_wait_keeps_election_ticket() {
  %seed = waveamdmachine.s_cmp_eq_u32_barrier_seed
      : !waveamdmachine.reg<scc, 1>
  %first, %arrived = waveamdmachine.s_barrier_signal_isfirst %seed
      : (!waveamdmachine.reg<scc, 1>)
        -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.s_barrier_wait %arrived scope cluster
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}
