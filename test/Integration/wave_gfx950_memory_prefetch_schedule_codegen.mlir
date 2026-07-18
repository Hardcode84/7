// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: memory_prefetch_schedule_codegen:
// ASM: global_load_dword v4, v0, s[0:1]
// ASM-NEXT: v_add_u32_e32 v5
// ASM-NEXT: v_add_u32_e32 v6
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: v_add_u32_e32 v7, v6, v4
func.func @memory_prefetch_schedule_codegen() attributes {wave.kernel} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %ptr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %y = waveamdmachine.v_add_u32 %x, %c
      : (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  %loaded, %tok = waveamdmachine.global_load_b32 %off, %ptr after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %y, %loaded
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: long_latency_memory_prefetch_schedule_codegen:
// ASM: global_load_dword v4, v0, s[0:1]{{.*}}sc0 nt
// ASM-NEXT: global_load_dword v5, v1, s[0:1]{{.*}}sc0 nt
// ASM-NEXT: v_add_u32_e32 v6
// ASM: v_add_u32_e32 v26
// ASM-NEXT: s_waitcnt vmcnt(1)
// ASM-NEXT: v_add_u32_e32 v27, v26, v4
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: v_add_u32_e32 v28, v27, v5
func.func @long_latency_memory_prefetch_schedule_codegen()
    attributes {wave.kernel, waveamdmachine.target_waves = 2 : i64} {
  %off0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %off1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %ptr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 3>
  %v0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  %v1 = waveamdmachine.v_add_u32 %v0, %b
      : (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  %v2 = waveamdmachine.v_add_u32 %v1, %b
      : (!waveamdmachine.reg<vgpr, 1, 7>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 8>
  %v3 = waveamdmachine.v_add_u32 %v2, %b
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 9>
  %v4 = waveamdmachine.v_add_u32 %v3, %b
      : (!waveamdmachine.reg<vgpr, 1, 9>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  %v5 = waveamdmachine.v_add_u32 %v4, %b
      : (!waveamdmachine.reg<vgpr, 1, 10>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 11>
  %v6 = waveamdmachine.v_add_u32 %v5, %b
      : (!waveamdmachine.reg<vgpr, 1, 11>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 12>
  %v7 = waveamdmachine.v_add_u32 %v6, %b
      : (!waveamdmachine.reg<vgpr, 1, 12>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 13>
  %v8 = waveamdmachine.v_add_u32 %v7, %b
      : (!waveamdmachine.reg<vgpr, 1, 13>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 14>
  %v9 = waveamdmachine.v_add_u32 %v8, %b
      : (!waveamdmachine.reg<vgpr, 1, 14>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 15>
  %v10 = waveamdmachine.v_add_u32 %v9, %b
      : (!waveamdmachine.reg<vgpr, 1, 15>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 16>
  %v11 = waveamdmachine.v_add_u32 %v10, %b
      : (!waveamdmachine.reg<vgpr, 1, 16>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 17>
  %v12 = waveamdmachine.v_add_u32 %v11, %b
      : (!waveamdmachine.reg<vgpr, 1, 17>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 18>
  %v13 = waveamdmachine.v_add_u32 %v12, %b
      : (!waveamdmachine.reg<vgpr, 1, 18>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 19>
  %v14 = waveamdmachine.v_add_u32 %v13, %b
      : (!waveamdmachine.reg<vgpr, 1, 19>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 20>
  %v15 = waveamdmachine.v_add_u32 %v14, %b
      : (!waveamdmachine.reg<vgpr, 1, 20>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 21>
  %v16 = waveamdmachine.v_add_u32 %v15, %b
      : (!waveamdmachine.reg<vgpr, 1, 21>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 22>
  %v17 = waveamdmachine.v_add_u32 %v16, %b
      : (!waveamdmachine.reg<vgpr, 1, 22>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 23>
  %v18 = waveamdmachine.v_add_u32 %v17, %b
      : (!waveamdmachine.reg<vgpr, 1, 23>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 24>
  %v19 = waveamdmachine.v_add_u32 %v18, %b
      : (!waveamdmachine.reg<vgpr, 1, 24>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 25>
  %v20 = waveamdmachine.v_add_u32 %v19, %b
      : (!waveamdmachine.reg<vgpr, 1, 25>, !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 26>
  %loaded0, %tok0 = waveamdmachine.global_load_b32 %off0, %ptr
      {cache = #waveamd.load_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>)
        -> (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.mem.token)
  %loaded1, %tok1 = waveamdmachine.global_load_b32 %off1, %ptr
      {cache = #waveamd.load_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<sgpr, 2, 0>)
        -> (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.mem.token)
  %sum0 = waveamdmachine.v_add_u32 %v20, %loaded0
      : (!waveamdmachine.reg<vgpr, 1, 26>, !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 27>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %loaded1
      : (!waveamdmachine.reg<vgpr, 1, 27>, !waveamdmachine.reg<vgpr, 1, 5>)
        -> !waveamdmachine.reg<vgpr, 1, 28>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: sched_barrier_memory_prefetch_codegen:
// ASM: v_add_u32_e32 v4
// ASM-NEXT: global_load_dword v5
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: v_add_u32_e32 v6, v4, v5
// ASM-NEXT: s_endpgm
func.func @sched_barrier_memory_prefetch_codegen() attributes {wave.kernel} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %ptr = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %before = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  waveamdmachine.sched_barrier
  %loaded, %tok = waveamdmachine.global_load_b32 %off, %ptr
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>)
        -> (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %before, %loaded
      : (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 5>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  waveamdmachine.s_endpgm
  return
}

}
