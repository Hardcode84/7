// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},waveamd-barrier-cleanup,waveamd-materialize-split-barriers,transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},waveamd-barrier-cleanup,waveamd-materialize-split-barriers,transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// ASM-LABEL: split_barrier_native_codegen:
// ASM-NOT: ds_add_rtn_u32
// ASM-NOT: s_sleep
// ASM-NOT: v_readfirstlane_b32
// ASM: s_barrier_signal -1
// ASM-NEXT: v_add_nc_u32_e32
// ASM-NEXT: s_barrier_wait -1
// ASM-NOT: ds_add_rtn_u32
// ASM-NOT: s_sleep
// ASM-NOT: v_readfirstlane_b32
// ASM: .amdhsa_group_segment_fixed_size 1024
// DIS-LABEL: <split_barrier_native_codegen>:
// DIS: s_barrier_signal -1
// DIS-NEXT: v_add_nc_u32_e32
// DIS-NEXT: s_barrier_wait 0xffff
func.func @split_barrier_native_codegen()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %before = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %before
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %addr, %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %sum, %value after %ready
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
