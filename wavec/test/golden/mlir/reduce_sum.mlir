module attributes {gpu.container_module} {
  func.func @reduce_sum(%arg0: !wave.ptr<#wave.global, f32>, %arg1: i32) attributes {wave.kernel} {
    %0 = wave.lane_id : !wave.simd<i32, 32>
    %c32_i32 = arith.constant 32 : i32
    %cst = arith.constant 0.000000e+00 : f32
    %1 = wave.splat %cst : f32 -> !wave.simd<f32, 32>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %2 = scf.for %arg2 = %c0_i32 to %arg1 step %c1_i32 iter_args(%arg3 = %1) -> (!wave.simd<f32, 32>)  : i32 {
      %5 = wave.muli %arg2, %c32_i32 : i32, i32 -> i32
      %6 = wave.addi %5, %0 : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
      %7 = wave.ptr_add %arg0, %6 : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
      %value, %token = wave.load %7 : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> (!wave.simd<f32, 32>, !wave.mem.token)
      %8 = wave.fadd %arg3, %value : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
      scf.yield %8 : !wave.simd<f32, 32>
    }
    %3 = wave.ptr_add %arg0, %0 : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
    %4 = wave.store %2 -> %3 : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> !wave.mem.token
    return
  }
}
