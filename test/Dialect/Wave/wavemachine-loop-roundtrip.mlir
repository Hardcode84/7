// RUN: wave-opt --verify-diagnostics --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @uniform_loop_do_while
// CHECK: %[[STEP:.+]] = wavemachine.imm 1 : !wavemachine.imm
// CHECK: %[[UPPER:.+]] = wavemachine.imm 16 : !wavemachine.imm
// CHECK: %{{.+}} = wavemachine.uniform_loop carries(%{{.+}} : !wavemachine.reg<sgpr, 1>) {
// CHECK: ^bb0(%[[IV:.+]]: !wavemachine.reg<sgpr, 1>):
// CHECK:   %[[SUM:.+]], %{{.+}} = wavemachine.s_add_i32 %[[IV]], %[[STEP]] : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
// CHECK:   %[[SCC:.+]] = wavemachine.s_cmp_lt_i32 %[[SUM]], %[[UPPER]] : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
// CHECK:   wavemachine.continue_if %[[SCC]] : !wavemachine.reg<scc, 1> carries(%[[SUM]] : !wavemachine.reg<sgpr, 1>)
// CHECK: } -> !wavemachine.reg<sgpr, 1>
func.func @uniform_loop_do_while(%init: !wavemachine.reg<sgpr, 1>) {
  %step = wavemachine.imm 1 : !wavemachine.imm
  %upper = wavemachine.imm 16 : !wavemachine.imm
  %r = wavemachine.uniform_loop carries(%init : !wavemachine.reg<sgpr, 1>) {
  ^bb0(%iv: !wavemachine.reg<sgpr, 1>):
    %next:2 = wavemachine.s_add_i32 %iv, %step : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %scc = wavemachine.s_cmp_lt_i32 %next#0, %upper : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %scc : !wavemachine.reg<scc, 1> carries(%next#0 : !wavemachine.reg<sgpr, 1>)
  } -> !wavemachine.reg<sgpr, 1>
  return
}

// -----

// CHECK-LABEL: func.func @uniform_loop_with_entry_cond
// CHECK: %[[EC:.+]] = wavemachine.s_cmp_lt_i32 %{{.+}}, %{{.+}} : (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<scc, 1>
// CHECK: wavemachine.uniform_loop if %[[EC]] : !wavemachine.reg<scc, 1> carries(%{{.+}} : !wavemachine.reg<sgpr, 1>)
func.func @uniform_loop_with_entry_cond(%lo: !wavemachine.reg<sgpr, 1>, %hi: !wavemachine.reg<sgpr, 1>) {
  %step = wavemachine.imm 1 : !wavemachine.imm
  %ec = wavemachine.s_cmp_lt_i32 %lo, %hi : (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<scc, 1>
  %r = wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1> carries(%lo : !wavemachine.reg<sgpr, 1>) {
  ^bb0(%iv: !wavemachine.reg<sgpr, 1>):
    %next:2 = wavemachine.s_add_i32 %iv, %step : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %scc = wavemachine.s_cmp_lt_i32 %next#0, %hi : (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %scc : !wavemachine.reg<scc, 1> carries(%next#0 : !wavemachine.reg<sgpr, 1>)
  } -> !wavemachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_continue_if_carry_count(%init: !wavemachine.reg<sgpr, 1>) {
  %step = wavemachine.imm 1 : !wavemachine.imm
  %r = wavemachine.uniform_loop carries(%init : !wavemachine.reg<sgpr, 1>) {
  ^bb0(%iv: !wavemachine.reg<sgpr, 1>):
    %next:2 = wavemachine.s_add_i32 %iv, %step : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    // expected-error@+1 {{carries count must match parent uniform_loop inits}}
    wavemachine.continue_if %next#1 : !wavemachine.reg<scc, 1>
  } -> !wavemachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_continue_if_carry_type(%init: !wavemachine.reg<sgpr, 1>,
                                      %vgpr: !wavemachine.reg<vgpr, 1>) {
  %step = wavemachine.imm 1 : !wavemachine.imm
  %r = wavemachine.uniform_loop carries(%init : !wavemachine.reg<sgpr, 1>) {
  ^bb0(%iv: !wavemachine.reg<sgpr, 1>):
    %next:2 = wavemachine.s_add_i32 %iv, %step : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    // expected-error@+1 {{carry types must match parent uniform_loop init types}}
    wavemachine.continue_if %next#1 : !wavemachine.reg<scc, 1> carries(%vgpr : !wavemachine.reg<vgpr, 1>)
  } -> !wavemachine.reg<sgpr, 1>
  return
}
