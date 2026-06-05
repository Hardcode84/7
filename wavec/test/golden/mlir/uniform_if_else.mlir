module attributes {gpu.container_module} {
  func.func @uniform_if_else(%arg0: !wave.ptr<#wave.global, i32>, %arg1: i32) attributes {wave.kernel} {
    %c64_i32 = arith.constant 64 : i32
    %0 = arith.cmpi ult, %arg1, %c64_i32 : i32
    %1 = wave.lane_id : !wave.simd<i32, 32>
    %2 = scf.if %0 -> (!wave.simd<i32, 32>) {
      scf.yield %1 : !wave.simd<i32, 32>
    } else {
      %c0_i32 = arith.constant 0 : i32
      %5 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 32>
      scf.yield %5 : !wave.simd<i32, 32>
    }
    %3 = wave.ptr_add %arg0, %1 : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %4 = wave.store %2 -> %3 : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
    return
  }
}
