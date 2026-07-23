// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --wave-simplify-index-exprs --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' | FileCheck %s --check-prefix=VERIFY
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @global_constant_overflow
// SELECT: waveamdmachine.global_store_b32_addr64
// SELECT-NOT: waveamdmachine.global_store_b32 %
// ASM-LABEL: global_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_constant_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_raw_constant_overflow
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_raw_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_raw_constant_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %raw = arith.constant 1073741824 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_non_power_of_two_mod_addr64
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.s_mul_hi_u32
// SELECT: waveamdmachine.global_store_b32_addr64
func.func @global_non_power_of_two_mod_addr64(
    %out: !wave.ptr<#wave.global, i32>, %raw_in: i32)
    attributes {wave.kernel} {
  %raw = wave.assume %raw_in as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %off = wave.index_expr <"1073741824 + Mod(raw, 3)"> ["raw"](%raw)
      : (i32) -> index
  %ptr = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_raw_unbounded_offset_addr64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_raw_unbounded_offset_addr64:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_raw_unbounded_offset_addr64(%out: !wave.ptr<#wave.global, i32>, %raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_raw_unbounded_offset_addr64_vector4_store
// SELECT-NOT: waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.global_store_b128_addr64
// SELECT-NOT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_raw_unbounded_offset_addr64_vector4_store:
// ASM: global_store_b128 v[{{[0-9]+}}:{{[0-9]+}}], v[{{[0-9]+}}:{{[0-9]+}}], off
func.func @global_raw_unbounded_offset_addr64_vector4_store(
    %out: !wave.ptr<#wave.global, i32>, %raw: i32)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %v2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %v3 = wave.splat %c3 : i32 -> !wave.simd<i32, 32>
  %v4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %packed = wave.pack %v1, %v2, %v3, %v4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %tok = wave.store %packed -> %ptrs
      : (!wave.simd<vector<4xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_floor_addr64
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_floor_addr64:
// ASM: v_lshrrev_b64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_floor_addr64(%out: !wave.ptr<#wave.global, i32>,
                               %x_raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8">] : i32
  %off = wave.index_expr <"1073741824*floor(1/2*x) + lid"> ["x", "lid"](%x, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_i64_floor_addr64
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_i64_floor_addr64:
// ASM: v_lshrrev_b64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_i64_floor_addr64(%out: !wave.ptr<#wave.global, i32>,
                                   %x_raw: i64)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8589934590">] : i64
  %off = wave.index_expr <"floor(1/2*x) + lid"> ["x", "lid"](%x, %lane)
      : (i64, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_i64_xor_floor_addr64
// SELECT: waveamdmachine.v_xor_b64
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT-NOT: waveamdmachine.global_store_b32_addr64
// SELECT: waveamdmachine.global_store_b32
// ASM-LABEL: global_i64_xor_floor_addr64:
// ASM: v_xor_b32
// ASM: v_xor_b32
// ASM: v_lshrrev_b64
// ASM: global_store_b32 v{{[0-9]+}}, v{{[0-9]+}}, s
func.func @global_i64_xor_floor_addr64(%out: !wave.ptr<#wave.global, i32>,
                                       %x_raw: i64)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 8">] : i64
  %off = wave.index_expr <"floor(1/2*xor(1, x)) + lid"> ["x", "lid"](%x, %lane)
      : (i64, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_mixed_index_and_raw_ptr_add
// SELECT: %[[RAW_ID:.*]] = waveamdmachine.v_workitem_id_x
// SELECT: %[[RAW:.*]] = waveamdmachine.v_lshlrev_b32 %[[RAW_ID]],
// SELECT: %[[RAW64:.*]] = waveamdmachine.tuple_from_elements %[[RAW]],
// SELECT: %[[ADDR:.*]], %{{.*}} = waveamdmachine.v_add_u64 {{.*}}, %[[RAW64]]
// SELECT: waveamdmachine.global_store_b32_addr64 %[[ADDR]]
// ASM-LABEL: global_mixed_index_and_raw_ptr_add:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_mixed_index_and_raw_ptr_add(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %raw_off = wave.workitem_id 0 : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %raw = wave.ptr_add %out, %raw_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %raw, %off
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_loop_carry_mixed_addr64
// SELECT: waveamdmachine.uniform_loop
// SELECT: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[CARRY:.*]]: !waveamdmachine.reg<vgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 2>):
// SELECT: %[[CARRY64:.*]] = waveamdmachine.tuple_from_elements %[[CARRY]],
// SELECT: waveamdmachine.v_add_u64 {{.*}}, %[[CARRY64]]
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_loop_carry_mixed_addr64:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_loop_carry_mixed_addr64(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 1 : i32
  %step = arith.constant 1 : i32
  %stride = arith.constant 16 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %raw = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  scf.for %i = %lo to %hi step %step iter_args(%q = %raw)
      -> (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) : i32 {
    %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptrs = wave.ptr_add %q, %off
        : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    %next = wave.ptr_add %q, %stride
        : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  }
  return
}

// SELECT-LABEL: func.func @global_addr64_two_uniform_products
// SELECT: %[[WGX:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[WGY:.*]] = waveamdmachine.s_workgroup_id_y
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.v_mul_u64
// SELECT: waveamdmachine.s_mov_b64_imm 8589934592
// SELECT: waveamdmachine.v_mul_u64
// SELECT-NOT: waveamdmachine.s_mul_u64
// SELECT: waveamdmachine.global_store_b32_addr64
// VERIFY-LABEL: func.func @global_addr64_two_uniform_products
// VERIFY: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_two_uniform_products:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_two_uniform_products(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_x = wave.workgroup_id 0
  %wgid_y = wave.workgroup_id 1
  %off = wave.index_expr <"lid + 1073741824*wgx + 2147483648*wgy">
      ["lid", "wgx", "wgy"] (%lane, %wgid_x, %wgid_y)
      : (!wave.simd<i32, 32>, i32, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_addr64_xor
// SELECT: waveamdmachine.s_mov_b64_imm 4
// SELECT: waveamdmachine.s_mov_b64_imm 1073741824
// SELECT: waveamdmachine.v_xor_b64
// SELECT: waveamdmachine.v_mul_u64
// SELECT: waveamdmachine.v_add_u64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_xor:
// ASM: v_xor_b32
// ASM: v_mul_lo_u32
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_xor(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"xor(lid, 1073741824)"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_addr64_mod
// SELECT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_mod:
// ASM: v_and_b32
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_mod(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + Mod(lid, 16)"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_addr64_rational_mod_floor
// SELECT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_rational_mod_floor:
// ASM: v_and_b32
// ASM: v_lshrrev_b64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_rational_mod_floor(%out: !wave.ptr<#wave.global, i32>,
                                            %x_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 4095">] : i32
  %off = wave.index_expr <"1073741824 + floor(1/512*Mod(8*x, 1024)) + lid">
      ["lid", "x"] (%lane, %x)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_addr64_rational_mod_lhs
// SELECT: waveamdmachine.v_and_b32
// SELECT-NOT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_rational_mod_lhs:
// ASM: v_and_b32
// ASM-NOT: v_lshrrev_b64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_rational_mod_lhs(%out: !wave.ptr<#wave.global, i32>,
                                          %x_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 4095">] : i32
  %off = wave.index_expr <"1073741824 + 8*Mod(1/8*Mod(8*x, 1024), 2) + 4*Mod(1/4*Mod(8*x, 1024), 2) + 2*Mod(1/2*Mod(8*x, 1024), 2) + lid">
      ["lid", "x"] (%lane, %x)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @shared_rational_mod_floor_full_address
// SELECT: %[[LID:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: waveamdmachine.s_and_b32
// SELECT: waveamdmachine.s_lshr_b32
// SELECT: %[[SLOT:.*]] = waveamdmachine.s_mul_i32
// SELECT: %[[LANE_MOD:.*]] = waveamdmachine.v_and_b32 %[[LID]],
// SELECT: %[[LANE_OFF:.*]] = waveamdmachine.v_mul_lo_u32 {{.*}}, %[[LANE_MOD]]
// SELECT: %[[LOAD_ADDR:.*]] = waveamdmachine.v_add_u32 %[[SLOT]], %[[LANE_OFF]]
// SELECT: waveamdmachine.ds_load_b32 %[[LOAD_ADDR]] offset 12 :
// SELECT: %[[STORE_ADDR:.*]] = waveamdmachine.v_add_u32
// SELECT: waveamdmachine.ds_store_b32 %[[STORE_ADDR]], {{.*}} offset 12 :
// ASM-LABEL: shared_rational_mod_floor_full_address:
// ASM: ds_load_b32 {{.*}} offset:12
// ASM: ds_store_b32 {{.*}} offset:12
func.func @shared_rational_mod_floor_full_address(%x: i32)
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"3 + 520*floor(1/512*Mod(8*x, 1024)) + 264*Mod(lid, 2)">
      ["lid", "x"](%lane, %x)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %load_token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %store_token = wave.store %value -> %ptrs after %load_token
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @shared_integer_rational_mod_term
// SELECT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.v_lshrrev_b32
// SELECT: waveamdmachine.ds_load_b32
// ASM-LABEL: shared_integer_rational_mod_term:
// ASM: v_and_b32
// ASM: v_lshrrev_b32
// ASM: ds_load_b32
func.func @shared_integer_rational_mod_term()
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"1/2*Mod(8*lid, 32) + 264*Mod(floor(1/4*lid), 2)">
      ["lid"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// SELECT-LABEL: func.func @shared_wide_mod_floor_full_address
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.ds_load_u8 %{{.*}}#0 :
// ASM-LABEL: shared_wide_mod_floor_full_address:
// ASM: v_lshrrev_b64
// ASM: ds_load_u8
func.func @shared_wide_mod_floor_full_address(%x_raw: i64)
    attributes {wave.kernel, wave.lds_size = 8192 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">] : i64
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
  %off = wave.index_expr <"Mod(floor(1/4294967296*x), 4096) + lid">
      ["lid", "x"](%lane, %x)
      : (!wave.simd<i32, 32>, i64) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 32>)
      -> (!wave.simd<i8, 32>, !wave.mem.token)
  return
}

// SELECT-LABEL: func.func @shared_nested_index_expr_producer_range
// SELECT: waveamdmachine.v_lshrrev_b32
// SELECT: waveamdmachine.v_lshrrev_b32
// SELECT: waveamdmachine.ds_load_b32
// ASM-LABEL: shared_nested_index_expr_producer_range:
// ASM: ds_load_b32
func.func @shared_nested_index_expr_producer_range()
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dim0 = wave.index_expr <"floor(1/2*lane)"> assuming [#wave.pred<"lane >= 0 & -31 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off = wave.index_expr <"floor(1/4*dim0)"> assuming [#wave.pred<"-272 + dim0 >= 0 & -2281701631 + dim0 <= 0">] ["dim0"](%dim0)
      : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// SELECT-LABEL: func.func @shared_floor_nested_xor_nonnegative
// SELECT: waveamdmachine.ds_load_b32
// ASM-LABEL: shared_floor_nested_xor_nonnegative:
// ASM: ds_load_b32
func.func @shared_floor_nested_xor_nonnegative()
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"floor(1/8*xor(32*Mod(floor(1/4*lane), 2), xor(16*Mod(floor(1/2*lane), 2), 8*Mod(lane, 2))))">
      assuming [#wave.pred<"lane >= 0 & -31 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// SELECT-LABEL: func.func @shared_floor_nested_xor_offset_bits
// SELECT: waveamdmachine.ds_load_b32
// ASM-LABEL: shared_floor_nested_xor_offset_bits:
// ASM: ds_load_b32
func.func @shared_floor_nested_xor_offset_bits()
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %raw = wave.index_expr <"16*lane"> assuming [#wave.pred<"lane >= 0 & -31 + lane <= 0">] ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"floor(1/64*xor(32*Mod(floor(1/128*raw), 2), xor(16*Mod(floor(1/64*raw), 2), xor(64 + 4*Mod(floor(1/16*raw), 2), 8*Mod(floor(1/32*raw), 2)))))">
      ["raw"](%raw) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// SELECT-LABEL: func.func @global_load_constant_overflow
// SELECT: waveamdmachine.global_load_b32_addr64
// ASM-LABEL: global_load_constant_overflow:
// ASM: global_load_b32 v{{[0-9]+}}, v[{{[0-9]+}}:{{[0-9]+}}], off
func.func @global_load_constant_overflow(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %load_token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %tok = wave.store %value -> %ptrs after %load_token
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
