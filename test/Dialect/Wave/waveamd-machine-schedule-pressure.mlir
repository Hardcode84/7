// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-candidates=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=WORK

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @no_inst_closure_peak(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token)
    -> (!waveamdmachine.reg<vgpr, 42>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>)
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 56 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 42 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 42>
  %off = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %tail = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %p0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %pair = waveamdmachine.tuple_from_elements %p0, %tail
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %keep, %a, %b, %pair
      : !waveamdmachine.reg<vgpr, 42>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>
}
}

// IR-LABEL: func.func @no_inst_closure_peak
// IR: waveamdmachine.sched_barrier
// IR-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// IR-NEXT: [[P0:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.tuple_from_elements [[P0]]
// DIAG: waveamd-machine-schedule region func=no_inst_closure_peak index=1
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: filled_gaps=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @prefix_pressure_guard()
    -> (!waveamdmachine.reg<vgpr, 43>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 43 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 43>
  %data = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %off = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %z = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %x = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  waveamdmachine.sched_barrier
  %baseline = waveamdmachine.ds_store_b32 %off, %data after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %kill = waveamdmachine.ds_store_b32 %off, %z after %baseline
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %candidate = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %keep, %data, %off
      : !waveamdmachine.reg<vgpr, 43>, !waveamdmachine.reg<vgpr, 1>,
        !waveamdmachine.reg<vgpr, 1>
}
}

// IR-LABEL: func.func @prefix_pressure_guard
// IR: waveamdmachine.sched_barrier
// IR-NEXT: [[BASELINE:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: waveamdmachine.ds_store_b32 {{.*}} after [[BASELINE]]
// IR-NEXT: waveamdmachine.v_add_u32
// DIAG: waveamd-machine-schedule region func=prefix_pressure_guard index=1
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: pressure_priority_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @conservative_mfma_acc_result_pressure(
    %sx: !waveamdmachine.reg<sgpr, 1>,
    %sy: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 36>, !waveamdmachine.reg<vgpr, 4>,
        !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>)
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 56 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 36 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 36>
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %acc = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %sx, %sy
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %result = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return %keep, %a, %b, %result
      : !waveamdmachine.reg<vgpr, 36>, !waveamdmachine.reg<vgpr, 4>,
        !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
}
}

// IR-LABEL: func.func @conservative_mfma_acc_result_pressure
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=conservative_mfma_acc_result_pressure index=1
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: resource_priority_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @sequential_transient_peaks()
    -> !waveamdmachine.reg<vgpr, 45>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 45 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 45>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %baseline = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %candidate = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %keep : !waveamdmachine.reg<vgpr, 45>
}
}

// IR-LABEL: func.func @sequential_transient_peaks
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=sequential_transient_peaks index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @non_aligned_vgpr_budget()
    -> !waveamdmachine.reg<vgpr, 47>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 73 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 47 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 47>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %mask = waveamdmachine.v_cmp_ge_i32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<sgpr, 2>
  return %wide : !waveamdmachine.reg<vgpr, 47>
}
}

// IR-LABEL: func.func @non_aligned_vgpr_budget
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_cmp_ge_i32
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=non_aligned_vgpr_budget index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @entry_virtual_livein_pressure(
    %keep: !waveamdmachine.reg<vgpr, 45>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 45>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %dead = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %keep : !waveamdmachine.reg<vgpr, 45>
}
}

// IR-LABEL: func.func @entry_virtual_livein_pressure
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=entry_virtual_livein_pressure index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @entry_fixed_livein_pressure(
    %keep: !waveamdmachine.reg<vgpr, 45, 0>,
    %x: !waveamdmachine.reg<vgpr, 1, 45>,
    %y: !waveamdmachine.reg<vgpr, 1, 46>)
    -> !waveamdmachine.reg<vgpr, 45, 0>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %dead = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 45>,
         !waveamdmachine.reg<vgpr, 1, 46>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %keep : !waveamdmachine.reg<vgpr, 45, 0>
}
}

// IR-LABEL: func.func @entry_fixed_livein_pressure
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=entry_fixed_livein_pressure index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @cfg_block_livein_pressure(
    %keep: !waveamdmachine.reg<vgpr, 45>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 45>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  cf.br ^bb1(%keep, %x, %y : !waveamdmachine.reg<vgpr, 45>,
             !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
^bb1(%block_keep: !waveamdmachine.reg<vgpr, 45>,
     %block_x: !waveamdmachine.reg<vgpr, 1>,
     %block_y: !waveamdmachine.reg<vgpr, 1>):
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %dead = waveamdmachine.v_add_u32 %block_x, %block_y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %block_keep : !waveamdmachine.reg<vgpr, 45>
}
}

// IR-LABEL: func.func @cfg_block_livein_pressure
// IR: ^bb1
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=cfg_block_livein_pressure index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @birth_before_death_vgpr_ceiling()
    -> !waveamdmachine.reg<vgpr, 46>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 46 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 46>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %dead = waveamdmachine.v_add_u32 %v0, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %wide : !waveamdmachine.reg<vgpr, 46>
}
}

// IR-LABEL: func.func @birth_before_death_vgpr_ceiling
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=birth_before_death_vgpr_ceiling index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @dead_result_does_not_overlap_next_birth()
    -> (!waveamdmachine.reg<sgpr, 3>, !waveamdmachine.reg<sgpr, 1>)
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 3>
  waveamdmachine.sched_barrier
  %dead = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %next = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %gap = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  return %keep, %next
      : !waveamdmachine.reg<sgpr, 3>, !waveamdmachine.reg<sgpr, 1>
}
}

// IR-LABEL: func.func @dead_result_does_not_overlap_next_birth
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_cmp_eq_u32
// DIAG: waveamd-machine-schedule region func=dead_result_does_not_overlap_next_birth index=1
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: pressure_priority_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @joint_noinst_sequence_peak()
    -> (!waveamdmachine.reg<vgpr, 46>, !waveamdmachine.reg<vgpr, 2>)
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 72 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 46 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 46>
  %x = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %baseline = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %candidate = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %pair = waveamdmachine.tuple_from_elements %baseline, %candidate
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %keep, %pair
      : !waveamdmachine.reg<vgpr, 46>, !waveamdmachine.reg<vgpr, 2>
}
}

// IR-LABEL: func.func @joint_noinst_sequence_peak
// IR: waveamdmachine.sched_barrier
// IR-NEXT: [[JOINT_CANDIDATE:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[JOINT_BASELINE:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.tuple_from_elements [[JOINT_BASELINE]], [[JOINT_CANDIDATE]]
// DIAG: waveamd-machine-schedule region func=joint_noinst_sequence_peak index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @staggered_vgpr_agpr_family_peak()
    -> !waveamdmachine.reg<vgpr, 53>
    attributes {waveamdmachine.target_waves = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %keep = waveamdmachine.v_mov_b32_tuple %zero {registers = 53 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 53>
  %x = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.sched_barrier
  %baseline = waveamdmachine.v_accvgpr_write_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 1>
  %candidate = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return %keep : !waveamdmachine.reg<vgpr, 53>
}
}

// IR-LABEL: func.func @staggered_vgpr_agpr_family_peak
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_accvgpr_write_b32_tuple
// DIAG: waveamd-machine-schedule region func=staggered_vgpr_agpr_family_peak index=1
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_issue_stream_keeps_first_filler(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token,
    %inc0: !waveamdmachine.reg<vgpr, 1>,
    %inc1: !waveamdmachine.reg<vgpr, 1>,
    %keep0: !waveamdmachine.reg<sgpr, 1>,
    %keep1: !waveamdmachine.reg<sgpr, 1>)
    attributes {waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 56 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 56>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %raised = waveamdmachine.v_add_u32 %inc0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<vgpr, 56>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 56>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 56>)
  } -> !waveamdmachine.reg<vgpr, 56>
  return
}

func.func @shared_issue_streams_prefer_pressure_neutral_filler(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token,
    %inc0: !waveamdmachine.reg<vgpr, 1>,
    %inc1: !waveamdmachine.reg<vgpr, 1>,
    %keep0: !waveamdmachine.reg<sgpr, 1>,
    %keep1: !waveamdmachine.reg<sgpr, 1>)
    attributes {gpu.known_block_size = array<i32: 256, 1, 1>,
                wave.waves_per_workgroup = 4 : i64,
                wave.workgroup_size = array<i32: 256, 1, 1>,
                waveamdmachine.target_waves = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 56 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 56>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %raised = waveamdmachine.v_add_u32 %inc0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %neutral = waveamdmachine.s_cmp_eq_u32 %keep0, %keep1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %use0 = waveamdmachine.v_xor_b32 %raised, %inc0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_xor_b32 %use0, %inc1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<vgpr, 56>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 56>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 56>)
  } -> !waveamdmachine.reg<vgpr, 56>
  return
}
}

// IR-LABEL: func.func @single_issue_stream_keeps_first_filler
// IR: [[SINGLE_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[RAISED:%.*]] = waveamdmachine.v_add_u32
// WORK-LABEL: waveamd-machine-schedule-report candidate func=single_issue_stream_keeps_first_filler region=0 name=greedy
// WORK-SAME: order=0,1,2,4,3,5,6,7
// WORK-SAME: pressure_state_builds=7 pressure_member_visits=77
// WORK-SAME: pressure_projections=15 pressure_projected_nodes=19 pressure_projection_checks=6

// IR-LABEL: func.func @shared_issue_streams_prefer_pressure_neutral_filler
// IR: [[SHARED_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[NEUTRAL:%.*]] = waveamdmachine.s_cmp_eq_u32
// IR-NOT: waveamdmachine.v_add_u32
// IR: waveamdmachine.global_load_lds_b32
// DIAG: waveamd-machine-schedule region func=shared_issue_streams_prefer_pressure_neutral_filler
// DIAG-SAME: action=apply reason=m0_hazard
// DIAG-SAME: m0_gaps={{[1-9][0-9]*}}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_stream_under_sgpr_limit(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 64 : i64} {
  waveamdmachine.sched_barrier
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %candidate = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @single_stream_under_sgpr_limit
// IR: waveamdmachine.sched_barrier
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=single_stream_under_sgpr_limit index=0
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=1
// DIAG-SAME: pressure_priority_moves=0
// WORK-LABEL: waveamd-machine-schedule-report candidate func=single_stream_under_sgpr_limit region=0 name=greedy
// WORK-SAME: order=0,2,1
// WORK-SAME: pressure_state_builds=3 pressure_member_visits=27
// WORK-SAME: pressure_projections=9 pressure_projected_nodes=12 pressure_projection_checks=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @ready_pressure_below_raw_limit() -> !waveamdmachine.reg<sgpr, 56>
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 64 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 56>
  %s0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s1 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %u0 = waveamdmachine.s_cmp_eq_u32 %s0, %s0
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %u1 = waveamdmachine.s_cmp_eq_u32 %s1, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return %wide : !waveamdmachine.reg<sgpr, 56>
}

func.func @ready_pressure_at_raw_limit() -> !waveamdmachine.reg<sgpr, 62>
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 64 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 62>
  %s0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s1 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %u0 = waveamdmachine.s_cmp_eq_u32 %s0, %s0
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %u1 = waveamdmachine.s_cmp_eq_u32 %s1, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return %wide : !waveamdmachine.reg<sgpr, 62>
}

func.func @ready_pressure_over_raw_limit() -> !waveamdmachine.reg<sgpr, 63>
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 64 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 63>
  %s0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s1 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %u0 = waveamdmachine.s_cmp_eq_u32 %s0, %s0
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %u1 = waveamdmachine.s_cmp_eq_u32 %s1, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return %wide : !waveamdmachine.reg<sgpr, 63>
}
}

// IR-LABEL: func.func @ready_pressure_below_raw_limit
// IR: [[UWIDE:%.*]] = waveamdmachine.s_mov_b32_tuple
// IR-NEXT: [[US0:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: [[US1:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[US0]], [[US0]]
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[US1]], [[US1]]
// IR-LABEL: func.func @ready_pressure_at_raw_limit
// IR: waveamdmachine.s_mov_b32_tuple
// IR-NEXT: [[AS0:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: [[AS1:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[AS0]], [[AS0]]
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[AS1]], [[AS1]]
// IR-LABEL: func.func @ready_pressure_over_raw_limit
// IR: [[OWIDE:%.*]] = waveamdmachine.s_mov_b32_tuple
// IR-NEXT: [[OS0:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[OS0]], [[OS0]]
// IR-NEXT: [[OS1:%.*]] = waveamdmachine.s_mov_b32_value
// IR-NEXT: waveamdmachine.s_cmp_eq_u32 [[OS1]], [[OS1]]
// DIAG: waveamd-machine-schedule region func=ready_pressure_below_raw_limit
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: pressure_priority_moves=0
// DIAG: waveamd-machine-schedule region func=ready_pressure_at_raw_limit
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: pressure_priority_moves=0
// DIAG: waveamd-machine-schedule region func=ready_pressure_over_raw_limit
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1
// WORK-LABEL: waveamd-machine-schedule-report candidate func=ready_pressure_over_raw_limit region=0 name=greedy
// WORK-SAME: order=0,1,2,4,3,5
// WORK-SAME: pressure_state_builds=5 pressure_member_visits=15
// WORK-SAME: pressure_projections=12 pressure_projected_nodes=16 pressure_projection_checks=13

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_stream_vgpr_pressure_over_raw_limit()
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.vgpr_count_max = 1 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %gap = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_add_u32 %v0, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_add_u32 %v1, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @ready_vgpr_pressure_over_budget()
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %gap = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_add_u32 %v0, %v0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_add_u32 %v1, %v1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @single_stream_vgpr_pressure_over_raw_limit
// IR: [[UV0:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.v_mov_b32_tuple
// IR-NEXT: [[UV1:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.v_add_u32 [[UV0]], [[UV0]]
// IR-NEXT: waveamdmachine.v_add_u32 [[UV1]], [[UV1]]
// IR-LABEL: func.func @ready_vgpr_pressure_over_budget
// IR: [[OV0:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.v_add_u32 [[OV0]], [[OV0]]
// IR-NEXT: waveamdmachine.v_mov_b32_tuple
// IR-NEXT: [[OV1:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.v_add_u32 [[OV1]], [[OV1]]
// DIAG: waveamd-machine-schedule region func=single_stream_vgpr_pressure_over_raw_limit
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: pressure_priority_moves=0
// DIAG: waveamd-machine-schedule region func=ready_vgpr_pressure_over_budget
// DIAG-SAME: action=apply reason=register_pressure
// DIAG-SAME: pressure_priority_moves=1
// WORK-LABEL: waveamd-machine-schedule-report candidate func=ready_vgpr_pressure_over_budget region=0 name=greedy
// WORK-SAME: order=0,1,4,2,3,5
// WORK-SAME: pressure_state_builds=5 pressure_member_visits=25
// WORK-SAME: pressure_projections=14 pressure_projected_nodes=18 pressure_projection_checks=8
