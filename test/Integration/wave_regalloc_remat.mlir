// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_remat
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.vgpr_count = 4 : i64
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK-NEXT: waveamdmachine.s_nop
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK: waveamdmachine.s_endpgm
func.func @regalloc_remat()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 121>
  %p = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  %use = waveamdmachine.v_add_u32 %p, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %v1, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %use
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 121>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 61>)
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @regalloc_remat_accvgpr_bridge
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.v_accvgpr_read_b32_tuple
// CHECK: waveamdmachine.s_endpgm
func.func @regalloc_remat_accvgpr_bridge()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 121>
  %raw = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %agp = waveamdmachine.v_accvgpr_write_b32_tuple %raw
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<agpr, 1>
  %p = waveamdmachine.v_accvgpr_read_b32_tuple %agp
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_nop %zero : (!waveamdmachine.imm) -> ()
  %use = waveamdmachine.v_add_u32 %p, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %v1, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %use
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 121>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 61>)
  waveamdmachine.s_endpgm
  return
}

}
