// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// MACHINE-LABEL: func.func @constant_true_where
// MACHINE: [[TRUE:%.*]] = waveamdmachine.imm -1
// MACHINE: [[COND:%.*]] = waveamdmachine.s_mov_b32_value [[TRUE]]
// MACHINE-NEXT: waveamdmachine.exec_if [[COND]]
// ASM-LABEL: constant_true_where:
// ASM: s_mov_b32 [[COND:s[0-9]+]], -1
// ASM: s_and_saveexec_b32 {{s[0-9]+}}, [[COND]]
func.func @constant_true_where(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %active = wave.constant true -> !wave.mask<32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

// MACHINE-LABEL: func.func @constant_false_where
// MACHINE: [[FALSE:%.*]] = waveamdmachine.imm 0
// MACHINE: [[COND:%.*]] = waveamdmachine.s_mov_b32_value [[FALSE]]
// MACHINE-NEXT: waveamdmachine.exec_if [[COND]]
// ASM-LABEL: constant_false_where:
// ASM: s_mov_b32 [[COND:s[0-9]+]], 0{{$}}
// ASM: s_and_saveexec_b32 {{s[0-9]+}}, [[COND]]
func.func @constant_false_where(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %active = wave.constant false -> !wave.mask<32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

}
