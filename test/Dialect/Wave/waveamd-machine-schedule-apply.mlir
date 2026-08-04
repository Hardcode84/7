// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' --waveamd-barrier-cleanup | FileCheck %s --check-prefix=CLEANUP
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-classes=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=CLASS
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1 max-region-ops=2' | FileCheck %s --check-prefix=CAP
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' --mlir-timing --mlir-timing-display=tree 2>&1 >/dev/null | FileCheck %s --check-prefix=TIMING

// TIMING: wave_machine_schedule_stages
// TIMING: machine_schedule_setup
// TIMING: machine_schedule_prepare_function
// TIMING: machine_schedule_collect_regions
// TIMING: machine_schedule_build_value_origins
// TIMING: machine_schedule_build_model
// TIMING: machine_schedule_build_graph
// TIMING: machine_schedule_build_order
// TIMING: machine_schedule_apply_order

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill(%base: !waveamdmachine.reg<sgpr, 1>,
                   %off: !waveamdmachine.reg<vgpr, 1>,
                   %ptr: !waveamdmachine.reg<sgpr, 2>,
                   %a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @m0_fill
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// CAP-LABEL: func.func @m0_fill
// CAP: [[M0:%.*]] = waveamdmachine.s_mov_m0
// CAP-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// DIAG: waveamd-machine-schedule region func=m0_fill
// DIAG-SAME: action=apply reason=m0_hazard
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: m0_gaps=1

// -----

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
func.func @store_data_fill(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %data0: !waveamdmachine.reg<vgpr, 4>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>,
    %stride: !waveamdmachine.reg<sgpr, 1>,
    %index: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %tok0 = waveamdmachine.buffer_store_b128 %off0, %data0, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  %p0 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p1 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p2 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p3 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %data1 = waveamdmachine.tuple_from_elements %p0, %p1, %p2, %p3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %scaled = waveamdmachine.v_mul_lo_u32 %stride, %index
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %off1 = waveamdmachine.v_lshl_add_u32 %scaled, %one, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %tok1 = waveamdmachine.buffer_store_b128 %off1, %data1, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @store_data_fill
// IR: waveamdmachine.buffer_store_b128
// IR-NEXT: [[SCALED:%.*]] = waveamdmachine.v_mul_lo_u32
// IR-NEXT: [[OFF:%.*]] = waveamdmachine.v_lshl_add_u32 [[SCALED]]
// IR-NEXT: [[P0:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P1:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P2:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P3:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[DATA:%.*]] = waveamdmachine.tuple_from_elements [[P0]], [[P1]], [[P2]], [[P3]]
// IR-NEXT: waveamdmachine.buffer_store_b128 [[OFF]], [[DATA]]
// DIAG: waveamd-machine-schedule region func=store_data_fill
// DIAG-SAME: action=apply reason=store_data_hazard
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: store_data_gaps=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @memory_prefetch(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %c: !waveamdmachine.reg<vgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_add_u32 %x, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %load_off = waveamdmachine.v_add_u32 %off, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok = waveamdmachine.global_load_b32 %load_off, %ptr after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %y, %loaded
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @memory_prefetch
// IR: [[OFF:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b32 [[OFF]]
// IR-NEXT: [[X:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[Y:%.*]] = waveamdmachine.v_add_u32 [[X]]
// IR-NEXT: waveamdmachine.v_add_u32 [[Y]], [[LOADED]]
// DIAG: waveamd-machine-schedule region func=memory_prefetch
// DIAG-SAME: action=apply reason=vmem_prefetch
// DIAG-SAME: vmem_prefetch_moves=2
// DIAG-SAME: long_latency_vmem_prefetch_moves=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @long_latency_memory_prefetch(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %off1: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>)
    attributes {waveamdmachine.target_waves = 2 : i64} {
  %v0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %v0, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_add_u32 %v1, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_add_u32 %v2, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_add_u32 %v3, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_add_u32 %v4, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_add_u32 %v5, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_add_u32 %v6, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_add_u32 %v7, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_add_u32 %v8, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_add_u32 %v9, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_add_u32 %v10, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_add_u32 %v11, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_add_u32 %v12, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_add_u32 %v13, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_add_u32 %v14, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v16 = waveamdmachine.v_add_u32 %v15, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v17 = waveamdmachine.v_add_u32 %v16, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v18 = waveamdmachine.v_add_u32 %v17, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v19 = waveamdmachine.v_add_u32 %v18, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v20 = waveamdmachine.v_add_u32 %v19, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loaded0, %tok0 = waveamdmachine.global_load_b32 %off0, %ptr
      {cache = #waveamd.load_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %loaded1, %tok1 = waveamdmachine.global_load_b32 %off1, %ptr
      {cache = #waveamd.load_cache<cs>}
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum0 = waveamdmachine.v_add_u32 %v20, %loaded0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_u32 %sum0, %loaded1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %packed = waveamdmachine.tuple_from_elements %sum1, %sum1, %sum1, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %s0 : !waveamdmachine.reg<sgpr, 1>
  } otherwise {
    waveamdmachine.yield %s1 : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @long_latency_memory_prefetch
// IR: [[LOADED0:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// IR-SAME: cache = #waveamd.load_cache<cs>
// IR-NEXT: [[LOADED1:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// IR-SAME: cache = #waveamd.load_cache<cs>
// IR-NEXT: [[V0:%.*]] = waveamdmachine.v_add_u32
// IR: [[SUM0:%.*]] = waveamdmachine.v_add_u32 {{%.*}}, [[LOADED0]]
// IR-NEXT: waveamdmachine.v_add_u32 [[SUM0]], [[LOADED1]]
// DIAG: waveamd-machine-schedule region func=long_latency_memory_prefetch
// DIAG-SAME: action=apply reason=vmem_prefetch
// DIAG-SAME: long_latency_vmem_prefetch_moves=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @long_latency_prefetch_respects_repeated_loop_carry_pressure(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>)
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 96 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 32 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 32>
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%wide, %wide : !waveamdmachine.reg<vgpr, 32>,
              !waveamdmachine.reg<vgpr, 32>) {
  ^bb0(%carry0: !waveamdmachine.reg<vgpr, 32>,
       %carry1: !waveamdmachine.reg<vgpr, 32>):
  %loop_wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 32 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 32>
  %v0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %v0, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_add_u32 %v1, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_add_u32 %v2, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_add_u32 %v3, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_add_u32 %v4, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_add_u32 %v5, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_add_u32 %v6, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_add_u32 %v7, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_add_u32 %v8, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_add_u32 %v9, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_add_u32 %v10, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_add_u32 %v11, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_add_u32 %v12, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_add_u32 %v13, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_add_u32 %v14, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v16 = waveamdmachine.v_add_u32 %v15, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v17 = waveamdmachine.v_add_u32 %v16, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v18 = waveamdmachine.v_add_u32 %v17, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v19 = waveamdmachine.v_add_u32 %v18, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v20 = waveamdmachine.v_add_u32 %v19, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok = waveamdmachine.global_load_b64 %off, %ptr
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %parts:2 = waveamdmachine.tuple_to_elements %loaded
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %sum = waveamdmachine.v_add_u32 %v20, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
      carries(%carry0, %carry1 : !waveamdmachine.reg<vgpr, 32>,
              !waveamdmachine.reg<vgpr, 32>)
  } -> !waveamdmachine.reg<vgpr, 32>, !waveamdmachine.reg<vgpr, 32>
  return
}
}

// IR-LABEL: func.func @long_latency_prefetch_respects_repeated_loop_carry_pressure
// IR: waveamdmachine.v_mov_b32_tuple
// IR: waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.v_mov_b32_tuple
// IR-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b64
// IR-NEXT: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements [[LOADED]]
// IR-NEXT: [[V0:%.*]] = waveamdmachine.v_add_u32
// IR: waveamdmachine.v_add_u32 {{%.*}}, [[PARTS]]#0
// DIAG: waveamd-machine-schedule region func=long_latency_prefetch_respects_repeated_loop_carry_pressure index=1
// DIAG-SAME: action=apply reason=vmem_prefetch
// DIAG-SAME: long_latency_vmem_prefetch_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_keeps_same_counter_order(%base: !waveamdmachine.reg<sgpr, 1>,
                                            %off0: !waveamdmachine.reg<vgpr, 1>,
                                            %off1: !waveamdmachine.reg<vgpr, 1>,
                                            %ptr: !waveamdmachine.reg<sgpr, 2>,
                                            %dep0: !waveamdmachine.mem.token,
                                            %dep1: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok0 = waveamdmachine.global_load_lds_b32 %off0, %ptr, %m0 after %dep0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off1, %ptr after %dep1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}
}

// IR-LABEL: func.func @m0_fill_keeps_same_counter_order
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// IR-NEXT: waveamdmachine.global_load_b32
// DIAG: waveamd-machine-schedule region func=m0_fill_keeps_same_counter_order
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: unfilled_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_keeps_same_counter_order_through_loop_arg(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %init = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %result = waveamdmachine.uniform_loop if %scc : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.mem.token) {
  ^bb0(%tok: !waveamdmachine.mem.token):
    %next_m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %next = waveamdmachine.global_load_lds_b32 %off, %ptr, %next_m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    %store = waveamdmachine.ds_store_b32 %addr, %value after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @m0_fill_keeps_same_counter_order_through_loop_arg
// IR: ^bb0([[TOK:%.*]]: !waveamdmachine.mem.token):
// IR-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after [[TOK]]
// IR-NEXT: waveamdmachine.ds_store_b32 {{.*}} after [[TOK]]
// DIAG: waveamd-machine-schedule region func=m0_fill_keeps_same_counter_order_through_loop_arg
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_through_noinst(%base: !waveamdmachine.reg<sgpr, 1>,
                                  %off: !waveamdmachine.reg<vgpr, 1>,
                                  %ptr: !waveamdmachine.reg<sgpr, 2>,
                                  %wide: !waveamdmachine.reg<vgpr, 2>,
                                  %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %parts:2 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>)
  %x = waveamdmachine.v_add_u32 %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @m0_fill_through_noinst
// IR: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
// IR-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32 [[PARTS]]#0, [[PARTS]]#1
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @valu_addr_gap_not_overfilled(%base: !waveamdmachine.reg<vgpr, 1>,
                                        %offset: !waveamdmachine.reg<vgpr, 1>,
                                        %lhs: !waveamdmachine.reg<sgpr, 1>,
                                        %rhs: !waveamdmachine.reg<sgpr, 1>,
                                        %tok: !waveamdmachine.mem.token) {
  %addr = waveamdmachine.v_add_u32 %base, %offset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ld, %next = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum, %scc = waveamdmachine.s_add_i32 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @valu_addr_gap_not_overfilled
// IR: [[ADDR:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_load_b32 [[ADDR]]
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=valu_addr_gap_not_overfilled
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barrier_memory_gap_fill(%addr: !waveamdmachine.reg<vgpr, 1>,
                                   %s0: !waveamdmachine.reg<sgpr, 1>,
                                   %s1: !waveamdmachine.reg<sgpr, 1>,
                                   %s2: !waveamdmachine.reg<sgpr, 1>,
                                   %tok: !waveamdmachine.mem.token) {
  %ld0, %t0 = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_load_b32 %addr after %t0 offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %bt = waveamdmachine.s_barrier %t1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_lshl_b32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %y, %sy = waveamdmachine.s_add_i32 %x, %s2
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @barrier_memory_gap_fill
// IR: waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.ds_load_b32
// IR-NEXT: [[SHIFT:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
// IR-NEXT: waveamdmachine.s_add_i32 [[SHIFT]]
// IR-NEXT: waveamdmachine.s_barrier
// DIAG: waveamd-machine-schedule region func=barrier_memory_gap_fill
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: memory_token_gaps={{[2-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=2

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

func.func @shared_issue_streams_reserve_sgpr_granule(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token)
    attributes {waveamdmachine.target_waves = 8 : i64,
                waveamdmachine.sgpr_count_max = 48 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 29>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %neutral = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<sgpr, 29>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 29>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<sgpr, 29>)
  } -> !waveamdmachine.reg<sgpr, 29>
  %raised = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %done = waveamdmachine.s_cmp_eq_u32 %raised, %raised
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return
}

func.func @shared_issue_streams_account_agpr_in_vgpr_family(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %dep: !waveamdmachine.mem.token)
    attributes {waveamdmachine.target_waves = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.v_mov_b32_tuple %zero {registers = 55 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 55>
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %neutral = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %looped = waveamdmachine.uniform_loop if %neutral
      : !waveamdmachine.reg<scc, 1>
      carries(%wide : !waveamdmachine.reg<vgpr, 55>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 55>):
    waveamdmachine.continue_if %neutral : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<vgpr, 55>)
  } -> !waveamdmachine.reg<vgpr, 55>
  %raised = waveamdmachine.v_accvgpr_write_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<agpr, 1>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %raised
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @single_issue_stream_keeps_first_filler
// IR: [[SINGLE_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[RAISED:%.*]] = waveamdmachine.v_add_u32

// IR-LABEL: func.func @shared_issue_streams_prefer_pressure_neutral_filler
// IR: [[SHARED_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[NEUTRAL:%.*]] = waveamdmachine.s_cmp_eq_u32
// IR-NOT: waveamdmachine.v_add_u32
// IR: waveamdmachine.global_load_lds_b32
// DIAG: waveamd-machine-schedule region func=shared_issue_streams_prefer_pressure_neutral_filler
// DIAG-SAME: action=apply reason=m0_hazard
// DIAG-SAME: m0_gaps={{[1-9][0-9]*}}

// IR-LABEL: func.func @shared_issue_streams_reserve_sgpr_granule
// IR: [[SGPR_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[SGPR_NEUTRAL:%.*]] = waveamdmachine.s_cmp_eq_u32
// IR-NOT: waveamdmachine.s_mov_b32_value
// IR: waveamdmachine.global_load_lds_b32

// IR-LABEL: func.func @shared_issue_streams_account_agpr_in_vgpr_family
// IR: [[AGPR_M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[AGPR_NEUTRAL:%.*]] = waveamdmachine.s_cmp_eq_u32
// IR-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// IR: waveamdmachine.global_load_lds_b32

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @set_priority_cuts_prefetch(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %before = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  waveamdmachine.s_setprio %two : (!waveamdmachine.imm) -> ()
  %loaded, %loaded_token = waveamdmachine.global_load_b32
      %off, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %before, %loaded
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @blocked_original_uses_resource_model(
    %init: !waveamdmachine.reg<vgpr, 1>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %result = waveamdmachine.uniform_loop
      carries(%init : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%carry: !waveamdmachine.reg<vgpr, 1>):
    %next = waveamdmachine.v_add_u32 %carry, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %read = waveamdmachine.v_xor_b32 %carry, %x
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @set_priority_cuts_prefetch
// IR-NOT: waveamdmachine.global_load_b32
// IR: [[BEFORE:%.*]] = waveamdmachine.v_add_u32
// IR-NOT: waveamdmachine.global_load_b32
// IR: waveamdmachine.s_setprio
// IR-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b32
// IR: waveamdmachine.v_add_u32 [[BEFORE]], [[LOADED]]
// DIAG: waveamd-machine-schedule region func=set_priority_cuts_prefetch index=1 ops=1 action=keep reason=same_order

// IR-LABEL: func.func @blocked_original_uses_resource_model
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_add_u32
// DIAG: waveamd-machine-schedule region func=blocked_original_uses_resource_model
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_recurrence_across_memory(
    %init: !waveamdmachine.reg<vgpr, 2>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %result = waveamdmachine.uniform_loop
      carries(%init : !waveamdmachine.reg<vgpr, 2>) {
  ^bb0(%address: !waveamdmachine.reg<vgpr, 2>):
    %parts:2 = waveamdmachine.tuple_to_elements %address
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>)
    %independent = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %loaded, %token = waveamdmachine.ds_load_b32 %parts#0
        : (!waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %mfma_parts:4 = waveamdmachine.tuple_to_elements %mfma
        : (!waveamdmachine.reg<vgpr, 4>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>)
    %next0 = waveamdmachine.v_add_u32 %parts#0, %mfma_parts#0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next = waveamdmachine.tuple_from_elements %next0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<vgpr, 2>)
  } -> !waveamdmachine.reg<vgpr, 2>
  return
}
}

// IR-LABEL: func.func @compute_recurrence_across_memory
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR: waveamdmachine.v_xor_b32
// IR: waveamdmachine.ds_load_b32
// DIAG: waveamd-machine-schedule region func=compute_recurrence_across_memory
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves={{[1-9][0-9]*}}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_resource_overlap(
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %s2: !waveamdmachine.reg<sgpr, 1>,
    %s3: !waveamdmachine.reg<sgpr, 1>,
    %s4: !waveamdmachine.reg<sgpr, 1>,
    %s5: !waveamdmachine.reg<sgpr, 1>,
    %s6: !waveamdmachine.reg<sgpr, 1>,
    %s7: !waveamdmachine.reg<sgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>) {
  %x0, %cc0 = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x1, %cc1 = waveamdmachine.s_add_i32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x2, %cc2 = waveamdmachine.s_add_i32 %s4, %s5
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x3, %cc3 = waveamdmachine.s_add_i32 %s6, %s7
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %r0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// IR-LABEL: func.func @compute_resource_overlap
// IR: [[R0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: {{%.*}} = waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[R0]]
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=compute_resource_overlap
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves=2
// CLASS: waveamd-machine-schedule-report op func=compute_resource_overlap {{.*}}name=waveamdmachine.s_add_i32 class=WriteSALU fu=SALU latency=1 resource_cycles=1
// CLASS: waveamd-machine-schedule-report op func=compute_resource_overlap {{.*}}name=waveamdmachine.mfma_f32_16x16x32_f16 class=Write4PassMAI fu=MFMA_XDL latency=4 resource_cycles=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_resource_model_preserves_equal_rank(
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>) {
  %sum, %cc = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// IR-LABEL: func.func @compute_resource_model_preserves_equal_rank(
// IR-SAME: [[S0:%[^ ,]+]]: !waveamdmachine.reg<sgpr, 1>,
// IR-SAME: [[S1:%[^ ,]+]]: !waveamdmachine.reg<sgpr, 1>,
// IR-SAME: [[A:%[^ ,]+]]: !waveamdmachine.reg<vgpr, 4>,
// IR-SAME: [[B:%[^ ,]+]]: !waveamdmachine.reg<vgpr, 4>,
// IR-SAME: [[ACC0:%[^ ,]+]]: !waveamdmachine.reg<vgpr, 4>,
// IR-SAME: [[ACC1:%[^ ,]+]]: !waveamdmachine.reg<vgpr, 4>)
// IR: waveamdmachine.mfma_f32_16x16x32_f16 [[A]], [[B]], [[ACC0]]
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16 [[A]], [[B]], [[ACC1]]
// DIAG: waveamd-machine-schedule region func=compute_resource_model_preserves_equal_rank
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_resource_pressure_rejects_priority(
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>)
    -> !waveamdmachine.reg<vgpr, 4>
    attributes {waveamdmachine.target_waves = 2 : i64,
                waveamdmachine.vgpr_count_max = 8 : i64} {
  %dead = waveamdmachine.v_add_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %r0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %hold_acc = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return %hold_acc : !waveamdmachine.reg<vgpr, 4>
}
}

// IR-LABEL: func.func @compute_resource_pressure_rejects_priority
// IR: waveamdmachine.v_add_f32
// IR-NEXT: [[PRESSURE_R0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16 {{.*}}, [[PRESSURE_R0]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=compute_resource_pressure_rejects_priority
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: resource_priority_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_resource_stall_fill(
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %s2: !waveamdmachine.reg<sgpr, 1>,
    %s3: !waveamdmachine.reg<sgpr, 1>,
    %s4: !waveamdmachine.reg<sgpr, 1>,
    %s5: !waveamdmachine.reg<sgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>) {
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %x0, %cc0 = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x1, %cc1 = waveamdmachine.s_add_i32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x2, %cc2 = waveamdmachine.s_add_i32 %s4, %s5
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @compute_resource_stall_fill
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=compute_resource_stall_fill
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_priority_moves=0
// DIAG-SAME: resource_stall_fills=3

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @mfma_packed_coissue_stall_fill(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %packed_lhs: !waveamdmachine.reg<vgpr, 2>,
    %packed_rhs: !waveamdmachine.reg<vgpr, 2>,
    %x0: !waveamdmachine.reg<vgpr, 1>,
    %y0: !waveamdmachine.reg<vgpr, 1>,
    %x1: !waveamdmachine.reg<vgpr, 1>,
    %y1: !waveamdmachine.reg<vgpr, 1>,
    %x2: !waveamdmachine.reg<vgpr, 1>,
    %y2: !waveamdmachine.reg<vgpr, 1>) {
  %mfma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %packed = waveamdmachine.v_pk_add_f32 %packed_lhs, %packed_rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %fill0 = waveamdmachine.v_add_f32 %x0, %y0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill1 = waveamdmachine.v_add_f32 %x1, %y1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill2 = waveamdmachine.v_add_f32 %x2, %y2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @mfma_packed_coissue_stall_fill
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.v_add_f32
// IR-NEXT: waveamdmachine.v_add_f32
// IR-NEXT: waveamdmachine.v_add_f32
// IR-NEXT: waveamdmachine.v_pk_add_f32
// DIAG: waveamd-machine-schedule region func=mfma_packed_coissue_stall_fill
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=3

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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_wave_pressure_model_accepts_resource_filler(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1>
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 96 : i64} {
  %keep = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %parts:4 = waveamdmachine.tuple_to_elements %r1
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %used = waveamdmachine.v_add_u32 %parts#0, %keep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum, %scc = waveamdmachine.s_add_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %sum : !waveamdmachine.reg<sgpr, 1>
}

func.func @single_wave_pressure_model_rejects_resource_filler(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
    attributes {waveamdmachine.target_waves = 1 : i64,
                waveamdmachine.sgpr_count_max = 2 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %wide = waveamdmachine.s_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  waveamdmachine.sched_barrier
  %keep = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %parts:4 = waveamdmachine.tuple_to_elements %r1
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %used = waveamdmachine.v_add_u32 %parts#0, %keep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum, %scc = waveamdmachine.s_add_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %sum, %wide
      : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 2>
}
}

// IR-LABEL: func.func @single_wave_pressure_model_accepts_resource_filler
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[ACCEPT_SUM:%.*]], {{%.*}} = waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[ACCEPT_PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
// IR-NEXT: waveamdmachine.v_add_u32 [[ACCEPT_PARTS]]#0
// IR-NEXT: return [[ACCEPT_SUM]]
// DIAG: waveamd-machine-schedule region func=single_wave_pressure_model_accepts_resource_filler
// DIAG-SAME: action=apply reason=compute_resource
// DIAG-SAME: resource_stall_fills=1
// DIAG-SAME: pressure_priority_moves=0
// IR-LABEL: func.func @single_wave_pressure_model_rejects_resource_filler
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements
// IR-NEXT: waveamdmachine.v_add_u32 [[PARTS]]#0
// IR-NEXT: [[SUM:%.*]], {{%.*}} = waveamdmachine.s_add_i32
// IR-NEXT: return [[SUM]]
// DIAG: waveamd-machine-schedule region func=single_wave_pressure_model_rejects_resource_filler
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: resource_stall_fills=0
// DIAG-SAME: pressure_priority_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @mfma_result_hazard_fill(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc0: !waveamdmachine.reg<vgpr, 4>,
    %acc1: !waveamdmachine.reg<vgpr, 4>,
    %acc2: !waveamdmachine.reg<vgpr, 4>,
    %acc3: !waveamdmachine.reg<vgpr, 4>,
    %acc4: !waveamdmachine.reg<vgpr, 4>,
    %acc5: !waveamdmachine.reg<vgpr, 4>,
    %acc6: !waveamdmachine.reg<vgpr, 4>,
    %acc7: !waveamdmachine.reg<vgpr, 4>,
    %acc8: !waveamdmachine.reg<vgpr, 4>) {
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %parts:4 = waveamdmachine.tuple_to_elements %r0
      : (!waveamdmachine.reg<vgpr, 4>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc2
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc3
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc4
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc5
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc6
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc7
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc8
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %packed = waveamdmachine.v_cvt_pk_f16_f32 %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @mfma_result_hazard_fill
// IR: [[R0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[PARTS:%.*]]:4 = waveamdmachine.tuple_to_elements [[R0]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.v_cvt_pk_f16_f32 [[PARTS]]#0, [[PARTS]]#1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @valu_to_mfma_hazard_fill(
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %r = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %fill0 = waveamdmachine.v_xor_b32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill1 = waveamdmachine.v_add_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @valu_to_mfma_hazard_fill
// IR: [[A:%.*]] = waveamdmachine.v_mov_b32_tuple
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16 [[A]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @compute_resource_barrier_boundary(
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %s2: !waveamdmachine.reg<sgpr, 1>,
    %s3: !waveamdmachine.reg<sgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %token: !waveamdmachine.mem.token) {
  %x0, %cc0 = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %x1, %cc1 = waveamdmachine.s_add_i32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %ready = waveamdmachine.s_barrier %token
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// IR-LABEL: func.func @compute_resource_barrier_boundary
// IR: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// DIAG: waveamd-machine-schedule region func=compute_resource_barrier_boundary
// DIAG-SAME: resource_priority_moves=0
// DIAG-SAME: resource_stall_fills=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @trans_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>,
                             %c: !waveamdmachine.reg<vgpr, 1>) {
  %trans = waveamdmachine.v_rcp_f32 %a
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_mul_f32 %trans, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill = waveamdmachine.v_add_u32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @trans_hazard_fill
// IR: [[TRANS:%.*]] = waveamdmachine.v_rcp_f32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_mul_f32 [[TRANS]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @readfirstlane_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                                     %b: !waveamdmachine.reg<vgpr, 1>,
                                     %c: !waveamdmachine.reg<vgpr, 1>) {
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %first = waveamdmachine.v_readfirstlane_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %fill = waveamdmachine.v_xor_b32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @readfirstlane_hazard_fill
// IR: [[SUM:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_readfirstlane_b32 [[SUM]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @vcc_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>,
                           %c: !waveamdmachine.reg<vgpr, 1>,
                           %d: !waveamdmachine.reg<vgpr, 1>) {
  %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum = waveamdmachine.v_add_u32 %a, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %vcc
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @vcc_hazard_fill
// IR: {{%.*}}, [[VCC:%.*]] = waveamdmachine.v_cmp_ge_u32_vcc
// IR-NEXT: [[SUM:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_cndmask_b32_vcc {{.*}}, [[SUM]], [[VCC]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @direct_sgpr_mask_hazard_fill(
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %c: !waveamdmachine.reg<vgpr, 1>,
    %d: !waveamdmachine.reg<vgpr, 1>) {
  %mask = waveamdmachine.v_cmp_ge_i32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<sgpr, 2>
  %pick = waveamdmachine.v_cndmask_b32_tuple %a, %b, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  %fill0 = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill1 = waveamdmachine.v_add_u32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @direct_sgpr_mask_hazard_fill
// IR: [[MASK:%.*]] = waveamdmachine.v_cmp_ge_i32
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_cndmask_b32_tuple {{.*}}, [[MASK]]
// DIAG: waveamd-machine-schedule region func=direct_sgpr_mask_hazard_fill
// DIAG-SAME: action=apply reason=greedy
// DIAG-SAME: filled_gaps=2 unfilled_gaps=0
// DIAG-SAME: cheap_hazard_gaps=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @cluster_barrier_pair_after_compute(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %tok0: !waveamdmachine.mem.token,
    %tok1: !waveamdmachine.mem.token) {
  %mma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %barrier0 = waveamdmachine.s_barrier %tok0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %sum, %scc = waveamdmachine.s_add_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %barrier1 = waveamdmachine.s_barrier %tok1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %barrier0, %barrier1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @cluster_barrier_pair_after_compute
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: [[BARRIER0:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: [[BARRIER1:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: waveamdmachine.token_join [[BARRIER0]], [[BARRIER1]]
// DIAG: waveamd-machine-schedule region func=cluster_barrier_pair_after_compute
// DIAG-SAME: action=apply reason=greedy
// CLEANUP-LABEL: func.func @cluster_barrier_pair_after_compute
// CLEANUP: waveamdmachine.mfma_f32_16x16x32_f16
// CLEANUP-NEXT: waveamdmachine.s_add_i32
// CLEANUP-NEXT: [[BARRIER:%.*]] = waveamdmachine.s_barrier
// CLEANUP-NOT: waveamdmachine.s_barrier
// CLEANUP: return

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @cluster_barrier_run_after_stall_fill(
    %addr0: !waveamdmachine.reg<vgpr, 1>,
    %addr1: !waveamdmachine.reg<vgpr, 1>,
    %addr2: !waveamdmachine.reg<vgpr, 1>,
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %tok: !waveamdmachine.mem.token) {
  %ld0, %t0 = waveamdmachine.ds_load_b32 %addr0 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_load_b32 %addr1 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ld2, %t2 = waveamdmachine.ds_load_b32 %addr2 after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b0 = waveamdmachine.s_barrier %t0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %b1 = waveamdmachine.s_barrier %t1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %j0 = waveamdmachine.token_join %b0, %b1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a0 = waveamdmachine.v_add_u32 %addr0, %addr1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use0, %u0 = waveamdmachine.ds_load_b32 %a0 after %j0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %b2 = waveamdmachine.s_barrier %t2
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %j1 = waveamdmachine.token_join %b0, %b2
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a1 = waveamdmachine.v_add_u32 %addr1, %addr2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use1, %u1 = waveamdmachine.ds_load_b32 %a1 after %j1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}
}

// IR-LABEL: func.func @cluster_barrier_run_after_stall_fill
// IR: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[RUN_B0:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: [[RUN_B1:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: [[RUN_J0:%.*]] = waveamdmachine.token_join [[RUN_B0]], [[RUN_B1]]
// IR-NEXT: waveamdmachine.ds_load_b32 {{.*}} after [[RUN_J0]]
// IR-NEXT: [[RUN_B2:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: waveamdmachine.token_join [[RUN_B0]], [[RUN_B2]]
// DIAG: waveamd-machine-schedule region func=cluster_barrier_run_after_stall_fill
// DIAG-SAME: action=apply reason=barrier_memory
// CLEANUP-LABEL: func.func @cluster_barrier_run_after_stall_fill
// CLEANUP: waveamdmachine.s_add_i32
// CLEANUP-NEXT: waveamdmachine.v_add_u32
// CLEANUP-NEXT: [[RUN_BARRIER0:%.*]] = waveamdmachine.s_barrier
// CLEANUP-NEXT: [[RUN_JOIN:%.*]] = waveamdmachine.token_join [[RUN_BARRIER0]], [[RUN_BARRIER0]]
// CLEANUP-NEXT: waveamdmachine.ds_load_b32 {{.*}} after [[RUN_JOIN]]
// CLEANUP-NEXT: [[RUN_BARRIER1:%.*]] = waveamdmachine.s_barrier
// CLEANUP-NOT: waveamdmachine.s_barrier
// CLEANUP: return

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_token_gap_fill(
    %addr_base: !waveamdmachine.reg<vgpr, 1>,
    %addr_off: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %s2: !waveamdmachine.reg<sgpr, 1>,
    %s3: !waveamdmachine.reg<sgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_add_u32 %addr_base, %addr_off
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %y, %sy = waveamdmachine.s_lshl_b32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_token_gap_fill
// IR: [[STATE:%.*]] = waveamdmachine.barrier_init
// IR-NEXT: [[ROOT:%.*]] = waveamdmachine.token
// IR-NEXT: [[ADDR:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[STORED:%.*]] = waveamdmachine.ds_store_b32 [[ADDR]]{{.*}} after [[ROOT]]
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_lshl_b32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[STORED]]
// IR-NEXT: {{%.*}} = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_token_gap_fill
// DIAG-SAME: action=apply reason=greedy
// CLASS: op func=split_barrier_arrive_token_gap_fill{{.*}}name=waveamdmachine.barrier_arrive
// CLASS-SAME: class=WriteLDS fu=LGKM
// CLASS: op func=split_barrier_arrive_token_gap_fill{{.*}}name=waveamdmachine.barrier_wait
// CLASS-SAME: class=WriteBarrier fu=BRANCH

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_after_valu_token_delay(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %v0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_after_valu_token_delay
// IR: [[STATE:%.*]] = waveamdmachine.barrier_init
// IR-NEXT: [[ROOT:%.*]] = waveamdmachine.token
// IR-NEXT: [[STORED:%.*]] = waveamdmachine.ds_store_b32{{.*}} after [[ROOT]]
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[STORED]]
// IR-NEXT: waveamdmachine.v_add_u32
// IR: {{%.*}} = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_after_valu_token_delay
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_after_mfma_token_delay(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r9 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r10 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r11 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r12 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r13 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r14 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r15 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_after_mfma_token_delay
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_after_mfma_token_delay
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_keeps_lgkm_producer_before_arrive(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %read, %read_token = waveamdmachine.ds_read_tr_b64_b8 %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r9 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r10 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r11 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r12 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r13 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r14 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r15 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_keeps_lgkm_producer_before_arrive
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_read_tr_b64_b8
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_keeps_lgkm_producer_before_arrive
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_memory_window_keep(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %value: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %g0, %t0 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g1, %t1 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g2, %t2 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g3, %t3 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_memory_window_keep
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_memory_window_keep
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @barrier_keep(%off: !waveamdmachine.reg<vgpr, 1>,
                        %base: !waveamdmachine.reg<sgpr, 2>,
                        %a: !waveamdmachine.reg<vgpr, 1>,
                        %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %tok2 = waveamdmachine.s_barrier %tok1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @barrier_keep
// IR: [[TOK0:%.*]] = waveamdmachine.token
// IR-NEXT: {{%.*}}, [[TOK1:%.*]] = waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier [[TOK1]]
// DIAG: waveamd-machine-schedule region func=barrier_keep
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: memory_token_gaps={{[1-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_barrier_memory_gap_fill(%addr: !waveamdmachine.reg<vgpr, 1>,
                                          %s0: !waveamdmachine.reg<sgpr, 1>,
                                          %s1: !waveamdmachine.reg<sgpr, 1>,
                                          %s2: !waveamdmachine.reg<sgpr, 1>,
                                          %s3: !waveamdmachine.reg<sgpr, 1>,
                                          %tok: !waveamdmachine.mem.token) {
  %ld, %t0 = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %t1 = waveamdmachine.s_barrier %t0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %y, %sy = waveamdmachine.s_lshl_b32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @single_barrier_memory_gap_fill
// IR: [[LD:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_lshl_b32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier [[TOK]]
// DIAG: waveamd-machine-schedule region func=single_barrier_memory_gap_fill
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: memory_token_gaps={{[2-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=2
