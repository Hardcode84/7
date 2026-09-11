// REQUIRES: linux, host-supports-amdgpu-wave, host-has-hip-runtime, host-has-hipcc
// RUN: sed -e 's/CHIP/%chip/g' -e 's/WAVE_WIDTH/%wave_width/g' %s > %t.mlir
// RUN: wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=%chip -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib %t.runner --iters 1 --warmup 1 --grid 1,1,1 \
// RUN:   --block 256,1,1 --buf-elems 256 --dump-out 256 %t.hsaco full_waves \
// RUN:   | FileCheck %s --check-prefix=FULL
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib %t.runner --iters 1 --warmup 1 --grid 1,1,1 \
// RUN:   --block 96,1,1 --buf-elems 96 --dump-out 96 %t.hsaco partial_wave \
// RUN:   | FileCheck %s --check-prefix=PARTIAL
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib %t.runner --iters 1 --warmup 1 --grid 1,1,1 \
// RUN:   --block 96,2,1 --buf-elems 192 --dump-out 192 %t.hsaco two_rows \
// RUN:   | FileCheck %s --check-prefix=ROWS

// FULL-COUNT-64: out[{{[0-9]+}}]: 3{{$}}
// FULL-COUNT-64: out[{{[0-9]+}}]: 11{{$}}
// FULL-COUNT-64: out[{{[0-9]+}}]: 19{{$}}
// FULL-COUNT-64: out[{{[0-9]+}}]: 27{{$}}
// PARTIAL-COUNT-64: out[{{[0-9]+}}]: 3{{$}}
// PARTIAL-COUNT-32: out[{{[0-9]+}}]: 11{{$}}
// ROWS-COUNT-64: out[{{[0-9]+}}]: 3{{$}}
// ROWS-COUNT-32: out[{{[0-9]+}}]: 11{{$}}
// ROWS-COUNT-64: out[{{[0-9]+}}]: 3{{$}}
// ROWS-COUNT-32: out[{{[0-9]+}}]: 11{{$}}

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--CHIP"} {

func.func @full_waves(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, WAVE_WIDTH>
  %tid = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">]
      : !wave.simd<i32, WAVE_WIDTH>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid)
      : (!wave.simd<i32, WAVE_WIDTH>) -> !wave.simd<index, WAVE_WIDTH>
  %data = wave.cast intconvert %q
      : !wave.simd<index, WAVE_WIDTH> -> !wave.simd<i32, WAVE_WIDTH>
  %dst = wave.ptr_add %out, %tid
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, WAVE_WIDTH>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %stored = wave.store %data -> %dst
      : (!wave.simd<i32, WAVE_WIDTH>,
         !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>) -> !wave.mem.token
  return
}

func.func @partial_wave(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 96, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, WAVE_WIDTH>
  %tid = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 95">]
      : !wave.simd<i32, WAVE_WIDTH>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid)
      : (!wave.simd<i32, WAVE_WIDTH>) -> !wave.simd<index, WAVE_WIDTH>
  %data = wave.cast intconvert %q
      : !wave.simd<index, WAVE_WIDTH> -> !wave.simd<i32, WAVE_WIDTH>
  %dst = wave.ptr_add %out, %tid
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, WAVE_WIDTH>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %stored = wave.store %data -> %dst
      : (!wave.simd<i32, WAVE_WIDTH>,
         !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>) -> !wave.mem.token
  return
}

func.func @two_rows(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 96, 2, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, WAVE_WIDTH>
  %tid = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 95">]
      : !wave.simd<i32, WAVE_WIDTH>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid)
      : (!wave.simd<i32, WAVE_WIDTH>) -> !wave.simd<index, WAVE_WIDTH>
  %data = wave.cast intconvert %q
      : !wave.simd<index, WAVE_WIDTH> -> !wave.simd<i32, WAVE_WIDTH>
  %y = wave.workitem_id 1 : !wave.simd<i32, WAVE_WIDTH>
  %linear = wave.index_expr <"x + 96*y"> ["x", "y"](%tid, %y)
      : (!wave.simd<i32, WAVE_WIDTH>, !wave.simd<i32, WAVE_WIDTH>)
      -> !wave.simd<index, WAVE_WIDTH>
  %dst = wave.ptr_add %out, %linear
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, WAVE_WIDTH>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %stored = wave.store %data -> %dst
      : (!wave.simd<i32, WAVE_WIDTH>,
         !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>) -> !wave.mem.token
  return
}
}
