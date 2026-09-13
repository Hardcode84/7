// RUN: wave-opt %s --waveamd-expand-materialization-variants | FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=2' | FileCheck %s --check-prefix=LIMIT --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants -o %t.parallel
// RUN: wave-opt %s --mlir-disable-threading --waveamd-expand-materialization-variants -o %t.serial
// RUN: diff %t.parallel %t.serial

// LIMIT-LABEL: func.func @shared_setup
// LIMIT: waveamdmachine.materialization_candidates
// LIMIT-COUNT-2: waveamdmachine.candidate_yield
// LIMIT-NOT: waveamdmachine.candidate_yield
// LIMIT: return
// CHECK-LABEL: func.func @shared_setup
// CHECK: waveamdmachine.materialization_candidates
// CHECK: test.setup
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: test.setup
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: test.setup
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: test.setup
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.materialization_candidates
// CHECK: return
func.func @shared_setup(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %init = waveamdmachine.s_mov_b32_value %x {test.setup} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %r0 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %r1 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %exit = waveamdmachine.s_mov_b32_value %r1 {test.exit} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  return %r0, %exit : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}

// LIMIT-LABEL: func.func @dependent_loops
// LIMIT: waveamdmachine.materialization_candidates
// LIMIT-COUNT-2: waveamdmachine.candidate_yield
// LIMIT-NOT: waveamdmachine.candidate_yield
// LIMIT: return
// CHECK-LABEL: func.func @dependent_loops
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: test.exit
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.materialization_candidates
// CHECK: return

func.func @dependent_loops(%condition: !waveamdmachine.reg<scc, 1>, %x: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %r0 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %r1 = waveamdmachine.uniform_loop if %condition : !waveamdmachine.reg<scc, 1> carries(%r0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 1>):
    %a = waveamdmachine.s_mov_b32_value %carry {test.variant = "a"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %b = waveamdmachine.s_mov_b32_value %carry {test.variant = "b"} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1> carries(%choice : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %exit = waveamdmachine.s_mov_b32_value %r1 {test.exit} : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  return %r0, %exit : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}
