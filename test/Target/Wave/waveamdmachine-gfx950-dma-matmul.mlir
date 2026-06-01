// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=128 --n=64 --k=64 --bm=2 --bn=2 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASM
//
// IR: wave.index_expr <{{.*xor.*floor\(1/2\*Mod\(wi, 16\)\).*}}>
// IR: waveamd.dma_load_lds
// IR: waveamd.mma "mfma.f32.16x16x32.f16"
//
// ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: v_xor_b32_e32
// ASM: global_load_lds_dwordx4
// ASM: v_mfma_f32_16x16x32_f16
