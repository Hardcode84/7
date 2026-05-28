// RUN: wave-opt %s --canonicalize | FileCheck %s

// CHECK-LABEL: func.func @extract_pack_f16
// CHECK-SAME: (%[[A:.*]]: f16, %[[B:.*]]: f16)
// CHECK-NOT: wave.pack
// CHECK-NOT: wave.extract
// CHECK: return %[[A]], %[[B]] : f16, f16
func.func @extract_pack_f16(%a: f16, %b: f16) -> (f16, f16) {
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  %x = wave.extract %p[0] : vector<2xf16> -> f16
  %y = wave.extract %p[1] : vector<2xf16> -> f16
  return %x, %y : f16, f16
}

// CHECK-LABEL: func.func @extract_pack_i16
// CHECK-SAME: (%[[A:.*]]: !wave.simd<i16, 32>, %[[B:.*]]: !wave.simd<i16, 32>)
// CHECK-NOT: wave.pack
// CHECK-NOT: wave.extract
// CHECK: return %[[B]], %[[A]] : !wave.simd<i16, 32>, !wave.simd<i16, 32>
func.func @extract_pack_i16(%a: !wave.simd<i16, 32>,
                            %b: !wave.simd<i16, 32>)
    -> (!wave.simd<i16, 32>, !wave.simd<i16, 32>) {
  %p = wave.pack %a, %b : !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.simd<vector<2xi16>, 32>
  %x = wave.extract %p[1] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %y = wave.extract %p[0] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  return %x, %y : !wave.simd<i16, 32>, !wave.simd<i16, 32>
}

// CHECK-LABEL: func.func @pack_extract_rebuild_f16
// CHECK-SAME: (%[[V:.*]]: vector<2xf16>)
// CHECK-NOT: wave.extract
// CHECK-NOT: wave.pack
// CHECK: return %[[V]] : vector<2xf16>
func.func @pack_extract_rebuild_f16(%v: vector<2xf16>) -> vector<2xf16> {
  %a = wave.extract %v[0] : vector<2xf16> -> f16
  %b = wave.extract %v[1] : vector<2xf16> -> f16
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  return %p : vector<2xf16>
}

// CHECK-LABEL: func.func @pack_extract_rebuild_i16
// CHECK-SAME: (%[[V:.*]]: !wave.simd<vector<2xi16>, 32>)
// CHECK-NOT: wave.extract
// CHECK-NOT: wave.pack
// CHECK: return %[[V]] : !wave.simd<vector<2xi16>, 32>
func.func @pack_extract_rebuild_i16(%v: !wave.simd<vector<2xi16>, 32>)
    -> !wave.simd<vector<2xi16>, 32> {
  %a = wave.extract %v[0] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %b = wave.extract %v[1] : !wave.simd<vector<2xi16>, 32> -> !wave.simd<i16, 32>
  %p = wave.pack %a, %b : !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.simd<vector<2xi16>, 32>
  return %p : !wave.simd<vector<2xi16>, 32>
}

// CHECK-LABEL: func.func @pack_extract_swapped_stays
// CHECK: wave.extract
// CHECK: wave.extract
// CHECK: wave.pack
func.func @pack_extract_swapped_stays(%v: vector<2xf16>) -> vector<2xf16> {
  %a = wave.extract %v[1] : vector<2xf16> -> f16
  %b = wave.extract %v[0] : vector<2xf16> -> f16
  %p = wave.pack %a, %b : f16, f16 -> vector<2xf16>
  return %p : vector<2xf16>
}
