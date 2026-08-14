// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx1250 --m=16 --n=16 --k=32 \
// RUN:   --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=1 --wave-k-tiles=1 \
// RUN:   --matrix-intrinsic=auto --input-type=f16 --kernel-only \
// RUN:   2>/dev/null > %t.f16.mlir
// RUN: FileCheck %s --check-prefix=F16-IR \
// RUN:   --implicit-check-not=waveamd.dma_load_lds < %t.f16.mlir
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx1250 --m=16 --n=16 --k=32 \
// RUN:   --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=1 --wave-k-tiles=1 \
// RUN:   --matrix-intrinsic=auto --input-type=f16 --kernel-only --dump-asm \
// RUN:   2>/dev/null > %t.f16.s
// RUN: FileCheck %s --check-prefix=F16-ASM \
// RUN:   --implicit-check-not='buffer_load_{{.*}} lds' \
// RUN:   --implicit-check-not=HW_REG_WAVE_SCHED_MODE < %t.f16.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.f16.s -o %t.f16.o 2> %t.f16.mc.err
// RUN: not grep -i warning %t.f16.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.f16.o \
// RUN:   | FileCheck %s --check-prefix=F16-DIS
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx1250 --m=16 --n=16 --k=32 \
// RUN:   --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=1 --wave-k-tiles=1 \
// RUN:   --matrix-intrinsic=auto --input-type=bf16 --kernel-only \
// RUN:   2>/dev/null > %t.bf16.mlir
// RUN: FileCheck %s --check-prefix=BF16-IR \
// RUN:   --implicit-check-not=waveamd.dma_load_lds < %t.bf16.mlir
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx1250 --m=16 --n=16 --k=32 \
// RUN:   --bm=1 --bn=1 --wave-m-tiles=1 --wave-n-tiles=1 --wave-k-tiles=1 \
// RUN:   --matrix-intrinsic=auto --input-type=bf16 --kernel-only --dump-asm \
// RUN:   2>/dev/null > %t.bf16.s
// RUN: FileCheck %s --check-prefix=BF16-ASM \
// RUN:   --implicit-check-not='buffer_load_{{.*}} lds' \
// RUN:   --implicit-check-not=HW_REG_WAVE_SCHED_MODE < %t.bf16.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.bf16.s -o %t.bf16.o 2> %t.bf16.mc.err
// RUN: not grep -i warning %t.bf16.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.bf16.o \
// RUN:   | FileCheck %s --check-prefix=BF16-DIS

// F16-IR-LABEL: func.func @wmma_f16_matmul_tiled(
// F16-IR-SAME: gpu.known_block_size = array<i32: 32, 1, 1>
// F16-IR-SAME: wave.lds_size = 2048 : i64
// F16-IR-SAME: waveamdmachine.enable_split_barriers
// F16-IR: wave.load
// F16-IR-SAME: !wave.simd<vector<8xi32>, 32>
// F16-IR: wave.store
// F16-IR-SAME: !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
// F16-IR: wave.barrier
// F16-IR: waveamd.fragment_pack
// F16-IR-SAME: !waveamd.fragment<0, f16, 16, 16, 32, 8>
// F16-IR: waveamd.fragment_pack
// F16-IR-SAME: !waveamd.fragment<1, f16, 16, 16, 32, 8>
// F16-IR: waveamd.mma "wmma.f32.16x16x32.f16"

// BF16-IR-LABEL: func.func @wmma_f16_matmul_tiled(
// BF16-IR-SAME: gpu.known_block_size = array<i32: 32, 1, 1>
// BF16-IR-SAME: wave.lds_size = 2048 : i64
// BF16-IR-SAME: waveamdmachine.enable_split_barriers
// BF16-IR: wave.load
// BF16-IR-SAME: !wave.simd<vector<8xi32>, 32>
// BF16-IR: wave.store
// BF16-IR-SAME: !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
// BF16-IR: wave.barrier
// BF16-IR: waveamd.fragment_pack
// BF16-IR-SAME: !waveamd.fragment<0, bf16, 16, 16, 32, 8>
// BF16-IR: waveamd.fragment_pack
// BF16-IR-SAME: !waveamd.fragment<1, bf16, 16, 16, 32, 8>
// BF16-IR: waveamd.mma "wmma.f32.16x16x32.bf16"

// F16-ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
// F16-ASM-LABEL: wmma_f16_matmul_tiled:
// F16-ASM: buffer_load_b128
// F16-ASM: ds_store_b128
// F16-ASM: s_barrier_signal
// F16-ASM-NEXT: s_barrier_wait
// F16-ASM: ds_load_b128
// F16-ASM: v_wmma_f32_16x16x32_f16
// F16-ASM-COUNT-8: buffer_store_b32
// F16-ASM: .amdhsa_group_segment_fixed_size 2048

// BF16-ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx1250"
// BF16-ASM-LABEL: wmma_f16_matmul_tiled:
// BF16-ASM: buffer_load_b128
// BF16-ASM: ds_store_b128
// BF16-ASM: s_barrier_signal
// BF16-ASM-NEXT: s_barrier_wait
// BF16-ASM: ds_load_b128
// BF16-ASM: v_wmma_f32_16x16x32_bf16
// BF16-ASM-COUNT-8: buffer_store_b32
// BF16-ASM: .amdhsa_group_segment_fixed_size 2048

// F16-DIS-LABEL: <wmma_f16_matmul_tiled>:
// F16-DIS: buffer_load_b128
// F16-DIS: ds_store_b128
// F16-DIS: s_barrier_signal
// F16-DIS-NEXT: s_barrier_wait
// F16-DIS: ds_load_b128
// F16-DIS: v_wmma_f32_16x16x32_f16
// F16-DIS-COUNT-8: buffer_store_b32

// BF16-DIS-LABEL: <wmma_f16_matmul_tiled>:
// BF16-DIS: buffer_load_b128
// BF16-DIS: ds_store_b128
// BF16-DIS: s_barrier_signal
// BF16-DIS-NEXT: s_barrier_wait
// BF16-DIS: ds_load_b128
// BF16-DIS: v_wmma_f32_16x16x32_bf16
// BF16-DIS-COUNT-8: buffer_store_b32
