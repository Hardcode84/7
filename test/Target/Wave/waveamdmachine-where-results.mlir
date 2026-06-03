// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @where_yields_value
// SELECT: waveamdmachine.s_and_saveexec_b32
// SELECT: [[SUM:%.*]] = waveamdmachine.v_add_u32
// SELECT: waveamdmachine.label
// SELECT: waveamdmachine.s_mov_exec_lo
// SELECT: waveamdmachine.v_readfirstlane_b32 [[SUM]]
func.func @where_yields_value(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.where %active {
    %sum = wave.addi %lane, %vlimit
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
// SELECT: waveamdmachine.s_and_saveexec_b32 [[COND]]
// SELECT: waveamdmachine.s_cbranch_execz [[ELSE:".*else.*"]]
// SELECT-NEXT: waveamdmachine.label [[ELSE]]
// SELECT-NEXT: waveamdmachine.s_andn2_exec_b32
// SELECT: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[COND]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
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
// SELECT: [[MATERIALIZED:%.*]] = waveamdmachine.v_mov_b32_tuple [[THEN_IMM]]
// SELECT: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple [[ELSE_IMM]], [[MATERIALIZED]], [[COND]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
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
// SELECT: [[POISON:%.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
// SELECT: [[MERGED:%.*]] = waveamdmachine.v_cndmask_b32_tuple [[POISON]], {{.*}}, [[COND]]
// SELECT: waveamdmachine.v_readfirstlane_b32 [[MERGED]]
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
// SELECT: waveamdmachine.s_cbranch_execz [[TOK_ELSE:".*else.*"]]
// SELECT: waveamdmachine.global_store_b32
// SELECT-NEXT: waveamdmachine.label [[TOK_ELSE]]
// SELECT-NEXT: waveamdmachine.s_andn2_exec_b32
// SELECT: waveamdmachine.global_store_b32
// SELECT: waveamdmachine.token_join
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

}
