// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},waveamd-barrier-cleanup,waveamd-materialize-split-barriers,transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},waveamd-barrier-cleanup,waveamd-materialize-split-barriers,transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: split_barrier_lds_codegen:
// ASM: ds_write_b32
// ASM: s_waitcnt lgkmcnt(0)
// ASM: s_barrier
// ASM: ds_write_b32
// ASM: s_waitcnt lgkmcnt(0)
// ASM: ds_add_rtn_u32
// ASM: s_waitcnt lgkmcnt(0)
// ASM: v_readfirstlane_b32
// ASM: s_add_i32
// ASM: s_and_saveexec_b64
// ASM-NEXT: .Lsplit_barrier_lds_codegen.loop_head_0:
// ASM: ds_read_b32
// ASM: s_xor_b32
// ASM: s_cmp_ge_u32 {{.*}}, 0x80000000
// ASM: s_cbranch_scc1 .Lsplit_barrier_lds_codegen.loop_head_0
// ASM-NEXT: .Lsplit_barrier_lds_codegen.loop_exit_0:
// ASM-NEXT: s_mov_b64 exec
// ASM: .amdhsa_group_segment_fixed_size 1040
func.func @split_barrier_lds_codegen()
    attributes {wave.kernel, wave.lds_size = 1024 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %store = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %store
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %loaded, %load_tok = waveamdmachine.ds_load_b32 %addr after %ready
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
