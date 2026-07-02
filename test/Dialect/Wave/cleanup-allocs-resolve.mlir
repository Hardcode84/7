// RUN: wave-opt --pass-pipeline='builtin.module(wave-cleanup-allocs,canonicalize,wave-resolve-allocs)' %s | FileCheck %s

// CHECK-LABEL: func.func @dead_alloc_before_resolve
// CHECK-SAME: attributes {wave.kernel}
// CHECK-NOT: wave.alloc
// CHECK-NOT: wave.shared_memory_base
func.func @dead_alloc_before_resolve() -> !wave.mem.token
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  // CHECK: [[TOK:%.*]] = wave.token : !wave.mem.token
  // CHECK: return [[TOK]] : !wave.mem.token
  return %tok : !wave.mem.token
}
