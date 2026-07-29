// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @reuse_killed_acc
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.reg<vgpr, 8, 0>
// CHECK-SAME: %[[B:.*]]: !waveamdmachine.reg<vgpr, 8, 8>
// CHECK-SAME: %[[ACC:.*]]: !waveamdmachine.reg<vgpr, 8, 16>
// CHECK: %[[MMA:.*]] = waveamdmachine.wmma_f32_16x16x32_f16 %[[A]], %[[B]], %[[ACC]]
// CHECK-SAME: matrix_a_reuse = true
// CHECK-SAME: matrix_b_reuse = true
// CHECK-SAME: neg_hi = 4
// CHECK-SAME: neg_lo = 4
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 16>
// CHECK: return %[[MMA]]
func.func @reuse_killed_acc(
    %a: !waveamdmachine.reg<vgpr, 8>,
    %b: !waveamdmachine.reg<vgpr, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8>)
    -> !waveamdmachine.reg<vgpr, 8>
    attributes {waveamdmachine.vgpr_count_max = 24 : i64} {
  %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      {matrix_a_reuse = true, matrix_b_reuse = true,
       neg_lo = 4 : i64, neg_hi = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>)
     -> !waveamdmachine.reg<vgpr, 8>
  return %result : !waveamdmachine.reg<vgpr, 8>
}

// CHECK-LABEL: func.func @keep_live_acc_distinct
// CHECK-SAME: %[[A:.*]]: !waveamdmachine.reg<vgpr, 8, 0>
// CHECK-SAME: %[[B:.*]]: !waveamdmachine.reg<vgpr, 8, 8>
// CHECK-SAME: %[[ACC:.*]]: !waveamdmachine.reg<vgpr, 8, 16>
// CHECK-NOT: waveamdmachine.copy_tuple
// CHECK: %[[MMA:.*]] = waveamdmachine.wmma_f32_16x16x32_bf16 %[[A]], %[[B]], %[[ACC]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 8, 24>
// CHECK-NEXT: %[[PARTS:.*]]:8 = waveamdmachine.tuple_to_elements %[[ACC]]
// CHECK: return %[[MMA]]
func.func @keep_live_acc_distinct(
    %a: !waveamdmachine.reg<vgpr, 8>,
    %b: !waveamdmachine.reg<vgpr, 8>,
    %acc: !waveamdmachine.reg<vgpr, 8>)
    -> !waveamdmachine.reg<vgpr, 8>
    attributes {waveamdmachine.vgpr_count_max = 32 : i64} {
  %result = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>)
     -> !waveamdmachine.reg<vgpr, 8>
  %parts:8 = waveamdmachine.tuple_to_elements %acc
      : (!waveamdmachine.reg<vgpr, 8>)
     -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  return %result : !waveamdmachine.reg<vgpr, 8>
}

}
