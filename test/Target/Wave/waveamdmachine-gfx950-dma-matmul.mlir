// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   | FileCheck %s --check-prefix=PRELOAD
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=128 --n=64 --k=64 --bm=2 --bn=2 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=64 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMBUF
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=192 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMPIPE
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=16 --k=32 --matrix-intrinsic=mfma_gfx950 --input-type=bf16 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMBF16
//
// IR: wave.index_expr <{{.*xor.*floor\(1/2\*Mod\(wi, 16\)\).*}}>
// IR: waveamd.dma_load_lds
// IR: waveamd.mma "mfma.f32.16x16x32.f16"
//
// PRELOAD-LABEL: func.func @wmma_f16_matmul_tiled
// PRELOAD-SAME: waveamdmachine.kernarg_preload_length = 7 : i64
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 2 : i64} : !waveamdmachine.reg<sgpr, 2, 4>
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 4 : i64} : !waveamdmachine.reg<sgpr, 2, 6>
// PRELOAD-NOT: waveamdmachine.s_load_b
// PRELOAD: waveamdmachine.v_workitem_id_x
//
// ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: s_load_dwordx2 s[2:3], s[0:1], 0x0
// ASM: s_load_dwordx2 s[4:5], s[0:1], 0x8
// ASM: s_load_dwordx2 s[6:7], s[0:1], 0x10
// ASM: s_load_dword s8, s[0:1], 0x18
// ASM: s_waitcnt lgkmcnt(0)
// ASM: s_branch [[ENTRY:.*kernarg_preload_entry]]
// ASM: .p2align 8
// ASM: [[ENTRY]]:
// ASM-NOT: s_load_dword
// ASM: v_xor_b32_e32
// ASM: global_load_lds_dwordx4
// ASM: v_mfma_f32_16x16x32_f16
// ASM: .amdhsa_user_sgpr_kernarg_preload_length 7
// ASM: .amdhsa_user_sgpr_kernarg_preload_offset 0

// ASMBUF-LABEL: wmma_f16_matmul_tiled:
// ASMBUF: buffer_load_dwordx4
// ASMBUF: buffer_store_dwordx4

// ASMPIPE-LABEL: wmma_f16_matmul_tiled:
// ASMPIPE: s_waitcnt vmcnt(8)
// ASMPIPE-NEXT: s_barrier

// ASMBF16-LABEL: wmma_f16_matmul_tiled:
// ASMBF16: v_mfma_f32_16x16x32_bf16
// ASMPIPE: ds_read_b128
// ASMPIPE: s_waitcnt lgkmcnt(0)
// ASMPIPE-NEXT: buffer_load_dwordx4
// ASMPIPE: s_waitcnt vmcnt(8)
// ASMPIPE-NEXT: s_barrier
