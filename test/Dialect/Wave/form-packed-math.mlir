// RUN: wave-opt %s --split-input-file --wave-form-packed-math | FileCheck %s

module {

// CHECK-LABEL: func.func @cast_pair
// CHECK-SAME: ([[A:%.*]]: !wave.simd<f32, 32>, [[B:%.*]]: !wave.simd<f32, 32>)
// CHECK: [[SRC:%.*]] = wave.pack [[A]], [[B]]
// CHECK-SAME: -> !wave.simd<vector<2xf32>, 32>
// CHECK: [[PACKED:%.*]] = wave.cast fpconvert [[SRC]] policy {rounding = #wave.cast_rounding<rtz>}
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[LO:%.*]] = wave.extract [[PACKED]][0]
// CHECK: [[HI:%.*]] = wave.extract [[PACKED]][1]
// CHECK: return [[LO]], [[HI]]
func.func @cast_pair(%a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %x = wave.cast fpconvert %a policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y = wave.cast fpconvert %b policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  return %x, %y : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @fadd_commute_tree
// CHECK: [[XSRC:%.*]] = wave.pack
// CHECK: [[X:%.*]] = wave.cast fpconvert [[XSRC]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[YSRC:%.*]] = wave.pack
// CHECK: [[Y:%.*]] = wave.cast fpconvert [[YSRC]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[ADD:%.*]] = wave.fadd [[X]], [[Y]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: wave.extract [[ADD]][0]
// CHECK: wave.extract [[ADD]][1]
func.func @fadd_commute_tree(%a0: !wave.simd<f32, 32>,
                             %a1: !wave.simd<f32, 32>,
                             %b0: !wave.simd<f32, 32>,
                             %b1: !wave.simd<f32, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %x0 = wave.cast fpconvert %a0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %x1 = wave.cast fpconvert %a1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y0 = wave.cast fpconvert %b0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y1 = wave.cast fpconvert %b1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %s0 = wave.fadd %x0, %y0
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %s1 = wave.fadd %y1, %x1
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  return %s0, %s1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @fmul_fma_tree
// CHECK: [[X:%.*]] = wave.cast fpconvert
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[Y:%.*]] = wave.cast fpconvert
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[Z:%.*]] = wave.cast fpconvert
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[MUL:%.*]] = wave.fmul [[X]], [[Y]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[FMA:%.*]] = wave.fma [[MUL]], [[Y]], [[Z]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
func.func @fmul_fma_tree(%a0: !wave.simd<f32, 32>,
                         %a1: !wave.simd<f32, 32>,
                         %b0: !wave.simd<f32, 32>,
                         %b1: !wave.simd<f32, 32>,
                         %c0: !wave.simd<f32, 32>,
                         %c1: !wave.simd<f32, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %x0 = wave.cast fpconvert %a0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %x1 = wave.cast fpconvert %a1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y0 = wave.cast fpconvert %b0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y1 = wave.cast fpconvert %b1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %z0 = wave.cast fpconvert %c0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %z1 = wave.cast fpconvert %c1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %m0 = wave.fmul %x0, %y0
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %m1 = wave.fmul %x1, %y1
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %r0 = wave.fma %m0, %y0, %z0
      : !wave.simd<f16, 32>, !wave.simd<f16, 32>,
        !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %r1 = wave.fma %m1, %y1, %z1
      : !wave.simd<f16, 32>, !wave.simd<f16, 32>,
        !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  return %r0, %r1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @f16_leaf_pack
// CHECK-SAME: ([[A0:%.*]]: !wave.simd<f16, 32>, [[A1:%.*]]: !wave.simd<f16, 32>, [[B0:%.*]]: !wave.simd<f16, 32>, [[B1:%.*]]: !wave.simd<f16, 32>)
// CHECK: [[LHS:%.*]] = wave.pack [[A0]], [[A1]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[RHS:%.*]] = wave.pack [[B0]], [[B1]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: [[ADD:%.*]] = wave.fadd [[LHS]], [[RHS]]
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
func.func @f16_leaf_pack(%a0: !wave.simd<f16, 32>,
                         %a1: !wave.simd<f16, 32>,
                         %b0: !wave.simd<f16, 32>,
                         %b1: !wave.simd<f16, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %s0 = wave.fadd %a0, %b0
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  %s1 = wave.fadd %a1, %b1
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  return %s0, %s1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @policy_mismatch
// CHECK-NOT: vector<2xf
// CHECK: wave.cast fpconvert
// CHECK-SAME: -> !wave.simd<f16, 32>
// CHECK: wave.cast fpconvert
// CHECK-SAME: -> !wave.simd<f16, 32>
// CHECK: return
func.func @policy_mismatch(%a: !wave.simd<f32, 32>, %b: !wave.simd<f32, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %x = wave.cast fpconvert %a policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %y = wave.cast fpconvert %b policy {rounding = #wave.cast_rounding<rne>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  return %x, %y : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// CHECK-LABEL: func.func @pack_extract_only_stays
// CHECK-NOT: wave.pack
// CHECK: wave.extract
// CHECK: wave.extract
// CHECK: return
func.func @pack_extract_only_stays(%v: !wave.simd<vector<2xf16>, 32>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>) {
  %x = wave.extract %v[0]
      : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  %y = wave.extract %v[1]
      : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  return %x, %y : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

}

// -----

module {

// CHECK-LABEL: func.func @cross_block
// CHECK-NOT: wave.pack
// CHECK: return
func.func @cross_block(%cond: i1, %a: !wave.simd<f32, 32>,
                       %b: !wave.simd<f32, 32>) -> !wave.simd<f16, 32> {
  cf.cond_br %cond, ^bb1, ^bb2
^bb1:
  %x = wave.cast fpconvert %a policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  cf.br ^bb3(%x : !wave.simd<f16, 32>)
^bb2:
  %y = wave.cast fpconvert %b policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  cf.br ^bb3(%y : !wave.simd<f16, 32>)
^bb3(%v: !wave.simd<f16, 32>):
  return %v : !wave.simd<f16, 32>
}

}
