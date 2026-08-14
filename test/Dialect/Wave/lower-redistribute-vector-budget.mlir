//===- lower-redistribute-vector-budget.mlir -------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt --wave-lower-redistribute %s 2>%t | FileCheck %s
// RUN: test ! -s %t

// The complete source-slot image fills the 16 KiB scratch budget. Starting
// from a rectangular transpose, the relation swaps result item bit 0 with
// result-slot bit 5, then triangularly XORs that slot bit into source-item bit
// 0. Source-slot bit 0 retains it, so the map remains a bijection of all 14
// coordinate bits. Every result-slot bit changes source_item, forcing scalar
// packets, while result item bit 0 selects a different source wave.
// The layout has 32,768 one-dword scored points. The 4 Mi-dword-visit work
// budget permits the identity plus 127 candidates, fewer than its 133 phase
// candidates. At the cutoff the best layout uses source-group bits 0..4 as an
// item phase shifted by one. An unrestricted search subsequently adds item XOR
// (7 -> 6), reducing its load conflict score from 512 to zero, so
// the physical index below observes deterministic retention at exhaustion.
// CHECK-LABEL: func.func @affine_slot_map_uses_full_budget
// CHECK: wave.alloc() {align = 1 : i64, bytesize = 16384 : i64}
// CHECK: wave.index_expr <"256 + xor(2, item)">
// CHECK: wave.store {{.*}} : (!wave.simd<i8, 64>,
// CHECK: wave.load {{.*}} -> (!wave.simd<i8, 64>, !wave.mem.token)
// CHECK-NOT: wave.redistribute
func.func @affine_slot_map_uses_full_budget(
    %source: !wave.simd<vector<64xi8>, 64>)
    -> !wave.simd<vector<64xi8>, 64>
    attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "xor(Mod(floor(item / 64), 2), floor(slot / 32)) + 2*floor(item / 128) + 4*Mod(slot, 32) + 128*Mod(item, 2)",
       source_slot = "floor(slot / 32) + 2*Mod(floor(item / 2), 32)">
      : !wave.simd<vector<64xi8>, 64>
     -> !wave.simd<vector<64xi8>, 64>
  return %result : !wave.simd<vector<64xi8>, 64>
}
