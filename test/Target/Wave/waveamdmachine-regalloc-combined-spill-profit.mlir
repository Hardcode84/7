// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true' %s | FileCheck %s
// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all \
// RUN:   --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=8 agpr-limit=1' \
// RUN:   --waveamd-resource-info %s | FileCheck %s --check-prefix=SOLVE
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=32 agpr-limit=128' \
// RUN:   --waveamd-resource-info %s | FileCheck %s --check-prefix=AGPR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        combined_pressure_rejects_cheap_expr_spill
// REMARK: class:           'VGPR/AGPR'
// REMARK: combined_vgpr_agpr: 'true'
// REMARK: request:         '{start=
// REMARK: pressure_relief_providers: '{{.*}}provider=remat{{.*}}'
// REMARK: no_use:         '1'
// REMARK: total:           '1'

// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        placement_rejects_sgpr_to_vgpr_promotion
// REMARK: class:           'VGPR/AGPR'
// REMARK: required_relief: '5'
// REMARK: combined_vgpr_agpr: 'true'
// REMARK: pressure_relief_providers: '{{.*}}provider=bank-promotion, candidates=0{{.*}}'
// REMARK: pressure_relief_candidates: '[]'

// REMARK: Function:        combined_pressure_reports_temp_only_spill_reject
// REMARK: Name:            regalloc-scratch-plan
// REMARK: Function:        combined_pressure_reports_temp_only_spill_reject
// REMARK: reserved_spill_bytes: '76'
// REMARK: status:          available
// REMARK: uses_flat_scratch: 'true'

// CHECK-LABEL: func.func @combined_pressure_rejects_cheap_expr_spill
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-NOT: waveamdmachine.lds_spill_bytes
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: waveamdmachine.s_endpgm
func.func @combined_pressure_rejects_cheap_expr_spill()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 120>) -> !waveamdmachine.reg<vgpr, 120>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u4 = waveamdmachine.v_add_u32 %u0, %v8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @placement_rejects_sgpr_to_vgpr_promotion
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK: waveamdmachine.s_endpgm
func.func @placement_rejects_sgpr_to_vgpr_promotion()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 124>
  %s = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %v = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %s_use = waveamdmachine.s_mov_b32_value %s
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %v
      : (!waveamdmachine.reg<vgpr, 8>)
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 124>) -> !waveamdmachine.reg<vgpr, 124>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @combined_pressure_rejects_wide_cheap_expr_spill
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: waveamdmachine.s_endpgm
func.func @combined_pressure_rejects_wide_cheap_expr_spill()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %cheap = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 120>) -> !waveamdmachine.reg<vgpr, 120>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %cheap
      : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>,
                                           !waveamdmachine.reg<vgpr, 1>)
  %use = waveamdmachine.v_add_u32 %parts#0, %u3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @combined_pressure_spills_noncheap_value
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 4 : i64
// CHECK: waveamdmachine.s_endpgm
func.func @combined_pressure_spills_noncheap_value()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 120>
  %spill = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 120>) -> !waveamdmachine.reg<vgpr, 120>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u4 = waveamdmachine.v_add_u32 %u0, %v8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %spill, %u4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// SOLVE-LABEL: func.func @combined_pressure_spill_solves_noncheap_value
// SOLVE-NOT: waveamdmachine.regalloc_overflowed
// SOLVE-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
// SOLVE: waveamdmachine.scratch_store_b32
// SOLVE: waveamdmachine.scratch_load_b32
func.func @combined_pressure_spill_solves_noncheap_value()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
  %spill = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %u0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %spill, %v6
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %u0, %u1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %u2, %use
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %sum0, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum3 = waveamdmachine.v_add_u32 %sum2, %read
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// SOLVE-LABEL: func.func @combined_pressure_spills_group_with_temp_alias
// SOLVE-SAME: waveamdmachine.scratch_spill_bytes = 8 : i64
// SOLVE-NOT: scratch_store_tuple_b32
// SOLVE: waveamdmachine.scratch_store_b32
// SOLVE: waveamdmachine.scratch_load_b32
func.func @combined_pressure_spills_group_with_temp_alias()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1>
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %wide = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %parts:4 = waveamdmachine.tuple_to_elements %wide
      {waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %u0 = waveamdmachine.v_add_u32 %parts#0, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u1 = waveamdmachine.v_add_u32 %parts#1, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u2 = waveamdmachine.v_add_u32 %parts#2, %v2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %u3 = waveamdmachine.v_add_u32 %parts#3, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %u0, %u1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %u2, %u3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %sum0, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %sum2, %read
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// AGPR-LABEL: func.func @combined_pressure_spills_agpr_temp
// AGPR-SAME: waveamdmachine.regalloc_assignments
// AGPR-SAME: waveamdmachine.vgpr_count = 20 : i64
// AGPR-NOT: waveamdmachine.scratch_spill_bytes
// AGPR: waveamdmachine.v_accvgpr_read_b32_tuple
// AGPR: waveamdmachine.mfma_f32_16x16x32_f16
func.func @combined_pressure_spills_agpr_temp()
    attributes {wave.kernel, waveamdmachine.target_waves = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag2 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag3 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag4 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag5 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag6 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag7 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag8 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag9 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %src = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 4 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %ag_spill = waveamdmachine.v_accvgpr_write_b32_tuple %src
      {waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<agpr, 4>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag_spill
      : (!waveamdmachine.reg<agpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %parts:4 = waveamdmachine.tuple_to_elements %read
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %sum0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum3 = waveamdmachine.v_add_u32 %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum4 = waveamdmachine.v_add_u32 %v8, %v9
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum5 = waveamdmachine.v_add_u32 %v10, %v11
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum6 = waveamdmachine.v_add_u32 %v12, %v13
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum7 = waveamdmachine.v_add_u32 %v14, %v15
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %v15, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %acc0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %ag0, %ag1, %acc0
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %ag2, %ag3, %mfma0
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma2 = waveamdmachine.mfma_f32_16x16x32_f16 %ag4, %ag5, %mfma1
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma3 = waveamdmachine.mfma_f32_16x16x32_f16 %ag6, %ag7, %mfma2
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma4 = waveamdmachine.mfma_f32_16x16x32_f16 %ag8, %ag9, %mfma3
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @combined_pressure_reports_temp_only_spill_reject
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.scratch_spill_bytes = 76 : i64
// CHECK-NOT: waveamdmachine.regalloc_overflowed
// CHECK: waveamdmachine.scratch_store_b32
// CHECK: waveamdmachine.scratch_load_b32
func.func @combined_pressure_reports_temp_only_spill_reject()
    attributes {wave.kernel, waveamdmachine.target_waves = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %ag0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag2 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag3 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag4 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag5 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag6 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag7 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag8 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag9 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag10 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag11 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag12 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
  %ag_tail = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 3>
  %src = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %ag_spill = waveamdmachine.v_accvgpr_write_b32_tuple %src
      {waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<agpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v16 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v17 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v18 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v19 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v20 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v21 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v22 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v23 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v24 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %ag_spill
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum0 = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %v2, %v3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum2 = waveamdmachine.v_add_u32 %v4, %v5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum3 = waveamdmachine.v_add_u32 %v6, %v7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum4 = waveamdmachine.v_add_u32 %v8, %v9
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum5 = waveamdmachine.v_add_u32 %v10, %v11
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum6 = waveamdmachine.v_add_u32 %v12, %v13
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum7 = waveamdmachine.v_add_u32 %v14, %v15
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum8 = waveamdmachine.v_add_u32 %v16, %v17
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum9 = waveamdmachine.v_add_u32 %v18, %v19
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum10 = waveamdmachine.v_add_u32 %v20, %v21
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum11 = waveamdmachine.v_add_u32 %v22, %v23
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %v24, %read
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tail_read = waveamdmachine.v_accvgpr_read_b32_tuple %ag_tail
      : (!waveamdmachine.reg<agpr, 3>) -> !waveamdmachine.reg<vgpr, 3>
  %acc0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %mfma0 = waveamdmachine.mfma_f32_16x16x32_f16 %ag0, %ag1, %acc0
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma1 = waveamdmachine.mfma_f32_16x16x32_f16 %ag1, %ag2, %mfma0
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma2 = waveamdmachine.mfma_f32_16x16x32_f16 %ag2, %ag3, %mfma1
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma3 = waveamdmachine.mfma_f32_16x16x32_f16 %ag3, %ag4, %mfma2
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma4 = waveamdmachine.mfma_f32_16x16x32_f16 %ag4, %ag5, %mfma3
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma5 = waveamdmachine.mfma_f32_16x16x32_f16 %ag5, %ag6, %mfma4
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma6 = waveamdmachine.mfma_f32_16x16x32_f16 %ag6, %ag7, %mfma5
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma7 = waveamdmachine.mfma_f32_16x16x32_f16 %ag7, %ag8, %mfma6
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma8 = waveamdmachine.mfma_f32_16x16x32_f16 %ag8, %ag9, %mfma7
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma9 = waveamdmachine.mfma_f32_16x16x32_f16 %ag9, %ag10, %mfma8
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma10 = waveamdmachine.mfma_f32_16x16x32_f16 %ag10, %ag11, %mfma9
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma11 = waveamdmachine.mfma_f32_16x16x32_f16 %ag11, %ag12, %mfma10
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mfma12 = waveamdmachine.mfma_f32_16x16x32_f16 %ag12, %ag0, %mfma11
      : (!waveamdmachine.reg<agpr, 4>, !waveamdmachine.reg<agpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

}
