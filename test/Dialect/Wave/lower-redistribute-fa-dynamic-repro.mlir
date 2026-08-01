//===- lower-redistribute-fa-dynamic-repro.mlir ----------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,canonicalize,cse)' > %t
// RUN: FileCheck %s --check-prefix=SHUFFLE < %t
// RUN: FileCheck %s --check-prefix=SELECT < %t
// RUN: FileCheck %s --check-prefix=LOCAL < %t
// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,waveamd-to-machine,canonicalize,cse,waveamd-form-fused-int,waveamd-cross-lane-peepholes,canonicalize,cse)' \
// RUN:   | FileCheck %s --check-prefix=PERMLANE

// SHUFFLE-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// SHUFFLE-COUNT-64: wave.shuffle {{.*}}!wave.simd<vector<4xbf16>, 64>
// SHUFFLE-NOT: wave.shuffle
// SHUFFLE: return
// SELECT-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// SELECT-COUNT-32: wave.select {{.*}}!wave.simd<vector<4xbf16>, 64>
// SELECT-NOT: wave.select
// SELECT: return
// LOCAL-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// LOCAL-NOT: wave.alloc
// LOCAL-NOT: wave.barrier
// LOCAL: return
// PERMLANE-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// PERMLANE-COUNT-16: waveamdmachine.v_permlane32_swap_b32_tuple
// PERMLANE-NOT: waveamdmachine.ds_bpermute_b32
// PERMLANE-NOT: waveamdmachine.v_cndmask_b32_tuple
// PERMLANE: return
// SHUFFLE-LABEL: func.func @fa_permuted_source_slots(
// SHUFFLE-COUNT-32: wave.shuffle {{.*}}!wave.simd<vector<4xbf16>, 64>
// SHUFFLE-NOT: wave.shuffle
// SHUFFLE: return
// LOCAL-LABEL: func.func @fa_permuted_source_slots(
// LOCAL-NOT: wave.alloc
// LOCAL-NOT: wave.barrier
// LOCAL: return
// PERMLANE-LABEL: func.func @fa_permuted_source_slots(
// PERMLANE-COUNT-8: waveamdmachine.v_permlane32_swap_b32_tuple
// PERMLANE-NOT: waveamdmachine.ds_bpermute_b32
// PERMLANE: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @fa_mfma_to_linear_dynamic_slot(
    %source: !wave.simd<vector<128xbf16>, 64>)
    -> !wave.simd<vector<128xbf16>, 64>
    attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 256,
       source_block = "block",
       source_item = "128*Mod(floor(1/128*item), 2) + 64*Mod(floor(1/64*item), 2) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2) + Mod(Mod(item, 64), 2), 2*Mod(floor(1/2*Mod(item, 64)), 2)))))",
       source_slot = "xor(Mod(slot, 2) + 64*Mod(floor(1/64*slot), 2) + 32*Mod(floor(1/32*slot), 2) + 16*Mod(floor(1/16*slot), 2) + 8*Mod(floor(1/8*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*floor(1/32*Mod(item, 64)))">
      : !wave.simd<vector<128xbf16>, 64>
     -> !wave.simd<vector<128xbf16>, 64>
  return %result : !wave.simd<vector<128xbf16>, 64>
}

func.func @fa_permuted_source_slots(
    %source: !wave.simd<vector<64xbf16>, 64>)
    -> !wave.simd<vector<64xbf16>, 64>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 512,
       source_block = "block",
       source_item = "64*floor(1/64*item) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(2*Mod(floor(1/2*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2), Mod(Mod(item, 64), 2))))))",
       source_slot = "xor(16*Mod(floor(1/32*Mod(item, 64)), 2), xor(Mod(floor(1/32*slot), 2), xor(2*Mod(floor(1/16*slot), 2), xor(32*Mod(floor(1/8*slot), 2), xor(4*Mod(slot, 2), 8*Mod(floor(1/2*slot), 2))))))">
      : !wave.simd<vector<64xbf16>, 64>
     -> !wave.simd<vector<64xbf16>, 64>
  return %result : !wave.simd<vector<64xbf16>, 64>
}

// SHUFFLE-LABEL: func.func @small_permuted_source_slots(
// SHUFFLE-SAME: [[SOURCE:%.*]]: !wave.simd<vector<8xbf16>, 64>
// SHUFFLE: [[S0:%.*]] = wave.extract [[SOURCE]][0]
// SHUFFLE: [[S2:%.*]] = wave.extract [[SOURCE]][2]
// SHUFFLE: [[S4:%.*]] = wave.extract [[SOURCE]][4]
// SHUFFLE: [[S6:%.*]] = wave.extract [[SOURCE]][6]
// SHUFFLE: [[PACKED:%.*]] = wave.pack [[S0]], [[S2]], [[S4]], [[S6]]
// SHUFFLE: [[MOVED:%.*]] = wave.shuffle [[PACKED]]
// SHUFFLE-NOT: wave.shuffle
// SHUFFLE: return [[MOVED]]
func.func @small_permuted_source_slots(
    %source: !wave.simd<vector<8xbf16>, 64>)
    -> !wave.simd<vector<4xbf16>, 64>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 1)", source_slot = "2*slot">
      : !wave.simd<vector<8xbf16>, 64>
     -> !wave.simd<vector<4xbf16>, 64>
  return %result : !wave.simd<vector<4xbf16>, 64>
}
}
