// RUN: wave-opt %s | FileCheck %s

// CHECK-LABEL: func.func @cache_attr_roundtrip
// CHECK: #waveamd.load_cache<none>
// CHECK: #waveamd.load_cache<ca>
// CHECK: #waveamd.load_cache<cg>
// CHECK: #waveamd.load_cache<cs>
// CHECK: #waveamd.load_cache<cv>
// CHECK: #waveamd.store_cache<none>
// CHECK: #waveamd.store_cache<wb>
// CHECK: #waveamd.store_cache<cg>
// CHECK: #waveamd.store_cache<cs>
// CHECK: #waveamd.store_cache<wt>
func.func @cache_attr_roundtrip(%ptr: !wave.ptr<#wave.global, i32>,
                                %value: !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %l0, %t0 = wave.load %ptr {cache = #waveamd.load_cache<none>}
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %l1, %t1 = wave.load %ptr {cache = #waveamd.load_cache<ca>}
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %l2, %t2 = wave.load %ptr {cache = #waveamd.load_cache<cg>}
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %l3, %t3 = wave.load %ptr {cache = #waveamd.load_cache<cs>}
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %l4, %t4 = wave.load %ptr {cache = #waveamd.load_cache<cv>}
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %s0 = wave.store %value -> %ptr {cache = #waveamd.store_cache<none>}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  %s1 = wave.store %value -> %ptr {cache = #waveamd.store_cache<wb>}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  %s2 = wave.store %value -> %ptr {cache = #waveamd.store_cache<cg>}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  %s3 = wave.store %value -> %ptr {cache = #waveamd.store_cache<cs>}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  %s4 = wave.store %value -> %ptr {cache = #waveamd.store_cache<wt>}
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}
