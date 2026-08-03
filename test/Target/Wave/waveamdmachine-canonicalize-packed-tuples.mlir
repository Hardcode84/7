// RUN: wave-opt --split-input-file --waveamd-canonicalize-packed-tuples --canonicalize %s | FileCheck %s

// CHECK-LABEL: func.func @reuse_later_natural_pair(
// CHECK-SAME: [[A:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[B:%.*]]: !waveamdmachine.reg<vgpr, 2>, [[LOW:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[HIGH:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK-NEXT: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[LOW]], [[HIGH]]
// CHECK-NEXT: [[LOW_FMA:%.*]] = waveamdmachine.v_pk_fma_f32 [[A]], [[B]], [[PAIR]]
// CHECK-SAME: op_sel_hi = 3 : i64
// CHECK-NEXT: [[HIGH_FMA:%.*]] = waveamdmachine.v_pk_fma_f32 [[A]], [[B]], [[PAIR]]
// CHECK-SAME: op_sel = 4 : i64
// CHECK-NEXT: [[SUM:%.*]] = waveamdmachine.v_pk_add_f32 [[LOW_FMA]], [[PAIR]]
// CHECK-NEXT: return [[SUM]], [[HIGH_FMA]]
func.func @reuse_later_natural_pair(
    %a: !waveamdmachine.reg<vgpr, 2>,
    %b: !waveamdmachine.reg<vgpr, 2>,
    %low: !waveamdmachine.reg<vgpr, 1>,
    %high: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) {
  %low_splat = waveamdmachine.tuple_from_elements %low, %low
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %low_fma = waveamdmachine.v_pk_fma_f32 %a, %b, %low_splat
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %high_splat = waveamdmachine.tuple_from_elements %high, %high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %high_fma = waveamdmachine.v_pk_fma_f32 %a, %b, %high_splat
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %pair = waveamdmachine.tuple_from_elements %low, %high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %sum = waveamdmachine.v_pk_add_f32 %low_fma, %pair
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %sum, %high_fma
      : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>
}

// -----

// CHECK-LABEL: func.func @keep_pair_dead_before_repack(
// CHECK: [[PAIR:%.*]] = waveamdmachine.tuple_from_elements [[LOW:%.*]], [[HIGH:%.*]]
// CHECK: [[EARLY:%.*]] = waveamdmachine.v_pk_add_f32 {{.*}}, [[PAIR]]
// CHECK: [[SPLAT:%.*]] = waveamdmachine.tuple_from_elements [[LOW]], [[LOW]]
// CHECK: [[LATE:%.*]] = waveamdmachine.v_pk_mul_f32 [[SPLAT]],
// CHECK: return [[EARLY]], [[LATE]]
func.func @keep_pair_dead_before_repack(
    %lhs: !waveamdmachine.reg<vgpr, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 2>,
    %low: !waveamdmachine.reg<vgpr, 1>,
    %high: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) {
  %pair = waveamdmachine.tuple_from_elements %low, %high
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %early = waveamdmachine.v_pk_add_f32 %lhs, %pair
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %splat = waveamdmachine.tuple_from_elements %low, %low
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %late = waveamdmachine.v_pk_mul_f32 %splat, %rhs
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  return %early, %late
      : !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>
}
