// RUN: wave-opt %s --split-input-file --wave-balance-reassociable-math | FileCheck %s

// CHECK-LABEL: func.func @fadd_chain(
// CHECK-SAME: [[A:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[B:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[C:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[D:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[E:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[F:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[G:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[H:%[^:]+]]: !wave.simd<f32, 64>)
// CHECK: [[AC:%.*]] = wave.fadd [[A]], [[C]] fastmath<reassoc>
// CHECK: [[EG:%.*]] = wave.fadd [[E]], [[G]] fastmath<reassoc>
// CHECK: [[ACEG:%.*]] = wave.fadd [[AC]], [[EG]] fastmath<reassoc>
// CHECK: [[BD:%.*]] = wave.fadd [[B]], [[D]] fastmath<reassoc>
// CHECK: [[FH:%.*]] = wave.fadd [[F]], [[H]] fastmath<reassoc>
// CHECK: [[BDFH:%.*]] = wave.fadd [[BD]], [[FH]] fastmath<reassoc>
// CHECK: [[RESULT:%.*]] = wave.fadd [[ACEG]], [[BDFH]] fastmath<reassoc>
// CHECK: return [[RESULT]]
func.func @fadd_chain(
    %a: !wave.simd<f32, 64>, %b: !wave.simd<f32, 64>,
    %c: !wave.simd<f32, 64>, %d: !wave.simd<f32, 64>,
    %e: !wave.simd<f32, 64>, %f: !wave.simd<f32, 64>,
    %g: !wave.simd<f32, 64>, %h: !wave.simd<f32, 64>)
    -> !wave.simd<f32, 64> {
  %s0 = wave.fadd %a, %b fastmath<reassoc,nnan>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s1 = wave.fadd %s0, %c fastmath<reassoc,nnan,ninf>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s2 = wave.fadd %s1, %d fastmath<reassoc,nnan>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s3 = wave.fadd %s2, %e fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s4 = wave.fadd %s3, %f fastmath<reassoc,nnan>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s5 = wave.fadd %s4, %g fastmath<reassoc,nnan>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s6 = wave.fadd %s5, %h fastmath<reassoc,nnan>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  return %s6 : !wave.simd<f32, 64>
}

// -----

// CHECK-LABEL: func.func @strict_chain(
// CHECK: [[S0:%.*]] = wave.fadd
// CHECK-NOT: fastmath
// CHECK: [[S1:%.*]] = wave.fadd [[S0]],
// CHECK-NOT: fastmath
// CHECK: [[S2:%.*]] = wave.fadd [[S1]],
// CHECK-NOT: fastmath
// CHECK: return [[S2]]
func.func @strict_chain(
    %a: !wave.simd<f32, 64>, %b: !wave.simd<f32, 64>,
    %c: !wave.simd<f32, 64>, %d: !wave.simd<f32, 64>)
    -> !wave.simd<f32, 64> {
  %s0 = wave.fadd %a, %b
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s1 = wave.fadd %s0, %c
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s2 = wave.fadd %s1, %d
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  return %s2 : !wave.simd<f32, 64>
}

// -----

// CHECK-LABEL: func.func @fmul_odd(
// CHECK-SAME: [[A:%[^:]+]]: !wave.simd<f32, 32>,
// CHECK-SAME: [[B:%[^:]+]]: !wave.simd<f32, 32>,
// CHECK-SAME: [[C:%[^:]+]]: !wave.simd<f32, 32>,
// CHECK-SAME: [[D:%[^:]+]]: !wave.simd<f32, 32>,
// CHECK-SAME: [[E:%[^:]+]]: !wave.simd<f32, 32>)
// CHECK: [[AC:%.*]] = wave.fmul [[A]], [[C]] fastmath<reassoc>
// CHECK: [[ACE:%.*]] = wave.fmul [[AC]], [[E]] fastmath<reassoc>
// CHECK: [[BD:%.*]] = wave.fmul [[B]], [[D]] fastmath<reassoc>
// CHECK: [[RESULT:%.*]] = wave.fmul [[ACE]], [[BD]] fastmath<reassoc>
// CHECK: return [[RESULT]]
func.func @fmul_odd(
    %a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>,
    %c: !wave.simd<f32, 32>, %d: !wave.simd<f32, 32>,
    %e: !wave.simd<f32, 32>) -> !wave.simd<f32, 32> {
  %s0 = wave.fmul %a, %b fastmath<reassoc>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %s1 = wave.fmul %s0, %c fastmath<reassoc>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %s2 = wave.fmul %s1, %d fastmath<reassoc>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  %s3 = wave.fmul %s2, %e fastmath<reassoc>
      : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<f32, 32>
  return %s3 : !wave.simd<f32, 32>
}

// -----

// CHECK-LABEL: func.func @shared_subtree(
// CHECK-SAME: [[A:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[B:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[C:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[D:%[^:]+]]: !wave.simd<f32, 64>,
// CHECK-SAME: [[E:%[^:]+]]: !wave.simd<f32, 64>)
// CHECK: [[SHARED:%.*]] = wave.fadd [[A]], [[B]] fastmath<reassoc>
// CHECK: [[LEFT:%.*]] = wave.fadd [[SHARED]], [[D]] fastmath<reassoc>
// CHECK: [[RIGHT:%.*]] = wave.fadd [[C]], [[E]] fastmath<reassoc>
// CHECK: [[RESULT:%.*]] = wave.fadd [[LEFT]], [[RIGHT]] fastmath<reassoc>
// CHECK: return [[RESULT]], [[SHARED]]
func.func @shared_subtree(
    %a: !wave.simd<f32, 64>, %b: !wave.simd<f32, 64>,
    %c: !wave.simd<f32, 64>, %d: !wave.simd<f32, 64>,
    %e: !wave.simd<f32, 64>)
    -> (!wave.simd<f32, 64>, !wave.simd<f32, 64>) {
  %shared = wave.fadd %a, %b fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s0 = wave.fadd %shared, %c fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s1 = wave.fadd %s0, %d fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s2 = wave.fadd %s1, %e fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  return %s2, %shared : !wave.simd<f32, 64>, !wave.simd<f32, 64>
}

// -----

// CHECK-LABEL: func.func @f16_unchanged(
// CHECK: [[S0:%.*]] = wave.fadd
// CHECK: [[S1:%.*]] = wave.fadd [[S0]],
// CHECK: [[S2:%.*]] = wave.fadd [[S1]],
// CHECK: return [[S2]]
func.func @f16_unchanged(
    %a: !wave.simd<f16, 64>, %b: !wave.simd<f16, 64>,
    %c: !wave.simd<f16, 64>, %d: !wave.simd<f16, 64>)
    -> !wave.simd<f16, 64> {
  %s0 = wave.fadd %a, %b fastmath<reassoc>
      : !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<f16, 64>
  %s1 = wave.fadd %s0, %c fastmath<reassoc>
      : !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<f16, 64>
  %s2 = wave.fadd %s1, %d fastmath<reassoc>
      : !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<f16, 64>
  return %s2 : !wave.simd<f16, 64>
}
