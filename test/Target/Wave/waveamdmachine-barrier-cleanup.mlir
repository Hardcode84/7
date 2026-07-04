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
