// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' --verify-diagnostics
// RUN: not wave-opt %s --waveamd-machine-schedule='apply-schedule=1 max-beam-work=1' 2>&1 | FileCheck %s --check-prefix=OPTION

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @unsupported_op(%a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>) {
  %imm = waveamdmachine.imm 0 : !waveamdmachine.imm
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  // expected-error @below {{waveamd-machine-schedule unsupported op: waveamdmachine.s_nop}}
  waveamdmachine.s_nop %imm : (!waveamdmachine.imm) -> ()
  return
}
}

// OPTION: waveamd-machine-schedule unsupported option: max-beam-work
