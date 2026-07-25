// RUN: wave-opt %s --waveamd-hazard-repair --waveamd-preserve-hw-regs \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-hazard-repair --waveamd-preserve-hw-regs \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-hazard-repair \
// RUN:   --waveamd-machine-schedule='apply-schedule=1' --mlir-timing \
// RUN:   --mlir-timing-display=tree 2>&1 >/dev/null \
// RUN:   | FileCheck %s --check-prefix=TIMING
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   | FileCheck %s --check-prefix=SCHEDULE

// TIMING-DAG: wave_hazard_repair_stages
// TIMING-DAG: hazard_repair_collect_op_info
// TIMING-DAG: hazard_repair_blocks
// TIMING-DAG: wave_machine_schedule_stages
// TIMING-DAG: machine_schedule_build_graph
// TIMING-DAG: machine_schedule_build_order

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: m0_region_hazard_codegen:
// ASM: s_mov_b32 m0, s8
// ASM-NEXT: s_and_saveexec_b64
// ASM-NEXT: s_cbranch_execz
// ASM-NEXT: buffer_load_dwordx4
// ASM-NOT: s_nop
// ASM: s_endpgm
func.func @m0_region_hazard_codegen() attributes {wave.kernel} {
  %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %dst = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %token = waveamdmachine.exec_if %cond {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 8>) -> !waveamdmachine.m0
    %loaded = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %zero, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield %loaded : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 2, 0> -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// SCHEDULE-LABEL: func.func @shared_issue_streams_prefer_pressure_releasing_filler
// SCHEDULE: [[M0:%.*]] = waveamdmachine.s_mov_m0
// SCHEDULE-NEXT: waveamdmachine.v_cmpx_eq_u32
// SCHEDULE-NOT: waveamdmachine.v_add_u32
// SCHEDULE-NEXT: waveamdmachine.buffer_load_lds_b128
func.func @shared_issue_streams_prefer_pressure_releasing_filler()
    attributes {waveamdmachine.target_waves = 8 : i64} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %inc0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %inc1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 2>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 4>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 8>
  %keep0 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 9>
  %keep1 = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 10>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 64 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 64, 32>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> !waveamdmachine.m0
  %loaded = waveamdmachine.buffer_load_lds_b128
      %off, %desc, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 4, 4>, !waveamdmachine.imm,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %raised = waveamdmachine.v_add_u32 %inc0, %inc1
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
      : (!waveamdmachine.reg<sgpr, 1, 9>,
         !waveamdmachine.reg<sgpr, 1, 10>)
        -> !waveamdmachine.reg<scc, 1>
  %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
      : (!waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
      : (!waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %parts:2 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 64, 32>)
        -> (!waveamdmachine.reg<vgpr, 1, 32>,
            !waveamdmachine.reg<vgpr, 63, 33>)
  waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 32>,
         !waveamdmachine.reg<vgpr, 1, 32>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
