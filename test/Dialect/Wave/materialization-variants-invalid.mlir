// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @empty() {
  // expected-error @+1 {{at least one choice}}
  %r = "wave.materialization_variants"() : () -> i32
  return
}

// -----

func.func @operand_types(%a: i32, %b: i64) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "wave.materialization_variants"(%a, %b) : (i32, i64) -> i32
  return
}

// -----

func.func @result_type(%a: i32) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "wave.materialization_variants"(%a, %a) : (i32, i32) -> i64
  return
}

// -----

func.func @simd_width(%a: !wave.simd<i32, 32>, %b: !wave.simd<i32, 64>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "wave.materialization_variants"(%a, %b)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 64>) -> !wave.simd<i32, 32>
  return
}

// -----

func.func @tensor_operand_shape(%a: tensor<4xi32>, %b: tensor<?xi32>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "wave.materialization_variants"(%a, %b)
      : (tensor<4xi32>, tensor<?xi32>) -> tensor<4xi32>
  return
}

// -----

func.func @tensor_result_shape(%a: tensor<4xi32>) {
  // expected-error @+1 {{all of {choices, result} have same type}}
  %r = "wave.materialization_variants"(%a) : (tensor<4xi32>) -> tensor<?xi32>
  return
}

// -----

func.func @no_result(%a: i32) {
  // expected-error @+1 {{requires one result}}
  "wave.materialization_variants"(%a) : (i32) -> ()
  return
}

// -----

func.func @multiple_results(%a: i32) {
  // expected-error @+1 {{requires one result}}
  %r:2 = "wave.materialization_variants"(%a) : (i32) -> (i32, i32)
  return
}
