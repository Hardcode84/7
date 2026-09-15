// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// Typed pointers must convert before pointer normalization.
// CHECK-LABEL: arith_select_pointer:
// CHECK: s_cselect_b32
// CHECK: buffer_load_dword
// CHECK: buffer_store_dword
// CHECK: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @arith_select_pointer(%a: !wave.ptr<#wave.global, i32>,
      %b: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
      %flag: i32) -> !wave.mem.token attributes {wave.kernel} {
    %zero = arith.constant 0 : i32
    %pred = arith.cmpi ne, %flag, %zero : i32
    %base = arith.select %pred, %a, %b : !wave.ptr<#wave.global, i32>
    %lane = wave.lane_id : !wave.simd<i32, 64>
    %src = wave.ptr_add %base, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %dst = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %value, %read = wave.load %src : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
    %done = wave.store %value -> %dst after %read : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    return %done : !wave.mem.token
  }
}
