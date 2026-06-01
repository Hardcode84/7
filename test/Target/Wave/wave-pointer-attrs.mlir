// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @address_spaces
// CHECK-SAME: !wave.ptr<#wave.global, i32>
// CHECK-SAME: !wave.ptr<#wave.shared, f32>
// CHECK-SAME: !wave.ptr<#wave.private, i8>
// CHECK-SAME: !wave.ptr<#waveamd.buffer, i32>
func.func @address_spaces(
    %global: !wave.ptr<#wave.global, i32>,
    %shared: !wave.ptr<#wave.shared, f32>,
    %private: !wave.ptr<#wave.private, i8>,
    %buffer: !wave.ptr<#waveamd.buffer, i32>) {
  return
}

// CHECK-LABEL: func.func @lane_varying_pointer
// CHECK-SAME: !wave.simd<!wave.ptr<#wave.global, i32>, 32>
// CHECK-SAME: !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
func.func @lane_varying_pointer(
    %ptrs: !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
    %buffer_ptrs: !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) {
  return
}
