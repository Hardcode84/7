// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS
// RUN: llvm-readobj --notes %t.o \
// RUN:   | FileCheck %s --check-prefix=META

// IR-LABEL: func.func @cluster_ids
// IR-SAME: gpu.known_cluster_size = array<i32: 2, 2, 1>
// IR-SAME: wave.cluster_dims = array<i32: 2, 2, 1>
// IR: waveamdmachine.s_cluster_id_x
// IR: waveamdmachine.s_cluster_id_y
// IR: waveamdmachine.s_cluster_id_z
// IR: waveamdmachine.s_cluster_workgroup_id_x
// IR: waveamdmachine.s_cluster_workgroup_id_y
// IR-NOT: waveamdmachine.s_cluster_workgroup_id_z
// IR-NOT: waveamdmachine.s_cluster_workgroup_max_id

// ASM-LABEL: cluster_ids:
// ASM: s_mov_b32 [[WG:s[0-9]+]], ttmp9
// ASM-NEXT: s_and_b32 [[LOCAL:s[0-9]+]], ttmp6, 15
// ASM-NEXT: s_mul_i32 [[WG]], [[WG]], 2
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM-NEXT: s_add_co_i32 [[WG]], [[WG]], [[LOCAL]]
// ASM-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// ASM-NOT: s_getreg_b32
// ASM: s_mov_b32 {{s[0-9]+}}, ttmp9
// ASM: s_and_b32 {{s[0-9]+}}, ttmp7, 0xffff
// ASM: s_lshr_b32 {{s[0-9]+}}, ttmp7, 16
// ASM: s_and_b32 {{s[0-9]+}}, ttmp6, 15
// ASM: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40004
// ASM-NOT: 0x40008
// ASM: s_endpgm
// ASM: .amdhsa_system_sgpr_workgroup_id_y 1
// ASM: .amdhsa_system_sgpr_workgroup_id_z 1

// DIS-LABEL: <cluster_ids>:
// DIS: s_mov_b32 [[WG:s[0-9]+]], ttmp9
// DIS-NEXT: s_and_b32 [[LOCAL:s[0-9]+]], ttmp6, 15
// DIS-NEXT: s_mul_i32 [[WG]], [[WG]], 2
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS-NEXT: s_add_co_i32 [[WG]], [[WG]], [[LOCAL]]
// DIS-NEXT: s_delay_alu instid0(SALU_CYCLE_1)
// DIS-NOT: s_getreg_b32
// DIS: s_mov_b32 {{s[0-9]+}}, ttmp9
// DIS: s_and_b32 {{s[0-9]+}}, ttmp7, 0xffff
// DIS: s_lshr_b32 {{s[0-9]+}}, ttmp7, 16
// DIS: s_and_b32 {{s[0-9]+}}, ttmp6, 15
// DIS: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40004
// DIS-NOT: 0x40008
// DIS: s_endpgm

// META: .cluster_dims:
// META: 2
// META: 2
// META: 1
// META: .name: cluster_ids

// IR-LABEL: func.func @runtime_cluster_ids
// IR: waveamdmachine.s_cluster_workgroup_id_z
// IR: waveamdmachine.s_cluster_workgroup_max_id_z

// ASM-LABEL: runtime_cluster_ids:
// ASM: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40008
// ASM: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40014
// ASM: s_endpgm

// DIS-LABEL: <runtime_cluster_ids>:
// DIS: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40008
// DIS: s_bfe_u32 {{s[0-9]+}}, ttmp6, 0x40014
// DIS: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

func.func @cluster_ids(%out: !wave.ptr<#wave.global, i32>) attributes {
    wave.kernel,
    gpu.known_cluster_size = array<i32: 2, 2, 1>,
    wave.cluster_dims = array<i32: 2, 2, 1>
  } {
  %global = wave.workgroup_id 0
  %cluster_x = wave.cluster_id x
  %cluster_y = wave.cluster_id y
  %cluster_z = wave.cluster_id z
  %local_x = wave.cluster_workgroup_id x
  %local_y = wave.cluster_workgroup_id y
  %local_z = wave.cluster_workgroup_id z
  %max_x = wave.cluster_workgroup_max_id x
  %max_y = wave.cluster_workgroup_max_id y
  %max_z = wave.cluster_workgroup_max_id z
  %sum0 = wave.binary addi %global, %cluster_x : i32, i32 -> i32
  %sum1 = wave.binary addi %sum0, %cluster_y : i32, i32 -> i32
  %sum2 = wave.binary addi %sum1, %cluster_z : i32, i32 -> i32
  %sum3 = wave.binary addi %sum2, %local_x : i32, i32 -> i32
  %sum4 = wave.binary addi %sum3, %local_y : i32, i32 -> i32
  %sum5 = wave.binary addi %sum4, %local_z : i32, i32 -> i32
  %sum6 = wave.binary addi %sum5, %max_x : i32, i32 -> i32
  %sum7 = wave.binary addi %sum6, %max_y : i32, i32 -> i32
  %sum8 = wave.binary addi %sum7, %max_z : i32, i32 -> i32
  %value = wave.splat %sum8 : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

func.func @runtime_cluster_ids(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %local_z = wave.cluster_workgroup_id z
  %max_z = wave.cluster_workgroup_max_id z
  %sum = wave.binary addi %local_z, %max_z : i32, i32 -> i32
  %value = wave.splat %sum : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
