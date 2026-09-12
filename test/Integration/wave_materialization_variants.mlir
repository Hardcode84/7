// RUN: split-file %s %t
// RUN: not wave-opt %t/live.mlir --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=LIVE
// RUN: not wave-translate %t/live.mlir --wave-to-amdgpu-asm 2>&1 | FileCheck %s --check-prefix=LIVE
// RUN: wave-translate %t/single.mlir --wave-to-amdgpu-asm | FileCheck %s --check-prefix=SINGLE
// RUN: wave-translate %t/single.mlir --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: wave-translate %t/chained.mlir --wave-to-amdgpu-asm -o %t/chained.s
// RUN: wave-translate %t/single.mlir --wave-to-amdgpu-asm -o %t/single.s
// RUN: diff %t/single.s %t/chained.s
// RUN: wave-translate %t/dead.mlir --wave-to-amdgpu-asm | FileCheck %s --check-prefix=DEAD

// LIVE: 'wave.materialization_variants' op must be resolved before WaveAMDMachine selection
// SINGLE-LABEL: single_variant:
// SINGLE: buffer_store_b32
// SINGLE: s_endpgm
// DEAD-LABEL: dead_variants:
// DEAD: s_endpgm

//--- live.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @live_variants(%out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %two = arith.constant 2 : i32
  %mul = wave.binary muli %x, %two : i32, i32 -> i32
  %add = wave.binary addi %x, %x : i32, i32 -> i32
  %choice = wave.materialization_variants %mul, %add : i32
  %v = wave.splat %choice : i32 -> !wave.simd<i32, 32>
  wave.store %v -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return
}
}

//--- single.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @single_variant(%out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %choice = wave.materialization_variants %x : i32
  %v = wave.splat %choice : i32 -> !wave.simd<i32, 32>
  wave.store %v -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return
}
}

//--- dead.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @dead_variants() attributes {wave.kernel} {
  %one = arith.constant 1 : i32
  %choice = wave.materialization_variants %one, %one : i32
  return
}
}

//--- chained.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @single_variant(%out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %inner = wave.materialization_variants %x, %x : i32
  %choice = wave.materialization_variants %inner, %x, %inner : i32
  %v = wave.splat %choice : i32 -> !wave.simd<i32, 32>
  wave.store %v -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return
}
}
