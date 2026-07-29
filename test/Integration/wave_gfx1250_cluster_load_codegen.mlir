// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @cluster_load_codegen
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR: {{%.*}}, [[B32:%.*]] = waveamdmachine.cluster_load_b32 {{.*}}, [[M0]]
// IR: waveamdmachine.s_waitcnt_split loadcnt(0)
// IR: {{%.*}}, [[B64:%.*]] = waveamdmachine.cluster_load_b64 {{.*}}, [[M0]] after [[B32]]
// IR: waveamdmachine.s_waitcnt_split loadcnt(0)
// IR: {{%.*}}, [[B128:%.*]] = waveamdmachine.cluster_load_b128 {{.*}}, [[M0]] after [[B64]]
// IR: waveamdmachine.s_waitcnt_split loadcnt(0)
// IR: [[A8:%.*]] = waveamdmachine.cluster_load_async_to_lds_b8 {{.*}}, [[M0]] after [[B128]]
// IR: waveamdmachine.s_waitcnt_split asynccnt(0)
// IR: [[A32:%.*]] = waveamdmachine.cluster_load_async_to_lds_b32 {{.*}}, [[M0]] after [[A8]]
// IR: waveamdmachine.s_waitcnt_split asynccnt(0)
// IR: [[A64:%.*]] = waveamdmachine.cluster_load_async_to_lds_b64 {{.*}}, [[M0]] after [[A32]]
// IR: waveamdmachine.s_waitcnt_split asynccnt(0)
// IR: waveamdmachine.cluster_load_async_to_lds_b128 {{.*}}, [[M0]] after [[A64]]

// ASM-LABEL: cluster_load_codegen:
// ASM: s_mov_b32 m0
// ASM: cluster_load_b32
// ASM: s_wait_loadcnt 0x0
// ASM: cluster_load_b64
// ASM: s_wait_loadcnt 0x0
// ASM: cluster_load_b128
// ASM: s_wait_loadcnt 0x0
// ASM: cluster_load_async_to_lds_b8
// ASM: s_wait_asynccnt 0x0
// ASM: cluster_load_async_to_lds_b32
// ASM: s_wait_asynccnt 0x0
// ASM: cluster_load_async_to_lds_b64
// ASM: s_wait_asynccnt 0x0
// ASM: cluster_load_async_to_lds_b128
// ASM: s_endpgm

// DIS-LABEL: <cluster_load_codegen>:
// DIS: cluster_load_b32
// DIS: s_wait_loadcnt 0x0
// DIS: cluster_load_b64
// DIS: s_wait_loadcnt 0x0
// DIS: cluster_load_b128
// DIS: s_wait_loadcnt 0x0
// DIS: cluster_load_async_to_lds_b8
// DIS: s_wait_asynccnt 0x0
// DIS: cluster_load_async_to_lds_b32
// DIS: s_wait_asynccnt 0x0
// DIS: cluster_load_async_to_lds_b64
// DIS: s_wait_asynccnt 0x0
// DIS: cluster_load_async_to_lds_b128

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @cluster_load_codegen() attributes {
    wave.kernel,
    gpu.known_cluster_size = array<i32: 4, 1, 1>,
    wave.cluster_dims = array<i32: 4, 1, 1>,
    wave.workgroup_size = array<i32: 32, 1, 1>
  } {
  %lds = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %global = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2>
  %mask_imm = waveamdmachine.imm 15 : !waveamdmachine.imm
  %mask = waveamdmachine.s_mov_b32_tuple %mask_imm
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %v32, %b32 = waveamdmachine.cluster_load_b32
      %global, %base, %m0 after %root offset -64
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %v64, %b64 = waveamdmachine.cluster_load_b64
      %global, %base, %m0 after %b32 offset 64
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>,
            !waveamdmachine.mem.token)
  %v128, %b128 = waveamdmachine.cluster_load_b128
      %global, %base, %m0 after %b64 offset 128
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4>,
            !waveamdmachine.mem.token)
  %a8 = waveamdmachine.cluster_load_async_to_lds_b8
      %lds, %global, %base, %m0 after %b128 offset -32
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a32 = waveamdmachine.cluster_load_async_to_lds_b32
      %lds, %global, %base, %m0 after %a8 offset 32
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a64 = waveamdmachine.cluster_load_async_to_lds_b64
      %lds, %global, %base, %m0 after %a32 offset 96
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a128 = waveamdmachine.cluster_load_async_to_lds_b128
      %lds, %global, %base, %m0 after %a64 offset 160
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
