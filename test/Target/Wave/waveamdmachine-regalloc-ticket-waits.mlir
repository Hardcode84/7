// RUN: wave-opt --waveamd-insert-ticket-waits --waveamd-reg-alloc='vgpr-limit=4' --waveamd-insert-ticket-waits %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @regalloc_agpr_copy_waits_for_vmem_result
// CHECK: %[[LOAD:.*]], %[[TOK:.*]] = waveamdmachine.global_load_u8
// CHECK-NOT: %[[LOAD]]
// CHECK: waveamdmachine.s_waitcnt vmcnt(0)
// CHECK-NEXT: %[[COPY:.*]] = waveamdmachine.v_mov_b32_tuple %[[LOAD]]
func.func @regalloc_agpr_copy_waits_for_vmem_result(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %load, %tok = waveamdmachine.global_load_u8 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %c = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %d = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use_load = waveamdmachine.v_mov_b32_tuple %load {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_a = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_b = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_c = waveamdmachine.v_mov_b32_tuple %c {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_d = waveamdmachine.v_mov_b32_tuple %d {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
