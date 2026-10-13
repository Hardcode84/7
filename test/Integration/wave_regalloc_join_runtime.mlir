// REQUIRES: linux, host-supports-amdgpu-gfx950, host-has-hip-runtime
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-abi-lowering,waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' > %t.alloc.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm %t.alloc.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %python %S/Inputs/regalloc_join_runtime.py %t.hsaco %hip_runtime_lib

// ASM-LABEL: joined_tuple_runtime:
// ASM: s_cbranch_scc0
// ASM: s_cbranch_scc0
// ASM: v_mov_b32
// ASM: [[LOOP:.Ljoined_tuple_runtime.loop_head_[0-9]+]]:
// ASM: v_add_u32
// ASM: s_cbranch_scc1 [[LOOP]]
// ASM-COUNT-3: global_store_dword
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @joined_tuple_runtime(%out: !wave.ptr<#wave.global, i32>, %choice: i32, %trips: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %flag = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
  %limit = waveamdmachine.arg {index = 2 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
  %lane = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c0 = waveamdmachine.imm 0 : !waveamdmachine.imm
  %c1 = waveamdmachine.imm 1 : !waveamdmachine.imm
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %c4 = waveamdmachine.imm 4 : !waveamdmachine.imm
  %c12 = waveamdmachine.imm 12 : !waveamdmachine.imm
  %c11 = waveamdmachine.imm 11 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %c23 = waveamdmachine.imm 23 : !waveamdmachine.imm
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c41 = waveamdmachine.imm 41 : !waveamdmachine.imm
  %c47 = waveamdmachine.imm 47 : !waveamdmachine.imm
  %outer_cond = waveamdmachine.s_cmp_lt_i32 %flag, %c2 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %init:2 = waveamdmachine.uniform_if %outer_cond {
    %inner_cond = waveamdmachine.s_cmp_eq_u32 %flag, %c0 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    %nested:2 = waveamdmachine.uniform_if %inner_cond {
      %a = waveamdmachine.v_mov_b32_tuple %c11 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.v_mov_b32_tuple %c17 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %pair = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.yield %pair, %b : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    } otherwise {
      %a = waveamdmachine.v_mov_b32_tuple %c23 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.v_mov_b32_tuple %c31 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %pair = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.yield %pair, %a : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %nested#0, %nested#1 : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %a = waveamdmachine.v_mov_b32_tuple %c41 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %b = waveamdmachine.v_mov_b32_tuple %c47 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %pair = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.yield %pair, %a : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  %count = waveamdmachine.s_mov_b32_tuple %c0 : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %enter = waveamdmachine.s_cmp_lt_i32 %count, %limit : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %results:3 = waveamdmachine.uniform_loop if %enter : !waveamdmachine.reg<scc, 1>
      carries(%init#0, %init#1, %count : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%pair: !waveamdmachine.reg<vgpr, 2>, %scalar: !waveamdmachine.reg<vgpr, 1>, %iter: !waveamdmachine.reg<sgpr, 1>):
    %cond = waveamdmachine.s_cmp_eq_u32 %flag, %c1 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    %next:2 = waveamdmachine.uniform_if %cond {
      %parts:2 = waveamdmachine.tuple_to_elements %pair : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      %a = waveamdmachine.v_add_u32 %scalar, %c1 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.v_add_u32 %parts#1, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %tuple = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.yield %tuple, %a : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    } otherwise {
      %parts:2 = waveamdmachine.tuple_to_elements %pair : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      %a = waveamdmachine.v_add_u32 %parts#0, %c1 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %b = waveamdmachine.v_add_u32 %scalar, %c2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
      %tuple = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
      waveamdmachine.yield %tuple, %a : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
    %next_iter, %carry = waveamdmachine.s_add_i32 %iter, %c1 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %again = waveamdmachine.s_cmp_lt_i32 %next_iter, %limit : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %again : !waveamdmachine.reg<scc, 1>
        carries(%next#0, %next#1, %next_iter : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %results#0 : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %offset = waveamdmachine.v_mul_lo_u32 %c12, %lane : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %t0 = waveamdmachine.global_store_b32 %offset, %parts#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t1 = waveamdmachine.global_store_b32 %offset, %parts#1, %base after %t0 offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b32 %offset, %results#1, %base after %t1 offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}
// ASM-LABEL: independent_join_runtime:
// ASM: s_cbranch_scc0
// ASM: v_mov_b32
// ASM: s_branch
// ASM: v_mov_b32
// ASM-COUNT-3: global_store_dword
// ASM: s_endpgm
func.func @independent_join_runtime(%out: !wave.ptr<#wave.global, i32>, %choice: i32, %trips: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %flag = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
  %lane = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %c0 = waveamdmachine.imm 0 : !waveamdmachine.imm
  %c12 = waveamdmachine.imm 12 : !waveamdmachine.imm
  %c11 = waveamdmachine.imm 11 : !waveamdmachine.imm
  %c17 = waveamdmachine.imm 17 : !waveamdmachine.imm
  %c23 = waveamdmachine.imm 23 : !waveamdmachine.imm
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %c47 = waveamdmachine.imm 47 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %flag, %c0 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:2 = waveamdmachine.uniform_if %cond {
    %a = waveamdmachine.v_mov_b32_tuple %c11 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %b = waveamdmachine.v_mov_b32_tuple %c17 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %pair = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
    waveamdmachine.yield %pair, %b : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %a = waveamdmachine.v_mov_b32_tuple %c23 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %b = waveamdmachine.v_mov_b32_tuple %c31 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %pair = waveamdmachine.tuple_from_elements %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
    %independent = waveamdmachine.v_mov_b32_tuple %c47 : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %pair, %independent : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>
  %parts:2 = waveamdmachine.tuple_to_elements %results#0 : (!waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %offset = waveamdmachine.v_mul_lo_u32 %c12, %lane : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %t0 = waveamdmachine.global_store_b32 %offset, %parts#0, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t1 = waveamdmachine.global_store_b32 %offset, %parts#1, %base after %t0 offset 4 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b32 %offset, %results#1, %base after %t1 offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}
}
