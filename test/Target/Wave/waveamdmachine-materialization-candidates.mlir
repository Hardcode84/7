// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-opt %s --canonicalize | FileCheck %s --check-prefix=CANON

// CHECK-LABEL: func.func @choices
// CHECK: waveamdmachine.materialization_candidates
// CHECK: ^bb0([[A:%.*]]: !waveamdmachine.reg<sgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<sgpr, 1>)
// CHECK: waveamdmachine.candidate_yield [[A]] : !waveamdmachine.reg<sgpr, 1> {cycles = 9 : i64}
// CHECK: ^bb0([[C:%.*]]: !waveamdmachine.reg<sgpr, 1>, [[D:%.*]]: !waveamdmachine.reg<sgpr, 1>)
// CHECK: waveamdmachine.candidate_yield [[D]] : !waveamdmachine.reg<sgpr, 1> {cycles = 0 : i64}
// CANON-LABEL: func.func @choices
// CANON: waveamdmachine.materialization_candidates
// CANON: cycles = 9
// CANON: cycles = 0
func.func @choices(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %x, %x : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %a : !waveamdmachine.reg<sgpr, 1> {cycles = 9 : i64}
  }, {
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.candidate_yield %b : !waveamdmachine.reg<sgpr, 1> {cycles = 0 : i64}
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @empty
// CHECK: waveamdmachine.candidate_yield
// CANON-LABEL: func.func @empty
// CANON-NEXT: return
func.func @empty() {
  waveamdmachine.materialization_candidates {
    waveamdmachine.candidate_yield
  }
  return
}

// CHECK-LABEL: func.func @effects
// CANON-LABEL: func.func @effects
// CANON: waveamdmachine.materialization_candidates
// CANON: waveamdmachine.s_barrier
// CANON: cycles = 0
// CANON: waveamdmachine.s_barrier
// CANON: cycles = 8
func.func @effects() {
  waveamdmachine.materialization_candidates {
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.candidate_yield {cycles = 0 : i64}
  }, {
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.candidate_yield {cycles = 8 : i64}
  }
  return
}
