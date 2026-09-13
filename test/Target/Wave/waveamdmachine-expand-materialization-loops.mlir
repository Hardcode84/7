// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=2' | FileCheck %s
// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=2' -o %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-expand-materialization-variants='max-candidates=2' -o %t.serial
// RUN: diff %t.parallel %t.serial

// CHECK-LABEL: func.func @independent_loops
// CHECK: waveamdmachine.s_cmp_eq_u32
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.candidate_yield
func.func @independent_loops(%x: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %condition = waveamdmachine.s_cmp_eq_u32 %x, %x : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %r0 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %r1 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return %r0, %r1 : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @nested_loops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.candidate_yield
// CHECK: return
func.func @nested_loops(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %outer = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%outer_carry: !waveamdmachine.reg<sgpr, 1>):
    %r0 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%outer_carry : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
      %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
      %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
      waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%r0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return %outer : !waveamdmachine.reg<sgpr, 1>
}
