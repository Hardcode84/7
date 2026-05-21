// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @param_float() -> f32 {
  // expected-error @below {{result #0 must be index or signless integer, but got 'f32'}}
  %v = wavemeta.param "unroll" : f32
  return %v : f32
}

// -----

func.func @param_vector() -> vector<4xi32> {
  // expected-error @below {{result #0 must be index or signless integer, but got 'vector<4xi32>'}}
  %v = wavemeta.param "x" : vector<4xi32>
  return %v : vector<4xi32>
}

// -----

func.func @param_signed_int() -> si32 {
  // expected-error @below {{result #0 must be index or signless integer, but got 'si32'}}
  %v = wavemeta.param "x" : si32
  return %v : si32
}

// -----

func.func @param_value_type_mismatch() -> index {
  // expected-error @below {{value attribute type must match result type}}
  %v = wavemeta.param "u" {value = 4 : i64} : index
  return %v : index
}
