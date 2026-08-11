// RUN: wave-opt --split-input-file --wave-extract-loop-strides %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-extract-loop-strides --wave-extract-loop-strides %s | FileCheck %s

// CHECK-LABEL: func.func @group_two_cyclic_offsets(
// CHECK: %[[INIT:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: scf.for {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK: %[[PEER:.*]] = wave.index_expr <"8192 + offset"> ["offset"](%[[OFF]])
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK: wave.ptr_add %arg1, %[[PEER]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(32768 + offset, 131072)"> ["offset"](%[[OFF]])
// CHECK: scf.yield %[[NEXT]]
func.func @group_two_cyclic_offsets(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"32768*Mod(i, 4)"> ["i"](%i) : (i32) -> index
    %boff = wave.index_expr <"8192 + 32768*Mod(i, 4)"> ["i"](%i)
        : (i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @group_fact_equivalent_bases(
// CHECK: %[[INIT:.*]] = wave.index_expr <"xor(32 + 4*b, 8*c, 16*a)">
// CHECK: scf.for {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK: %[[PEER:.*]] = wave.index_expr <"8192 + offset"> ["offset"](%[[OFF]])
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK: wave.ptr_add %arg1, %[[PEER]]
func.func @group_fact_equivalent_bases(
    %p: !wave.ptr<#wave.global, i32>, %q: !wave.ptr<#wave.global, i32>,
    %a: i32, %b: i32, %c: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"8192*Mod(i, 4) + xor(16*a, xor(32 + 4*b, 8*c))">
        assuming [#wave.pred<"a >= 0 & -1 + a <= 0">,
                  #wave.pred<"b >= 0 & -1 + b <= 0">,
                  #wave.pred<"c >= 0 & -1 + c <= 0">]
        ["i", "a", "b", "c"](%i, %a, %b, %c)
        : (i32, i32, i32, i32) -> index
    %boff = wave.index_expr <"8224 + 8192*Mod(i, 4) + 16*a + 4*b + 8*c">
        assuming [#wave.pred<"a >= 0 & -1 + a <= 0">,
                  #wave.pred<"b >= 0 & -1 + b <= 0">,
                  #wave.pred<"c >= 0 & -1 + c <= 0">]
        ["i", "a", "b", "c"](%i, %a, %b, %c)
        : (i32, i32, i32, i32) -> index
    %ap = wave.ptr_add %p, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %q, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @group_three_cyclic_offsets_with_negative_rebase(
// CHECK: %[[INIT:.*]] = wave.index_expr <"0"> []() : () -> index
// CHECK: scf.for {{.*}} iter_args(%[[OFF:.*]] = %[[INIT]])
// CHECK: %[[AOFF:.*]] = wave.index_expr <"8192 + offset"> ["offset"](%[[OFF]])
// CHECK: %[[BOFF:.*]] = wave.index_expr <"16384 + offset"> ["offset"](%[[OFF]])
// CHECK: wave.ptr_add %arg0, %[[AOFF]]
// CHECK: wave.ptr_add %arg1, %[[BOFF]]
// CHECK: wave.ptr_add %arg2, %[[OFF]]
// CHECK: %[[NEXT:.*]] = wave.index_expr <"Mod(32768 + offset, 131072)"> ["offset"](%[[OFF]])
// CHECK: scf.yield %[[NEXT]]
func.func @group_three_cyclic_offsets_with_negative_rebase(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>,
    %c: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"8192 + 32768*Mod(i, 4)"> ["i"](%i)
        : (i32) -> index
    %boff = wave.index_expr <"16384 + 32768*Mod(i, 4)"> ["i"](%i)
        : (i32) -> index
    %coff = wave.index_expr <"32768*Mod(i, 4)"> ["i"](%i) : (i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %cp = wave.ptr_add %c, %coff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %cv, %ct = wave.load %cp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @rebase_compatible_span_subset(
// CHECK: %[[GROUP_INIT:.*]] = wave.index_expr <"16384 + b">
// CHECK: %[[REJECTED_INIT:.*]] = wave.index_expr <"b">
// CHECK: scf.for {{.*}} iter_args(%[[GROUP:.*]] = %[[GROUP_INIT]], %[[REJECTED:.*]] = %[[REJECTED_INIT]])
// CHECK: %[[FAR:.*]] = wave.index_expr <"20480 + offset"> ["offset"](%[[GROUP]])
// CHECK: %[[NEAR:.*]] = wave.index_expr <"4096 + offset"> ["offset"](%[[GROUP]])
// CHECK: wave.ptr_add %arg0, %[[GROUP]]
// CHECK: wave.ptr_add %arg1, %[[FAR]]
// CHECK: wave.ptr_add %arg2, %[[REJECTED]]
// CHECK: wave.ptr_add %arg3, %[[NEAR]]
func.func @rebase_compatible_span_subset(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>,
    %c: !wave.ptr<#wave.global, i32>, %d: !wave.ptr<#wave.global, i32>,
    %bias: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"16384 + b + 8192*Mod(i, 4)">
        assuming [#wave.pred<"b >= -16384">, #wave.pred<"b <= -8193">]
        ["b", "i"](%bias, %i) : (i32, i32) -> index
    %boff = wave.index_expr <"36864 + b + 8192*Mod(i, 4)">
        assuming [#wave.pred<"b >= -36864">, #wave.pred<"b <= -28673">]
        ["b", "i"](%bias, %i) : (i32, i32) -> index
    %coff = wave.index_expr <"b + 8192*Mod(i, 4)">
        assuming [#wave.pred<"b >= 0">, #wave.pred<"b <= 8191">]
        ["b", "i"](%bias, %i) : (i32, i32) -> index
    %doff = wave.index_expr <"20480 + b + 8192*Mod(i, 4)">
        assuming [#wave.pred<"b >= -20480">, #wave.pred<"b <= -12289">]
        ["b", "i"](%bias, %i) : (i32, i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %cp = wave.ptr_add %c, %coff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %dp = wave.ptr_add %d, %doff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %cv, %ct = wave.load %cp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %dv, %dt = wave.load %dp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @keep_mismatched_rings_independent(
// CHECK: scf.for {{.*}} iter_args(%[[SHORT:.*]] = {{.*}}, %[[LONG:.*]] = {{.*}})
// CHECK: wave.ptr_add %arg0, %[[SHORT]]
// CHECK: wave.ptr_add %arg1, %[[LONG]]
// CHECK: wave.index_expr <"Mod(8192 + offset, 32768)"> ["offset"](%[[SHORT]])
// CHECK: wave.index_expr <"Mod(8192 + offset, 65536)"> ["offset"](%[[LONG]])
func.func @keep_mismatched_rings_independent(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"8192*Mod(i, 4)"> ["i"](%i) : (i32) -> index
    %boff = wave.index_expr <"8192*Mod(i, 8)"> ["i"](%i) : (i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}

// -----

// CHECK-LABEL: func.func @keep_mismatched_bindings_independent(
// CHECK: %[[WA:.*]] = wave.assume %arg2 as "w"
// CHECK: %[[WB:.*]] = wave.assume %arg3 as "w"
// CHECK: %[[AINIT:.*]] = wave.index_expr <"1024*w"> {{.*}}(%[[WA]])
// CHECK: %[[BINIT:.*]] = wave.index_expr <"1024*w"> {{.*}}(%[[WB]])
// CHECK: scf.for {{.*}} iter_args(%[[AOFF:.*]] = %[[AINIT]], %[[BOFF:.*]] = %[[BINIT]])
// CHECK: wave.ptr_add %arg0, %[[AOFF]]
// CHECK: wave.ptr_add %arg1, %[[BOFF]]
func.func @keep_mismatched_bindings_independent(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>,
    %wa_raw: i32, %wb_raw: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  %wa = wave.assume %wa_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 7">] : i32
  %wb = wave.assume %wb_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 7">] : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"1024*w + 8192*Mod(i, 4)">
        assuming [#wave.pred<"w >= 0">, #wave.pred<"w <= 7">]
        ["w", "i"](%wa, %i) : (i32, i32) -> index
    %boff = wave.index_expr <"1024*w + 8192*Mod(i, 4)">
        assuming [#wave.pred<"w >= 0">, #wave.pred<"w <= 7">]
        ["w", "i"](%wb, %i) : (i32, i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  }
  return
}
