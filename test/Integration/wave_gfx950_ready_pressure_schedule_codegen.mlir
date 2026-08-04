// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:     -filetype=obj -o /dev/null
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: ready_pressure_schedule_codegen:
// ASM: v_mov_b32_e32 v0, 0
// ASM-NEXT: v_add_u32_e32 v3, v0, v0
// ASM-NEXT: v_mov_b32_e32 v1, 0
// ASM-NEXT: v_mov_b32_e32 v2, 0
// ASM-NEXT: v_add_u32_e32 v4, v2, v2
// ASM-NEXT: s_endpgm
// DIAG: waveamd-machine-schedule region func=ready_pressure_schedule_codegen
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1
func.func @ready_pressure_schedule_codegen()
    attributes {wave.kernel,
                waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  %gap = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 2>
  %use0 = waveamdmachine.v_add_u32 %v0, %v0
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %use1 = waveamdmachine.v_add_u32 %v1, %v1
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  waveamdmachine.s_endpgm
  return
}

}
