// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-readobj --notes %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=META
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=DIS
// RUN: %python %S/Inputs/gfx1250_cluster_ctypes_runner.py --hsaco=%t.hsaco \
// RUN:   > %t.run
// RUN: FileCheck %s --check-prefix=RUNTIME < %t.run

// IR-LABEL: func.func @gfx1250_cluster_load(
// IR: waveamdmachine.global_store_b32
// IR: waveamdmachine.s_waitcnt_split storecnt(0)
// IR: waveamdmachine.s_barrier_signal_isfirst
// IR: waveamdmachine.s_barrier_wait
// IR: waveamdmachine.s_barrier_signal {{.*}} scope cluster
// IR: waveamdmachine.s_barrier_wait {{.*}} scope cluster
// IR: waveamdmachine.cluster_load_b32
// IR: waveamdmachine.s_waitcnt_split loadcnt(0)
// IR: waveamdmachine.global_store_b32

// IR-LABEL: func.func @gfx1250_cluster_load_async(
// IR: waveamdmachine.global_store_b32
// IR: waveamdmachine.s_waitcnt_split storecnt(0)
// IR: waveamdmachine.s_barrier_signal_isfirst
// IR: waveamdmachine.s_barrier_wait
// IR: waveamdmachine.s_barrier_signal {{.*}} scope cluster
// IR: waveamdmachine.s_barrier_wait {{.*}} scope cluster
// IR: waveamdmachine.cluster_load_async_to_lds_b32
// IR: waveamdmachine.s_waitcnt_split asynccnt(0)
// IR: waveamdmachine.ds_load_b32
// IR: waveamdmachine.s_waitcnt_split dscnt(0)
// IR: waveamdmachine.global_store_b32

// ASM-LABEL: gfx1250_cluster_load:
// ASM: global_store_b32
// ASM: s_wait_storecnt 0x0
// ASM: s_barrier_signal_isfirst -1
// ASM: s_barrier_wait -1
// ASM: s_barrier_signal -3
// ASM: s_barrier_wait -3
// ASM: s_mov_b32 [[MASK:s[0-9]+]], 15
// ASM-NEXT: s_mov_b32 m0, [[MASK]]
// ASM: cluster_load_b32
// ASM: s_wait_loadcnt 0x0
// ASM: global_store_b32

// ASM-LABEL: gfx1250_cluster_load_async:
// ASM: global_store_b32
// ASM: s_wait_storecnt 0x0
// ASM: s_barrier_signal_isfirst -1
// ASM: s_barrier_wait -1
// ASM: s_barrier_signal -3
// ASM: s_barrier_wait -3
// ASM: s_mov_b32 [[ASYNC_MASK:s[0-9]+]], 15
// ASM-NEXT: s_mov_b32 m0, [[ASYNC_MASK]]
// ASM: cluster_load_async_to_lds_b32
// ASM: s_wait_asynccnt 0x0
// ASM: ds_load_b32
// ASM: s_wait_dscnt 0x0
// ASM: global_store_b32
// ASM: .amdhsa_group_segment_fixed_size 512

// DIS-LABEL: <gfx1250_cluster_load>:
// DIS: cluster_load_b32
// DIS: s_wait_loadcnt 0x0
// DIS-LABEL: <gfx1250_cluster_load_async>:
// DIS: cluster_load_async_to_lds_b32
// DIS: s_wait_asynccnt 0x0
// DIS: ds_load_b32
// DIS: s_wait_dscnt 0x0

// META: .cluster_dims:
// META-NEXT: 4
// META-NEXT: 1
// META-NEXT: 1
// META: .name: gfx1250_cluster_load
// META: .cluster_dims:
// META-NEXT: 4
// META-NEXT: 1
// META-NEXT: 1
// META: .name: gfx1250_cluster_load_async

// RUNTIME: gfx1250 cluster runtime {{passed|skipped: gfx1250 unavailable}}

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @gfx1250_cluster_load(
    %scratch: !wave.ptr<#wave.global, i32>,
    %output: !wave.ptr<#wave.global, i32>) attributes {
    wave.kernel,
    gpu.known_cluster_size = array<i32: 4, 1, 1>,
    wave.cluster_dims = array<i32: 4, 1, 1>,
    wave.workgroup_size = array<i32: 128, 1, 1>,
    wave.waves_per_workgroup = 4 : i64
  } {
  %scratch_base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %output_base = waveamdmachine.arg {index = 1 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %cluster = waveamdmachine.s_cluster_id_x
      : !waveamdmachine.reg<sgpr, 1>
  %cluster_workgroup, %cluster_workgroup_scc =
      waveamdmachine.s_cluster_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1>,
        !waveamdmachine.reg<scc, 1>
  %thread = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %nine = waveamdmachine.imm 9 : !waveamdmachine.imm
  %eleven = waveamdmachine.imm 11 : !waveamdmachine.imm
  %lane_bytes = waveamdmachine.v_lshlrev_b32 %thread, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cluster_workgroups, %cluster_workgroups_scc =
      waveamdmachine.s_lshl_b32 %cluster, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup, %workgroup_scc = waveamdmachine.s_add_i32
      %cluster_workgroups, %cluster_workgroup
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup_bytes, %workgroup_bytes_scc =
      waveamdmachine.s_lshl_b32 %workgroup, %nine
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup_offset =
      waveamdmachine.v_add_u32 %workgroup_bytes, %lane_bytes
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %workgroup_elements, %workgroup_elements_scc =
      waveamdmachine.s_lshl_b32 %workgroup, %seven
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %global_id = waveamdmachine.v_add_u32 %workgroup_elements, %thread
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %stored = waveamdmachine.global_store_b32
      %workgroup_offset, %global_id, %scratch_base
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  %ready = waveamdmachine.cluster_barrier %stored
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %cluster_bytes, %cluster_bytes_scc =
      waveamdmachine.s_lshl_b32 %cluster, %eleven
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %cluster_offset =
      waveamdmachine.v_add_u32 %cluster_bytes, %lane_bytes
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %mask_imm = waveamdmachine.imm 15 : !waveamdmachine.imm
  %mask = waveamdmachine.s_mov_b32_tuple %mask_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %value, %loaded = waveamdmachine.cluster_load_b32
      %cluster_offset, %scratch_base, %m0 after %ready
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %result = waveamdmachine.global_store_b32
      %workgroup_offset, %value, %output_base after %loaded
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

func.func @gfx1250_cluster_load_async(
    %scratch: !wave.ptr<#wave.global, i32>,
    %output: !wave.ptr<#wave.global, i32>) attributes {
    wave.kernel,
    gpu.known_cluster_size = array<i32: 4, 1, 1>,
    wave.cluster_dims = array<i32: 4, 1, 1>,
    wave.lds_size = 512 : i64,
    wave.workgroup_size = array<i32: 128, 1, 1>,
    wave.waves_per_workgroup = 4 : i64
  } {
  %scratch_base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %output_base = waveamdmachine.arg {index = 1 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %cluster = waveamdmachine.s_cluster_id_x
      : !waveamdmachine.reg<sgpr, 1>
  %cluster_workgroup, %cluster_workgroup_scc =
      waveamdmachine.s_cluster_workgroup_id_x
      : !waveamdmachine.reg<sgpr, 1>,
        !waveamdmachine.reg<scc, 1>
  %thread = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %nine = waveamdmachine.imm 9 : !waveamdmachine.imm
  %eleven = waveamdmachine.imm 11 : !waveamdmachine.imm
  %lane_bytes = waveamdmachine.v_lshlrev_b32 %thread, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cluster_workgroups, %cluster_workgroups_scc =
      waveamdmachine.s_lshl_b32 %cluster, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup, %workgroup_scc = waveamdmachine.s_add_i32
      %cluster_workgroups, %cluster_workgroup
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup_bytes, %workgroup_bytes_scc =
      waveamdmachine.s_lshl_b32 %workgroup, %nine
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %workgroup_offset =
      waveamdmachine.v_add_u32 %workgroup_bytes, %lane_bytes
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %workgroup_elements, %workgroup_elements_scc =
      waveamdmachine.s_lshl_b32 %workgroup, %seven
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %global_id = waveamdmachine.v_add_u32 %workgroup_elements, %thread
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %stored = waveamdmachine.global_store_b32
      %workgroup_offset, %global_id, %scratch_base
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.mem.token
  %ready = waveamdmachine.cluster_barrier %stored
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %cluster_bytes, %cluster_bytes_scc =
      waveamdmachine.s_lshl_b32 %cluster, %eleven
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>,
            !waveamdmachine.reg<scc, 1>)
  %cluster_offset =
      waveamdmachine.v_add_u32 %cluster_bytes, %lane_bytes
      : (!waveamdmachine.reg<sgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %mask_imm = waveamdmachine.imm 15 : !waveamdmachine.imm
  %mask = waveamdmachine.s_mov_b32_tuple %mask_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %async = waveamdmachine.cluster_load_async_to_lds_b32
      %lane_bytes, %cluster_offset, %scratch_base, %m0 after %ready
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %value, %lds_loaded = waveamdmachine.ds_load_b32
      %lane_bytes after %async
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %result = waveamdmachine.global_store_b32
      %workgroup_offset, %value, %output_base after %lds_loaded
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
