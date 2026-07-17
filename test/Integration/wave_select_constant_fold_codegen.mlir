// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: constant_select_simd_splat_codegen:
// ASM-NOT: cselect
// ASM-NOT: cndmask
// ASM: buffer_store_b32
func.func @constant_select_simd_splat_codegen(
    %dst: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %yes = arith.constant true
  %seven = arith.constant 7 : i32
  %nine = arith.constant 9 : i32
  %vseven = wave.splat %seven : i32 -> !wave.simd<i32, 32>
  %vnine = wave.splat %nine : i32 -> !wave.simd<i32, 32>
  %selected = wave.select %yes, %vseven, %vnine : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %selected -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: constant_select_vector_splat_codegen:
// ASM-NOT: cselect
// ASM-NOT: cndmask
// ASM: buffer_store_b32
func.func @constant_select_vector_splat_codegen(
    %dst: !wave.ptr<#wave.global, i16>, %first_value: vector<2xi16>,
    %second_value: vector<2xi16>) attributes {wave.kernel} {
  %no = arith.constant false
  %first = wave.splat %first_value
      : vector<2xi16> -> !wave.simd<vector<2xi16>, 32>
  %second = wave.splat %second_value
      : vector<2xi16> -> !wave.simd<vector<2xi16>, 32>
  %selected = wave.select %no, %first, %second
      : !wave.simd<vector<2xi16>, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i16>, 32>
  %stored = wave.store %selected -> %ptrs
      : (!wave.simd<vector<2xi16>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i16>, 32>)
      -> !wave.mem.token
  return
}

}
