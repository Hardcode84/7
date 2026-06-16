// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-reg-alloc --waveamd-insert-hazard-waits %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Pre-tested (no `wave.nonzero_trip` attr): the selector materialises
// an `s_cmp_lt_i32 lower, upper` immediately before the loop op and
// threads its SCC result as `if %ec`.
// SELECT-LABEL: func.func @loop_pretested
// SELECT: %[[LOWER:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// SELECT: %[[UPPER:.+]] = waveamdmachine.imm 4 : !waveamdmachine.imm
// SELECT: %[[STEP:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// SELECT: %[[INIT:.+]] = waveamdmachine.s_mov_b32_value %[[LOWER]] : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
// SELECT: %[[EC:.+]] = waveamdmachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: waveamdmachine.uniform_loop if %[[EC]] : !waveamdmachine.reg<scc, 1> carries(%[[INIT]] : !waveamdmachine.reg<sgpr, 1>)
// SELECT: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 1>):
// SELECT:   %[[NIV:.+]], %{{.+}} = waveamdmachine.s_add_i32 %[[IV]], %[[STEP]]
// SELECT:   %[[BC:.+]] = waveamdmachine.s_cmp_lt_i32 %[[NIV]], %[[UPPER]]
// SELECT:   waveamdmachine.continue_if %[[BC]] : !waveamdmachine.reg<scc, 1> carries(%[[NIV]]

// Carry coalescing: the init register, body block arg, s_add result, and
// loop op result all share the same physical SGPR so no inter-iteration
// moves are emitted.
// REGALLOC-LABEL: func.func @loop_pretested
// REGALLOC: %{{.+}} = waveamdmachine.s_mov_b32_value %{{.+}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, [[CARRY:[0-9]+]]>
// REGALLOC: waveamdmachine.uniform_loop if %{{.+}} carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1, [[CARRY]]>)
// REGALLOC: ^bb0(%{{.+}}: !waveamdmachine.reg<sgpr, 1, [[CARRY]]>):
// REGALLOC:   %[[SUM:.+]], %{{.+}} = waveamdmachine.s_add_i32 %{{.+}}, %{{.+}} : {{.+}} -> (!waveamdmachine.reg<sgpr, 1, [[CARRY]]>, {{.+}})

// ASM-LABEL: loop_pretested:
// ASM: s_mov_b32 s[[CARRY:[0-9]+]], 0
// ASM: s_cmp_lt_i32 0, 4
// ASM: s_cbranch_scc0 .Lloop_pretested.loop_exit_0
// ASM: .Lloop_pretested.loop_head_0:
// ASM: s_add_i32 s[[CARRY]], s[[CARRY]], 1
// ASM: s_cmp_lt_i32 s[[CARRY]], 4
// ASM: s_cbranch_scc1 .Lloop_pretested.loop_head_0
// ASM: .Lloop_pretested.loop_exit_0:
func.func @loop_pretested() attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %step = arith.constant 1 : i32
  scf.for %i = %lo to %hi step %step : i32 {
    scf.yield
  }
  return
}

// Index upper bounds may materialize as SGPR2 values. The IV must widen too.
// SELECT-LABEL: func.func @loop_index_expr_upper_sgpr2
// SELECT: %[[HI:.+]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.s_cmp_eq_u32
// SELECT: waveamdmachine.s_cmp_lt_u32
// SELECT: waveamdmachine.uniform_loop if %{{.+}} : !waveamdmachine.reg<scc, 1> carries(%{{.+}} : !waveamdmachine.reg<sgpr, 2>)
// SELECT: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 2>):
// SELECT:   %[[NIV:.+]], %{{.+}} = waveamdmachine.s_add_u64 %[[IV]], {{.*}}
// SELECT:   waveamdmachine.s_cmp_lt_u32
func.func @loop_index_expr_upper_sgpr2(%hi_raw: i64) attributes {wave.kernel} {
  %lo = arith.constant 0 : index
  %step = arith.constant 1 : index
  %hi = wave.index_expr <"h"> ["h"](%hi_raw) : (i64) -> index
  scf.for %i = %lo to %hi step %step {
    scf.yield
  }
  return
}

// SELECT-LABEL: func.func @loop_index_imm_upper_sgpr2
// SELECT: waveamdmachine.uniform_loop if %{{.+}} : !waveamdmachine.reg<scc, 1> carries(%{{.+}} : !waveamdmachine.reg<sgpr, 2>)
// SELECT: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 2>):
// SELECT:   waveamdmachine.s_add_u64 %[[IV]],
func.func @loop_index_imm_upper_sgpr2() attributes {wave.kernel} {
  %lo = arith.constant 0 : index
  %hi = arith.constant 4294967297 : index
  %step = arith.constant 1 : index
  scf.for %i = %lo to %hi step %step {
    scf.yield
  }
  return
}

// SELECT-LABEL: func.func @loop_index_negative_lower_sgpr2
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.uniform_loop if %{{.+}} : !waveamdmachine.reg<scc, 1> carries(%{{.+}} : !waveamdmachine.reg<sgpr, 2>)
// SELECT: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 2>):
// SELECT:   waveamdmachine.s_add_u64 %[[IV]],
func.func @loop_index_negative_lower_sgpr2(%lo_raw: i32) attributes {wave.kernel} {
  %lo = wave.index_expr <"lo"> ["lo"](%lo_raw) : (i32) -> index
  %hi = arith.constant 4294967297 : index
  %step = arith.constant 1 : index
  scf.for %i = %lo to %hi step %step {
    scf.yield
  }
  return
}

// Post-tested (with `wave.nonzero_trip`): no entry_cond materialised;
// loop op printed without the `if` clause.
// SELECT-LABEL: func.func @loop_post_tested
// SELECT: %[[LOWER:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// SELECT: %[[UPPER:.+]] = waveamdmachine.imm 4 : !waveamdmachine.imm
// SELECT: %[[STEP:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// SELECT-NOT: waveamdmachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: %[[INIT:.+]] = waveamdmachine.s_mov_b32_value %[[LOWER]] : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.uniform_loop carries(%[[INIT]] : !waveamdmachine.reg<sgpr, 1>) {
// SELECT-NOT: uniform_loop if %

// ASM-LABEL: loop_post_tested:
// ASM-NOT: s_cbranch_scc0
// ASM: s_mov_b32 s{{[0-9]+}}, 0
// ASM: .Lloop_post_tested.loop_head_0:
// ASM: s_cbranch_scc1 .Lloop_post_tested.loop_head_0
// ASM: .Lloop_post_tested.loop_exit_0:
func.func @loop_post_tested() attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %step = arith.constant 1 : i32
  scf.for %i = %lo to %hi step %step : i32 {
    scf.yield
  } {wave.nonzero_trip}
  return
}

}
