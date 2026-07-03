// RUN: wave-opt %s --waveamd-machine-schedule-report='print-deps max-region-ops=1' 2>&1 | FileCheck %s --check-prefix=REGION
// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-candidates beam-search' 2>&1 | FileCheck %s --check-prefix=BEAM

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // REGION: skipped func=region_default region=0 reason=max_region_ops
  // REGION-SAME: limit=1
  // REGION: skipped func=region_override region=0 reason=max_region_ops
  func.func @region_default(%a: !waveamdmachine.reg<vgpr, 1>,
                            %b: !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.schedule_max_beam_work = -1 : i64} {
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

  func.func @region_override(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.schedule_max_region_ops = 3 : i64,
                  waveamdmachine.schedule_max_beam_work = -1 : i64} {
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

  // BEAM: waveamd-machine-schedule-report unsupported option: beam-search
  func.func @beam_default(%a: !waveamdmachine.reg<vgpr, 1>,
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

  func.func @beam_override(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>)
      attributes {waveamdmachine.schedule_max_beam_work = -1 : i64} {
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
