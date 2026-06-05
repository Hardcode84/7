module attributes {gpu.container_module} {
  func.func @cast_f32_f16() attributes {wave.kernel} {
    %cst = arith.constant 1.000000e+00 : f32
    %0 = wave.splat %cst : f32 -> !wave.simd<f32, 32>
    %1 = wave.cast fpconvert %0 : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
    return
  }
}
