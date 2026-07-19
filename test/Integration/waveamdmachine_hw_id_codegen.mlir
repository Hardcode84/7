// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: hw_id_schedule_codegen:
// ASM: s_getreg_b32 s8, hwreg(HW_REG_HW_ID1, 4, 1)
// ASM: s_endpgm
func.func @hw_id_schedule_codegen() attributes {wave.kernel} {
  %id = waveamdmachine.s_getreg_hw_id offset 4 width 1
      : !waveamdmachine.reg<sgpr, 1, 8>
  waveamdmachine.s_mov_b32 "s9", %id
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
