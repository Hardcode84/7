// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-linearize-exec-if --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=LINEAR
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @where_yields_value
// SELECT: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: [[CHOSEN:%.*]] = waveamdmachine.exec_if [[COND]]
// SELECT: [[SUM:%.*]] = waveamdmachine.v_add_u32
// SELECT: waveamdmachine.yield [[SUM]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[CHOSEN]]
func.func @where_yields_value(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.where %active {
    %sum = wave.binary addi %lane, %vlimit
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield %sum : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @where_otherwise_yields_value
// SELECT: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: [[MERGED:%.*]] = waveamdmachine.exec_if [[COND]]
// SELECT: waveamdmachine.yield
// SELECT: otherwise
// SELECT: waveamdmachine.yield
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// LINEAR-LABEL: func.func @where_otherwise_yields_value
// LINEAR: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// LINEAR: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[COND]]
// LINEAR: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// ASM-LABEL: where_otherwise_yields_value:
// ASM: v_cndmask_b32_e64
func.func @where_otherwise_yields_value(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.where %active {
    wave.yield %lane : !wave.simd<i32, 32>
  } otherwise {
    wave.yield %vlimit : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @where_otherwise_two_literals
// SELECT: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: [[THEN_IMM:%.*]] = waveamdmachine.imm 123456789
// SELECT: [[ELSE_IMM:%.*]] = waveamdmachine.imm 987654321
// SELECT: [[MERGED:%.*]] = waveamdmachine.exec_if [[COND]]
// SELECT: waveamdmachine.yield [[THEN_IMM]]
// SELECT: otherwise
// SELECT: waveamdmachine.yield [[ELSE_IMM]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// LINEAR-LABEL: func.func @where_otherwise_two_literals
// LINEAR: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// LINEAR: [[THEN_IMM:%.*]] = waveamdmachine.imm 123456789
// LINEAR: [[ELSE_IMM:%.*]] = waveamdmachine.imm 987654321
// LINEAR: [[MATERIALIZED:%.*]] = waveamdmachine.v_mov_b32_tuple [[THEN_IMM]]
// LINEAR: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple [[ELSE_IMM]], [[MATERIALIZED]], [[COND]]
// LINEAR: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// ASM-LABEL: where_otherwise_two_literals:
// ASM: v_mov_b32_e32
// ASM: v_cndmask_b32_e64
func.func @where_otherwise_two_literals(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %then_c = arith.constant 123456789 : i32
  %else_c = arith.constant 987654321 : i32
  %then_v = wave.splat %then_c : i32 -> !wave.simd<i32, 32>
  %else_v = wave.splat %else_c : i32 -> !wave.simd<i32, 32>
  %chosen = wave.where %active {
    wave.yield %then_v : !wave.simd<i32, 32>
  } otherwise {
    wave.yield %else_v : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @where_otherwise_poison_value
// SELECT: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: [[MERGED:%.*]] = waveamdmachine.exec_if [[COND]]
// SELECT: [[POISON:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
// SELECT: waveamdmachine.yield [[POISON]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// LINEAR-LABEL: func.func @where_otherwise_poison_value
// LINEAR: [[COND:%.*]] = waveamdmachine.v_cmp_lt_u32
// LINEAR: [[POISON:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
// LINEAR: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple [[POISON]], {{.*}}, [[COND]]
// LINEAR: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
// ASM-LABEL: where_otherwise_poison_value:
// ASM: v_cndmask_b32_e64
func.func @where_otherwise_poison_value(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.where %active {
    wave.yield %lane : !wave.simd<i32, 32>
  } otherwise {
    %p = ub.poison : !wave.simd<i32, 32>
    wave.yield %p : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// SELECT-LABEL: func.func @where_otherwise_yields_token
// SELECT: [[TOK:%.*]] = waveamdmachine.exec_if
// SELECT: waveamdmachine.global_store_b32
// SELECT: otherwise
// SELECT: waveamdmachine.global_store_b32
// LINEAR-LABEL: func.func @where_otherwise_yields_token
// LINEAR: waveamdmachine.s_cbranch_execz [[TOK_ELSE:".*else.*"]]
// LINEAR: waveamdmachine.global_store_b32
// LINEAR: waveamdmachine.label [[TOK_ELSE]]
// LINEAR: waveamdmachine.s_andn2_exec_b32
// LINEAR: waveamdmachine.global_store_b32
// LINEAR: waveamdmachine.token_join
func.func @where_otherwise_yields_token(%out: !wave.ptr<#wave.global, i32>,
                                        %limit: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.where %active {
    %then_tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield %then_tok : !wave.mem.token
  } otherwise {
    %else_tok = wave.store %vlimit -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield %else_tok : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_otherwise_recomputes_else_address
// SELECT: [[LOAD:%.*]]:2 = waveamdmachine.exec_if
// SELECT: [[STORE:%.*]] = waveamdmachine.exec_if
// SELECT: otherwise
// ASM-LABEL: where_otherwise_recomputes_else_address:
// ASM: s_cbranch_execz [[ELSE:.Lwave_where_otherwise_recomputes_else_address_exec_else_[0-9]+]]
// ASM: global_store_b32
// ASM: [[ELSE]]:
// ASM: s_and_not1_b32
// ASM: v_mul_lo_u32
// ASM: global_store_b32
func.func @where_otherwise_recomputes_else_address(
    %src: !wave.ptr<#wave.global, f32>, %dst: !wave.ptr<#wave.global, f32>,
    %limit: i32) attributes {wave.kernel} {
  %c32 = arith.constant 32 : i32
  %five = arith.constant 5.000000e+00 : f32
  %pid = wave.workgroup_id 0
  %base = wave.binary muli %pid, %c32 : i32, i32 -> i32
  %vbase = wave.splat %base : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %idx = wave.binary addi %vbase, %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %idx, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src_off = wave.index_expr <"lid + c32*pid"> ["pid", "c32", "lid"](%pid, %c32, %lane)
      : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %src_ptrs = wave.ptr_add %src, %src_off
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %dst_off = wave.index_expr <"lid + c32*pid"> ["pid", "c32", "lid"](%pid, %c32, %lane)
      : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %dst_ptrs = wave.ptr_add %dst, %dst_off
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %loaded:2 = wave.where %active {
    %value, %token = wave.load %src_ptrs
        : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
        -> (!wave.simd<f32, 32>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<f32, 32>, !wave.mem.token
  %stored = wave.where %active {
    %token = wave.store %loaded#0 -> %dst_ptrs after %loaded#1
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    %fallback = wave.splat %five : f32 -> !wave.simd<f32, 32>
    %token = wave.store %fallback -> %dst_ptrs
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  wave.wait %stored : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_yields_pointer
// SELECT: waveamdmachine.exec_if
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 1>
// SELECT: waveamdmachine.global_store_b32
// ASM-LABEL: where_yields_pointer:
// ASM: global_store_b32
func.func @where_yields_pointer(%out: !wave.ptr<#wave.global, i32>,
                                %limit: i32) attributes {wave.kernel} {
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.where %active {
    %offset = wave.binary addi %lane, %c4
        : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %ptr = wave.ptr_add %out, %offset
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_otherwise_yields_same_base_pointer
// SELECT: waveamdmachine.exec_if
// SELECT: otherwise
// SELECT: waveamdmachine.global_store_b32
// LINEAR-LABEL: func.func @where_otherwise_yields_same_base_pointer
// LINEAR: waveamdmachine.v_cndmask_b32_tuple
// LINEAR: waveamdmachine.global_store_b32
// ASM-LABEL: where_otherwise_yields_same_base_pointer:
// ASM: v_cndmask_b32_e64
// ASM: global_store_b32
func.func @where_otherwise_yields_same_base_pointer(
    %out: !wave.ptr<#wave.global, i32>, %limit: i32) attributes {wave.kernel} {
  %c4 = arith.constant 4 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.where %active {
    %then_ptr = wave.ptr_add %out, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %then_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } otherwise {
    %else_offset = wave.binary addi %lane, %c4
        : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
    %else_ptr = wave.ptr_add %out, %else_offset
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %else_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_yields_large_pointer_offset
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 2>
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: where_yields_large_pointer_offset:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @where_yields_large_pointer_offset(
    %out: !wave.ptr<#wave.global, i32>, %limit: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.where %active {
    %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptr = wave.ptr_add %out, %off
        : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_yields_negative_pointer_offset
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 2>
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: where_yields_negative_pointer_offset:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @where_yields_negative_pointer_offset(
    %out: !wave.ptr<#wave.global, i32>, %limit: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.where %active {
    %off = wave.index_expr <"-1 + lid"> ["lid"] (%lane)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptr = wave.ptr_add %out, %off
        : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// SELECT-LABEL: func.func @where_otherwise_yields_large_pointer_offset
// SELECT: waveamdmachine.exec_if
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 2>
// SELECT: otherwise
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 2>
// LINEAR-LABEL: func.func @where_otherwise_yields_large_pointer_offset
// LINEAR: waveamdmachine.v_cndmask_b32_tuple
// LINEAR: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: where_otherwise_yields_large_pointer_offset:
// ASM: v_cndmask_b32_e64
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @where_otherwise_yields_large_pointer_offset(
    %out: !wave.ptr<#wave.global, i32>, %limit: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.where %active {
    %then_ptr = wave.ptr_add %out, %lane
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %then_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } otherwise {
    %off = wave.index_expr <"1073741825 + lid"> ["lid"] (%lane)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %else_ptr = wave.ptr_add %out, %off
        : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    wave.yield %else_ptr : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  } : !wave.mask<32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

}
