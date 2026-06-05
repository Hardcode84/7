module attributes {gpu.container_module} {
  func.func @where_carry(%arg0: !wave.ptr<#wave.global, i32>, %arg1: i32) attributes {wave.kernel} {
    %0 = wave.lane_id : !wave.simd<i32, 32>
    %1 = wave.splat %arg1 : i32 -> !wave.simd<i32, 32>
    %2 = wave.cmpi ult %0, %1 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
    %3 = wave.where %2 {
      wave.yield %0 : !wave.simd<i32, 32>
    } otherwise {
      wave.yield %0 : !wave.simd<i32, 32>
    } : !wave.mask<32> -> !wave.simd<i32, 32>
    %4 = wave.ptr_add %arg0, %0 : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %5 = wave.store %3 -> %4 : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
    return
  }
}
