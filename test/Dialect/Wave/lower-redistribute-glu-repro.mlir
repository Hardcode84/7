//===- lower-redistribute-glu-repro.mlir -----------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,wave-normalize-pointer-offsets,wave-generate-index-exprs,wave-simplify-index-exprs,wave-coalesce-memory,canonicalize,cse)' > %t
// RUN: FileCheck %s --check-prefixes=F32-256,F32-512,DOT-A,DOT-B < %t

// F32-256-LABEL: func.func @glu_mfma_to_blocked_128x128(
// F32-256: wave.alloc() {align = 16 : i64, bytesize = 16384 : i64}
// F32-256-COUNT-4: wave.store
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.load
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.store
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.load
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.store
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.load
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.store
// F32-256: wave.barrier
// F32-256-COUNT-4: wave.load
// F32-256-NOT: wave.alloc()
// F32-256: return
func.func @glu_mfma_to_blocked_128x128(
    %source: !wave.simd<vector<64xf32>, 64>)
    -> !wave.simd<vector<64xf32>, 64>
    attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "128*Mod(floor(1/8*slot), 2) + 64*Mod(floor(1/2*Mod(item, 64)), 2) + xor(8*Mod(floor(1/128*item), 2), xor(4*Mod(floor(1/64*item), 2), xor(2*floor(1/32*Mod(item, 64)), xor(16*Mod(floor(1/4*slot), 2) + 32*Mod(Mod(item, 64), 2), Mod(floor(1/16*Mod(item, 64)), 2)))))",
       source_slot = "xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(Mod(slot, 2) + 32*Mod(floor(1/32*slot), 2) + 16*Mod(floor(1/16*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/4*Mod(item, 64)), 2)))">
      : !wave.simd<vector<64xf32>, 64>
     -> !wave.simd<vector<64xf32>, 64>
  return %result : !wave.simd<vector<64xf32>, 64>
}

// F32-512-LABEL: func.func @glu_mfma_to_blocked_128x256(
// F32-512: wave.alloc() {align = 16 : i64, bytesize = 32768 : i64}
// F32-512-COUNT-4: wave.store
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.load
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.store
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.load
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.store
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.load
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.store
// F32-512: wave.barrier
// F32-512-COUNT-4: wave.load
// F32-512-NOT: wave.alloc()
// F32-512: return
func.func @glu_mfma_to_blocked_128x256(
    %source: !wave.simd<vector<64xf32>, 64>)
    -> !wave.simd<vector<64xf32>, 64>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 512,
       source_block = "block",
       source_item = "64*xor(4*Mod(floor(1/8*slot), 2) + Mod(floor(1/2*Mod(item, 64)), 2), 2*Mod(floor(1/4*Mod(item, 64)), 2)) + xor(8*Mod(floor(1/256*item), 2), xor(4*Mod(floor(1/128*item), 2), xor(2*Mod(floor(1/64*item), 2), xor(16*Mod(floor(1/4*slot), 2) + 32*Mod(Mod(item, 64), 2), floor(1/32*Mod(item, 64))))))",
       source_slot = "xor(8*Mod(floor(1/16*Mod(item, 64)), 2), xor(Mod(slot, 2) + 32*Mod(floor(1/32*slot), 2) + 16*Mod(floor(1/16*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/8*Mod(item, 64)), 2)))">
      : !wave.simd<vector<64xf32>, 64>
     -> !wave.simd<vector<64xf32>, 64>
  return %result : !wave.simd<vector<64xf32>, 64>
}

// DOT-A-LABEL: func.func @glu_blocked_to_dot_operand_a(
// DOT-A: wave.alloc() {align = 16 : i64, bytesize = 8192 : i64}
// DOT-A: wave.index_expr <"8*xor(
// DOT-A: wave.store
// DOT-A: wave.barrier
// DOT-A-COUNT-4: wave.load
// DOT-A: wave.barrier
// DOT-A: wave.store
// DOT-A: wave.barrier
// DOT-A-COUNT-4: wave.load
// DOT-A-NOT: wave.alloc()
// DOT-A: return
func.func @glu_blocked_to_dot_operand_a(
    %source: !wave.simd<vector<16xf16>, 64>)
    -> !wave.simd<vector<64xf16>, 64>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 512,
       source_block = "block",
       source_item = "64*xor(4*Mod(floor(1/16*slot), 2) + Mod(floor(1/8*Mod(item, 64)), 2), 2*Mod(floor(1/256*item), 2)) + xor(2*floor(1/32*Mod(item, 64)), xor(4*Mod(floor(1/8*slot), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2) + 8*Mod(Mod(item, 64), 2), Mod(floor(1/16*Mod(item, 64)), 2)))",
       source_slot = "Mod(slot, 2) + 8*Mod(floor(1/32*slot), 2) + 4*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2)">
      : !wave.simd<vector<16xf16>, 64>
     -> !wave.simd<vector<64xf16>, 64>
  return %result : !wave.simd<vector<64xf16>, 64>
}

// DOT-B-LABEL: func.func @glu_blocked_to_dot_operand_b(
// DOT-B: wave.alloc() {align = 4 : i64, bytesize = 16384 : i64}
// DOT-B-COUNT-8: wave.store {{.*}}vector<2xf16>
// DOT-B: wave.barrier
// DOT-B-COUNT-16: wave.load {{.*}}vector<2xf16>
// DOT-B-NOT: wave.alloc()
// DOT-B: return
func.func @glu_blocked_to_dot_operand_b(
    %source: !wave.simd<vector<16xf16>, 64>)
    -> !wave.simd<vector<32xf16>, 64>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 512,
       source_block = "block",
       source_item = "128*floor(1/16*Mod(item, 64)) + 64*Mod(floor(1/4*slot), 2) + xor(4*Mod(floor(1/128*item), 2), xor(2*Mod(floor(1/64*item), 2), xor(Mod(floor(1/8*Mod(item, 64)), 2), xor(16*Mod(slot, 2) + 32*Mod(floor(1/2*slot), 2), 8*Mod(floor(1/16*slot), 2)))))",
       source_slot = "xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*slot), 2) + Mod(Mod(item, 64), 2), 2*Mod(floor(1/2*Mod(item, 64)), 2)))">
      : !wave.simd<vector<16xf16>, 64>
     -> !wave.simd<vector<32xf16>, 64>
  return %result : !wave.simd<vector<32xf16>, 64>
}
