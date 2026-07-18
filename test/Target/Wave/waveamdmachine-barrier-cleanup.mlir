// RUN: wave-opt %s --split-input-file --waveamd-barrier-cleanup | FileCheck %s

// CHECK-LABEL: func.func @collapse_noinst_tokens(
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.mem.token, %[[B:.*]]: !waveamdmachine.mem.token
// CHECK: %[[BARRIER:.*]] = waveamdmachine.s_barrier %[[A]], %[[B]]
// CHECK-SAME: (!waveamdmachine.mem.token, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// CHECK: waveamdmachine.token_join %[[BARRIER]], %[[B]]
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK-NOT: waveamdmachine.s_barrier
// CHECK: return
func.func @collapse_noinst_tokens(%a: !waveamdmachine.mem.token,
                                  %b: !waveamdmachine.mem.token) {
  %first = waveamdmachine.s_barrier %a
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %first, %b
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %after = waveamdmachine.after %joined
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.s_barrier %after
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %second
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @collapse_void_first(
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.mem.token
// CHECK: %[[BARRIER:.*]] = waveamdmachine.s_barrier %[[A]]
// CHECK-SAME: (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK-NOT: waveamdmachine.s_barrier
// CHECK: return
func.func @collapse_void_first(%a: !waveamdmachine.mem.token) {
  waveamdmachine.s_barrier : () -> ()
  %second = waveamdmachine.s_barrier %a
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %second
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_completion_cut(
// CHECK: [[FIRST:%.*]] = waveamdmachine.s_barrier
// CHECK: [[ISSUED:%.*]] = waveamdmachine.issue_token [[FIRST]]
// CHECK: waveamdmachine.s_barrier [[ISSUED]]
func.func @keep_completion_cut(%a: !waveamdmachine.mem.token) {
  %first = waveamdmachine.s_barrier %a
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %issued = waveamdmachine.issue_token %first
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.s_barrier %issued
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @merge_split_pair(
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.mem.token
// CHECK-NOT: waveamdmachine.barrier_init
// CHECK: %[[BARRIER:.*]] = waveamdmachine.s_barrier %[[A]]
// CHECK-SAME: (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK-NOT: waveamdmachine.barrier_arrive
// CHECK-NOT: waveamdmachine.barrier_wait
// CHECK: return
func.func @merge_split_pair(%a: !waveamdmachine.mem.token) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @merge_split_pair_noinst_tokens(
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.mem.token, %[[B:.*]]: !waveamdmachine.mem.token
// CHECK-NOT: waveamdmachine.barrier_init
// CHECK: %[[BARRIER:.*]] = waveamdmachine.s_barrier %[[A]], %[[B]]
// CHECK-SAME: (!waveamdmachine.mem.token, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK: waveamdmachine.token_join
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK-NOT: waveamdmachine.barrier_arrive
// CHECK-NOT: waveamdmachine.barrier_wait
// CHECK: return
func.func @merge_split_pair_noinst_tokens(%a: !waveamdmachine.mem.token,
                                          %b: !waveamdmachine.mem.token) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %after = waveamdmachine.after %arrived
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %after, %b
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %ready = waveamdmachine.barrier_wait %state, %ticket after %joined
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @merge_split_then_collapse_previous(
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.mem.token
// CHECK-NOT: waveamdmachine.barrier_init
// CHECK: %[[BARRIER:.*]] = waveamdmachine.s_barrier %[[A]]
// CHECK-SAME: (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// CHECK: waveamdmachine.after %[[BARRIER]]
// CHECK-NOT: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_arrive
// CHECK-NOT: waveamdmachine.barrier_wait
// CHECK: return
func.func @merge_split_then_collapse_previous(%a: !waveamdmachine.mem.token) {
  %first = waveamdmachine.s_barrier %a
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %first
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %ready
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_split_pair_mismatched_init
// CHECK: [[LEFT:%.*]] = waveamdmachine.barrier_init
// CHECK: [[RIGHT:%.*]] = waveamdmachine.barrier_init
// CHECK: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[LEFT]]
// CHECK: waveamdmachine.barrier_wait [[RIGHT]], [[TICKET]] after [[ARRIVED]]
func.func @keep_split_pair_mismatched_init(%a: !waveamdmachine.mem.token) {
  %left = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %right = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %left after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %right, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_split_pair_mismatched_ticket
// CHECK: [[STATE:%.*]] = waveamdmachine.barrier_init
// CHECK: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]]
// CHECK: waveamdmachine.barrier_wait [[STATE]], %{{.*}} after [[ARRIVED]]
func.func @keep_split_pair_mismatched_ticket(
    %a: !waveamdmachine.mem.token,
    %other_ticket: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %other_ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_split_pair_mismatched_arrival
// CHECK: [[STATE:%.*]] = waveamdmachine.barrier_init
// CHECK: [[TICKET:%.*]], %{{.*}} = waveamdmachine.barrier_arrive [[STATE]]
// CHECK: waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after %{{.*}}
func.func @keep_split_pair_mismatched_arrival(%a: !waveamdmachine.mem.token) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %a
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_split_pair_with_real_inst
// CHECK: waveamdmachine.barrier_arrive
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.barrier_wait
func.func @keep_split_pair_with_real_inst(%a: !waveamdmachine.mem.token,
                                          %x: !waveamdmachine.reg<vgpr, 1>,
                                          %y: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %a
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_real_inst
// CHECK: waveamdmachine.s_barrier
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_barrier
func.func @keep_real_inst(%a: !waveamdmachine.mem.token,
                          %x: !waveamdmachine.reg<vgpr, 1>,
                          %y: !waveamdmachine.reg<vgpr, 1>) {
  %first = waveamdmachine.s_barrier %a
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %sum = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %second = waveamdmachine.s_barrier %first
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}
