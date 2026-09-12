// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s --canonicalize | FileCheck %s
// RUN: wave-opt %s --canonicalize='top-down=true' | FileCheck %s
// RUN: wave-opt %s --canonicalize -o %t.once
// RUN: wave-opt %t.once --canonicalize -o %t.twice
// RUN: diff %t.once %t.twice

// ROUNDTRIP-LABEL: func.func @duplicates
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @duplicates
// CHECK: [[A:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[B:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[C:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK-NEXT: [[R:%.*]] = waveamdmachine.materialization_variants [[A]], [[B]], [[C]]
// CHECK-NEXT: return [[R]]
func.func @duplicates(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.materialization_variants %a, %b, %a, %c, %b {test.marker = 7 : i64} : !waveamdmachine.reg<sgpr, 1>
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// ROUNDTRIP-LABEL: func.func @nested
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @nested
// CHECK: [[A:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[B:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[C:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK-NEXT: [[R:%.*]] = waveamdmachine.materialization_variants [[A]], [[B]], [[C]]
// CHECK-NEXT: return [[R]]
func.func @nested(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %inner = waveamdmachine.materialization_variants %a, %b : !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.materialization_variants %inner, %c, %inner : !waveamdmachine.reg<sgpr, 1>
  return %r : !waveamdmachine.reg<sgpr, 1>
}

// ROUNDTRIP-LABEL: func.func @shared_dag
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @shared_dag
// CHECK: [[A:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[B:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[C:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK-NEXT: [[R:%.*]] = waveamdmachine.materialization_variants [[A]], [[B]], [[C]]
// CHECK-NEXT: return [[R]]
func.func @shared_dag(%x: !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1> {
  %a = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %v0 = waveamdmachine.materialization_variants %a, %b, %c : !waveamdmachine.reg<sgpr, 1>
  %v1 = waveamdmachine.materialization_variants %v0, %v0 : !waveamdmachine.reg<sgpr, 1>
  %v2 = waveamdmachine.materialization_variants %v1, %v1 : !waveamdmachine.reg<sgpr, 1>
  %v3 = waveamdmachine.materialization_variants %v2, %v2 : !waveamdmachine.reg<sgpr, 1>
  %v4 = waveamdmachine.materialization_variants %v3, %v3 : !waveamdmachine.reg<sgpr, 1>
  %v5 = waveamdmachine.materialization_variants %v4, %v4 : !waveamdmachine.reg<sgpr, 1>
  %v6 = waveamdmachine.materialization_variants %v5, %v5 : !waveamdmachine.reg<sgpr, 1>
  %v7 = waveamdmachine.materialization_variants %v6, %v6 : !waveamdmachine.reg<sgpr, 1>
  %v8 = waveamdmachine.materialization_variants %v7, %v7 : !waveamdmachine.reg<sgpr, 1>
  %v9 = waveamdmachine.materialization_variants %v8, %v8 : !waveamdmachine.reg<sgpr, 1>
  %v10 = waveamdmachine.materialization_variants %v9, %v9 : !waveamdmachine.reg<sgpr, 1>
  %v11 = waveamdmachine.materialization_variants %v10, %v10 : !waveamdmachine.reg<sgpr, 1>
  %v12 = waveamdmachine.materialization_variants %v11, %v11 : !waveamdmachine.reg<sgpr, 1>
  %v13 = waveamdmachine.materialization_variants %v12, %v12 : !waveamdmachine.reg<sgpr, 1>
  %v14 = waveamdmachine.materialization_variants %v13, %v13 : !waveamdmachine.reg<sgpr, 1>
  %v15 = waveamdmachine.materialization_variants %v14, %v14 : !waveamdmachine.reg<sgpr, 1>
  %v16 = waveamdmachine.materialization_variants %v15, %v15 : !waveamdmachine.reg<sgpr, 1>
  %v17 = waveamdmachine.materialization_variants %v16, %v16 : !waveamdmachine.reg<sgpr, 1>
  %v18 = waveamdmachine.materialization_variants %v17, %v17 : !waveamdmachine.reg<sgpr, 1>
  %v19 = waveamdmachine.materialization_variants %v18, %v18 : !waveamdmachine.reg<sgpr, 1>
  %v20 = waveamdmachine.materialization_variants %v19, %v19 : !waveamdmachine.reg<sgpr, 1>
  %v21 = waveamdmachine.materialization_variants %v20, %v20 : !waveamdmachine.reg<sgpr, 1>
  %v22 = waveamdmachine.materialization_variants %v21, %v21 : !waveamdmachine.reg<sgpr, 1>
  %v23 = waveamdmachine.materialization_variants %v22, %v22 : !waveamdmachine.reg<sgpr, 1>
  %v24 = waveamdmachine.materialization_variants %v23, %v23 : !waveamdmachine.reg<sgpr, 1>
  %v25 = waveamdmachine.materialization_variants %v24, %v24 : !waveamdmachine.reg<sgpr, 1>
  %v26 = waveamdmachine.materialization_variants %v25, %v25 : !waveamdmachine.reg<sgpr, 1>
  %v27 = waveamdmachine.materialization_variants %v26, %v26 : !waveamdmachine.reg<sgpr, 1>
  %v28 = waveamdmachine.materialization_variants %v27, %v27 : !waveamdmachine.reg<sgpr, 1>
  %v29 = waveamdmachine.materialization_variants %v28, %v28 : !waveamdmachine.reg<sgpr, 1>
  %v30 = waveamdmachine.materialization_variants %v29, %v29 : !waveamdmachine.reg<sgpr, 1>
  %v31 = waveamdmachine.materialization_variants %v30, %v30 : !waveamdmachine.reg<sgpr, 1>
  %v32 = waveamdmachine.materialization_variants %v31, %v31 : !waveamdmachine.reg<sgpr, 1>
  return %v32 : !waveamdmachine.reg<sgpr, 1>
}

// ROUNDTRIP-LABEL: func.func @single
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @single(
// CHECK-SAME: [[X:%[^:]+]]:
// CHECK-NEXT: return [[X]]
func.func @single(%x: !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4> {
  %r = waveamdmachine.materialization_variants %x : !waveamdmachine.reg<vgpr, 4>
  return %r : !waveamdmachine.reg<vgpr, 4>
}

// ROUNDTRIP-LABEL: func.func @token
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @token(
// CHECK-SAME: [[X:%[^:]+]]:
// CHECK-NEXT: return [[X]]
func.func @token(%x: !waveamdmachine.mem.token) -> !waveamdmachine.mem.token {
  %r = waveamdmachine.materialization_variants %x : !waveamdmachine.mem.token
  return %r : !waveamdmachine.mem.token
}

// ROUNDTRIP-LABEL: func.func @immediate
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @immediate(
// CHECK-SAME: [[X:%[^:]+]]:
// CHECK-NEXT: return [[X]]
func.func @immediate(%x: !waveamdmachine.imm) -> !waveamdmachine.imm {
  %r = waveamdmachine.materialization_variants %x : !waveamdmachine.imm
  return %r : !waveamdmachine.imm
}

// ROUNDTRIP-LABEL: func.func @scc
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @scc(
// CHECK-SAME: [[X:%[^:]+]]:
// CHECK-NEXT: return [[X]]
func.func @scc(%x: !waveamdmachine.reg<scc, 1>) -> !waveamdmachine.reg<scc, 1> {
  %r = waveamdmachine.materialization_variants %x : !waveamdmachine.reg<scc, 1>
  return %r : !waveamdmachine.reg<scc, 1>
}

// ROUNDTRIP-LABEL: func.func @dead
// ROUNDTRIP: waveamdmachine.materialization_variants
// CHECK-LABEL: func.func @dead
// CHECK-NEXT: return
func.func @dead(%x: !waveamdmachine.imm) {
  %r = waveamdmachine.materialization_variants %x, %x : !waveamdmachine.imm
  return
}
