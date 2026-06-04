// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @select_uniform
// SELECT: waveamdmachine.s_cmp_lg_u32
// SELECT: waveamdmachine.s_cselect_b32
// ASM-LABEL: select_uniform:
// ASM: s_cmp_lg_u32
// ASM: s_cselect_b32
func.func @select_uniform(%pred: i1, %a: i32, %b: i32) -> i32 {
  %r = wave.select %pred, %a, %b : i32
  return %r : i32
}

// SELECT-LABEL: func.func @select_lane
// SELECT: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: [[SEL:%.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[COND]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[SEL]]
// ASM-LABEL: select_lane:
// ASM: v_cndmask_b32_e64
func.func @select_lane(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %r = wave.select %active, %lane, %vlimit
      : !wave.mask<32>, !wave.simd<i32, 32>
  %first = wave.read_first %r : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @select_lane_immediate_splats
// SELECT-DAG: [[TRUE_IMM:%.*]] = waveamdmachine.imm 7
// SELECT-DAG: [[FALSE_IMM:%.*]] = waveamdmachine.imm 100000
// SELECT: [[FALSE:%.*]] = waveamdmachine.v_mov_b32_tuple [[FALSE_IMM]]
// SELECT: [[TRUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[TRUE_IMM]]
// SELECT: waveamdmachine.v_cndmask_b32_tuple [[FALSE]], [[TRUE]],
// ASM-LABEL: select_lane_immediate_splats:
// ASM: v_cndmask_b32_e64
func.func @select_lane_immediate_splats(%limit: i32) -> i32 {
  %c7 = arith.constant 7 : i32
  %c100000 = arith.constant 100000 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %v7 = wave.splat %c7 : i32 -> !wave.simd<i32, 32>
  %v100000 = wave.splat %c100000 : i32 -> !wave.simd<i32, 32>
  %r = wave.select %active, %v7, %v100000
      : !wave.mask<32>, !wave.simd<i32, 32>
  %first = wave.read_first %r : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @select_lane_sgpr_pair_splats
// SELECT-DAG: [[TRUE_ARG:%.*]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT-DAG: [[FALSE_ARG:%.*]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: [[FALSE:%.*]] = waveamdmachine.v_mov_b32_tuple [[FALSE_ARG]]
// SELECT: [[TRUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[TRUE_ARG]]
// SELECT: waveamdmachine.v_cndmask_b32_tuple [[FALSE]], [[TRUE]],
func.func @select_lane_sgpr_pair_splats(%a: i64, %b: i64, %limit: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %va = wave.splat %a : i64 -> !wave.simd<i64, 32>
  %vb = wave.splat %b : i64 -> !wave.simd<i64, 32>
  %r = wave.select %active, %va, %vb
      : !wave.mask<32>, !wave.simd<i64, 32>
  return
}

// SELECT-LABEL: func.func @select_whole_simd
// SELECT: waveamdmachine.s_cmp_lg_u32
// SELECT: [[MASK:%.*]] = waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[MASK]]
// SELECT: waveamdmachine.v_readfirstlane_b32
// ASM-LABEL: select_whole_simd:
// ASM: s_cselect_b32
// ASM: v_cndmask_b32_e64
func.func @select_whole_simd(%pred: i1, %a: !wave.simd<i32, 32>,
                             %b: !wave.simd<i32, 32>) -> i32 {
  %r = wave.select %pred, %a, %b : !wave.simd<i32, 32>
  %first = wave.read_first %r : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @select_mask_lane
// SELECT: waveamdmachine.s_xor_b32
// SELECT: waveamdmachine.s_and_b32
// SELECT: waveamdmachine.s_xor_b32
// ASM-LABEL: select_mask_lane:
// ASM: s_xor_b32
// ASM: s_and_b32
func.func @select_mask_lane(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi eq %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %r = wave.select %m0, %m0, %m1 : !wave.mask<32>, !wave.mask<32>
  %bits = wave.ballot %r : !wave.mask<32> -> i32
  return %bits : i32
}

// SELECT-LABEL: func.func @select_lane_pointer
// SELECT: waveamdmachine.v_cndmask_b32_tuple
// SELECT: waveamdmachine.global_store_b32
// ASM-LABEL: select_lane_pointer:
// ASM: v_cndmask_b32_e64
// ASM: global_store_b32
func.func @select_lane_pointer(%out: !wave.ptr<#wave.global, i32>, %limit: i32)
    attributes {wave.kernel} {
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %then_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %plus4 = wave.addi %lane, %c4
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %else_ptr = wave.ptr_add %out, %plus4
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %ptrs = wave.select %active, %then_ptr, %else_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

}
