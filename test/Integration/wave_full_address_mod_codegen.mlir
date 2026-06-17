// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: full_address_rational_mod_floor:
// ASM: v_and_b32
// ASM: v_lshrrev_b64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @full_address_rational_mod_floor(
    %out: !wave.ptr<#wave.global, i32>, %x_raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 4095">] : i32
  %off = wave.index_expr <"1073741824 + floor(1/512*Mod(8*x, 1024)) + lid">
      ["lid", "x"] (%lane, %x)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: full_address_vector4_store:
// ASM-NOT: global_store_b32
// ASM: global_store_b128 v[{{[0-9]+}}:{{[0-9]+}}], v[{{[0-9]+}}:{{[0-9]+}}], off
func.func @full_address_vector4_store(%out: !wave.ptr<#wave.global, i32>,
                                      %raw: i32)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %v2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %v3 = wave.splat %c3 : i32 -> !wave.simd<i32, 32>
  %v4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %packed = wave.pack %v1, %v2, %v3, %v4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %tok = wave.store %packed -> %ptrs
      : (!wave.simd<vector<4xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
