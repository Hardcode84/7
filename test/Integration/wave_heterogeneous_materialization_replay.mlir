// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' -o %t.selected
// RUN: wave-opt %t.selected --pass-pipeline='builtin.module(waveamd-machine-multi-wave-specialize,waveamd-expand-materialization-variants,func.func(waveamd-cleanup-materialization-variants))' -o %t.expanded
// RUN: FileCheck %s --check-prefix=MIXED < %t.expanded
// RUN: wave-opt %t.expanded --waveamd-machine-schedule='apply-schedule=true require-selected-input=true' -o %t.scored
// RUN: FileCheck %s --check-prefix=SCORE < %t.scored
// RUN: wave-opt %t.scored --waveamd-collapse-materialization-variants -o %t.winner
// RUN: FileCheck %s --check-prefix=WINNER --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.multi_wave_schedule < %t.winner
// RUN: wave-translate %t.winner --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// Mixed candidate: one multiply versus two adds. Branch graph sizes differ.
// MIXED: waveamdmachine.candidate_yield
// MIXED: waveamdmachine.uniform_if
// MIXED: waveamdmachine.uniform_loop
// MIXED: waveamdmachine.v_mul_lo_u32
// MIXED: } otherwise {
// MIXED: waveamdmachine.uniform_loop
// MIXED: waveamdmachine.v_add_u32
// MIXED: waveamdmachine.v_add_u32
// MIXED: waveamdmachine.candidate_yield
// SCORE-COUNT-4: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
// WINNER: waveamdmachine.uniform_if
// WINNER-COUNT-2: waveamdmachine.uniform_loop
// WINNER: waveamdmachine.buffer_store_b32
// ASM-LABEL: heterogeneous_choices:
// ASM: s_cbranch_scc0
// ASM: .Lheterogeneous_choices.loop_head_0:
// ASM: s_cbranch_scc1 .Lheterogeneous_choices.loop_head_0
// ASM: .Lheterogeneous_choices.loop_head_1:
// ASM: s_cbranch_scc1 .Lheterogeneous_choices.loop_head_1
// ASM: buffer_store_dword
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @heterogeneous_choices(%out: !wave.ptr<#wave.global, i32>, %x: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.enable_multi_wave_specialization, waveamdmachine.target_waves = 2 : i64} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %three = arith.constant 3 : i32
  %four = arith.constant 4 : i32
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %init = wave.binary addi %lane, %x : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
  %result = scf.for %i = %zero to %four step %one iter_args(%carry = %init) -> !wave.simd<i32, 64> : i32 {
    %mul = wave.binary muli %carry, %three : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
    %add = wave.binary addi %carry, %carry : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %sum = wave.binary addi %add, %carry : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %choice = wave.materialization_variants %mul, %sum : !wave.simd<i32, 64>
    scf.yield %choice : !wave.simd<i32, 64>
  }
  %ptr = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %result -> %ptr : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return %stored : !wave.mem.token
}
}
