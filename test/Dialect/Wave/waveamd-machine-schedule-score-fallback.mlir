// RUN: wave-opt %s --waveamd-machine-schedule='print-score=1' 2>&1 | FileCheck %s

module {
func.func @missing_target(%a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>) {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// CHECK: waveamd-machine-schedule score func=missing_target region=0 order=original fallback=original reason=missing_target
