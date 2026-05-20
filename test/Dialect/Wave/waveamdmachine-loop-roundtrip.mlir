// RUN: wave-opt --verify-diagnostics --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @uniform_loop_do_while
// CHECK: %[[STEP:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// CHECK: %[[UPPER:.+]] = waveamdmachine.imm 16 : !waveamdmachine.imm
// CHECK: %{{.+}} = waveamdmachine.uniform_loop carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1>) {
// CHECK: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK:   %[[SUM:.+]], %{{.+}} = waveamdmachine.s_add_i32 %[[IV]], %[[STEP]] : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
// CHECK:   %[[SCC:.+]] = waveamdmachine.s_cmp_lt_i32 %[[SUM]], %[[UPPER]] : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
// CHECK:   waveamdmachine.continue_if %[[SCC]] : !waveamdmachine.reg<scc, 1> carries(%[[SUM]] : !waveamdmachine.reg<sgpr, 1>)
// CHECK: } -> !waveamdmachine.reg<sgpr, 1>
func.func @uniform_loop_do_while(%init: !waveamdmachine.reg<sgpr, 1>) {
  %step = waveamdmachine.imm 1 : !waveamdmachine.imm
  %upper = waveamdmachine.imm 16 : !waveamdmachine.imm
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %step : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %upper : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1> carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

// CHECK-LABEL: func.func @uniform_loop_with_entry_cond
// CHECK: %[[EC:.+]] = waveamdmachine.s_cmp_lt_i32 %{{.+}}, %{{.+}} : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
// CHECK: waveamdmachine.uniform_loop if %[[EC]] : !waveamdmachine.reg<scc, 1> carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1>)
func.func @uniform_loop_with_entry_cond(%lo: !waveamdmachine.reg<sgpr, 1>, %hi: !waveamdmachine.reg<sgpr, 1>) {
  %step = waveamdmachine.imm 1 : !waveamdmachine.imm
  %ec = waveamdmachine.s_cmp_lt_i32 %lo, %hi : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %step : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %hi : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1> carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_continue_if_carry_count(%init: !waveamdmachine.reg<sgpr, 1>) {
  %step = waveamdmachine.imm 1 : !waveamdmachine.imm
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %step : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    // expected-error@+1 {{carries count must match parent uniform_loop inits}}
    waveamdmachine.continue_if %next#1 : !waveamdmachine.reg<scc, 1>
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_continue_if_carry_type(%init: !waveamdmachine.reg<sgpr, 1>,
                                      %vgpr: !waveamdmachine.reg<vgpr, 1>) {
  %step = waveamdmachine.imm 1 : !waveamdmachine.imm
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %step : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    // expected-error@+1 {{carry types must match parent uniform_loop init types}}
    waveamdmachine.continue_if %next#1 : !waveamdmachine.reg<scc, 1> carries(%vgpr : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}
