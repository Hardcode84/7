// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,waveamd-insert-ticket-waits,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-hazard-waits)' | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Static positive trip count: no entry guard.
// SELECT-LABEL: func.func @loop_static_nonzero_trip
// SELECT: %[[LOWER:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// SELECT: %[[UPPER:.+]] = waveamdmachine.imm 4 : !waveamdmachine.imm
// SELECT: %[[STEP:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// SELECT-NOT: waveamdmachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: %[[INIT:.+]] = waveamdmachine.s_mov_b32_value %[[LOWER]] : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.uniform_loop carries(%[[INIT]] : !waveamdmachine.reg<sgpr, 1>)
// SELECT-NOT: uniform_loop if %
// SELECT: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 1>):
// SELECT:   %[[NIV:.+]], %{{.+}} = waveamdmachine.s_add_i32 %[[IV]], %[[STEP]]
// SELECT:   %[[BC:.+]] = waveamdmachine.s_cmp_lt_i32 %[[NIV]], %[[UPPER]]
// SELECT:   waveamdmachine.continue_if %[[BC]] : !waveamdmachine.reg<scc, 1> carries(%[[NIV]]

// Carry coalescing: the init register, body block arg, s_add result, and
// loop op result all share the same physical SGPR so no inter-iteration
// moves are emitted.
// REGALLOC-LABEL: func.func @loop_static_nonzero_trip
// REGALLOC: %{{.+}} = waveamdmachine.s_mov_b32_value %{{.+}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, [[CARRY:[0-9]+]]>
// REGALLOC: waveamdmachine.uniform_loop carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1, [[CARRY]]>)
// REGALLOC: ^bb0(%{{.+}}: !waveamdmachine.reg<sgpr, 1, [[CARRY]]>):
// REGALLOC:   %[[SUM:.+]], %{{.+}} = waveamdmachine.s_add_i32 %{{.+}}, %{{.+}} : {{.+}} -> (!waveamdmachine.reg<sgpr, 1, [[CARRY]]>, {{.+}})

// ASM-LABEL: loop_static_nonzero_trip:
// ASM-NOT: s_cbranch_scc0
// ASM: s_mov_b32 s[[CARRY:[0-9]+]], 0
// ASM: .Lloop_static_nonzero_trip.loop_head_0:
// ASM: s_add_i32 s[[CARRY]], s[[CARRY]], 1
// ASM: s_cmp_lt_i32 s[[CARRY]], 4
// ASM: s_cbranch_scc1 .Lloop_static_nonzero_trip.loop_head_0
// ASM: .Lloop_static_nonzero_trip.loop_exit_0:
func.func @loop_static_nonzero_trip() attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %step = arith.constant 1 : i32
  scf.for %i = %lo to %hi step %step : i32 {
    scf.yield
  }
  return
}

// Static zero trip count still needs the entry guard.
// SELECT-LABEL: func.func @loop_static_zero_trip
// SELECT: %[[LOWER:.+]] = waveamdmachine.imm 4 : !waveamdmachine.imm
// SELECT: %[[UPPER:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// SELECT: %[[EC:.+]] = waveamdmachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: waveamdmachine.uniform_loop if %[[EC]] : !waveamdmachine.reg<scc, 1>
func.func @loop_static_zero_trip() attributes {wave.kernel} {
  %lo = arith.constant 4 : i32
  %hi = arith.constant 0 : i32
  %step = arith.constant 1 : i32
  scf.for %i = %lo to %hi step %step : i32 {
    scf.yield
  }
  return
}

// Range-proven positive trip count: no entry guard.
// SELECT-LABEL: func.func @loop_range_nonzero_trip
// SELECT: %[[LOWER:.+]] = waveamdmachine.arg
// SELECT: %[[UPPER:.+]] = waveamdmachine.arg
// SELECT-NOT: waveamdmachine.s_cmp_lt_i32 %[[LOWER]], %[[UPPER]]
// SELECT: waveamdmachine.uniform_loop carries(%[[LOWER]]
// SELECT-NOT: uniform_loop if %
func.func @loop_range_nonzero_trip(%lo_raw: i32, %hi_raw: i32)
    attributes {wave.kernel} {
  %lo = wave.assume %lo_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 3">] : i32
  %hi = wave.assume %hi_raw as "x" [#wave.pred<"x >= 4">, #wave.pred<"x <= 8">] : i32
  %step = arith.constant 1 : i32
  scf.for %i = %lo to %hi step %step : i32 {
    scf.yield
  }
  return
}

// Invariant body use cannot share the loop carry init.
// SELECT-LABEL: func.func @loop_carry_init_distinct_from_invariant_use
// SELECT: %[[STEP:.+]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 1>
// SELECT: %[[COPY:.+]] = waveamdmachine.copy_tuple %[[STEP]] : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.uniform_loop carries({{.*}}, %[[COPY]]
// SELECT: waveamdmachine.s_add_i32 {{.*}}, %[[STEP]]

// ASM-LABEL: loop_carry_init_distinct_from_invariant_use:
// ASM: s_load_b32 s[[STEP:[0-9]+]], s[0:1], 0x0
// ASM: s_waitcnt lgkmcnt(0)
// ASM: s_mov_b32 s[[CARRY:[0-9]+]], s[[STEP]]
// ASM: .Lloop_carry_init_distinct_from_invariant_use.loop_head_0:
// ASM: s_add_i32 s[[CARRY]], s[[CARRY]], s[[STEP]]
func.func @loop_carry_init_distinct_from_invariant_use(%step_raw: i32)
    attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %one = arith.constant 1 : i32
  %step = wave.assume %step_raw as "x" [#wave.pred<"x >= 1">, #wave.pred<"x <= 16">] : i32
  %res = scf.for %i = %lo to %hi step %one iter_args(%base = %step) -> (i32) : i32 {
    %next = wave.binary addi %base, %step : i32, i32 -> i32
    scf.yield %next : i32
  }
  return
}

// SELECT-LABEL: func.func @loop_i64_carry_init_distinct_from_invariant_use
// SELECT: %[[STEP:.+]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: %[[COPY:.+]] = waveamdmachine.copy_tuple %[[STEP]] : (!waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.uniform_loop carries({{.*}}, %[[COPY]]
// SELECT: waveamdmachine.s_add_u64 {{.*}}, %[[STEP]]
func.func @loop_i64_carry_init_distinct_from_invariant_use(%step: i64)
    attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %one = arith.constant 1 : i32
  %res = scf.for %i = %lo to %hi step %one iter_args(%base = %step) -> (i64) : i32 {
    %next = wave.binary addi %base, %step : i64, i64 -> i64
    scf.yield %next : i64
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
// SELECT: waveamdmachine.uniform_loop carries(%{{.+}} : !waveamdmachine.reg<sgpr, 2>)
// SELECT-NOT: uniform_loop if %
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
