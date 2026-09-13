// RUN: wave-opt %s --waveamd-expand-materialization-variants='max-candidates=3' --split-input-file --verify-diagnostics
// RUN: not wave-opt %s --waveamd-expand-materialization-variants='max-candidates=0' 2>&1 | FileCheck %s --check-prefix=ZERO
// ZERO: max-candidates must be positive

func.func @already_expanded(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %r = waveamdmachine.materialization_candidates %x : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<sgpr, 1> {
  ^bb0(%arg: !waveamdmachine.reg<sgpr, 1>):
    // expected-error @+1 {{cannot expand choices inside an existing candidate}}
    %choice = waveamdmachine.materialization_variants %arg, %arg : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.candidate_yield %choice : !waveamdmachine.reg<sgpr, 1>
  }
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// -----

func.func @after_exit(%x: !waveamdmachine.reg<sgpr, 1>) {
  waveamdmachine.s_endpgm
  // expected-error @+1 {{cannot expand a block with operations after its exit}}
  %r = waveamdmachine.materialization_variants %x, %x : !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @overlapping_wrapper(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  // expected-error @+1 {{cannot nest candidate expansion scopes}}
  waveamdmachine.materialization_candidates {
    waveamdmachine.candidate_yield
  }
  %r = waveamdmachine.materialization_variants %a, %x : !waveamdmachine.reg<sgpr, 1>
  return %r : !waveamdmachine.reg<sgpr, 1>
}
