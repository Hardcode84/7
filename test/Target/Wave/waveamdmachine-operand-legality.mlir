// RUN: wave-opt --waveamd-verify-machine-operands --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @same_gfx11_literal
func.func @same_gfx11_literal(%lane: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  %lit = waveamdmachine.imm 256 : !waveamdmachine.imm
  // CHECK: waveamdmachine.v_add3_u32
  %out = waveamdmachine.v_add3_u32 %lit, %lit, %lane
      : (!waveamdmachine.imm, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}
