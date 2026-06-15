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
    %b, %add_scc = waveamdmachine.s_add_u64 %a, %t : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %v, %tok = waveamdmachine.global_load_b32 %off, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %niv, %scc = waveamdmachine.s_add_i32 %iv, %z1 : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1> carries(%niv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @tuple_element_loop_backedge_value
// CHECK: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>, !waveamdmachine.reg<vgpr, 1, [[SLOT:[0-9]+]]>)
// CHECK: waveamdmachine.uniform_loop {{.*}}carries([[PARTS]]#1 : !waveamdmachine.reg<vgpr, 1, [[SLOT]]>)
// CHECK: ^bb0([[CUR:%.*]]: !waveamdmachine.reg<vgpr, 1, [[SLOT]]>):
// CHECK: [[NEXT:%.*]] = waveamdmachine.v_add_u32 [[CUR]], [[CUR]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, [[SLOT]]>
// CHECK: continue_if {{.*}} carries([[NEXT]] : !waveamdmachine.reg<vgpr, 1, [[SLOT]]>)
// CHECK: } -> !waveamdmachine.reg<vgpr, 1, [[SLOT]]>
func.func @tuple_element_loop_backedge_value() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%parts#1 : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur: !waveamdmachine.reg<vgpr, 1>):
    %next = waveamdmachine.v_add_u32 %cur, %cur
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}
}
