// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: scalar_integer_arith_codegen:
// ASM: s_xor_b32
// ASM: s_lshr_b32
// ASM: s_and_b32
// ASM: s_cmp_lt_i32
// ASM: s_cselect_b32
// ASM: s_add_i32
// ASM: s_cmp_lg_u32
// ASM: s_cselect_b32
// ASM: global_store_b32
func.func @scalar_integer_arith_codegen(%out: !wave.ptr<#wave.global, i32>,
                                        %x: i32, %y: i32)
    attributes {wave.kernel} {
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %diff = wave.binary subi %x, %y : i32, i32 -> i32
  %half = wave.binary divui %diff, %two : i32, i32 -> i32
  %tail = wave.binary remui %diff, %four : i32, i32 -> i32
  %cond = arith.cmpi slt, %half, %tail : i32
  %clobber = wave.binary addi %half, %tail : i32, i32 -> i32
  %pick = wave.select %cond, %clobber, %tail : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v = wave.splat %pick : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

// ASM-LABEL: scalar_i64_div_rem_codegen:
// ASM: s_lshr_b64
// ASM: s_and_b32
// ASM: v_cmp
// ASM: s_or_b32
// ASM: global_store_b32
func.func @scalar_i64_div_rem_codegen(%out: !wave.ptr<#wave.global, i32>,
                                      %wide: i64)
    attributes {wave.kernel} {
  %two64 = arith.constant 2 : i64
  %eight64 = arith.constant 8 : i64
  %wide_half = wave.binary divui %wide, %two64 : i64, i64 -> i64
  %wide_tail = wave.binary remui %wide, %eight64 : i64, i64 -> i64
  %vhalf = wave.splat %wide_half : i64 -> !wave.simd<i64, 32>
  %vtail = wave.splat %wide_tail : i64 -> !wave.simd<i64, 32>
  %mask = wave.cmpi ult %vhalf, %vtail
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %bits = wave.ballot %mask : !wave.mask<32> -> i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v = wave.splat %bits : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

}
