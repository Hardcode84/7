//===- lower-redistribute-glu-repro.mlir -----------------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,wave-normalize-pointer-offsets,wave-generate-index-exprs,wave-simplify-index-exprs,wave-coalesce-memory,canonicalize,cse)' > %t
// RUN: FileCheck %s --check-prefixes=F32-256,F32-512,DOT-A,DOT-B < %t
// RUN: FileCheck %s --check-prefix=DOT-B-CANONICAL < %t
// RUN: FileCheck %s --check-prefix=CAPACITY < %t

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
// DOT-A: wave.index_expr
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

// The TLX bridge's canonical GF(2) relation is algebraically identical to
// @glu_blocked_to_dot_operand_b.  Packet and scratch planning must therefore
// recover the same two-element source groups instead of duplicating one used
// element across 32 loads.
// DOT-B-CANONICAL-LABEL: func.func @glu_blocked_to_dot_operand_b_canonical(
// DOT-B-CANONICAL: wave.alloc() {align = 4 : i64, bytesize = 16384 : i64}
// DOT-B-CANONICAL-COUNT-8: wave.store {{.*}}vector<2xf16>
// DOT-B-CANONICAL: wave.barrier
// DOT-B-CANONICAL-COUNT-16: wave.load {{.*}}vector<2xf16>
// DOT-B-CANONICAL-NOT: wave.alloc()
// DOT-B-CANONICAL: return
func.func @glu_blocked_to_dot_operand_b_canonical(
    %source: !wave.simd<vector<16xf16>, 64>)
    -> !wave.simd<vector<32xf16>, 64>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 512,
       source_block = "0",
       source_item = "8*floor(1/16*slot) + 128*floor(1/16*Mod(item, 64)) + 16*Mod(slot, 8) + 4*Mod(floor(1/128*item), 2) + 2*Mod(floor(1/64*item), 2) + Mod(floor(1/8*Mod(item, 64)), 2)",
       source_slot = "Mod(8*floor(1/8*slot) + Mod(item, 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2), 16)">
      : !wave.simd<vector<16xf16>, 64>
     -> !wave.simd<vector<32xf16>, 64>
  return %result : !wave.simd<vector<32xf16>, 64>
}

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"
} {
  // Result group spans more source groups than remaining LDS holds.
  // CAPACITY-LABEL: func.func @capacity_bounded_partial_result_group(
  // CAPACITY: wave.alloc() {align = 16 : i64, bytesize = 4096 : i64, offset = 159744 : i64}
  // CAPACITY: wave.cmpi eq
  // CAPACITY: wave.where
  // CAPACITY: wave.load
  // CAPACITY: wave.cmpi eq
  // CAPACITY: wave.where
  // CAPACITY: wave.load
  // CAPACITY-NOT: wave.redistribute
  // CAPACITY: return
  func.func @capacity_bounded_partial_result_group(
      %source: !wave.simd<vector<16xf32>, 64>)
      -> !wave.simd<vector<4xf32>, 64>
      attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
    %live = wave.alloc() {align = 16 : i64, bytesize = 159744 : i64}
        : !wave.ptr<#wave.shared, f32>
    %result = wave.redistribute %source,
        <blocks = 1, items = 128,
         source_block = "block",
         source_item = "Mod(item + 64, 128)",
         source_slot = "4*Mod(floor(1/32*item), 4) + slot">
        : !wave.simd<vector<16xf32>, 64>
       -> !wave.simd<vector<4xf32>, 64>
    %keep_live = wave.ptr_cast %live
        : !wave.ptr<#wave.shared, f32> -> !wave.ptr<#wave.shared, i32>
    return %result : !wave.simd<vector<4xf32>, 64>
  }
}
