//===- lower-redistribute-fa-dynamic-repro.mlir ----------------*- MLIR -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,canonicalize,cse)' > %t
// RUN: FileCheck %s --check-prefix=PERMLANE < %t
// RUN: FileCheck %s --check-prefix=LOCAL < %t
// RUN: wave-opt %s --pass-pipeline='builtin.module(wave-lower-redistribute,waveamd-to-machine,canonicalize,cse)' | FileCheck %s --check-prefix=MACHINE

// PERMLANE-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// PERMLANE-COUNT-16: waveamd.permlane32_swap
// PERMLANE-NOT: wave.shuffle
// PERMLANE-NOT: wave.select
// PERMLANE: return
// LOCAL-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// LOCAL-NOT: wave.alloc
// LOCAL-NOT: wave.barrier
// LOCAL: return
// MACHINE-LABEL: func.func @fa_mfma_to_linear_dynamic_slot(
// MACHINE-COUNT-16: waveamdmachine.v_permlane32_swap_b32_tuple
// MACHINE-NOT: waveamdmachine.ds_bpermute_b32
// MACHINE: return
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
}
