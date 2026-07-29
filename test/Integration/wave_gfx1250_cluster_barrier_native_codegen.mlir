// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @cluster_barrier_native_codegen(
// IR-SAME: wave.lds_size = 128 : i64
// IR-NOT: waveamdmachine.cluster_barrier
// IR-NOT: waveamdmachine.barrier_init
// IR-NOT: waveamdmachine.ds_add_rtn_u32
// IR: waveamdmachine.s_cmp_eq_u32_barrier_seed
// IR: waveamdmachine.s_barrier_signal_isfirst
// IR: waveamdmachine.s_barrier_wait
// IR: waveamdmachine.uniform_if
// IR: waveamdmachine.s_barrier_signal {{.*}} scope cluster
// IR: waveamdmachine.s_barrier_wait {{.*}} scope cluster

// ASM-LABEL: cluster_barrier_native_codegen:
// ASM-NOT: ds_add_rtn_u32
// ASM-NOT: s_sleep
// ASM: ds_store_b32
// ASM: s_cmp_eq_u32 0, 0
// ASM: s_wait_dscnt 0x0
// ASM-NEXT: s_barrier_signal_isfirst -1
// ASM-NEXT: s_barrier_wait -1
// ASM: s_cbranch_scc0
// ASM: s_barrier_signal -3
// ASM: s_barrier_wait -3
// ASM: ds_load_b32
// ASM-NOT: ds_add_rtn_u32
// ASM-NOT: s_sleep
// ASM: .amdhsa_group_segment_fixed_size 128
// ASM: .cluster_dims: [ 2, 1, 1 ]

// DIS-LABEL: <cluster_barrier_native_codegen>:
// DIS: s_cmp_eq_u32 0, 0
// DIS: s_barrier_signal_isfirst -1
// DIS-NEXT: s_barrier_wait 0xffff
// DIS: s_cbranch_scc0
// DIS: s_barrier_signal -3
// DIS: s_barrier_wait 0xfffd

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @cluster_barrier_native_codegen(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {
      wave.kernel,
      gpu.known_cluster_size = array<i32: 2, 1, 1>,
      wave.cluster_dims = array<i32: 2, 1, 1>,
      wave.workgroup_size = array<i32: 64, 1, 1>
    } {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %lds_ptr = wave.ptr_add %allocation, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %lds_ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %ready = wave.barrier %stored scope cluster
      : (!wave.mem.token) -> !wave.mem.token
  %value, %loaded = wave.load %lds_ptr after %ready
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %global_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %done = wave.store %value -> %global_ptr after %loaded
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
