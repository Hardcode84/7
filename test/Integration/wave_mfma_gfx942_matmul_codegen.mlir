// REQUIRES: wave-python-bindings
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=gfx942 \
// RUN:   --m=16 --n=16 --k=32 --bm=1 --bn=1 --input-type=f16 > %t.f16.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.f16.mlir
// RUN: wave-opt %t.f16.mlir \
// RUN:   --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx942},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | FileCheck %s --check-prefix=LLVM
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=gfx942 \
// RUN:   --m=16 --n=16 --k=32 --bm=1 --bn=1 --input-type=bf16 > %t.bf16.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.bf16.mlir
// RUN: wave-opt %t.bf16.mlir \
// RUN:   --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx942},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | FileCheck %s --check-prefix=LLVM

// IR-LABEL: func.func @wmma_f16_matmul_tiled
// IR-SAME: wave.workgroup_size = array<i32: 64, 1, 1>
// IR: [[WI:%.*]] = wave.workitem_id 0 : !wave.simd<i32, 64>
// IR: [[BOUNDED:%.*]] = wave.assume [[WI]]
// IR-COUNT-2: wave.index_expr <"4*floor(1/16*Mod(wi, 64)) + 32*Mod(wi, 16)"> ["wi"]([[BOUNDED]])
// IR: waveamd.mma "mfma.f32.16x16x16.{{b?}}f16"
// IR-SAME: !waveamd.fragment<2, f32, 16, 16, 64, 4>
// LLVM: gpu.binary @kernels {{.*}}#rocdl.target<O = 3, chip = "gfx942">, bin = "\7FELF
// LLVM: gpu.launch_func @kernels::@wmma_f16_matmul_tiled
