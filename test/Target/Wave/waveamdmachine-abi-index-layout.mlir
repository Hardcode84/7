// RUN: wave-opt --waveamd-abi-lowering %s | FileCheck %s

// CHECK-LABEL: func.func @arg_index_layout
// CHECK-SAME: waveamdmachine.kernarg_size = 16 : i64
// CHECK: [[OFF4:%.*]] = waveamdmachine.imm 4
// CHECK-NEXT: waveamdmachine.s_load_b64 [[OFF4]], "s[0:1]"
func.func @arg_index_layout(%unused: i32, %wide: i64) attributes {wave.kernel} {
  %arg = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
  return
}

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @preloaded_uniform_loop_init
// CHECK: [[ARG:%.*]] = waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// CHECK-NEXT: [[INIT:%.*]] = waveamdmachine.s_mov_b32_tuple [[ARG]] : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<sgpr, 2>
// CHECK: waveamdmachine.uniform_loop carries([[INIT]] : !waveamdmachine.reg<sgpr, 2>)
// CHECK: waveamdmachine.s_mov_b32_tuple [[ARG]] : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<sgpr, 2>
func.func @preloaded_uniform_loop_init(%ptr: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 2 : i64} {
  %arg = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %m0 = waveamdmachine.s_mov_m0 %iv
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %dma = waveamdmachine.global_load_lds_b128
      %off, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %delayed_m0 = waveamdmachine.dma_issue_delay %dma, %m0
      {cycles = 1 : i64}
      : (!waveamdmachine.mem.token, !waveamdmachine.m0)
        -> !waveamdmachine.m0
  %cond = waveamdmachine.s_cmp_lt_i32 %iv, %zero
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %loop = waveamdmachine.uniform_loop
      carries(%arg : !waveamdmachine.reg<sgpr, 2>) {
  ^bb0(%carry: !waveamdmachine.reg<sgpr, 2>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%carry : !waveamdmachine.reg<sgpr, 2>)
  } -> !waveamdmachine.reg<sgpr, 2>
  %direct = waveamdmachine.s_mov_b32_tuple %arg
      : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 2>
  return
}

}
