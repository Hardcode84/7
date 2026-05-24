// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s

// A value used as both a loop carry init and a tuple_from_elements
// element is dual-pinned: the carry coalescer wants it at offset 0,
// the tuple wants it at slot 1. Reg-alloc must copy it for the tuple
// instead of splitting the carry (else init/continue land in different
// physical regs and the verifier rejects continue_if). The IV here
// stays one register; the tuple gets a fresh s_mov copy.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @carry_tuple(%a: !waveamdmachine.reg<sgpr, 2>, %n: !waveamdmachine.reg<sgpr, 1>)
    attributes {wave.kernel} {
  %z0 = waveamdmachine.imm 0 : !waveamdmachine.imm
  %z1 = waveamdmachine.imm 1 : !waveamdmachine.imm
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.s_mov_b32_value %z0 : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %lo, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  // CHECK: uniform_loop {{.*}}carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1, [[X:[0-9]+]]>)
  // CHECK: s_mov_b32_tuple %{{.+}} : (!waveamdmachine.reg<sgpr, 1, [[X]]>) -> !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
  // CHECK: continue_if %{{.+}} carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1, [[X]]>)
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %t = waveamdmachine.tuple_from_elements %iv, %lo : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 2>
    %b = waveamdmachine.s_add_u64 %a, %t : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 2>
    %v, %tok = waveamdmachine.global_load_b32 %off, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %niv, %scc = waveamdmachine.s_add_i32 %iv, %z1 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1> carries(%niv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}
}
