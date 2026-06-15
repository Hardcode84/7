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
// ASM: s_lshr_b64
// ASM: global_store_b32
func.func @scalar_integer_arith_codegen(%out: !wave.ptr<#wave.global, i32>,
                                        %x: i32, %y: i32, %wide: i64)
    attributes {wave.kernel} {
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %two64 = arith.constant 2 : i64
  %eight64 = arith.constant 8 : i64
  %diff = wave.binary subi %x, %y : i32, i32 -> i32
  %half = wave.binary divui %diff, %two : i32, i32 -> i32
  %tail = wave.binary remui %diff, %four : i32, i32 -> i32
  %cond = arith.cmpi slt, %half, %tail : i32
  %pick = wave.select %cond, %half, %tail : i32
  %wide_half = wave.binary divui %wide, %two64 : i64, i64 -> i64
  %wide_tail = wave.binary remui %wide, %eight64 : i64, i64 -> i64
  %wide_cond = arith.cmpi uge, %wide_half, %wide_tail : i64
  %selected = wave.select %wide_cond, %pick, %tail : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v = wave.splat %selected : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  wave.wait %tok : !wave.mem.token
  return
}

}
