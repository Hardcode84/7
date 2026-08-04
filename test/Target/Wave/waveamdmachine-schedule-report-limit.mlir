// RUN: wave-opt %s --waveamd-machine-schedule-report='print-regions print-deps max-region-ops=1' 2>&1 | FileCheck %s --check-prefix=REGION

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // REGION: region func=region_first block=0 region=0 ops=3
  // REGION-NEXT: skipped func=region_first region=0 reason=max_region_ops
  // REGION-SAME: limit=1
  // REGION: region func=region_second block=0 region=0 ops=3
  // REGION-NEXT: skipped func=region_second region=0 reason=max_region_ops
  func.func @region_first(%a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>) {
    %0 = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %1 = waveamdmachine.v_add_u32 %0, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %2 = waveamdmachine.v_add_u32 %1, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @region_second(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
    %0 = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %1 = waveamdmachine.v_add_u32 %0, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %2 = waveamdmachine.v_add_u32 %1, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}
