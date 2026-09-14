// RUN: wave-opt %s --waveamd-form-fused-int | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @subtract(
// CHECK-NOT: waveamdmachine.s_xor_b32
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_sub_i32
func.func @subtract(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out : !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @commuted(
// CHECK-NOT: waveamdmachine.s_xor_b32
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_sub_i32
func.func @commuted(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %mask, %rhs : (!waveamdmachine.imm, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %neg, %lhs : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out : !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @xor_scc(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @xor_scc(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out, %xs : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>
}
// CHECK-LABEL: func.func @negate_scc(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @negate_scc(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out, %ns : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>
}
// CHECK-LABEL: func.func @outer_scc(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @outer_scc(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out, %os : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>
}
// CHECK-LABEL: func.func @shared_negate(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @shared_negate(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out, %neg : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @shared_not(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @shared_not(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %lhs, %neg : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out, %inv : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
}
// CHECK-LABEL: func.func @immediate_minuend(
// CHECK: waveamdmachine.s_xor_b32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK-NOT: waveamdmachine.s_sub_i32
func.func @immediate_minuend(%lhs: !waveamdmachine.reg<sgpr, 1>, %rhs: !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<sgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %mask = waveamdmachine.imm -1 : !waveamdmachine.imm
  %inv, %xs = waveamdmachine.s_xor_b32 %rhs, %mask : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %ns = waveamdmachine.s_add_i32 %inv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %out, %os = waveamdmachine.s_add_i32 %neg, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %out : !waveamdmachine.reg<sgpr, 1>
}
}
