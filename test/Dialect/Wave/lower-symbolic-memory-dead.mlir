// RUN: wave-opt --pass-pipeline='builtin.module(canonicalize,wave-lower-symbolic-memory)' %s | FileCheck %s

// CHECK-LABEL: func.func @dead_fractional_mapping
// CHECK-NOT: wave.gather
func.func @dead_fractional_mapping(%base: !wave.ptr<#wave.shared, i32>) {
  %false = arith.constant false
  scf.if %false {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"slot / 2">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  }
  return
}
