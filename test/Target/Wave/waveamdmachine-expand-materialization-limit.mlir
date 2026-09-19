// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=3' --verify-diagnostics | FileCheck %s --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-expand-materialization-variants | FileCheck %s --check-prefix=DEFAULT --implicit-check-not=waveamdmachine.materialization_variants

// CHECK-LABEL: func.func @capped_product
// CHECK: waveamdmachine.materialization_candidates
// CHECK-COUNT-3: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.candidate_yield
// CHECK: return
func.func @capped_product(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  // expected-remark @+1 {{candidate limit reached; exploring 3 diverse assignments}}
  %a = waveamdmachine.materialization_variants %x, %x : !waveamdmachine.reg<sgpr, 1>
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

// DEFAULT-LABEL: func.func @default_limit
// DEFAULT: waveamdmachine.materialization_candidates
// DEFAULT-COUNT-64: waveamdmachine.candidate_yield
// DEFAULT-NOT: waveamdmachine.candidate_yield
// DEFAULT: return
func.func @default_limit(%x: !waveamdmachine.reg<sgpr, 1>,
                         %y: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1> {
  // expected-remark @+1 {{candidate limit reached; exploring 3 diverse assignments}}
  %a = waveamdmachine.materialization_variants %x, %y : !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.materialization_variants %a, %y : !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.materialization_variants %b, %y : !waveamdmachine.reg<sgpr, 1>
  %d = waveamdmachine.materialization_variants %c, %y : !waveamdmachine.reg<sgpr, 1>
  %e = waveamdmachine.materialization_variants %d, %y : !waveamdmachine.reg<sgpr, 1>
  %f = waveamdmachine.materialization_variants %e, %y : !waveamdmachine.reg<sgpr, 1>
  return %f : !waveamdmachine.reg<sgpr, 1>
}
