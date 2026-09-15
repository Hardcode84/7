// REQUIRES: wave-python-bindings
//
// RUN: env PYTHONWARNINGS=ignore %python %S/../../examples/wave/tensilelite_mxfp4_subtile.py \
// RUN:   --chip=gfx950 --m=256 --n=256 --k=512 --bm=2 --bn=2 \
// RUN:   --wave-m-tiles=8 --wave-n-tiles=8 --wave-k-tiles=2 \
// RUN:   --target-waves=1 --scale-input=canonical | FileCheck %s

// CHECK: [[A_DATA:%.*]] = wave.alloc() {align = 16 : i64, bytesize = 65536 : i64} : !wave.ptr<#wave.shared, i32>
// CHECK-NEXT: [[B_DATA:%.*]] = wave.alloc() {align = 16 : i64, bytesize = 65536 : i64} : !wave.ptr<#wave.shared, i32>
// CHECK-NEXT: [[A_LDS:%.*]] = wave.alloc() {align = 16 : i64, bytesize = 4096 : i64} : !wave.ptr<#wave.shared, i8>
// CHECK-NEXT: [[B_LDS:%.*]] = wave.alloc() {align = 16 : i64, bytesize = 4096 : i64} : !wave.ptr<#wave.shared, i8>
// CHECK: [[A_OFF:%.*]] = wave.index_expr <"1024*floor(1/128*wi) + 2048*Mod(step, 2) + 4*Mod(wi, 64)">
// CHECK: wave.ptr_add [[A_LDS]], [[A_OFF]]
// CHECK: [[B_OFF:%.*]] = wave.index_expr <"2048*Mod(step, 2) + 4*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)">
// CHECK: wave.ptr_add [[B_LDS]], [[B_OFF]]
