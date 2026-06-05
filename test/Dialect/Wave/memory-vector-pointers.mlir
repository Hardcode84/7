// RUN: wave-opt %s | FileCheck %s

// CHECK-LABEL: func.func @vector_ptr_payload
// CHECK-SAME: ([[PTRS:%.*]]: !wave.simd<!wave.ptr<#wave.global, vector<8xi32>>, 32>, [[VAL:%.*]]: !wave.simd<vector<8xi32>, 32>)
// CHECK: [[LOAD:%.*]], [[TOK:%.*]] = wave.load [[PTRS]]
// CHECK-SAME: -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
// CHECK: wave.store [[VAL]] -> [[PTRS]] after [[TOK]]
func.func @vector_ptr_payload(
    %ptrs: !wave.simd<!wave.ptr<#wave.global, vector<8xi32>>, 32>,
    %value: !wave.simd<vector<8xi32>, 32>) {
  %loaded, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, vector<8xi32>>, 32>)
      -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %store_token = wave.store %value -> %ptrs after %token
      : (!wave.simd<vector<8xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, vector<8xi32>>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
