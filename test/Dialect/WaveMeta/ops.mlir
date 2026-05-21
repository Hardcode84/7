// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @param_index
// CHECK: %[[V:.+]] = wavemeta.param "unroll" : index
// CHECK: return %[[V]] : index
func.func @param_index() -> index {
  %v = wavemeta.param "unroll" : index
  return %v : index
}

// CHECK-LABEL: func.func @param_i1
// CHECK: %[[V:.+]] = wavemeta.param "use_lds" : i1
// CHECK: return %[[V]] : i1
func.func @param_i1() -> i1 {
  %v = wavemeta.param "use_lds" : i1
  return %v : i1
}

// CHECK-LABEL: func.func @param_i32
// CHECK: %[[V:.+]] = wavemeta.param "tile_m" : i32
// CHECK: return %[[V]] : i32
func.func @param_i32() -> i32 {
  %v = wavemeta.param "tile_m" : i32
  return %v : i32
}

// CHECK-LABEL: func.func @param_i64
// CHECK: %[[V:.+]] = wavemeta.param "depth" : i64
// CHECK: return %[[V]] : i64
func.func @param_i64() -> i64 {
  %v = wavemeta.param "depth" : i64
  return %v : i64
}

// Bound form: `$value` attribute attached, type matches the result.
// CHECK-LABEL: func.func @param_bound
// CHECK: %[[V:.+]] = wavemeta.param "unroll" {value = 4 : index} : index
// CHECK: return %[[V]] : index
func.func @param_bound() -> index {
  %v = wavemeta.param "unroll" {value = 4 : index} : index
  return %v : index
}
