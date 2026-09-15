// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// RUN: wave-opt %s --wave-lower-symbolic-memory | FileCheck %s --check-prefix=IR
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// IR-LABEL: func.func @distributed_remainder_address
// IR-COUNT-1: wave.binary remsi
// IR-NOT: wave.binary divsi
// IR-NOT: wave.gather
// IR: wave.store
// ASM-LABEL: distributed_remainder_address:
// ASM: v_rcp_iflag_f32
// ASM: buffer_load_b32
// ASM: buffer_store_b32
// ASM: s_endpgm
func.func @distributed_remainder_address(
    %source: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
    %x: i32, %d: i32, %y: i32, %e: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item = wave.assume %lane as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
      : !wave.simd<i32, 32>
  %value, %loaded = wave.gather %buffer mapping
      <bit_offset = <"8*Mod(4*(128 + -2147483648 + 1*Mod(2147483648 + x + item, 4294967296) - 1*Mod(2147483648 + d, 4294967296)*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + 2147483648*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + slot), 4294967296)">>
      bindings ["item", "x", "d", "y", "e"] (%item, %x, %d, %y, %e)
      : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>, i32, i32, i32, i32)
      -> (!wave.simd<vector<1xi32>, 32>, !wave.mem.token)
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr after %loaded
      : (!wave.simd<vector<1xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %stored : !wave.mem.token
}

// IR-LABEL: func.func @inexact_remainder_address
// IR: wave.binary divsi
// IR-NOT: wave.gather
// IR: wave.store
// ASM-LABEL: inexact_remainder_address:
// ASM: v_rcp_iflag_f32
// ASM: buffer_load_b32
// ASM: buffer_store_b32
// ASM: s_endpgm
func.func @inexact_remainder_address(
    %source: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
    %x: i32, %d: i32, %y: i32, %e: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item = wave.assume %lane as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
      : !wave.simd<i32, 32>
  %value, %loaded = wave.gather %buffer mapping
      <bit_offset = <"8*Mod(4*(128 + -2147483648 + 1*Mod(2147483648 + x + item, 4294967296) - 1*Mod(2147483648 + d, 4294967296)*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + 2147483647*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + slot), 4294967296)">>
      bindings ["item", "x", "d", "y", "e"] (%item, %x, %d, %y, %e)
      : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>, i32, i32, i32, i32)
      -> (!wave.simd<vector<1xi32>, 32>, !wave.mem.token)
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr after %loaded
      : (!wave.simd<vector<1xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %stored : !wave.mem.token
}

// IR-LABEL: func.func @multiple_remainder_address
// Modulo reduction removes quotient coefficients divisible by 2^32.
// IR-COUNT-2: wave.binary divsi
// IR-NOT: wave.gather
// IR: wave.store
// ASM-LABEL: multiple_remainder_address:
// ASM: v_rcp_iflag_f32
// ASM: buffer_load_b32
// ASM: buffer_store_b32
// ASM: s_endpgm
func.func @multiple_remainder_address(
    %source: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
    %x: i32, %d: i32, %y: i32, %e: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item = wave.assume %lane as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
      : !wave.simd<i32, 32>
  %value, %loaded = wave.gather %buffer mapping
      <bit_offset = <"8*Mod(4*(128 + -2147483648 + 1*Mod(2147483648 + x + item, 4294967296) - 1*Mod(2147483648 + d, 4294967296)*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + 2147483648*Trunc((-2147483648 + Mod(2147483648 + x + item, 4294967296))/(-2147483648 + Mod(2147483648 + d, 4294967296))) + -2147483648 + 1*Mod(2147483648 + y + item, 4294967296) - 1*Mod(2147483648 + e, 4294967296)*Trunc((-2147483648 + Mod(2147483648 + y + item, 4294967296))/(-2147483648 + Mod(2147483648 + e, 4294967296))) + 2147483648*Trunc((-2147483648 + Mod(2147483648 + y + item, 4294967296))/(-2147483648 + Mod(2147483648 + e, 4294967296))) + slot), 4294967296)">>
      bindings ["item", "x", "d", "y", "e"] (%item, %x, %d, %y, %e)
      : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>, i32, i32, i32, i32)
      -> (!wave.simd<vector<1xi32>, 32>, !wave.mem.token)
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr after %loaded
      : (!wave.simd<vector<1xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %stored : !wave.mem.token
}
}
