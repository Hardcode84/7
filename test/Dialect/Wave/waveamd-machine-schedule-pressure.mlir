// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 print-candidates=1 pressure-vgpr-budget=3 pressure-target-waves=-1' 2>&1 | FileCheck %s --check-prefix=DISABLED
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 print-candidates=1 pressure-aware-selection=1 pressure-vgpr-budget=3 pressure-target-waves=-1' 2>&1 | FileCheck %s --check-prefix=HARD
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1 print-candidates=1 pressure-aware-selection=1 pressure-critical-vgpr-budget=3 pressure-target-waves=-1' 2>&1 | FileCheck %s --check-prefix=CRIT

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

// DISABLED: waveamd-machine-schedule candidate func=pressure_guard region=0 name=original cycles=332 delta=0 issued_ops=5 max_vgpr=3 max_sgpr=0 vgpr_hard_excess=0 order=0,1,2,3,4,5
// DISABLED: waveamd-machine-schedule candidate func=pressure_guard region=0 name=critical_path cycles=325 delta=-7 issued_ops=5 max_vgpr=4 max_sgpr=0 vgpr_hard_excess=1 order=0,4,1,2,3,5
// DISABLED: waveamd-machine-schedule selected func=pressure_guard region=0 name=critical_path original_cycles=332 selected_cycles=325 delta=-7 action=apply order=0,4,1,2,3,5

// HARD: waveamd-machine-schedule candidate func=pressure_guard region=0 name=original cycles=332 delta=0 issued_ops=5 max_vgpr=3 max_sgpr=0 vgpr_hard_excess=0 order=0,1,2,3,4,5
// HARD: waveamd-machine-schedule candidate func=pressure_guard region=0 name=critical_path cycles=325 delta=-7 issued_ops=5 max_vgpr=4 max_sgpr=0 vgpr_hard_excess=1 order=0,4,1,2,3,5
// HARD: waveamd-machine-schedule selected func=pressure_guard region=0 name=original original_cycles=332 selected_cycles=332 delta=0 action=keep order=0,1,2,3,4,5

// CRIT: waveamd-machine-schedule candidate func=pressure_guard region=0 name=original cycles=332 delta=0 issued_ops=5 max_vgpr=3 max_sgpr=0 vgpr_critical_excess=0 order=0,1,2,3,4,5
// CRIT: waveamd-machine-schedule candidate func=pressure_guard region=0 name=critical_path cycles=325 delta=-7 issued_ops=5 max_vgpr=4 max_sgpr=0 vgpr_critical_excess=1 order=0,4,1,2,3,5
// CRIT: waveamd-machine-schedule selected func=pressure_guard region=0 name=original original_cycles=332 selected_cycles=332 delta=0 action=keep order=0,1,2,3,4,5
