// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

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

// CHECK-LABEL: func.func @regalloc_remat_reuses_rebuilt_value
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: [[R_ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[R_ONE:%.*]] = waveamdmachine.imm 1
// CHECK: waveamdmachine.uniform_loop
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple [[R_ZERO]]
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.v_mov_b32_tuple [[R_ZERO]]
// CHECK: waveamdmachine.v_add_u32 {{.*}}, [[R_ONE]]
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.s_endpgm
func.func @regalloc_remat_reuses_rebuilt_value()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.v_add_u32 %seed, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %guard = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v4 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %v5 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %u0 = waveamdmachine.v_add_u32 %v0, %v1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u1 = waveamdmachine.v_add_u32 %v2, %v3
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %u2 = waveamdmachine.v_add_u32 %v4, %v5
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pressure0 = waveamdmachine.v_add_u32 %u0, %u1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pressure = waveamdmachine.v_add_u32 %pressure0, %u2
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %use0 = waveamdmachine.v_add_u32 %root, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_add_u32 %root, %use0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_readfirstlane_b32 %use1
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %guard_use = waveamdmachine.v_readfirstlane_b32 %guard
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %ag
      : (!waveamdmachine.reg<agpr, 120>)
      -> (!waveamdmachine.reg<agpr, 60>, !waveamdmachine.reg<agpr, 60>)
  waveamdmachine.s_endpgm
  return
}

}
