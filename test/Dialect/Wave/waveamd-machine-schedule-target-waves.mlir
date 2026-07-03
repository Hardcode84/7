// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule | FileCheck %s

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
