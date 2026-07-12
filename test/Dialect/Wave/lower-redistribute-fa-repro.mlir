//===- lower-redistribute-fa-repro.mlir ------------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,wave-normalize-pointer-offsets,wave-generate-index-exprs,wave-simplify-index-exprs,wave-coalesce-memory,canonicalize,cse)' > %t
// RUN: FileCheck %s --check-prefix=CHECK < %t
// RUN: FileCheck %s --check-prefix=NOSELECT < %t

// CHECK-LABEL: func.func @fa_blocked_to_dot_operand_cross_wave(
// CHECK: wave.alloc() {align = 16 : i64, bytesize = 65536 : i64}
// CHECK-COUNT-16: wave.store {{.*}}!wave.simd<vector<8xbf16>, 64>
// CHECK: wave.barrier
// CHECK-COUNT-16: wave.load {{.*}} -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
// CHECK: wave.pack
// NOSELECT-LABEL: func.func @fa_blocked_to_dot_operand_cross_wave(
// NOSELECT-NOT: wave.select
// NOSELECT-NOT: wave.transpose_load
// NOSELECT: return
func.func @fa_blocked_to_dot_operand_cross_wave(
    %source: !wave.simd<vector<128xbf16>, 64>)
    -> !wave.simd<vector<128xbf16>, 64>
    attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "128*Mod(floor(1/8*Mod(item, 64)), 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + xor(8*Mod(floor(1/32*slot), 2) + 4*Mod(floor(1/16*slot), 2) + 2*Mod(floor(1/8*slot), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2) + 16*Mod(Mod(item, 64), 2), floor(1/32*Mod(item, 64)))",
       source_slot = "xor(32*Mod(floor(1/128*item), 2), xor(16*Mod(floor(1/64*item), 2), xor(Mod(slot, 2) + 64*Mod(floor(1/64*slot), 2) + 4*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 8*Mod(floor(1/16*Mod(item, 64)), 2))))">
      : !wave.simd<vector<128xbf16>, 64>
     -> !wave.simd<vector<128xbf16>, 64>
  return %result : !wave.simd<vector<128xbf16>, 64>
}
