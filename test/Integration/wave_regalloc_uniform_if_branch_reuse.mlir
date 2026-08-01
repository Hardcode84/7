// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | FileCheck %s --check-prefix=ALLOC
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx90a -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// ALLOC-LABEL: func.func @uniform_if_branch_storage_reuse()
// ALLOC-SAME: waveamdmachine.regalloc_assignments
// ALLOC-SAME: waveamdmachine.vgpr_count = 64 : i64
// ALLOC: waveamdmachine.uniform_if
// ALLOC: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
// ALLOC-NEXT: [[THEN:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
// ALLOC-NEXT: waveamdmachine.yield [[THEN]] : !waveamdmachine.reg<vgpr, 64, 0>
// ALLOC: otherwise
// ALLOC-NEXT: waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
// ALLOC-NEXT: [[ELSE:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64, 0>
// ALLOC-NEXT: waveamdmachine.yield [[ELSE]] : !waveamdmachine.reg<vgpr, 64, 0>
// ASM-LABEL: uniform_if_branch_storage_reuse:
// ASM: s_cbranch_scc0
// ASM: s_branch
// ASM: v_cmpx_eq_u32
func.func @uniform_if_branch_storage_reuse()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
    %then = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
    waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 64>
  } otherwise {
    %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
    %else = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
    waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 64>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 64>
  %parts:2 = waveamdmachine.tuple_to_elements %selected
      : (!waveamdmachine.reg<vgpr, 64>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 63>)
  waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_sibling_loop_invariant_reuse()
// ALLOC: [[INIT:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, [[REG:[0-9]+]]>
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NOT: waveamdmachine.copy_tuple
// ALLOC: waveamdmachine.uniform_loop carries([[INIT]]
// ALLOC-NOT: waveamdmachine.v_mov_b32_tuple
// ALLOC: waveamdmachine.yield
// ALLOC: otherwise
// ALLOC-NOT: waveamdmachine.copy_tuple
// ALLOC: waveamdmachine.uniform_loop carries([[INIT]]
// ALLOC-NOT: waveamdmachine.v_mov_b32_tuple
// ALLOC: waveamdmachine.yield
// ASM-LABEL: uniform_if_sibling_loop_invariant_reuse:
// ASM-NOT: v_mov_b32
// ASM: s_cbranch_scc0
// ASM: v_add_u32
// ASM: s_branch
// ASM: v_add_u32
// ASM-NOT: v_mov_b32
// ASM: s_endpgm
func.func @uniform_if_sibling_loop_invariant_reuse()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %init = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %selected = waveamdmachine.uniform_if %cond {
    %then = waveamdmachine.uniform_loop carries(%init
        : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%arg: !waveamdmachine.reg<vgpr, 1>):
      %unused = waveamdmachine.v_add_u32 %arg, %arg
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.v_cmpx_eq_u32 %unused, %unused
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%init : !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %else = waveamdmachine.uniform_loop carries(%init
        : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%arg: !waveamdmachine.reg<vgpr, 1>):
      %unused = waveamdmachine.v_add_u32 %arg, %arg
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.v_cmpx_eq_u32 %unused, %unused
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%init : !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %selected, %selected
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_dead_passthrough_reuses_vgpr(
// ALLOC-SAME: [[INPUT:%[^:]+]]: !waveamdmachine.reg<vgpr, 64, [[REG:[0-9]+]]>
// ALLOC-SAME: waveamdmachine.vgpr_count = 64 : i64
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: waveamdmachine.yield [[INPUT]]
// ALLOC-NOT: waveamdmachine.update_tuple
// ALLOC-NOT: waveamdmachine.copy_tuple
// ASM-LABEL: uniform_if_dead_passthrough_reuses_vgpr:
// ASM-NOT: v_mov_b32
// ASM: s_cbranch_scc0
// ASM: s_branch
// ASM-NOT: v_mov_b32
// ASM: s_endpgm
func.func @uniform_if_dead_passthrough_reuses_vgpr(
    %input: !waveamdmachine.reg<vgpr, 64>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<vgpr, 64>
  } otherwise {
    %changed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 64>
    waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 64>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 64>
  %parts:2 = waveamdmachine.tuple_to_elements %selected
      : (!waveamdmachine.reg<vgpr, 64>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 63>)
  waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_other_writer_reads_dead_input(
// ALLOC-SAME: [[INPUT:%[^:]+]]: !waveamdmachine.reg<vgpr, 1, [[REG:[0-9]+]]>
// ALLOC-SAME: waveamdmachine.vgpr_count = 1 : i64
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: waveamdmachine.yield [[INPUT]]
// ALLOC-NOT: waveamdmachine.update_tuple
// ALLOC: otherwise
// ALLOC-NEXT: [[CHANGED:%.*]] = waveamdmachine.v_add_u32 [[INPUT]], [[INPUT]]
// ALLOC-SAME: -> !waveamdmachine.reg<vgpr, 1, [[REG]]>
// ALLOC-NEXT: waveamdmachine.yield [[CHANGED]]
// ALLOC-NOT: waveamdmachine.copy_tuple
// ALLOC: return
func.func @uniform_if_other_writer_reads_dead_input(
    %input: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %changed = waveamdmachine.v_add_u32 %input, %input
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %selected, %selected
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// SGPR input storage can be reserved by the kernel ABI.
// ALLOC-LABEL: func.func @uniform_if_dead_passthrough_copies_sgpr(
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: waveamdmachine.yield [[COPY]]
func.func @uniform_if_dead_passthrough_copies_sgpr(
    %input: !waveamdmachine.reg<sgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<sgpr, 1>
  } otherwise {
    %changed = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.yield %changed : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_cmp_eq_u32 %selected, %selected
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_live_passthrough_keeps_copy(
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: waveamdmachine.yield [[COPY]]
func.func @uniform_if_live_passthrough_keeps_copy(
    %input: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %changed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %selected, %input
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum, %sum
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_sibling_late_use_keeps_copy(
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: waveamdmachine.yield [[COPY]]
func.func @uniform_if_sibling_late_use_keeps_copy(
    %input: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %changed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %late = waveamdmachine.v_add_u32 %input, %input
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.v_cmpx_eq_u32 %late, %late
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
    waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %selected, %selected
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_duplicate_passthrough_keeps_copies(
// ALLOC: waveamdmachine.uniform_if
// ALLOC-NEXT: [[COPY0:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: [[COPY1:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: waveamdmachine.yield [[COPY0]], [[COPY1]]
func.func @uniform_if_duplicate_passthrough_keeps_copies(
    %input: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected:2 = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %input, %input
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %changed0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    %changed1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %changed0, %changed1
        : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1>
      -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %selected#0, %selected#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum, %sum
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @exec_if_dead_passthrough_keeps_copy(
// ALLOC: waveamdmachine.exec_if
// ALLOC-NEXT: [[COPY:%.*]] = waveamdmachine.copy_tuple
// ALLOC-NEXT: waveamdmachine.yield [[COPY]]
func.func @exec_if_dead_passthrough_keeps_copy(
    %cond: !waveamdmachine.reg<sgpr, 2>,
    %input: !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %selected = waveamdmachine.exec_if %cond {
    waveamdmachine.yield %input : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %changed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 2> -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %selected, %selected
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_else_input_skips_then_pressure(
// ALLOC-SAME: [[LIVE:%[^:]+]]: !waveamdmachine.reg<vgpr, 128, 0>
// ALLOC-SAME: waveamdmachine.regalloc_assignments
// ALLOC-SAME: waveamdmachine.vgpr_count = 128 : i64
// ALLOC: waveamdmachine.uniform_if
// ALLOC: [[SCRATCH:%.*]] = waveamdmachine.uninit
// ALLOC-SAME: !waveamdmachine.reg<vgpr, 128, 0>
// ALLOC: otherwise
// ALLOC: waveamdmachine.tuple_to_elements [[LIVE]]
func.func @uniform_if_else_input_skips_then_pressure(
    %live: !waveamdmachine.reg<vgpr, 128>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_if %cond {
    %scratch = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 128>
    %parts:2 = waveamdmachine.tuple_to_elements %scratch
        : (!waveamdmachine.reg<vgpr, 128>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 127>)
    waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> ()
    waveamdmachine.yield
  } otherwise {
    %parts:2 = waveamdmachine.tuple_to_elements %live
        : (!waveamdmachine.reg<vgpr, 128>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 127>)
    waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> ()
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

// ALLOC-LABEL: func.func @uniform_if_agpr_branch_storage_reuse()
// ALLOC-SAME: waveamdmachine.agpr_count = 64 : i64
// ALLOC: waveamdmachine.uniform_if
// ALLOC: waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64, 0>
// ALLOC-NEXT: [[THEN_AGPR:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64, 0>
// ALLOC-NEXT: waveamdmachine.yield [[THEN_AGPR]] : !waveamdmachine.reg<agpr, 64, 0>
// ALLOC: otherwise
// ALLOC-NEXT: waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64, 0>
// ALLOC-NEXT: [[ELSE_AGPR:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64, 0>
// ALLOC-NEXT: waveamdmachine.yield [[ELSE_AGPR]] : !waveamdmachine.reg<agpr, 64, 0>
// ASM-LABEL: uniform_if_agpr_branch_storage_reuse:
// ASM: s_cbranch_scc0
// ASM: s_branch
// ASM: v_accvgpr_read_b32 v0, a0
func.func @uniform_if_agpr_branch_storage_reuse()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %selected = waveamdmachine.uniform_if %cond {
    %scratch = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
    %then = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
    waveamdmachine.yield %then : !waveamdmachine.reg<agpr, 64>
  } otherwise {
    %scratch = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
    %else = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
    waveamdmachine.yield %else : !waveamdmachine.reg<agpr, 64>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<agpr, 64>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %selected
      : (!waveamdmachine.reg<agpr, 64>) -> !waveamdmachine.reg<vgpr, 64>
  %parts:2 = waveamdmachine.tuple_to_elements %read
      : (!waveamdmachine.reg<vgpr, 64>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 63>)
  waveamdmachine.v_cmpx_eq_u32 %parts#0, %parts#0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
