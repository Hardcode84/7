// RUN: wave-opt --split-input-file --wave-extract-loop-strides %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-extract-loop-strides --wave-extract-loop-strides %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-extract-loop-strides --wave-materialize-memory-variants %s | FileCheck %s --check-prefix=MEMORY

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

// CHECK-LABEL: func.func @preserve_cheaper_xor_base
// CHECK: %[[BASE:.*]] = wave.index_expr <"xor(32 + 4*b, 8*c, 16*a)">
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"128"> []() : () -> index
// CHECK: scf.for {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @preserve_cheaper_xor_base(
    %p: !wave.ptr<#wave.global, i8>, %a: !wave.simd<i32, 32>,
    %b: !wave.simd<i32, 32>, %c: !wave.simd<i32, 32>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + xor(16*a, xor(32 + 4*b, 8*c))">
        assuming [#wave.pred<"a >= 0 & -1 + a <= 0">,
                  #wave.pred<"b >= 0 & -1 + b <= 0">,
                  #wave.pred<"c >= 0 & -1 + c <= 0">]
        ["i", "a", "b", "c"](%i, %a, %b, %c)
        : (i32, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
           !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %address = wave.ptr_add %p, %off
        : !wave.ptr<#wave.global, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %value, %token = wave.load %address
        : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
        -> (!wave.simd<vector<4xi8>, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @accept_cheaper_base_fold
// CHECK: %[[BASE:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: %[[SPLAT:.*]] = wave.splat %[[BASE]]
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[SPLAT]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"128"> []() : () -> index
// CHECK: scf.for {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @accept_cheaper_base_fold(
    %p: !wave.ptr<#wave.global, i8>, %k: !wave.simd<i32, 32>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + Mod(k, 8)">
        assuming [#wave.pred<"Mod(k, 16) == 0">] ["i", "k"](%i, %k)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %address = wave.ptr_add %p, %off
        : !wave.ptr<#wave.global, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %value, %token = wave.load %address
        : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
        -> (!wave.simd<vector<4xi8>, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @preserve_factored_stride
// CHECK: %[[BASE:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %arg0, %[[BASE]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"x*(y + z)">
// CHECK-NOT: wave.index_expr <"x*y + x*z">
// CHECK: scf.for {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @preserve_factored_stride(
    %p: !wave.ptr<#wave.global, i8>, %x: i32, %y: i32, %z: i32,
    %n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"i*x*(y + z)"> ["i", "x", "y", "z"]
        (%i, %x, %y, %z) : (i32, i32, i32, i32) -> index
    %address = wave.ptr_add %p, %off
        : !wave.ptr<#wave.global, i8>, index -> !wave.ptr<#wave.global, i8>
    %value, %token = wave.load %address
        : (!wave.ptr<#wave.global, i8>)
        -> (!wave.simd<vector<4xi8>, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @reject_fractional_stride
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK: wave.index_expr <"1/2*i + 64*Mod(wi, 16)">
func.func @reject_fractional_stride(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"1/2*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
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

// CHECK-LABEL: func.func @reject_shared_symbolic_pointer_carry
// CHECK: %[[STRIDE:.*]] = wave.assume
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: scf.for %[[IV:[^ ]+]] =
// CHECK-NOT: iter_args
// CHECK: %[[OFF:.*]] = wave.index_expr <"i*s + 8*Mod(wi, 64)"> ["s", "i", "wi"](%[[STRIDE]], %[[IV]], %[[WI]])
// CHECK: wave.ptr_add %{{.*}}, %[[OFF]]
func.func @reject_shared_symbolic_pointer_carry(
    %lds: !wave.ptr<#wave.shared, i8>, %stride_raw: i32, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %stride = wave.assume %stride_raw as "s"
      [#wave.pred<"s >= 0">, #wave.pred<"s <= 16">] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"s*i + 8*Mod(wi, 64)"> ["s", "i", "wi"](%stride, %i, %wi)
        : (i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
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

// CHECK-LABEL: func.func @extract_proven_nonnegative_remainder_carry
// CHECK: %[[INIT:.*]] = wave.index_expr <"0"> {{.*}}[]() : () -> index
// CHECK: scf.for %[[IV:.*]] = {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK-NOT: wave.index_expr <"4*slot">
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(4 + offset, 16)"> ["offset"](%[[OFF]]) : (index) -> index
// CHECK: scf.yield %[[NEXT]]
func.func @extract_proven_nonnegative_remainder_carry(
    %a: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"i <= 7">] : i32
    %slot = wave.binary remsi %bounded, %c4 : i32, i32 -> i32
    %off = wave.index_expr <"4*slot"> ["slot"](%slot)
        : (i32) -> index
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
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

// -----

// CHECK-LABEL: func.func @address_contract_expands_unflagged_stride
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE_OFF:.*]] = wave.index_expr <"8 + 64*Mod(wi, 16)">
// CHECK: %[[BASE_PTR:.*]] = wave.ptr_add %{{.*}}, %[[BASE_OFF]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"4"> []() : () -> index
// CHECK: scf.for {{.*}} iter_args(%[[PTR:.*]] = %[[BASE_PTR]])
// CHECK: wave.load %[[PTR]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[PTR]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @address_contract_expands_unflagged_stride(
    %a: !wave.ptr<#wave.global, i8>, %n: i32)
    attributes {wave.address_arithmetic_no_overflow, wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c8 = arith.constant 8 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled = wave.binary muli %i, %c2 : i32, i32 -> i32
    %shifted = wave.binary shli %scaled, %c1 : i32, i32 -> i32
    %offset = wave.binary addi %shifted, %c8 : i32, i32 -> i32
    %off = wave.index_expr <"x + 64*Mod(wi, 16)"> ["x", "wi"]
        (%offset, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @unflagged_stride_without_contract_stays_in_loop
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK: wave.binary muli
// CHECK: wave.binary shli
// CHECK: wave.binary addi
// CHECK: wave.index_expr <"x + 64*Mod(wi, 16)">
func.func @unflagged_stride_without_contract_stays_in_loop(
    %a: !wave.ptr<#wave.global, i8>, %n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c8 = arith.constant 8 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled = wave.binary muli %i, %c2 : i32, i32 -> i32
    %shifted = wave.binary shli %scaled, %c1 : i32, i32 -> i32
    %offset = wave.binary addi %shifted, %c8 : i32, i32 -> i32
    %off = wave.index_expr <"x + 64*Mod(wi, 16)"> ["x", "wi"]
        (%offset, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @drop_dead_simd_offset_carries
// CHECK-SAME: %[[A:.*]]: !wave.ptr<#wave.global, i32>
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[INIT:.*]] = wave.binary addi %[[WI]],
// CHECK: %[[TOK:.*]] = wave.token
// CHECK: scf.for %[[IV:[^ ]+]] =
// CHECK-SAME: iter_args(%[[TOK_ARG:[^ ]+]] = %[[TOK]]) -> (!wave.mem.token)
// CHECK: %[[TRIP:.*]] = wave.binary subi %[[IV]],
// CHECK: %[[SCALED:.*]] = wave.binary muli {{.*}}, %[[TRIP]]
// CHECK: %[[OFF:.*]] = wave.binary addi %[[INIT]], %[[SCALED]]
// CHECK: %[[BOUNDED:.*]] = wave.assume %[[OFF]]
// CHECK: %[[PTR:.*]] = wave.ptr_add %[[A]], %[[BOUNDED]]
// CHECK: %{{.*}}, %[[LOAD_TOK:.*]] = wave.load %[[PTR]] after %[[TOK_ARG]]
// CHECK: scf.yield %[[LOAD_TOK]] : !wave.mem.token
func.func @drop_dead_simd_offset_carries(
    %a: !wave.ptr<#wave.global, i32>, %n: i32) attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c64 = arith.constant 64 : i32
  %c128 = arith.constant 128 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %s64 = wave.splat %c64 : i32 -> !wave.simd<i32, 32>
  %s128 = wave.splat %c128 : i32 -> !wave.simd<i32, 32>
  %init0 = wave.binary addi %wi, %s64 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %init1 = wave.binary addi %wi, %s128 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok0 = wave.token : !wave.mem.token
  %unused:3 = scf.for %i = %c1 to %n step %c1
      iter_args(%off0 = %init0, %off1 = %init1, %tok = %tok0)
      -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.mem.token) : i32 {
    %bounded = wave.assume %off0 as "x"
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">]
        : !wave.simd<i32, 32>
    %p = wave.ptr_add %a, %bounded
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %v, %t = wave.load %p after %tok
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %next0 = wave.binary addi %off0, %s64 overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %next1 = wave.binary addi %off1, %s64 overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next0, %next1, %t
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.mem.token
  }
  return
}

// -----

// Keep the original wrapping address tree as the first alternative. The
// carried offset is an exact second materialization of the same address.
// CHECK-LABEL: func.func @exact_cast_memory_offset_carry
// CHECK-SAME: %[[BUFFER:.*]]: !wave.ptr<#waveamd.buffer, i8>
// CHECK: %[[ITEM:.*]] = wave.assume
// CHECK: %[[BASE:.*]] = wave.index_expr <"Mod(256 + raw0, 4294967296)">
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// CHECK: %[[SCALED_INDEX:.*]] = wave.index_expr <"64*(4 + i)"> ["i"](%[[I]])
// CHECK: %[[SCALED:.*]] = wave.cast intconvert %[[SCALED_INDEX]] : index -> i32
// CHECK: %[[SPLAT:.*]] = wave.splat %[[SCALED]]
// CHECK: %[[SUM:.*]] = wave.binary addi %[[SPLAT]], %[[ITEM]]
// CHECK: %[[ORIGINAL:.*]] = wave.cast intconvert %[[SUM]] policy {extension = #wave.cast_extension<zero>}
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[ORIGINAL]], %[[OFFSET]]
// CHECK: wave.ptr_add %[[BUFFER]], %[[CHOICE]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(64 + offset, 4294967296)"> ["offset"](%[[OFFSET]])
// CHECK: scf.yield %[[NEXT]]
// MEMORY-LABEL: func.func @exact_cast_memory_offset_carry
// MEMORY: %[[ORIGINAL_OFFSET:.*]] = wave.cast intconvert %{{.*}} policy {extension = #wave.cast_extension<zero>}
// MEMORY: %[[ORIGINAL_PTR:.*]] = wave.ptr_add %{{.*}}, %[[ORIGINAL_OFFSET]]
// MEMORY: %[[CARRIED_PTR:.*]] = wave.ptr_add %{{.*}}, %{{.*}}
// MEMORY: %[[ORIGINAL_VALUE:.*]], %[[ORIGINAL_TOKEN:.*]] = wave.load %[[ORIGINAL_PTR]]
// MEMORY: %[[CARRIED_VALUE:.*]], %[[CARRIED_TOKEN:.*]] = wave.load %[[CARRIED_PTR]]
// MEMORY: %[[VALUE:.*]] = wave.materialization_variants %[[ORIGINAL_VALUE]], %[[CARRIED_VALUE]]
// MEMORY: %[[TOKEN:.*]] = wave.materialization_variants %[[ORIGINAL_TOKEN]], %[[CARRIED_TOKEN]]
// MEMORY: %[[ORIGINAL_STORE:.*]] = wave.store %[[VALUE]] -> %[[ORIGINAL_PTR]] after %[[TOKEN]]
// MEMORY: %[[CARRIED_STORE:.*]] = wave.store %[[VALUE]] -> %[[CARRIED_PTR]] after %[[TOKEN]]
// MEMORY: wave.materialization_variants %[[ORIGINAL_STORE]], %[[CARRIED_STORE]]
func.func @exact_cast_memory_offset_carry(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %item_raw = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item = wave.assume %item_raw as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"-31 + item <= 0">]
      : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, 32>
    %sum = wave.binary addi %scaled_lanes, %item
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %offset = wave.cast intconvert %sum
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, 32> -> !wave.simd<index, 32>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @exact_offset_with_local_base_and_assumed_iv
// CHECK: %[[ITEM:.*]] = wave.assume
// CHECK: %[[BASE:.*]] = wave.index_expr <"Mod(256 + {{raw[0-9]+}}, 4294967296)">
// CHECK: scf.for %[[I:.*]] = {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// CHECK: %[[BOUNDED:.*]] = wave.assume %[[I]]
// CHECK: %[[BUFFER:.*]] = waveamd.make_buffer
// CHECK: %[[SUM:.*]] = wave.binary addi
// CHECK: %[[ORIGINAL:.*]] = wave.cast intconvert %[[SUM]] policy
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[ORIGINAL]], %[[OFFSET]]
// CHECK: wave.ptr_add %[[BUFFER]], %[[CHOICE]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(64 + offset, 4294967296)">
// CHECK: scf.yield %[[NEXT]]
func.func @exact_offset_with_local_base_and_assumed_iv(
    %base: !wave.ptr<#wave.global, i8>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %item_raw = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item = wave.assume %item_raw as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"-31 + item <= 0">]
      : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"-2147483646 + i <= 0">] : i32
    %buffer = waveamd.make_buffer %base, %bounded
        : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%bounded)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, 32>
    %sum = wave.binary addi %scaled_lanes, %item
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %offset = wave.cast intconvert %sum
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, 32> -> !wave.simd<index, 32>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @buffer_modular_offset_carry
// CHECK-SAME: %[[BUFFER:.*]]: !wave.ptr<#waveamd.buffer, i8>
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE:.*]] = wave.index_expr <"Mod(wi, 4294967296)">
// CHECK: scf.for {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// CHECK: %[[REMAT:.*]] = wave.index_expr <"Mod(128*i + wi, 4294967296)">
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[REMAT]], %[[OFFSET]]
// CHECK: wave.ptr_add %[[BUFFER]], %[[CHOICE]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(256 + offset, 4294967296)"> ["offset"](%[[OFFSET]])
// CHECK: scf.yield %[[NEXT]]
func.func @buffer_modular_offset_carry(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c2 = arith.constant 2 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c2 : i32 {
    %off = wave.index_expr <"Mod(128*i + wi, 4294967296)"> ["i", "wi"]
        (%i, %wi) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %buffer, %off
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @buffer_modular_uniform_stride
// CHECK-SAME: %[[BUFFER:[^ ]+]]: !wave.ptr<#waveamd.buffer, i8>, %[[STRIDE:[^ ]+]]: i32
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE:.*]] = wave.index_expr <"Mod(wi, 4294967296)">
// CHECK: scf.for {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// CHECK: %[[SCALED:.*]] = wave.binary muli
// CHECK: %[[REMAT:.*]] = wave.index_expr <"Mod(wi + 128*x, 4294967296)">
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[REMAT]], %[[OFFSET]]
// CHECK: wave.ptr_add %[[BUFFER]], %[[CHOICE]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(offset + 128*x_1, 4294967296)"> ["offset", "x_1"](%[[OFFSET]], %[[STRIDE]])
// CHECK: scf.yield %[[NEXT]]
func.func @buffer_modular_uniform_stride(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %stride: i32, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
    %off = wave.index_expr <"Mod(128*x + wi, 4294967296)"> ["x", "wi"]
        (%scaled, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %buffer, %off
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
  }
  return
}

// -----

// Explicit modular semantics belong to the expression and do not depend on a
// pointer consumer.
// CHECK-LABEL: func.func @explicit_modular_offset_without_pointer_user
// CHECK-SAME: %[[STRIDE:[^ ]+]]: i32
// CHECK: %[[BASE:.*]] = wave.index_expr <"Mod(wi, 4294967296)">
// CHECK: scf.for {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// CHECK: %[[SCALED:.*]] = wave.binary muli
// CHECK: %[[REMAT:.*]] = wave.index_expr <"Mod(wi + 128*x, 4294967296)">
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[REMAT]], %[[OFFSET]]
// CHECK: wave.binary addi %[[CHOICE]], %[[CHOICE]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(offset + 128*x_1, 4294967296)"> ["offset", "x_1"](%[[OFFSET]], %[[STRIDE]])
// CHECK: scf.yield %[[NEXT]]
func.func @explicit_modular_offset_without_pointer_user(
    %stride: i32, %n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
    %off = wave.index_expr <"Mod(128*x + wi, 4294967296)"> ["x", "wi"]
        (%scaled, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %twice = wave.binary addi %off, %off
        : !wave.simd<index, 32>, !wave.simd<index, 32>
        -> !wave.simd<index, 32>
  }
  return
}

// -----

// Keep a buffer offset as an expression when the enclosing loop contains a
// nested loop. The nested induction must see the original pointer relationship.
// CHECK-LABEL: func.func @buffer_modular_offset_nested_loop
// CHECK: scf.for %[[I:[^ ]+]] =
// CHECK-NOT: iter_args
// CHECK: %[[SCALED:.*]] = wave.binary muli %[[I]],
// CHECK: %[[OFF:.*]] = wave.index_expr <"x + Mod(wi, 4294967296)"> ["wi", "x"]({{.*}}, %[[SCALED]])
// CHECK: %[[PTR:.*]] = wave.ptr_add {{.*}}, %[[OFF]]
// CHECK: scf.for {{.*}} iter_args({{.*}} = %[[PTR]])
func.func @buffer_modular_offset_nested_loop(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c128 = arith.constant 128 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled = wave.binary muli %i, %c128 : i32, i32 -> i32
    %off = wave.index_expr <"Mod(wi, 4294967296) + x"> ["wi", "x"]
        (%wi, %scaled) : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
    %p = wave.ptr_add %buffer, %off
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    %unused = scf.for %j = %c0 to %n step %c1
        iter_args(%nested = %p)
        -> (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>) : i32 {
      %value, %token = wave.load %nested
          : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>)
          -> (!wave.simd<i8, 32>, !wave.mem.token)
      scf.yield %nested : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
    }
  }
  return
}

// -----

// CHECK-LABEL: func.func @drop_only_offset_carry
// CHECK: scf.for %[[IV:[^ ]+]] =
// CHECK-NOT: iter_args
// CHECK: %[[SCALED:.*]] = wave.binary muli {{.*}}, %[[IV]]
// CHECK: %[[OFF:.*]] = wave.binary addi {{.*}}, %[[SCALED]]
// CHECK: %[[PTR:.*]] = wave.ptr_add %{{.*}}, %[[OFF]]
// CHECK: wave.load %[[PTR]]
// CHECK-NOT: scf.yield {{.*}} : i32
func.func @drop_only_offset_carry(
    %a: !wave.ptr<#wave.global, i32>, %n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c64 = arith.constant 64 : i32
  %unused = scf.for %i = %c0 to %n step %c1
      iter_args(%off = %c64) -> (i32) : i32 {
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %next = wave.binary addi %off, %c64 : i32, i32 -> i32
    scf.yield %next : i32
  }
  return
}

// -----

// CHECK-LABEL: func.func @extract_non_normalized_shared_pointer_carry
// CHECK: %[[WI:.*]] = wave.workitem_id 0
// CHECK: %[[BASE:.*]] = wave.index_expr <"32 + 8*Mod(wi, 64)"> ["wi"](%[[WI]])
// CHECK: %[[PTR:.*]] = wave.ptr_add %arg0, %[[BASE]]
// CHECK: %[[STRIDE:.*]] = wave.index_expr <"16"> []()
// CHECK: scf.for {{.*}} iter_args(%[[CARRY:.*]] = %[[PTR]])
// CHECK: wave.load %[[CARRY]]
// CHECK: %[[NEXT:.*]] = wave.ptr_add %[[CARRY]], %[[STRIDE]]
// CHECK: scf.yield %[[NEXT]]
func.func @extract_non_normalized_shared_pointer_carry(
    %lds: !wave.ptr<#wave.shared, i8>) attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %c12 = arith.constant 12 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  scf.for %i = %c4 to %c12 step %c2 : i32 {
    %off = wave.index_expr <"8*i + 8*Mod(wi, 64)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %ptr = wave.ptr_add %lds, %off
        : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value, %token = wave.load %ptr
        : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @signed_wrap_i16
// CHECK: scf.for {{.*}} iter_args(
// CHECK: wave.materialization_variants
// CHECK: return
func.func @signed_wrap_i16(%n: i16) attributes {wave.kernel} {
  %start = arith.constant -2 : i16
  %step = arith.constant 1 : i16
  %factor = arith.constant 32767 : i16
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %start to %n step %step : i16 {
    %scaled = wave.binary muli %i, %factor : i16, i16 -> i16
    %offset = wave.index_expr <"Mod(x + lane, 65536)"> ["x", "lane"](%scaled, %lane)
        : (i16, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @signed_wrap_shift
// CHECK: scf.for {{.*}} iter_args(
// CHECK: wave.materialization_variants
// CHECK: return
func.func @signed_wrap_shift(%n: i32) attributes {wave.kernel} {
  %start = arith.constant -2 : i32
  %step = arith.constant 1 : i32
  %factor = arith.constant 30 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %start to %n step %step : i32 {
    %scaled = wave.binary shli %i, %factor : i32, i32 -> i32
    %offset = wave.index_expr <"Mod(x + lane, 4294967296)"> ["x", "lane"](%scaled, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @wider_modulus_preserves_signed_wrap
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK-NOT: wave.materialization_variants
// CHECK: return
func.func @wider_modulus_preserves_signed_wrap(%n: i16) attributes {wave.kernel} {
  %start = arith.constant -2 : i16
  %step = arith.constant 1 : i16
  %factor = arith.constant 32767 : i16
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %start to %n step %step : i16 {
    %scaled = wave.binary muli %i, %factor : i16, i16 -> i16
    %offset = wave.index_expr <"Mod(x + lane, 4294967296)"> ["x", "lane"](%scaled, %lane)
        : (i16, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @non_power_of_two_modulus
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK-NOT: wave.materialization_variants
// CHECK: return
func.func @non_power_of_two_modulus(%n: i32) attributes {wave.kernel} {
  %start = arith.constant -2 : i32
  %step = arith.constant 1 : i32
  %factor = arith.constant 32767 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %start to %n step %step : i32 {
    %scaled = wave.binary muli %i, %factor : i32, i32 -> i32
    %offset = wave.index_expr <"Mod(x + lane, 65535)"> ["x", "lane"](%scaled, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @too_wide_modulus
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK-NOT: wave.materialization_variants
// CHECK: return
func.func @too_wide_modulus(%n: i32) attributes {wave.kernel} {
  %start = arith.constant -2 : i32
  %step = arith.constant 1 : i32
  %factor = arith.constant 32767 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %start to %n step %step : i32 {
    %scaled = wave.binary muli %i, %factor : i32, i32 -> i32
    %offset = wave.index_expr <"Mod(x + lane, 8589934592)"> ["x", "lane"](%scaled, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @lane_varying_modular_stride
// CHECK: scf.for
// CHECK-NOT: iter_args
// CHECK-NOT: wave.materialization_variants
// CHECK: return
func.func @lane_varying_modular_stride(%n: i32) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %zero to %n step %one : i32 {
    %offset = wave.index_expr <"Mod(i*lane, 4294967296)"> ["i", "lane"](%i, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %used = wave.binary addi %offset, %offset
        : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @negative_dividend_remainder_stays
// CHECK: scf.for
// CHECK: [[REM:%.*]] = wave.binary remsi
// CHECK: wave.index_expr <"4*slot"> ["slot"]([[REM]])

func.func @negative_dividend_remainder_stays(
    %a: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c0 = arith.constant -8 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c8 = arith.constant 0 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= -8">, #wave.pred<"i <= -1">] : i32
    %slot = wave.binary remsi %bounded, %c4 : i32, i32 -> i32
    %off = wave.index_expr <"4*slot"> ["slot"](%slot)
        : (i32) -> index
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}


// -----

// CHECK-LABEL: func.func @negative_divisor_remainder_stays
// CHECK: scf.for
// CHECK: [[REM:%.*]] = wave.binary remsi
// CHECK: wave.index_expr <"4*slot"> ["slot"]([[REM]])

func.func @negative_divisor_remainder_stays(
    %a: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %bounded = wave.assume %i as "i"
        [#wave.pred<"i >= 0">, #wave.pred<"i <= 7">] : i32
    %negative = arith.constant -4 : i32
    %slot = wave.binary remsi %bounded, %negative : i32, i32 -> i32
    %off = wave.index_expr <"4*slot"> ["slot"](%slot)
        : (i32) -> index
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}
