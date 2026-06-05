module attributes {gpu.container_module} {
  func.func @saxpy(%arg0: !wave.ptr<#wave.global, f32>, %arg1: !wave.ptr<#wave.global, f32>, %arg2: f32, %arg3: i32) attributes {wave.kernel} {
    %0 = wave.lane_id : !wave.simd<i32, 32>
    %1 = wave.workgroup_id 0
    %c32_i32 = arith.constant 32 : i32
    %2 = wave.binary muli %1, %c32_i32 : i32, i32 -> i32
    %3 = wave.binary addi %2, %0 : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %4 = wave.splat %arg3 : i32 -> !wave.simd<i32, 32>
    %5 = wave.cmpi ult %3, %4 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
    %6 = wave.ptr_add %arg0, %3 : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
    %7 = wave.ptr_add %arg1, %3 : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
    wave.where %5 {
      %value, %token = wave.load %6 : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> (!wave.simd<f32, 32>, !wave.mem.token)
      %value_0, %token_1 = wave.load %7 : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> (!wave.simd<f32, 32>, !wave.mem.token)
      %8 = wave.splat %arg2 : f32 -> !wave.simd<f32, 32>
      %9 = wave.fmul %8, %value : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
      %10 = wave.fadd %9, %value_0 : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
      %11 = wave.store %10 -> %7 : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> !wave.mem.token
    } : !wave.mask<32>
    return
  }
}
