// RUN: wave-opt --waveamd-insert-ticket-waits %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits %s \
// RUN:   | wave-opt --waveamd-insert-ticket-waits \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @partial_tensor_completion
// CHECK: [[FIRST:%.*]] = waveamdmachine.tdm_load
// CHECK-NEXT: waveamdmachine.tdm_load
// CHECK-NEXT: waveamdmachine.s_waitcnt_split tensorcnt(1)
// CHECK-NEXT: waveamdmachine.s_barrier [[FIRST]]
func.func @partial_tensor_completion(
    %d0: !waveamdmachine.reg<sgpr, 4>,
    %d1: !waveamdmachine.reg<sgpr, 8>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %first
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @completion_neutral_prefetch
// CHECK: [[PREFETCH:%.*]] = waveamdmachine.tdm_prefetch
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.s_barrier [[PREFETCH]]
func.func @completion_neutral_prefetch(
    %base: !waveamdmachine.reg<sgpr, 2>,
    %offset: !waveamdmachine.reg<vgpr, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %prefetch = waveamdmachine.tdm_prefetch %base, %offset after %root
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %prefetch
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @prefetch_forwards_completion
// CHECK: [[LOAD:%.*]] = waveamdmachine.tdm_load
// CHECK-NEXT: [[PREFETCH:%.*]] = waveamdmachine.tdm_prefetch
// CHECK-NEXT: waveamdmachine.s_waitcnt_split tensorcnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier [[PREFETCH]]
func.func @prefetch_forwards_completion(
    %d0: !waveamdmachine.reg<sgpr, 4>,
    %d1: !waveamdmachine.reg<sgpr, 8>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %offset: !waveamdmachine.reg<vgpr, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %load = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %prefetch = waveamdmachine.tdm_prefetch %base, %offset after %load
      : (!waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %prefetch
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @tensor_cfg_join
// CHECK: [[FIRST:%.*]] = waveamdmachine.tdm_store
// CHECK: scf.if
// CHECK: waveamdmachine.tdm_store
// CHECK: waveamdmachine.tdm_store
// CHECK: waveamdmachine.s_waitcnt_split tensorcnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier
func.func @tensor_cfg_join(
    %condition: i1,
    %d0: !waveamdmachine.reg<sgpr, 4>,
    %d1: !waveamdmachine.reg<sgpr, 8>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %first = waveamdmachine.tdm_store %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %selected = scf.if %condition -> (!waveamdmachine.mem.token) {
    %then = waveamdmachine.tdm_store %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    scf.yield %then : !waveamdmachine.mem.token
  } else {
    %else = waveamdmachine.tdm_store %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    scf.yield %else : !waveamdmachine.mem.token
  }
  waveamdmachine.s_barrier %selected
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @tensor_loop_backedge
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[TOKEN:.+]]: !waveamdmachine.mem.token):
// CHECK-NEXT: waveamdmachine.s_waitcnt_split tensorcnt(0)
// CHECK-NEXT: [[READY:%.*]] = waveamdmachine.s_barrier %[[TOKEN]]
// CHECK: [[NEXT:%.*]] = waveamdmachine.tdm_load
// CHECK: waveamdmachine.continue_if
// CHECK-SAME: carries([[NEXT]]
func.func @tensor_loop_backedge(
    %condition: !waveamdmachine.reg<scc, 1>,
    %d0: !waveamdmachine.reg<sgpr, 4>,
    %d1: !waveamdmachine.reg<sgpr, 8>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %initial = waveamdmachine.tdm_load %d0, %d1 after %root
      : (!waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 8>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %result = waveamdmachine.uniform_loop
      if %condition : !waveamdmachine.reg<scc, 1>
      carries(%initial : !waveamdmachine.mem.token) {
  ^bb0(%token: !waveamdmachine.mem.token):
    %ready = waveamdmachine.s_barrier %token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next = waveamdmachine.tdm_load %d0, %d1 after %ready
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %condition
        : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return
}

}
