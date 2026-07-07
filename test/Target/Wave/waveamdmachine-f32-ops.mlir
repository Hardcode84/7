// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @waveamdmachine_f32_ops
// CHECK-SAME: ([[A:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 1>)
func.func @waveamdmachine_f32_ops(%a: !waveamdmachine.reg<vgpr, 1>,
                                  %b: !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1> {
  // CHECK: [[ADD:%.*]] = waveamdmachine.v_add_f32 [[A]], [[B]] : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %add = waveamdmachine.v_add_f32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[SUB:%.*]] = waveamdmachine.v_sub_f32 [[ADD]], [[B]] : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sub = waveamdmachine.v_sub_f32 %add, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[MUL:%.*]] = waveamdmachine.v_mul_f32 [[SUB]], [[A]] : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_mul_f32 %sub, %a : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[FMA:%.*]] = waveamdmachine.v_fma_f32 [[MUL]], [[A]], [[B]] : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %fma = waveamdmachine.v_fma_f32 %mul, %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[MAX:%.*]] = waveamdmachine.v_max_f32 [[FMA]], [[ADD]] : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %max = waveamdmachine.v_max_f32 %fma, %add : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[EXP:%.*]] = waveamdmachine.v_exp_f32 [[MAX]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %exp = waveamdmachine.v_exp_f32 %max : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[RCP:%.*]] = waveamdmachine.v_rcp_f32 [[EXP]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %rcp = waveamdmachine.v_rcp_f32 %exp : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[F16:%.*]] = waveamdmachine.v_cvt_f16_f32 [[RCP]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %f16 = waveamdmachine.v_cvt_f16_f32 %rcp : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  // CHECK: [[F32:%.*]] = waveamdmachine.v_cvt_f32_f16 [[F16]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %f32 = waveamdmachine.v_cvt_f32_f16 %f16 : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return %f32 : !waveamdmachine.reg<vgpr, 1>
}
