// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUND
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUND
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ROUND-LABEL: func.func @bitop3_b32
// ROUND: waveamdmachine.v_bitop3_b32 {{.*}} bitop3 106
// ASM-LABEL: bitop3_b32:
// ASM: v_bitop3_b32 v3, v0, v1, v2 bitop3:0x6a
func.func @bitop3_b32(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                      %b: !waveamdmachine.reg<vgpr, 1, 1>,
                      %c: !waveamdmachine.reg<vgpr, 1, 2>)
    -> !waveamdmachine.reg<sgpr, 1, 0> {
  %bitop = waveamdmachine.v_bitop3_b32 %a, %b, %c bitop3 106
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %first = waveamdmachine.v_readfirstlane_b32 %bitop
      : (!waveamdmachine.reg<vgpr, 1, 3>) -> !waveamdmachine.reg<sgpr, 1, 0>
  waveamdmachine.s_endpgm
  return %first : !waveamdmachine.reg<sgpr, 1, 0>
}

}
