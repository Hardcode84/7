// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule | FileCheck %s
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-candidates=1 pressure-aware-selection=1' 2>&1 | FileCheck %s --check-prefix=TARGET
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-candidates=1 pressure-aware-selection=1 pressure-target-waves-override=1' 2>&1 | FileCheck %s --check-prefix=ONE
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-candidates=1 pressure-aware-selection=1 pressure-target-waves-override=0' 2>&1 | FileCheck %s --check-prefix=MAX

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.target_waves = 4 : i64} {
func.func @module_default(%a: !waveamdmachine.reg<vgpr, 1>,
                          %b: !waveamdmachine.reg<vgpr, 1>) {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @explicit(%a: !waveamdmachine.reg<vgpr, 1>,
                    %b: !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = 2 : i64} {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @missing_default(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @pressure_explicit_one(%a: !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %v = waveamdmachine.v_add_u32 %a, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @pressure_missing_default(%a: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 128 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 128>
  %v = waveamdmachine.v_add_u32 %a, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942",
                   waveamdmachine.target_waves = 8 : i64} {
func.func @cdna_budget(%a: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 80 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 80>
  %v = waveamdmachine.v_add_u32 %a, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// CHECK: module attributes {{{.*}}waveamdmachine.target_waves = 4 : i64{{.*}}}
// CHECK-LABEL: func.func @explicit
// CHECK-SAME: attributes {{{.*}}waveamdmachine.target_waves = 2 : i64{{.*}}}
// CHECK-LABEL: func.func @missing_default

// TARGET: budgets func=module_default hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=106 derived_hard_sgpr=106 critical_vgpr=256 derived_critical_vgpr=256 critical_sgpr=106 derived_critical_sgpr=106
// TARGET: budgets func=pressure_explicit_one hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=106 derived_hard_sgpr=106 critical_vgpr=disabled critical_sgpr=disabled
// TARGET: candidate func=pressure_explicit_one region=0 name=original cycles=6 delta=0 issued_ops=4 max_vgpr=128 max_sgpr=0 vgpr_hard_excess=0 sgpr_hard_excess=0
// TARGET: budgets func=pressure_missing_default hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=106 derived_hard_sgpr=106 critical_vgpr=disabled critical_sgpr=disabled
// TARGET: candidate func=pressure_missing_default region=0 name=original cycles=6 delta=0 issued_ops=2 max_vgpr=128 max_sgpr=0 vgpr_hard_excess=0 sgpr_hard_excess=0
// TARGET: budgets func=cdna_budget hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=102 derived_hard_sgpr=102 critical_vgpr=64 derived_critical_vgpr=64 critical_sgpr=96 derived_critical_sgpr=96
// TARGET: candidate func=cdna_budget region=0 name=original cycles=64 delta=0 issued_ops=64 max_vgpr=80 max_sgpr=0 vgpr_hard_excess=0 sgpr_hard_excess=0 vgpr_critical_excess=16 sgpr_critical_excess=0

// ONE: budgets func=module_default hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=106 derived_hard_sgpr=106 critical_vgpr=disabled critical_sgpr=disabled
// MAX: budgets func=pressure_missing_default hard_vgpr=256 derived_hard_vgpr=256 hard_sgpr=106 derived_hard_sgpr=106 critical_vgpr=96 derived_critical_vgpr=96 critical_sgpr=106 derived_critical_sgpr=106
