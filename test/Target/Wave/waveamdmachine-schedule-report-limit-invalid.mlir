// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-deps max-region-ops=-2' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @bad_report_region_limit(%a: !waveamdmachine.reg<vgpr, 1>,
                                     %b: !waveamdmachine.reg<vgpr, 1>) {
    %0 = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: max-region-ops must be -1 or non-negative
