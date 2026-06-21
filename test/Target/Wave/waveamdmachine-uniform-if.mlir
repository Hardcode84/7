// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-reg-alloc --waveamd-insert-hazard-waits --split-input-file %s | wave-translate --wave-to-amdgpu-asm --split-input-file - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-reg-alloc --waveamd-insert-hazard-waits --split-input-file %s | wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @uniform_if_scalar
// SELECT: [[COND:%.*]] = waveamdmachine.s_cmp_lg_u32
// SELECT: [[R:%.*]] = waveamdmachine.uniform_if [[COND]]
// SELECT: waveamdmachine.s_add_i32
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 1>
// SELECT: otherwise
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.s_mov_b32 "s0", [[R]]
// ASM-LABEL: uniform_if_scalar:
// ASM: s_cmp_lg_u32 s0, 0
// ASM: s_cbranch_scc0 .Luniform_if_scalar.if_else_0
// ASM: s_add_i32
// ASM: s_branch .Luniform_if_scalar.if_end_0
// ASM: .Luniform_if_scalar.if_else_0:
// ASM: .Luniform_if_scalar.if_end_0:
func.func @uniform_if_scalar(%cond: i1, %x: i32, %y: i32) -> i32 {
  %r = scf.if %cond -> (i32) {
    %sum = wave.binary addi %x, %y : i32, i32 -> i32
    scf.yield %sum : i32
  } else {
    scf.yield %y : i32
  }
  return %r : i32
}

// SELECT-LABEL: func.func @uniform_if_index_expr_yield
// SELECT: [[R:%.*]] = waveamdmachine.uniform_if
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: otherwise
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
func.func @uniform_if_index_expr_yield(%cond: i1, %x: i32) attributes {wave.kernel} {
  %zero = arith.constant 0 : index
  %r = scf.if %cond -> (index) {
    %bounded = wave.assume %x as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1024">] : i32
    %idx = wave.index_expr <"x + 1"> ["x"](%bounded) : (i32) -> index
    scf.yield %idx : index
  } else {
    scf.yield %zero : index
  }
  return
}

// SELECT-LABEL: func.func @uniform_if_index_expr_return
// SELECT: [[R:%.*]] = waveamdmachine.uniform_if
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: otherwise
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.s_mov_b32 "s0"
// SELECT: waveamdmachine.s_mov_b32 "s1"
func.func @uniform_if_index_expr_return(%cond: i1, %x: i32) -> index {
  %zero = arith.constant 0 : index
  %r = scf.if %cond -> (index) {
    %bounded = wave.assume %x as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1024">] : i32
    %idx = wave.index_expr <"x + 1"> ["x"](%bounded) : (i32) -> index
    scf.yield %idx : index
  } else {
    scf.yield %zero : index
  }
  return %r : index
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @uniform_if_simd
// SELECT: [[COND:%.*]] = waveamdmachine.s_cmp_lg_u32
// SELECT: [[R:%.*]] = waveamdmachine.uniform_if [[COND]]
// SELECT: waveamdmachine.s_add_i32
// SELECT: waveamdmachine.v_mov_b32_tuple
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 1>
// SELECT: otherwise
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<vgpr, 1>
// SELECT: waveamdmachine.v_readfirstlane_b32 [[R]]
// ASM-LABEL: uniform_if_simd:
// ASM-NOT: s_and_saveexec
// ASM: s_cbranch_scc0 .Luniform_if_simd.if_else_0
// ASM: s_add_i32
// ASM: v_mov_b32
// ASM: s_branch .Luniform_if_simd.if_end_0
// ASM: .Luniform_if_simd.if_else_0:
// ASM: .Luniform_if_simd.if_end_0:
func.func @uniform_if_simd(%cond: i1, %x: i32, %y: i32) -> i32 {
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %vy = wave.splat %y : i32 -> !wave.simd<i32, 32>
  %r = scf.if %cond -> (!wave.simd<i32, 32>) {
    %sum = wave.binary addi %vx, %vy
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %sum : !wave.simd<i32, 32>
  } else {
    scf.yield %vy : !wave.simd<i32, 32>
  }
  %first = wave.read_first %r : !wave.simd<i32, 32> -> i32
  return %first : i32
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @uniform_if_pointer
// SELECT: [[COND:%.*]] = waveamdmachine.s_cmp_lg_u32
// SELECT: [[R:%.*]] = waveamdmachine.uniform_if [[COND]]
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: otherwise
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.yield {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 2>
func.func @uniform_if_pointer(%cond: i1, %out: !wave.ptr<#wave.global, i32>,
                              %i: i32, %j: i32) attributes {wave.kernel} {
  %pi = wave.ptr_add %out, %i
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %pj = wave.ptr_add %out, %j
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %p = scf.if %cond -> (!wave.ptr<#wave.global, i32>) {
    scf.yield %pi : !wave.ptr<#wave.global, i32>
  } else {
    scf.yield %pj : !wave.ptr<#wave.global, i32>
  }
  return
}

}
