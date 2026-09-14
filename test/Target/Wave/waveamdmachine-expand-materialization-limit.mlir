// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=3' --verify-diagnostics | FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants

// CHECK-LABEL: func.func @capped_product
// CHECK: waveamdmachine.materialization_candidates
// CHECK-COUNT-3: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @capped_product(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.materialization_variants %x, %x : !waveamdmachine.reg<sgpr, 1>
  // expected-remark @+1 {{candidate limit reached; exploring first 3 assignments in operand order}}
  %b = waveamdmachine.materialization_variants %a, %a, %a : !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.materialization_variants %b, %b : !waveamdmachine.reg<sgpr, 1>
  return %c : !waveamdmachine.reg<sgpr, 1>
}

// CHECK-LABEL: func.func @exact_limit
// CHECK: waveamdmachine.materialization_candidates
// CHECK-COUNT-3: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @exact_limit(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.materialization_variants %x, %x, %x : !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.materialization_variants %a : !waveamdmachine.reg<sgpr, 1>
  return %b : !waveamdmachine.reg<sgpr, 1>
}
