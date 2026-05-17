// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-wavemachine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --waveamd-reg-alloc %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Pre-tested (no `wave.nonzero_trip` attr): the selector materialises
// an `s_cmp_lt_i32 lower, upper` immediately before the loop op and
// threads its SCC result as `if %ec`.
// SELECT-LABEL: func.func @loop_pretested
// SELECT: %[[LOWER:.+]] = wavemachine.imm 0 : !wavemachine.imm
// SELECT: %[[UPPER:.+]] = wavemachine.imm 4 : !wavemachine.imm
// SELECT: %[[STEP:.+]] = wavemachine.imm 1 : !wavemachine.imm
// SELECT: %[[EC:.+]] = wavemachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: %[[INIT:.+]] = wavemachine.s_mov_b32_value %[[LOWER]] : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
// SELECT: wavemachine.uniform_loop if %[[EC]] : !wavemachine.reg<scc, 1> carries(%[[INIT]] : !wavemachine.reg<sgpr, 1>)
// SELECT: ^bb0(%[[IV:.+]]: !wavemachine.reg<sgpr, 1>):
// SELECT:   %[[NIV:.+]], %{{.+}} = wavemachine.s_add_i32 %[[IV]], %[[STEP]]
// SELECT:   %[[BC:.+]] = wavemachine.s_cmp_lt_i32 %[[NIV]], %[[UPPER]]
// SELECT:   wavemachine.continue_if %[[BC]] : !wavemachine.reg<scc, 1> carries(%[[NIV]]

// Carry coalescing: the init register, body block arg, s_add result, and
// loop op result all share the same physical SGPR so no inter-iteration
// moves are emitted.
// REGALLOC-LABEL: func.func @loop_pretested
// REGALLOC: %{{.+}} = wavemachine.s_mov_b32_value %{{.+}} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1, [[CARRY:[0-9]+]]>
// REGALLOC: wavemachine.uniform_loop if %{{.+}} carries(%{{.+}} : !wavemachine.reg<sgpr, 1, [[CARRY]]>)
// REGALLOC: ^bb0(%{{.+}}: !wavemachine.reg<sgpr, 1, [[CARRY]]>):
// REGALLOC:   %[[SUM:.+]], %{{.+}} = wavemachine.s_add_i32 %{{.+}}, %{{.+}} : {{.+}} -> (!wavemachine.reg<sgpr, 1, [[CARRY]]>, {{.+}})

// ASM-LABEL: loop_pretested:
// ASM: s_cmp_lt_i32 0, 4
// ASM: s_mov_b32 s[[CARRY:[0-9]+]], 0
// ASM: s_cbranch_scc0 .Lloop_pretested.loop_exit_0
// ASM: .Lloop_pretested.loop_head_0:
// ASM: s_add_i32 s[[CARRY]], s[[CARRY]], 1
// ASM: s_cmp_lt_i32 s[[CARRY]], 4
// ASM: s_cbranch_scc1 .Lloop_pretested.loop_head_0
// ASM: .Lloop_pretested.loop_exit_0:
func.func @loop_pretested() attributes {wave.kernel} {
  %lo = arith.constant 0 : index
  %hi = arith.constant 4 : index
  %step = arith.constant 1 : index
  scf.for %i = %lo to %hi step %step {
    scf.yield
  }
  return
}

// Post-tested (with `wave.nonzero_trip`): no entry_cond materialised;
// loop op printed without the `if` clause.
// SELECT-LABEL: func.func @loop_post_tested
// SELECT: %[[LOWER:.+]] = wavemachine.imm 0 : !wavemachine.imm
// SELECT: %[[UPPER:.+]] = wavemachine.imm 4 : !wavemachine.imm
// SELECT: %[[STEP:.+]] = wavemachine.imm 1 : !wavemachine.imm
// SELECT-NOT: wavemachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: %[[INIT:.+]] = wavemachine.s_mov_b32_value %[[LOWER]] : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
// SELECT: wavemachine.uniform_loop carries(%[[INIT]] : !wavemachine.reg<sgpr, 1>) {
// SELECT-NOT: uniform_loop if %

// ASM-LABEL: loop_post_tested:
// ASM-NOT: s_cbranch_scc0
// ASM: s_mov_b32 s{{[0-9]+}}, 0
// ASM: .Lloop_post_tested.loop_head_0:
// ASM: s_cbranch_scc1 .Lloop_post_tested.loop_head_0
// ASM: .Lloop_post_tested.loop_exit_0:
func.func @loop_post_tested() attributes {wave.kernel} {
  %lo = arith.constant 0 : index
  %hi = arith.constant 4 : index
  %step = arith.constant 1 : index
  scf.for %i = %lo to %hi step %step {
    scf.yield
  } {wave.nonzero_trip}
  return
}

}
