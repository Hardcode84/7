// RUN: wave-opt %s --split-input-file --verify-diagnostics

func.func @no_candidates() {
  // expected-error @+1 {{at least one candidate}}
  "waveamdmachine.materialization_candidates"() : () -> ()
  return
}

// -----
func.func @empty_region() {
  // expected-error @+1 {{region #0 ('candidates') failed to verify constraint: region with 1 blocks}}
  "waveamdmachine.materialization_candidates"() ({}) : () -> ()
  return
}

// -----
func.func @args(%x: i32) {
  // expected-error @+1 {{candidate argument types must match input types}}
  waveamdmachine.materialization_candidates %x : i32 {
    waveamdmachine.candidate_yield
  }
  return
}

// -----
func.func @results(%x: i32) {
  // expected-error @+1 {{candidate yield types must match result types}}
  %r = waveamdmachine.materialization_candidates %x : i32 -> i64 {
  ^bb0(%a: i32):
    waveamdmachine.candidate_yield %a : i32
  }
  return
}

// -----
func.func @capture(%x: i32) {
  // expected-note @+1 {{required by region isolation constraints}}
  %r = waveamdmachine.materialization_candidates -> i32 {
    // expected-error @+1 {{using value defined outside the region}}
    waveamdmachine.candidate_yield %x : i32
  }
  return
}

// -----
func.func @wrong_terminator() {
  // expected-error @+1 {{candidate must end with candidate_yield}}
  waveamdmachine.materialization_candidates {
    func.return
  }
  return
}

// -----
func.func @negative_score() {
  waveamdmachine.materialization_candidates {
    // expected-error @+1 {{attribute 'cycles' failed to satisfy constraint}}
    waveamdmachine.candidate_yield {cycles = -1 : i64}
  }
  return
}

// -----
func.func @score_type() {
  waveamdmachine.materialization_candidates {
    // expected-error @+1 {{attribute 'cycles' failed to satisfy constraint}}
    waveamdmachine.candidate_yield {cycles = 1 : i32}
  }
  return
}

// -----
func.func @wrong_parent() {
  // expected-error @+1 {{op expects parent op 'waveamdmachine.materialization_candidates'}}
  waveamdmachine.candidate_yield
}
