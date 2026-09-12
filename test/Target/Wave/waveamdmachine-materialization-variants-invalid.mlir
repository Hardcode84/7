// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @empty() {
  // expected-error @+1 {{at least one choice}}
  %r = "waveamdmachine.materialization_variants"() : () -> i32
  return
}

// -----

func.func @operand_types(%a: i32, %b: i64) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "waveamdmachine.materialization_variants"(%a, %b) : (i32, i64) -> i32
  return
}

// -----

func.func @result_type(%a: i32) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "waveamdmachine.materialization_variants"(%a, %a) : (i32, i32) -> i64
  return
}

// -----

func.func @register_width(%a: !waveamdmachine.reg<vgpr, 1>, %b: !waveamdmachine.reg<vgpr, 2>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "waveamdmachine.materialization_variants"(%a, %b)
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @register_class(%a: !waveamdmachine.reg<sgpr, 1>, %b: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "waveamdmachine.materialization_variants"(%a, %b)
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @register_assignment(%a: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "waveamdmachine.materialization_variants"(%a) : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1, 0>
  return
}

// -----

func.func @no_result(%a: i32) {
  // expected-error @+1 {{requires one result}}
  "waveamdmachine.materialization_variants"(%a) : (i32) -> ()
  return
}

// -----

func.func @multiple_results(%a: i32) {
  // expected-error @+1 {{requires one result}}
  %r:2 = "waveamdmachine.materialization_variants"(%a) : (i32) -> (i32, i32)
  return
}
