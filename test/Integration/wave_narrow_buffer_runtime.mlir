// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime, host-has-hipcc
// RUN: sed 's/, 32>/, %wave_width>/g; s/array<i32: 32,/array<i32: %wave_width,/' %S/wave_narrow_buffer.mlir | wave-opt --wave-set-target-attr=chip=%chip -o %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib:%rocm_lib %t.runner --iters 1 --warmup 0 --grid 1,1,1 --block %wave_width,1,1 --buf-elems %wave_width --dump-out %wave_width %t.hsaco narrow_buffer | %python -c "import sys; values = [int(line.split(': ')[1]) for line in sys.stdin if line.startswith('out[')]; expected = [-1] * 4 + list(range(1, 13)) + [-1] * (%wave_width - 16); assert values == expected, values"
