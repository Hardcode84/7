// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 beam-search=1' 2>&1 | FileCheck %s --check-prefix=REPORT-BEAM-ERR
// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 pressure-aware-selection=1' 2>&1 | FileCheck %s --check-prefix=REPORT-PRESSURE-ERR
// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-candidates=1 pressure-critical-vgpr-budget=3' 2>&1 | FileCheck %s --check-prefix=REPORT-BUDGET-ERR
// RUN: not wave-opt %s --waveamd-machine-schedule='apply-schedule=1 pressure-aware-selection=1' 2>&1 | FileCheck %s --check-prefix=APPLY-ERR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @pressure_guard(%off: !waveamdmachine.reg<vgpr, 1>,
                          %base: !waveamdmachine.reg<sgpr, 2>,
                          %a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>,
                          %c: !waveamdmachine.reg<vgpr, 1>,
                          %d: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %t0 = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %t1 = waveamdmachine.v_add_u32 %c, %d : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %t0, %t1 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %dep = waveamdmachine.v_add_u32 %loaded, %sum : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// REPORT-BEAM-ERR: waveamd-machine-schedule-report unsupported option: beam-search
// REPORT-PRESSURE-ERR: waveamd-machine-schedule-report unsupported option: pressure-aware-selection
// REPORT-BUDGET-ERR: waveamd-machine-schedule-report unsupported option: pressure-critical-vgpr-budget
// APPLY-ERR: waveamd-machine-schedule unsupported option: pressure-aware-selection
