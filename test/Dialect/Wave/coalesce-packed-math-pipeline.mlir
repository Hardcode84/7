// RUN: wave-opt %s --split-input-file \
// RUN:   --wave-combine-pointer-offsets \
// RUN:   --wave-simplify-index-exprs \
// RUN:   --wave-coalesce-memory \
// RUN:   --canonicalize \
// RUN:   --cse \
// RUN:   --wave-form-packed-math \
// RUN:   --canonicalize \
// RUN:   --cse \
// RUN:   | FileCheck %s

module {

// CHECK-LABEL: func.func @coalesce_feeds_packed_cast
// CHECK-SAME: ([[SRC:%.*]]: !wave.ptr<#wave.global, f32>, [[DST:%.*]]: !wave.ptr<#wave.global, f16>)
// CHECK: [[LOAD:%.*]], [[TOK:%.*]] = wave.load [[SRC]]
// CHECK-SAME: -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
// CHECK: [[CAST:%.*]] = wave.cast fpconvert [[LOAD]] policy {rounding = #wave.cast_rounding<rtz>}
// CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
// CHECK: wave.store [[CAST]] -> [[DST]] after [[TOK]]
// CHECK-SAME: (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>, !wave.mem.token)
// CHECK-NEXT: return
func.func @coalesce_feeds_packed_cast(%src: !wave.ptr<#wave.global, f32>,
                                      %dst: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %src1 = wave.ptr_add %src, %c1
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#wave.global, f32>
  %v0, %t0 = wave.load %src
      : (!wave.ptr<#wave.global, f32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %src1 after %t0
      : (!wave.ptr<#wave.global, f32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %h0 = wave.cast fpconvert %v0 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %h1 = wave.cast fpconvert %v1 policy {rounding = #wave.cast_rounding<rtz>}
      : !wave.simd<f32, 32> -> !wave.simd<f16, 32>
  %dst1 = wave.ptr_add %dst, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %s0 = wave.store %h0 -> %dst after %t1
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> !wave.mem.token
  %s1 = wave.store %h1 -> %dst1 after %s0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
