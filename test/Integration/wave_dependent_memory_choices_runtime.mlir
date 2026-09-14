// REQUIRES: linux, host-supports-amdgpu-gfx1100, host-has-hip-runtime, host-has-hipcc
// RUN: wave-opt %S/wave_dependent_memory_choices.mlir --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,waveamd-buffer-rsrc-to-tuples,waveamd-expand-materialization-variants,func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)),waveamd-machine-schedule{apply-schedule},waveamd-collapse-materialization-variants)' -o %t.winner
// RUN: wave-translate %t.winner --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=%compiler_rocm_lib:%rocm_lib %t.runner --iters 1 --warmup 1 --grid 1,1,1 --block 32,1,1 --buf-elems 512 --dump-out 512 %t.hsaco dependent_memory_choices | %python -c "import sys; values = [int(line.split(': ')[1]) for line in sys.stdin if line.startswith('out[')]; assert len(values) == 512; assert all(values[offset + scale * lane] == lane + 3 for offset, scale in [(0, 1), (64, 2), (128, 4), (256, 6)] for lane in range(32)), values"
