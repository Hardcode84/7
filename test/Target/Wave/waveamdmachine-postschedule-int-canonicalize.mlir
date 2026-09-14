// RUN: wave-opt --split-input-file --waveamd-postschedule-int-canonicalize %s | FileCheck %s

module {

// CHECK-LABEL: func.func @contract_sub
// CHECK-NOT: waveamdmachine.s_xor_b32
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: %[[SUB:[^,]+]], %{{.*}} = waveamdmachine.s_sub_i32 %arg0, %arg1
// CHECK: return %[[SUB]]
func.func @contract_sub(
    %lhs: !waveamdmachine.reg<sgpr, 1>,
    %rhs: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.reg<sgpr, 1> {
  %minus_one = waveamdmachine.imm -1 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %not, %not_scc = waveamdmachine.s_xor_b32 %rhs, %minus_one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %neg_scc = waveamdmachine.s_add_i32 %not, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %result, %result_scc = waveamdmachine.s_add_i32 %lhs, %neg
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %result : !waveamdmachine.reg<sgpr, 1>
}

}

// -----

module {

// A live intermediate result keeps the expanded graph intact.
// CHECK-LABEL: func.func @preserve_shared_negation
// CHECK: %[[NOT:[^,]+]], %{{.*}} = waveamdmachine.s_xor_b32
// CHECK: %[[NEG:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[NOT]],
// CHECK: %[[RESULT:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %arg0, %[[NEG]]
// CHECK: return %[[RESULT]], %[[NEG]]
func.func @preserve_shared_negation(
    %lhs: !waveamdmachine.reg<sgpr, 1>,
    %rhs: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  %minus_one = waveamdmachine.imm -1 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %not, %not_scc = waveamdmachine.s_xor_b32 %rhs, %minus_one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %neg, %neg_scc = waveamdmachine.s_add_i32 %not, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %result, %result_scc = waveamdmachine.s_add_i32 %lhs, %neg
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return %result, %neg : !waveamdmachine.reg<sgpr, 1>,
                         !waveamdmachine.reg<sgpr, 1>
}

}
