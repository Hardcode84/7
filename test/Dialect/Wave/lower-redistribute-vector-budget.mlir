//===- lower-redistribute-vector-budget.mlir -------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt --wave-lower-redistribute %s | FileCheck %s

// Last item preserves only the final four-bit slot order.
// CHECK-LABEL: func.func @late_valid_slot_order_uses_bounded_fallback
// CHECK: wave.alloc() {align = 1 : i64, bytesize = 16384 : i64}
// CHECK: wave.store {{.*}} : (!wave.simd<i8, 64>,
// CHECK: wave.load {{.*}} -> (!wave.simd<i8, 64>, !wave.mem.token)
// CHECK-NOT: wave.redistribute
func.func @late_valid_slot_order_uses_bounded_fallback(
    %source: !wave.simd<vector<128xi8>, 64>)
    -> !wave.simd<vector<128xi8>, 64>
    attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 128,
       source_block = "block",
       source_item = "xor(item, 64)",
       source_slot = "xor(slot, floor(1/127*item)*xor(slot, 2*Mod(slot, 2) + 4*Mod(floor(1/2*slot), 2) + Mod(floor(1/4*slot), 2) + 16*Mod(floor(1/8*slot), 2) + 32*Mod(floor(1/16*slot), 2) + 64*Mod(floor(1/32*slot), 2) + 8*floor(1/64*slot)))">
      : !wave.simd<vector<128xi8>, 64>
     -> !wave.simd<vector<128xi8>, 64>
  return %result : !wave.simd<vector<128xi8>, 64>
}
