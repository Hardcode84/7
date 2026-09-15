// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule' -o %t.parallel 2> %t.parallel.log
// RUN: wave-opt %s --mlir-disable-threading --waveamd-machine-schedule='apply-schedule' -o %t.serial 2> %t.serial.log
// RUN: diff %t.parallel %t.serial
// RUN: diff %t.parallel.log %t.serial.log
// RUN: wave-opt %t.parallel --waveamd-collapse-materialization-variants -o %t.winner
// RUN: FileCheck %s --check-prefix=WINNER --implicit-check-not=waveamdmachine.materialization --implicit-check-not=test.losing --implicit-check-not=test.second < %t.winner
// RUN: wave-translate %t.winner --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null

// WINNER-LABEL: func.func @scheduler_state
// WINNER: [[LOADED:%.*]], [[TOKEN:%.*]] = waveamdmachine.global_load_b32
// WINNER: waveamdmachine.imm 0 {test.first}
// WINNER: [[INDEPENDENT:%.*]] = waveamdmachine.v_add_u32 {{.*}} {test.independent}
// WINNER-NEXT: [[DEPENDENT:%.*]] = waveamdmachine.v_add_u32 [[LOADED]], {{.*}} {test.dependent}
// WINNER: waveamdmachine.global_store_b32 {{.*}} after [[TOKEN]]
// WINNER: waveamdmachine.s_endpgm
// ASM-LABEL: scheduler_state:
// ASM: global_load_b32
// ASM-NOT: global_load_b32
// ASM: global_store_b32
// ASM-NOT: global_store_b32
// ASM: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @scheduler_state() attributes {wave.kernel, waveamdmachine.kernarg_size = 8 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %base = waveamdmachine.s_load_b64 %zero, "s[0:1]" : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %off = waveamdmachine.v_lshlrev_b32 %lane, %two : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %ready = waveamdmachine.global_load_b32 %off, %base after %token : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %first:2 = waveamdmachine.materialization_candidates %loaded, %ready, %zero : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.imm -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token, %z: !waveamdmachine.imm):
    %copy = waveamdmachine.v_add_u32 %value, %z {test.losing} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.candidate_yield %copy, %dep : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  }, {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token, %z: !waveamdmachine.imm):
    waveamdmachine.candidate_yield %value, %dep : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  }
  %second:3 = waveamdmachine.materialization_candidates %first#0, %first#1 : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token -> !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.imm {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %marker = waveamdmachine.imm 0 {test.first} : !waveamdmachine.imm
    waveamdmachine.candidate_yield %value, %dep, %marker : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.imm
  }, {
  ^bb0(%value: !waveamdmachine.reg<vgpr, 1>, %dep: !waveamdmachine.mem.token):
    %marker = waveamdmachine.imm 0 {test.second} : !waveamdmachine.imm
    waveamdmachine.candidate_yield %value, %dep, %marker : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.imm
  }
  %dependent = waveamdmachine.v_add_u32 %second#0, %lane {test.dependent} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %independent = waveamdmachine.v_add_u32 %lane, %lane {test.independent} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %dependent, %independent : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_add_u32 %sum, %second#2 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %done = waveamdmachine.global_store_b32 %off, %value, %base after %second#1 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm after %done : !waveamdmachine.mem.token
  return
}
}
