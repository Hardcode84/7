// RUN: wave-opt --split-input-file --wave-extract-loop-strides %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-extract-loop-strides --wave-extract-loop-strides %s | FileCheck %s

// CHECK-LABEL: func.func @extract_iv_stride
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%[[WI]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"128"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: wave.load %[[PTR]]
// CHECK: wave.store {{.*}} -> %[[PTR]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @extract_iv_stride(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @non_unit_step
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64 + 64*Mod(wi, 16)"> ["wi"](%[[WI]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"32"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @non_unit_step(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c4 to %n step %c2 : i32 {
    %off = wave.index_expr <"16*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @scaled_nested_iv_binding
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"128*base + 64*Mod(wi, 16)"> ["base", "wi"](%arg1, %[[WI]]) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %arg0, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"128"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: wave.load %[[PTR]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @scaled_nested_iv_binding(%a: !wave.ptr<#wave.global, f16>,
                                    %base: i32, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %sum = wave.index_expr <"base + i"> ["base", "i"](%base, %i)
        : (i32, i32) -> index
    %off = wave.index_expr <"128*x + 64*Mod(wi, 16)"> ["x", "wi"](%sum, %wi)
        : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @derived_binary_shared_orig
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[ABASE_OFF:.*]] = wave.index_expr <"128 + 4194304*wg_m + 64*Mod(wi, 16)"> ["wi", "wg_m"](%[[WI]], %arg2) : (!wave.simd<i32, 32>, index) -> !wave.simd<index, 32>
// CHECK: %[[AP:.*]] = wave.ptr_add %arg0, %[[ABASE_OFF]]
// CHECK: %[[ASTRIDE:.*]] = wave.index_expr <"64"> []() : () -> index
// CHECK: %[[BBASE_OFF:.*]] = wave.index_expr <"128 + 4194304*wg_n + 64*Mod(wi, 16)"> ["wi", "wg_n"](%[[WI]], %arg3) : (!wave.simd<i32, 32>, index) -> !wave.simd<index, 32>
// CHECK: %[[BP:.*]] = wave.ptr_add %arg1, %[[BBASE_OFF]]
// CHECK: %[[BSTRIDE:.*]] = wave.index_expr <"64"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[ACARRY:.*]] = %[[AP]], %[[BCARRY:.*]] = %[[BP]])
// CHECK: wave.load %[[ACARRY]]
// CHECK: wave.load %[[BCARRY]]
// CHECK: %[[ANEXT:.*]] = wave.ptr_add %[[ACARRY]], %[[ASTRIDE]]
// CHECK: %[[BNEXT:.*]] = wave.ptr_add %[[BCARRY]], %[[BSTRIDE]]
// CHECK: scf.yield %[[ANEXT]], %[[BNEXT]]
func.func @derived_binary_shared_orig(%a: !wave.ptr<#wave.global, f16>,
                                      %b: !wave.ptr<#wave.global, f16>,
                                      %wg_m: index, %wg_n: index)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c32 = arith.constant 32 : i32
  %c254 = arith.constant 254 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %c254 step %c1 : i32 {
    %bounded_i = wave.assume %i as "x"
        [#wave.pred<"x >= 0">, #wave.pred<"-254 + x <= 0">] : i32
    %next = wave.binary addi %bounded_i, %c2 : i32, i32 -> i32
    %bounded_next = wave.assume %next as "x"
        [#wave.pred<"-2 + x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
    %scaled = wave.binary muli %bounded_next, %c32 : i32, i32 -> i32
    %orig = wave.assume %scaled as "x"
        [#wave.pred<"-32 + x >= 0">, #wave.pred<"-8160 + x <= 0">] : i32
    %aoff = wave.index_expr <"2*orig + 4194304*wg_m + 64*Mod(wi, 16)">
        ["wi", "wg_m", "orig"](%wi, %wg_m, %orig)
        : (!wave.simd<i32, 32>, index, i32) -> !wave.simd<index, 32>
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %boff = wave.index_expr <"2*orig + 4194304*wg_n + 64*Mod(wi, 16)">
        ["wi", "wg_n", "orig"](%wi, %wg_n, %orig)
        : (!wave.simd<i32, 32>, index, i32) -> !wave.simd<index, 32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %av, %at = wave.load %ap
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %av -> %bp
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    wave.store %bv -> %ap
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @reject_unbounded_binary_binding
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK: wave.binary addi
// CHECK: wave.index_expr <"128*x + 64*Mod(wi, 16)"> ["x", "wi"]{{.*}} -> !wave.simd<index, 32>
func.func @reject_unbounded_binary_binding(%a: !wave.ptr<#wave.global, f16>,
                                           %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %next = wave.binary addi %i, %c2 : i32, i32 -> i32
    %off = wave.index_expr <"128*x + 64*Mod(wi, 16)"> ["x", "wi"](%next, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @extract_shared_pointer_carry
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"8*Mod(wi, 64)"> ["wi"](%[[WI]]) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"8192"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: wave.load %[[PTR]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @extract_shared_pointer_carry(%lds: !wave.ptr<#wave.shared, i8>,
                                        %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"8192*i + 8*Mod(wi, 64)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %p = wave.ptr_add %lds, %off
        : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @extract_cyclic_offset_carry
// CHECK: %[[BASE_B:.*]] = wave.ptr_add %arg0, %{{.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
// CHECK: %[[INIT:.*]] = wave.index_expr <"16384"> []() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK-NOT: wave.index_expr <"8192*Mod
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK: wave.ptr_add %[[BASE_B]], %[[OFF]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(8192 + offset, 32768)"> ["offset"](%[[OFF]]) : (index) -> index
// CHECK: scf.yield %[[NEXT]]
func.func @extract_cyclic_offset_carry(%a: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c8 = arith.constant 8 : i32
  %c4096 = arith.constant 4096 : i32
  %b = wave.ptr_add %a, %c4096
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %next = wave.binary addi %i, %c2 : i32, i32 -> i32
    %off = wave.index_expr <"8192*Mod(i, 4)"> ["i"](%next)
        : (i32) -> index
    %ap = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @extract_cyclic_offset_with_invariant_base
// CHECK: %[[W:.*]] = wave.assume
// CHECK: %[[INIT:.*]] = wave.index_expr <"65536 + 1024*w"> {{.*}}["w"](%[[W]]) : (i32) -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK-NOT: wave.index_expr <"1024*w + 32768*Mod
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(32768 + offset, 131072)"> ["offset"](%[[OFF]]) : (index) -> index
// CHECK: scf.yield %[[NEXT]]
func.func @extract_cyclic_offset_with_invariant_base(
    %a: !wave.ptr<#wave.global, i32>, %wave_raw: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c8 = arith.constant 8 : i32
  %wave = wave.assume %wave_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 15">] : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %next = wave.binary addi %i, %c2 : i32, i32 -> i32
    %off = wave.index_expr <"1024*w + 32768*Mod(i, 4)">
        assuming [#wave.pred<"w >= 0">, #wave.pred<"w <= 15">]
        ["w", "i"](%wave, %next) : (i32, i32) -> index
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @reject_nonlinear
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK: wave.index_expr <"i**2 + 64*Mod(wi, 16)"> ["i", "wi"]{{.*}} -> !wave.simd<index, 32>
func.func @reject_nonlinear(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"i*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @nested_two_ivs
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%[[WI]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[OUTER_STRIDE:.*]] = wave.index_expr <"1024"> []() : () -> index
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OUTER_PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[INNER_STRIDE:.*]] = wave.index_expr <"128"> []() : () -> index
// CHECK: scf.for %[[J:.*]] = {{.*}} iter_args(%[[INNER_PTR:.*]] = %[[OUTER_PTR]])
// CHECK: wave.load %[[INNER_PTR]]
// CHECK: %[[INNER_NEXT:.*]] = wave.ptr_add %[[INNER_PTR]], %[[INNER_STRIDE]]
// CHECK: scf.yield %[[INNER_NEXT]]
// CHECK: %[[OUTER_NEXT:.*]] = wave.ptr_add %[[OUTER_PTR]], %[[OUTER_STRIDE]]
// CHECK: scf.yield %[[OUTER_NEXT]]
func.func @nested_two_ivs(%a: !wave.ptr<#wave.global, f16>, %n: i32,
                          %m: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c0 to %m step %c1 : i32 {
      %off = wave.index_expr <"1024*i + 128*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    }
  }
  return
}

// -----

// CHECK-LABEL: func.func @nested_cross_iv
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"64*Mod(wi, 16)">{{.*}} -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[OUTER_STRIDE:.*]] = wave.index_expr <"16"> []() : () -> index
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OUTER_PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[INNER_STRIDE:.*]] = wave.index_expr <"16*i"> ["i"](%[[I]]) : (i32) -> index
// CHECK: scf.for %[[J:.*]] = {{.*}} iter_args(%[[INNER_PTR:.*]] = %[[OUTER_PTR]])
// CHECK: %[[INNER_NEXT:.*]] = wave.ptr_add %[[INNER_PTR]], %[[INNER_STRIDE]]
// CHECK: scf.yield %[[INNER_NEXT]]
// CHECK: %[[OUTER_NEXT:.*]] = wave.ptr_add %[[OUTER_PTR]], %[[OUTER_STRIDE]]
// CHECK: scf.yield %[[OUTER_NEXT]]
func.func @nested_cross_iv(%a: !wave.ptr<#wave.global, f16>, %n: i32,
                           %m: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c1 to %m step %c1 : i32 {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    }
  }
  return
}

// -----

// CHECK-LABEL: func.func @simd_stride_scalar_base
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[ZERO:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: %[[ZERO_SIMD:.*]] = wave.splat %[[ZERO]] : index -> !wave.simd<index, 32>
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[ZERO_SIMD]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"16*wi"> ["wi"](%[[WI]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @simd_stride_scalar_base(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"16*i*wi"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}
