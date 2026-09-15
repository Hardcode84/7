// RUN: wave-opt --wave-expand-integer-div-rem --canonicalize --cse %s \
// RUN:   | FileCheck %s --check-prefix=IR \
// RUN:       --implicit-check-not="wave.cmpi slt" --implicit-check-not="arith.cmpi slt"
// RUN: wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj %t.s -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// IR-LABEL: func.func @positive_divisor_scalar
// IR: [[SIGN:%.*]] = wave.binary shrsi
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// IR: wave.urecip
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// ASM-LABEL: positive_divisor_scalar:
// ASM: s_ashr_i32
// ASM: s_xor_b32
// ASM: s_sub_i32
// ASM: v_rcp_iflag_f32
// ASM-NOT: s_cmp_lt_i32
// ASM: .amdhsa_kernel positive_divisor_scalar
func.func @positive_divisor_scalar(%out: !wave.ptr<#wave.global, i32>,
    %x: i32, %d: i32) -> !wave.mem.token attributes {wave.kernel} {
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %q = wave.binary divsi %x, %pos : i32, i32 -> i32
  %r = wave.binary remsi %x, %pos : i32, i32 -> i32
  %vq = wave.splat %q : i32 -> !wave.simd<i32, 32>
  %vr = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %two = arith.constant 2 : i32
  %one = arith.constant 1 : i32
  %even = wave.binary muli %lane, %two : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %odd = wave.binary addi %even, %one : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %qp = wave.ptr_add %out, %even
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %rp = wave.ptr_add %out, %odd
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %qt = wave.store %vq -> %qp
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %rt = wave.store %vr -> %rp after %qt
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %rt : !wave.mem.token
}

// IR-LABEL: func.func @positive_divisor_narrow
// IR: [[SIGN:%.*]] = wave.binary shrsi
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// IR: wave.urecip
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// ASM-LABEL: positive_divisor_narrow:
// ASM: s_ashr_i32
// ASM: s_xor_b32
// ASM: s_sub_i32
// ASM: v_rcp_iflag_f32
// ASM-NOT: s_cmp_lt_i32
// ASM: .amdhsa_kernel positive_divisor_narrow
func.func @positive_divisor_narrow(%out: !wave.ptr<#wave.global, i32>,
    %x: i64, %d: i64) -> !wave.mem.token attributes {wave.kernel} {
  %bx = wave.assume %x as "x"
      [#wave.pred<"x >= -2147483648">, #wave.pred<"x <= 2147483647">] : i64
  %pos = wave.assume %d as "d"
      [#wave.pred<"d >= 1">, #wave.pred<"d <= 2147483647">] : i64
  %q = wave.binary divsi %bx, %pos : i64, i64 -> i64
  %r = wave.binary remsi %bx, %pos : i64, i64 -> i64
  %qn = wave.cast intconvert %q : i64 -> i32
  %rn = wave.cast intconvert %r : i64 -> i32
  %vq = wave.splat %qn : i32 -> !wave.simd<i32, 32>
  %vr = wave.splat %rn : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %two = arith.constant 2 : i32
  %one = arith.constant 1 : i32
  %even = wave.binary muli %lane, %two : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %odd = wave.binary addi %even, %one : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %qp = wave.ptr_add %out, %even
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %rp = wave.ptr_add %out, %odd
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %qt = wave.store %vq -> %qp
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %rt = wave.store %vr -> %rp after %qt
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %rt : !wave.mem.token
}

// IR-LABEL: func.func @positive_divisor_simd
// IR: [[SIGN:%.*]] = wave.binary shrsi
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// IR: wave.urecip
// IR: wave.binary xori {{.*}}, [[SIGN]]
// IR: wave.binary subi {{.*}}, [[SIGN]]
// ASM-LABEL: positive_divisor_simd:
// ASM: v_ashrrev_i32
// ASM: v_xor_b32
// ASM: v_sub_nc_u32
// ASM: v_rcp_iflag_f32
// ASM-NOT: v_cmp_lt_i32
// ASM: .amdhsa_kernel positive_divisor_simd
func.func @positive_divisor_simd(%src: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %d: i32) -> !wave.mem.token attributes {wave.kernel} {
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %vp = wave.splat %pos : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %x, %read = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %q = wave.binary divsi %x, %vp
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r = wave.binary remsi %x, %vp
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %two = arith.constant 2 : i32
  %one = arith.constant 1 : i32
  %even = wave.binary muli %lane, %two : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %odd = wave.binary addi %even, %one : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %qp = wave.ptr_add %out, %even
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %rp = wave.ptr_add %out, %odd
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %qt = wave.store %q -> %qp after %read
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  %rt = wave.store %r -> %rp after %qt
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return %rt : !wave.mem.token
}
}
