// RUN: %python %S/Inputs/cross_lane_exec.py --emit-mlir > %t.mlir
// RUN: wave-opt %t.mlir --waveamd-cross-lane-peepholes | FileCheck %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null
