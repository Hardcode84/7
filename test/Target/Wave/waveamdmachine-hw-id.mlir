// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' --waveamd-resource-info \
// RUN:   | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' --waveamd-resource-info \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUND-LABEL: func.func @hw_id_simd_bit
// ROUND: [[ID:%.*]] = waveamdmachine.s_getreg_hw_id offset 4 width 1 : !waveamdmachine.reg<sgpr, 1, 8>

// ASM-LABEL: hw_id_simd_bit:
// ASM: s_getreg_b32 s8, hwreg(HW_REG_HW_ID, 4, 1)
func.func @hw_id_simd_bit() attributes {wave.kernel} {
  %id = waveamdmachine.s_getreg_hw_id offset 4 width 1
      : !waveamdmachine.reg<sgpr, 1, 8>
  waveamdmachine.s_mov_b32 "s9", %id
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
