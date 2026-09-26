// RUN: wave-opt --wave-generate-index-exprs --wave-combine-pointer-offsets \
// RUN:   --wave-generate-index-exprs %s | FileCheck %s --check-prefix=INDEX
// RUN: wave-opt --wave-set-target-attr=chip=gfx950 \
// RUN:   --wave-generate-index-exprs --wave-combine-pointer-offsets \
// RUN:   --wave-generate-index-exprs --wave-expand-integer-div-rem \
// RUN:   --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

// INDEX-LABEL: func.func @typed_shared_slot
// INDEX: [[QUOT:%.*]] = wave.binary divsi
// INDEX: [[SLOT:%.*]] = wave.binary remsi [[QUOT]],
// INDEX: [[OFFSET:%.*]] = wave.index_expr <"8320*slot"> {{.*}}["slot"]([[SLOT]])
// INDEX: [[OFFSETS:%.*]] = wave.splat [[OFFSET]]
// INDEX: wave.ptr_add {{.*}}, [[OFFSETS]]
// MACHINE-LABEL: func.func @typed_shared_slot
// MACHINE-NOT: waveamdmachine.s_mul_u64
// MACHINE: waveamdmachine.s_mul_i32
// MACHINE-NOT: waveamdmachine.s_mul_u64
// MACHINE: waveamdmachine.ds_store_b32
func.func @typed_shared_slot(%base: !wave.ptr<#wave.shared, i32>, %raw: i32)
    -> !wave.mem.token attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %c64 = arith.constant 64 : i32
  %c2 = arith.constant 2 : i32
  %bounded = wave.assume %raw as "raw"
      [#wave.pred<"raw >= 0">, #wave.pred<"raw <= 8191">] : i32
  %q = wave.binary divsi %bounded, %c64 : i32, i32 -> i32
  %slot = wave.binary remsi %q, %c2 : i32, i32 -> i32
  %offset = wave.index_expr <"8320*slot"> assuming
      [#wave.pred<"slot >= 0">, #wave.pred<"slot <= 1">]
      ["slot"](%slot) : (i32) -> index
  %offsets = wave.splat %offset : index -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %base, %offsets
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %value = wave.constant 1 : i32
  %values = wave.splat %value : i32 -> !wave.simd<i32, 64>
  %token = wave.store %values -> %ptr
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.shared, i32>, 64>)
      -> !wave.mem.token
  return %token : !wave.mem.token
}

// INDEX-LABEL: func.func @typed_global_slot
// INDEX: [[QUOT:%.*]] = wave.binary divui
// INDEX: [[SLOT:%.*]] = wave.binary remui [[QUOT]],
// INDEX: [[OFFSET:%.*]] = wave.index_expr <"3072*slot"> {{.*}}["slot"]([[SLOT]])
// INDEX: [[OFFSETS:%.*]] = wave.splat [[OFFSET]]
// INDEX: wave.ptr_add {{.*}}, [[OFFSETS]]
// MACHINE-LABEL: func.func @typed_global_slot
// MACHINE-NOT: waveamdmachine.s_mul_u64
// MACHINE: waveamdmachine.s_mul_i32
// MACHINE-NOT: waveamdmachine.s_mul_u64
// MACHINE: waveamdmachine.global_store_b32
func.func @typed_global_slot(%base: !wave.ptr<#wave.global, i32>, %raw: i32)
    -> !wave.mem.token attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %c32 = arith.constant 32 : i32
  %c4 = arith.constant 4 : i32
  %q = wave.binary divui %raw, %c32 : i32, i32 -> i32
  %slot = wave.binary remui %q, %c4 : i32, i32 -> i32
  %offset = wave.index_expr <"3072*slot"> assuming
      [#wave.pred<"slot >= 0">, #wave.pred<"slot <= 3">]
      ["slot"](%slot) : (i32) -> index
  %offsets = wave.splat %offset : index -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %base, %offsets
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %value = wave.constant 1 : i32
  %values = wave.splat %value : i32 -> !wave.simd<i32, 64>
  %token = wave.store %values -> %ptr
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  return %token : !wave.mem.token
}
