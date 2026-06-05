module attributes {gpu.container_module} {
  func.func @lds_roundtrip(%arg0: !wave.ptr<#wave.global, f32>) attributes {wave.kernel, wave.lds_size = 128 : i64} {
    %0 = wave.lane_id : !wave.simd<i32, 32>
    %1 = wave.ptr_add %arg0, %0 : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
    %2 = wave.lds_base : !wave.ptr<#wave.shared, f32>
    %3 = wave.ptr_add %2, %0 : !wave.ptr<#wave.shared, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 32>
    %value, %token = wave.load %1 : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> (!wave.simd<f32, 32>, !wave.mem.token)
    %4 = wave.store %value -> %3 after %token : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.shared, f32>, 32>, !wave.mem.token) -> !wave.mem.token
    %5 = wave.barrier %4 : (!wave.mem.token) -> !wave.mem.token
    %value_0, %token_1 = wave.load %3 after %5 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 32>, !wave.mem.token) -> (!wave.simd<f32, 32>, !wave.mem.token)
    %6 = wave.store %value_0 -> %1 after %5 : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token) -> !wave.mem.token
    return
  }
}
