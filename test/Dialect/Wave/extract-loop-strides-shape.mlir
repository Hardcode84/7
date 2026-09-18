// RUN: sed 's/@W@/32/g' %s | wave-opt --wave-extract-loop-strides -o %t.32
// RUN: FileCheck %s < %t.32
// RUN: wave-opt --wave-extract-loop-strides %t.32 -o %t.32.twice
// RUN: diff %t.32 %t.32.twice
// RUN: sed 's/@W@/64/g' %s | wave-opt --wave-extract-loop-strides -o %t.64
// RUN: FileCheck %s < %t.64
// RUN: wave-opt --wave-extract-loop-strides %t.64 -o %t.64.twice
// RUN: diff %t.64 %t.64.twice

// CHECK-LABEL: func.func @uniform_constant
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: [[INIT:%.*]] = wave.splat [[BASE]] : index -> !wave.simd<index, {{32|64}}>
// CHECK: scf.for {{%.*}} = {{.*}} iter_args([[CARRY:%.*]] = [[INIT]]) -> (!wave.simd<index, {{32|64}}>)
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[NEXT:%.*]] = wave.index_expr <"Mod({{.*}}, 4294967296)">
// CHECK: scf.yield [[NEXT]] : !wave.simd<index, {{32|64}}>
func.func @uniform_constant(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32, %lower: i32, %step: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 3 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %scaled_lanes
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>)
        -> (!wave.simd<i8, @W@>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}

// CHECK-LABEL: func.func @uniform_dynamic
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: [[INIT:%.*]] = wave.splat [[BASE]] : index -> !wave.simd<index, {{32|64}}>
// CHECK: scf.for {{%.*}} = {{.*}} iter_args([[CARRY:%.*]] = [[INIT]]) -> (!wave.simd<index, {{32|64}}>)
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[NEXT:%.*]] = wave.index_expr <"Mod({{.*}}, 4294967296)">
// CHECK: scf.yield [[NEXT]] : !wave.simd<index, {{32|64}}>
func.func @uniform_dynamic(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32, %lower: i32, %step: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  scf.for %i = %lower to %n step %step : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %scaled_lanes
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>)
        -> (!wave.simd<i8, @W@>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}

// CHECK-LABEL: func.func @varying_constant
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: scf.for {{%.*}} = {{.*}} iter_args([[CARRY:%.*]] = [[BASE]]) -> (!wave.simd<index, {{32|64}}>)
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[NEXT:%.*]] = wave.index_expr <"Mod({{.*}}, 4294967296)">
// CHECK: scf.yield [[NEXT]] : !wave.simd<index, {{32|64}}>
func.func @varying_constant(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32, %lower: i32, %step: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 3 : i32
  %c1 = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %sum = wave.binary addi %scaled_lanes, %lane : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %sum
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>)
        -> (!wave.simd<i8, @W@>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}

// CHECK-LABEL: func.func @varying_dynamic
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: scf.for {{%.*}} = {{.*}} iter_args([[CARRY:%.*]] = [[BASE]]) -> (!wave.simd<index, {{32|64}}>)
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[CARRY]]
// CHECK: wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[NEXT:%.*]] = wave.index_expr <"Mod({{.*}}, 4294967296)">
// CHECK: scf.yield [[NEXT]] : !wave.simd<index, {{32|64}}>
func.func @varying_dynamic(
    %buffer: !wave.ptr<#waveamd.buffer, i8>, %n: i32, %lower: i32, %step: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  scf.for %i = %lower to %n step %step : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i)
        : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %scaled_lanes = wave.splat %scaled : i32 -> !wave.simd<i32, @W@>
    %sum = wave.binary addi %scaled_lanes, %lane : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
    %offset = wave.cast intconvert %sum
        policy {extension = #wave.cast_extension<zero>}
        : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
    %p = wave.ptr_add %buffer, %offset
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>)
        -> (!wave.simd<i8, @W@>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}

// CHECK-LABEL: func.func @scalar_i64
// CHECK: [[BASE:%.*]] = wave.index_expr
// CHECK: [[INIT:%.*]] = wave.cast intconvert [[BASE]] : index -> i64
// CHECK: scf.for {{%.*}} = {{.*}} iter_args([[CARRY:%.*]] = [[INIT]]) -> (i64)
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{%.*}} policy
// CHECK: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[CARRY]] : i64
// CHECK: wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[NEXT:%.*]] = wave.index_expr <"Mod({{.*}}, 4294967296)">
// CHECK: [[TYPED:%.*]] = wave.cast intconvert [[NEXT]] : index -> i64
// CHECK: scf.yield [[TYPED]] : i64
func.func @scalar_i64(%buffer: !wave.ptr<#wave.global, i8>,
                       %lower: i32, %upper: i32, %step: i32) {
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  scf.for %i = %lower to %upper step %step : i32 {
    %scaled_index = wave.index_expr <"64*(4 + i)"> ["i"](%i) : (i32) -> index
    %scaled = wave.cast intconvert %scaled_index : index -> i32
    %offset = wave.cast intconvert %scaled policy {extension = #wave.cast_extension<zero>} : i32 -> i64
    %scalar = wave.ptr_add %buffer, %offset : !wave.ptr<#wave.global, i8>, i64 -> !wave.ptr<#wave.global, i8>
    %ptr = wave.ptr_add %scalar, %lane : !wave.ptr<#wave.global, i8>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#wave.global, i8>, @W@>
    %value, %token = wave.load %ptr : (!wave.simd<!wave.ptr<#wave.global, i8>, @W@>) -> (!wave.simd<i8, @W@>, !wave.mem.token)
  }
  return
}
