// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-3 tuple. AMDGPU's VReg_96 class is 4-aligned, so the
// allocator must pick a base that is a multiple of 4 even though
// the tuple only occupies 3 dwords. With kernel v0 reservation the
// `width % 4 == 0` candidates are v0 (taken), v4, v8, ... -- the
// allocator must skip v3 (which is `width`-aligned but not
// `next_pow_2(width)`-aligned) and pick v4.
//
// CHECK-LABEL: func.func @width3_tuple_aligns_to_4
// CHECK: %{{.+}} = wavemachine.tuple_from_elements
// CHECK-SAME: -> !wavemachine.reg<vgpr, 3, 4>
func.func @width3_tuple_aligns_to_4() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.v_mov_b32_tuple %zero {registers = 2 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 2>
  %b = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %t = wavemachine.tuple_from_elements %a, %b
      : (!wavemachine.reg<vgpr, 2>, !wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 3>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Width-5 tuple. VReg_160 is 8-aligned. With kernel v0 reservation
// the allocator must pick v8, not v5 (5-aligned but not 8-aligned).
//
// CHECK-LABEL: func.func @width5_tuple_aligns_to_8
// CHECK: %{{.+}} = wavemachine.tuple_from_elements
// CHECK-SAME: -> !wavemachine.reg<vgpr, 5, 8>
func.func @width5_tuple_aligns_to_8() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %a = wavemachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 4>
  %b = wavemachine.v_mov_b32_tuple %zero {registers = 1 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 1>
  %t = wavemachine.tuple_from_elements %a, %b
      : (!wavemachine.reg<vgpr, 4>, !wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 5>
  return
}

}

// -----

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Power-of-two widths still get the tight alignment they had
// before (width-4 stays 4-aligned, width-8 stays 8-aligned):
// `next_power_of_two(N) == N` for those.
//
// CHECK-LABEL: func.func @width4_tuple_stays_4_aligned
// CHECK: %[[T:.+]] = wavemachine.v_mov_b32_tuple {{.*}} -> !wavemachine.reg<vgpr, 4, 4>
func.func @width4_tuple_stays_4_aligned() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %t = wavemachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 4>
  return
}

}
