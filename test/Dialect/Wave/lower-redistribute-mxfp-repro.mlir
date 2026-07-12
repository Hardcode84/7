//===- lower-redistribute-mxfp-repro.mlir ----------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,wave-normalize-pointer-offsets,wave-generate-index-exprs,wave-simplify-index-exprs,wave-coalesce-memory,canonicalize,cse)' > %t
// RUN: FileCheck %s < %t

// CHECK-LABEL: func.func @mxfp_mfma_to_blocked_cross_wave(
// CHECK: wave.alloc() {align = 8 : i64, bytesize = 65536 : i64}
// CHECK-COUNT-32: wave.store
// CHECK: wave.barrier
// CHECK-COUNT-32: wave.load
// CHECK-NOT: wave.alloc()
// CHECK: return
func.func @mxfp_mfma_to_blocked_cross_wave(
    %source: !wave.simd<vector<128xbf16>, 64>)
    -> !wave.simd<vector<128xbf16>, 64>
    attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "64*xor(2*Mod(floor(1/8*slot), 2), Mod(floor(1/2*Mod(item, 64)), 2)) + xor(8*Mod(floor(1/128*item), 2), xor(4*Mod(floor(1/64*item), 2), xor(2*Mod(floor(1/32*Mod(item, 64)), 2), xor(Mod(floor(1/16*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))",
       source_slot = "xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))">
      : !wave.simd<vector<128xbf16>, 64>
     -> !wave.simd<vector<128xbf16>, 64>
  return %result : !wave.simd<vector<128xbf16>, 64>
}
