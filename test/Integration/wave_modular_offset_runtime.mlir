// REQUIRES: linux, host-supports-amdgpu-gfx1100, host-has-hip-runtime, host-has-hipcc
// RUN: wave-opt %s --wave-promote-global-to-buffer --wave-extract-loop-strides | FileCheck %s --check-prefix=CHOICE
// RUN: wave-translate %s --wave-to-amdgpu-asm > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib:%rocm_lib %t.runner --iters 1 --warmup 1 --args 2 --x 1073741825 --grid 1,1,1 --block 32,1,1 --buf-elems 32 --dump-out 32 %t.hsaco modular_offset_runtime | %python -c "import sys; values = [int(line.split(': ')[1]) for line in sys.stdin if line.startswith('out[')]; assert values == list(range(3, 35)), values"
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib:%rocm_lib %t.runner --iters 1 --warmup 1 --args 2 --x -1073741823 --grid 1,1,1 --block 32,1,1 --buf-elems 32 --dump-out 32 %t.hsaco modular_offset_runtime | %python -c "import sys; values = [int(line.split(': ')[1]) for line in sys.stdin if line.startswith('out[')]; assert values == list(range(3, 35)), values"

// ASM-LABEL: modular_offset_runtime:
// ASM-NOT: s_mul_i32
// ASM: v_add_nc_u32
// ASM-NOT: s_mul_i32
// ASM: s_endpgm
// CHOICE-LABEL: func.func @modular_offset_runtime
// CHOICE: wave.materialization_variants
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @modular_offset_runtime(%out: !wave.ptr<#wave.global, i32>, %stride: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %four = arith.constant 4 : i32
  %range = arith.constant 512 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %initial = wave.token : !wave.mem.token
  %done = scf.for %i = %zero to %four step %one
      iter_args(%previous = %initial) -> (!wave.mem.token) : i32 {
    %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
    %offset = wave.index_expr <"Mod(x + lane, 128)"> ["x", "lane"](%scaled, %lane)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptr = wave.ptr_add %buffer, %lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %value = wave.cast intconvert %offset : !wave.simd<index, 32> -> !wave.simd<i32, 32>
    %stored = wave.store %value -> %ptr after %previous
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
        -> !wave.mem.token
    scf.yield %stored : !wave.mem.token
  }
  return
}
}
