// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | wave-opt -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-3 tuple. AMDGPU's VReg_96 class is 4-aligned, so the
// allocator must pick a base that is a multiple of 4 even though
// the tuple only occupies 3 dwords.
//
// CHECK-LABEL: func.func @width3_tuple_aligns_to_4
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 3, 0>
func.func @width3_tuple_aligns_to_4() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 3>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-5 tuple. VReg_160 is 8-aligned.
//
// CHECK-LABEL: func.func @width5_tuple_aligns_to_8
// CHECK: %{{.+}} = waveamdmachine.tuple_from_elements
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 5, 0>
func.func @width5_tuple_aligns_to_8() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %t = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 5>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Power-of-two widths still get the tight alignment they had
// before (width-4 stays 4-aligned, width-8 stays 8-aligned):
// `next_power_of_two(N) == N` for those.
//
// CHECK-LABEL: func.func @width4_tuple_stays_4_aligned
// CHECK: %[[T:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 4, 0>
func.func @width4_tuple_stays_4_aligned() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %t = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  return
}

}
