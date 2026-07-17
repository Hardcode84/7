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

// SELECT-LABEL: func.func @select_memory_token
// SELECT: [[TRUE:%.*]] = waveamdmachine.token
// SELECT: [[FALSE:%.*]] = waveamdmachine.token
// SELECT: waveamdmachine.token_join [[TRUE]], [[FALSE]]
func.func @select_memory_token(%pred: i1) {
  %true = wave.token : !wave.mem.token
  %false = wave.token : !wave.mem.token
  %merged = arith.select %pred, %true, %false : !wave.mem.token
  %barrier = wave.barrier %merged : (!wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @select_uniform_index_args
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.tuple_from_elements
func.func @select_uniform_index_args(%pred: i1, %a: index, %b: index) {
  %r = wave.select %pred, %a, %b : index
  return
}

// SELECT-LABEL: func.func @select_lane_index_read_first_return
// SELECT: waveamdmachine.v_cndmask_b32_tuple
// SELECT: waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.v_readfirstlane_b32
// SELECT: waveamdmachine.v_readfirstlane_b32
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.s_mov_b32 "s0"
// SELECT: waveamdmachine.s_mov_b32 "s1"
func.func @select_lane_index_read_first_return(%limit: i32, %a: index,
                                               %b: index) -> index {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %va = wave.splat %a : index -> !wave.simd<index, 32>
  %vb = wave.splat %b : index -> !wave.simd<index, 32>
  %r = wave.select %active, %va, %vb
      : !wave.mask<32>, !wave.simd<index, 32>
  %first = wave.read_first %r : !wave.simd<index, 32> -> index
  return %first : index
}

// SELECT-LABEL: func.func @select_lane_index_constants
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.v_cndmask_b32_tuple
// ASM-LABEL: select_lane_index_constants:
// ASM: v_cmp_lt_u32_e64 [[MASK:s[0-9]+]],
// ASM-DAG: v_mov_b32_e32 [[TWO_LO:v[0-9]+]], 2
// ASM-DAG: v_mov_b32_e32 {{v[0-9]+}}, 0
// ASM-DAG: v_mov_b32_e32 {{v[0-9]+}}, 0
// ASM-DAG: v_mov_b32_e32 [[ONE_LO:v[0-9]+]], 1
// ASM: v_cndmask_b32_e64 {{v[0-9]+}}, [[TWO_LO]], [[ONE_LO]], [[MASK]]
// ASM-NEXT: v_cndmask_b32_e64 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, [[MASK]]
func.func @select_lane_index_constants(%limit: i32) -> index {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %one = arith.constant 1 : index
  %two = arith.constant 2 : index
  %vone = wave.splat %one : index -> !wave.simd<index, 32>
  %vtwo = wave.splat %two : index -> !wave.simd<index, 32>
  %r = wave.select %active, %vone, %vtwo
      : !wave.mask<32>, !wave.simd<index, 32>
  %first = wave.read_first %r : !wave.simd<index, 32> -> index
  return %first : index
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

// SELECT-LABEL: func.func @select_whole_simd_uniform_splats
// SELECT: waveamdmachine.s_cselect_b32
// SELECT-NOT: waveamdmachine.v_cndmask_b32_tuple
// SELECT-NOT: waveamdmachine.v_readfirstlane_b32
// SELECT: return
// ASM-LABEL: select_whole_simd_uniform_splats:
// ASM: s_cselect_b32
// ASM-NOT: v_cndmask_b32
// ASM: s_setpc_b64
func.func @select_whole_simd_uniform_splats(%pred: i1, %a: i32,
                                            %b: i32) -> i32 {
  %va = wave.splat %a : i32 -> !wave.simd<i32, 32>
  %vb = wave.splat %b : i32 -> !wave.simd<i32, 32>
  %r = wave.select %pred, %va, %vb : !wave.simd<i32, 32>
  %first = wave.read_first %r : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @select_whole_simd_i64_uniform_splats
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.s_cselect_b32
// SELECT-NOT: waveamdmachine.v_cndmask_b32_tuple
// SELECT-NOT: waveamdmachine.v_readfirstlane_b32
// SELECT: return
func.func @select_whole_simd_i64_uniform_splats(%pred: i1, %a: i64,
                                                %b: i64) -> i64 {
  %va = wave.splat %a : i64 -> !wave.simd<i64, 32>
  %vb = wave.splat %b : i64 -> !wave.simd<i64, 32>
  %r = wave.select %pred, %va, %vb : !wave.simd<i64, 32>
  %first = wave.read_first %r : !wave.simd<i64, 32> -> i64
  return %first : i64
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

// SELECT-LABEL: func.func @select_mask_and_false
// SELECT: waveamdmachine.s_and_b32
// SELECT-NOT: waveamdmachine.s_xor_b32
// ASM-LABEL: select_mask_and_false:
// ASM: s_and_b32
// ASM-NOT: s_xor_b32
func.func @select_mask_and_false(%limit: i32, %other: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %vother = wave.splat %other : i32 -> !wave.simd<i32, 32>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi ult %lane, %vother
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %r = wave.select %m0, %m1, %false : !wave.mask<32>, !wave.mask<32>
  %bits = wave.ballot %r : !wave.mask<32> -> i32
  return %bits : i32
}

// SELECT-LABEL: func.func @select_mask_or_true
// SELECT: waveamdmachine.s_or_b32
// SELECT-NOT: waveamdmachine.s_xor_b32
// ASM-LABEL: select_mask_or_true:
// ASM: s_or_b32
// ASM-NOT: s_xor_b32
func.func @select_mask_or_true(%limit: i32, %other: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %vother = wave.splat %other : i32 -> !wave.simd<i32, 32>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi ult %lane, %vother
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %true = wave.constant true -> !wave.mask<32>
  %r = wave.select %m0, %true, %m1 : !wave.mask<32>, !wave.mask<32>
  %bits = wave.ballot %r : !wave.mask<32> -> i32
  return %bits : i32
}

// SELECT-LABEL: func.func @select_mask_false_false_constants
// SELECT-NOT: waveamdmachine.s_and_b32
// SELECT-NOT: waveamdmachine.s_or_b32
// SELECT-NOT: waveamdmachine.s_xor_b32
// SELECT: return
// ASM-LABEL: select_mask_false_false_constants:
// ASM-NOT: s_and_b32
// ASM-NOT: s_or_b32
// ASM-NOT: s_xor_b32
// ASM: s_setpc_b64
func.func @select_mask_false_false_constants(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false0 = wave.constant false -> !wave.mask<32>
  %false1 = wave.constant false -> !wave.mask<32>
  %r = wave.select %m0, %false0, %false1 : !wave.mask<32>, !wave.mask<32>
  %bits = wave.ballot %r : !wave.mask<32> -> i32
  return %bits : i32
}

// SELECT-LABEL: func.func @select_mask_true_true_constants
// SELECT-NOT: waveamdmachine.s_and_b32
// SELECT-NOT: waveamdmachine.s_or_b32
// SELECT-NOT: waveamdmachine.s_xor_b32
// SELECT: return
// ASM-LABEL: select_mask_true_true_constants:
// ASM-NOT: s_and_b32
// ASM-NOT: s_or_b32
// ASM-NOT: s_xor_b32
// ASM: s_setpc_b64
func.func @select_mask_true_true_constants(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %m0 = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %true0 = wave.constant true -> !wave.mask<32>
  %true1 = wave.constant true -> !wave.mask<32>
  %r = wave.select %m0, %true0, %true1 : !wave.mask<32>, !wave.mask<32>
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
  %plus4 = wave.binary addi %lane, %c4
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %else_ptr = wave.ptr_add %out, %plus4
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %ptrs = wave.select %active, %then_ptr, %else_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
