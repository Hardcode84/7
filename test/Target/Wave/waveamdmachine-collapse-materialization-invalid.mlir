// RUN: wave-opt %s --waveamd-collapse-materialization-variants --split-input-file --verify-diagnostics
func.func @missing_later_score() {
  waveamdmachine.materialization_candidates {
    waveamdmachine.candidate_yield {cycles = 0 : i64}
  }, {
    // expected-error @+1 {{requires a cycle score before candidate collapse}}
    waveamdmachine.candidate_yield
  }, {
    waveamdmachine.candidate_yield {cycles = 1 : i64}
  }
  return
}
// -----
func.func @missing_first_score() {
  waveamdmachine.materialization_candidates {
    // expected-error @+1 {{requires a cycle score before candidate collapse}}
    waveamdmachine.candidate_yield
  }, {
    waveamdmachine.candidate_yield {cycles = 1 : i64}
  }
  return
}
