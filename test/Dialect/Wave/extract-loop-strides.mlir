// RUN: wave-opt --split-input-file --wave-extract-loop-strides %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-extract-loop-strides --wave-extract-loop-strides %s | FileCheck %s

// CHECK-LABEL: func.func @extract_iv_stride
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%[[WI]])
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"128"> []()
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: wave.load %[[PTR]]
// CHECK: wave.store {{.*}} -> %[[PTR]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @extract_iv_stride(%a: !wave.ptr<f16, #wave.global>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<f16, #wave.global>, !wave.index<32>
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @non_unit_step
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64 + 64*Mod(wi, 16)"> ["wi"](%[[WI]])
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"32"> []()
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @non_unit_step(%a: !wave.ptr<f16, #wave.global>, %n: i32)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c4 to %n step %c2 : i32 {
    %off = wave.index_expr <"16*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<f16, #wave.global>, !wave.index<32>
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @reject_nonlinear
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK: wave.index_expr <"i**2 + 64*Mod(wi, 16)"> ["i", "wi"]
func.func @reject_nonlinear(%a: !wave.ptr<f16, #wave.global>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"i*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<f16, #wave.global>, !wave.index<32>
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @nested_two_ivs
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%[[WI]])
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[OUTER_STRIDE:.*]] = wave.index_expr <"1024"> []()
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OUTER_PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[INNER_STRIDE:.*]] = wave.index_expr <"128"> []()
// CHECK: scf.for %[[J:.*]] = {{.*}} iter_args(%[[INNER_PTR:.*]] = %[[OUTER_PTR]])
// CHECK: wave.load %[[INNER_PTR]]
// CHECK: %[[INNER_NEXT:.*]] = wave.ptr_add %[[INNER_PTR]], %[[INNER_STRIDE]]
// CHECK: scf.yield %[[INNER_NEXT]]
// CHECK: %[[OUTER_NEXT:.*]] = wave.ptr_add %[[OUTER_PTR]], %[[OUTER_STRIDE]]
// CHECK: scf.yield %[[OUTER_NEXT]]
func.func @nested_two_ivs(%a: !wave.ptr<f16, #wave.global>, %n: i32,
                          %m: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c0 to %m step %c1 : i32 {
      %off = wave.index_expr <"1024*i + 128*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.index<32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<f16, #wave.global>, !wave.index<32>
          -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
    }
  }
  return
}

// -----

// CHECK-LABEL: func.func @nested_cross_iv
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)">
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[OUTER_STRIDE:.*]] = wave.index_expr <"16"> []()
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OUTER_PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[INNER_STRIDE:.*]] = wave.index_expr <"16*i"> ["i"](%[[I]])
// CHECK: scf.for %[[J:.*]] = {{.*}} iter_args(%[[INNER_PTR:.*]] = %[[OUTER_PTR]])
// CHECK: %[[INNER_NEXT:.*]] = wave.ptr_add %[[INNER_PTR]], %[[INNER_STRIDE]]
// CHECK: scf.yield %[[INNER_NEXT]]
// CHECK: %[[OUTER_NEXT:.*]] = wave.ptr_add %[[OUTER_PTR]], %[[OUTER_STRIDE]]
// CHECK: scf.yield %[[OUTER_NEXT]]
func.func @nested_cross_iv(%a: !wave.ptr<f16, #wave.global>, %n: i32,
                           %m: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c1 to %m step %c1 : i32 {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.index<32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<f16, #wave.global>, !wave.index<32>
          -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
    }
  }
  return
}

// -----

// CHECK-LABEL: func.func @simd_stride_scalar_base
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[ZERO:.*]] = wave.index_expr <"0"> []()
// CHECK: %[[SCALAR_PTR:.*]] = wave.ptr_add %{{.*}}, %[[ZERO]]
// CHECK: %[[BASE_PTR:.*]] = wave.splat %[[SCALAR_PTR]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"16*wi"> ["wi"](%[[WI]])
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @simd_stride_scalar_base(%a: !wave.ptr<f16, #wave.global>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"16*i*wi"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<f16, #wave.global>, !wave.index<32>
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<f16, #wave.global>, 32>) -> !wave.mem.token
  }
  return
}
