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
// ASM-NOT: s_and_saveexec_b32
// ASM: buffer_store_b32
// ASM: s_endpgm
func.func @constant_true_where(%dst: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
  %active = wave.constant true -> !wave.mask<32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %observe_seed_1 = wave.token : !wave.mem.token
  %observe_region_2 = wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %observe_seed_1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  return %observe_region_2 : !wave.mem.token
}

// MACHINE-LABEL: func.func @constant_false_where
// MACHINE: [[FALSE:%.*]] = waveamdmachine.imm 0
// MACHINE: [[COND:%.*]] = waveamdmachine.s_mov_b32_value [[FALSE]]
// MACHINE-NEXT: waveamdmachine.exec_if [[COND]]
// ASM-LABEL: constant_false_where:
// ASM-NOT: store
// ASM: s_endpgm
func.func @constant_false_where(%dst: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
  %active = wave.constant false -> !wave.mask<32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %observe_seed_5 = wave.token : !wave.mem.token
  %observe_region_6 = wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %observe_seed_5 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  return %observe_region_6 : !wave.mem.token
}

}
