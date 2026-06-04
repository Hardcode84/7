// RUN: not wave-opt --waveamd-reg-alloc='agpr-bank-spill=true vgpr-limit=16' %s 2>&1 | FileCheck %s

// CHECK: waveamd-reg-alloc could not find a legal AGPR bank-spill candidate for VGPR pressure

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @unbridgeable_definition_pressure() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 32 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 32>
  %use = waveamdmachine.v_mov_b32_tuple %wide {registers = 32 : i64}
      : (!waveamdmachine.reg<vgpr, 32>) -> !waveamdmachine.reg<vgpr, 32>
  return
}

}
