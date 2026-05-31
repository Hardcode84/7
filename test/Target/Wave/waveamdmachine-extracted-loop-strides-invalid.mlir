// RUN: wave-opt --wave-extract-loop-strides --canonicalize --cse --waveamd-to-machine -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unbounded_nested_symbolic_stride(
    %a: !wave.ptr<f16, #wave.global>, %n: i32, %m: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    // expected-error @below {{scf.for pointer carry offset must fit proven unsigned 32-bit for every iteration}}
    scf.for %j = %c1 to %m step %c1 : i32 {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<f16, #wave.global>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
    }
  }
  return
}
}
