// RUN: wave-opt --wave-extract-loop-strides --canonicalize --cse --waveamd-to-machine -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unbounded_nested_symbolic_stride(
    %a: !wave.ptr<#wave.global, f16>, %n: i32, %m: i32) -> !wave.mem.token attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %observe_seed_5 = wave.token : !wave.mem.token
  %observe_region_6 = scf.for %i = %c0 to %n step %c1 iter_args(%observe_carry_7 = %observe_seed_5) -> (!wave.mem.token) : i32  {
    %observe_seed_1 = wave.token : !wave.mem.token
    // expected-error @below {{scf.for pointer carry offset must fit proven unsigned 32-bit for every iteration}}
    %observe_region_2 = scf.for %j = %c1 to %m step %c1 iter_args(%observe_carry_3 = %observe_seed_1) -> (!wave.mem.token) : i32  {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      %observed_store_1 = wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
      %observe_join_4 = wave.join %observe_carry_3, %observed_store_1 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      scf.yield %observe_join_4 : !wave.mem.token
    }
    %observe_join_8 = wave.join %observe_carry_7, %observe_region_2 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %observe_join_8 : !wave.mem.token
  }
  return %observe_region_6 : !wave.mem.token
}
}
