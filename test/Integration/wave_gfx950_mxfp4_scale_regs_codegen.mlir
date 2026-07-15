// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=gfx950 --build-dir=%wave_obj_root \
// RUN:   --m=512 --n=512 --k=1024 --bm=2 --bn=2 \
// RUN:   --wave-m-tiles=8 --wave-n-tiles=8 --wave-k-tiles=2 \
// RUN:   --target-waves=1 --use-buffer --use-dma-lds \
// RUN:   --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 \
// RUN:   --mxfp4-scale-path=regs --cta-swizzle-xcds=1 --cta-group-m=1 \
// RUN:   --variants=scheduled --skip-hw --emit-mlir=%t.mlir --emit-asm=%t.s 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=OUT
// RUN: FileCheck %s --input-file=%t.mlir --check-prefix=IR
// RUN: FileCheck %s --input-file=%t.s --check-prefix=ASM
//
// OUT: mxfp4_scale_path=regs
// OUT: variant: scheduled
//
// IR-LABEL: func.func @wmma_f16_matmul_tiled
// IR-NOT: waveamd.transpose_load
// IR: wave.gather
// IR-SAME: -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
// IR-NOT: waveamd.transpose_load
// IR: return
//
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: buffer_load_dword v{{[0-9]+}},
// ASM: ds_write{{.*}}_b32
// ASM: .Lwmma_f16_matmul_tiled.loop_head_0:
// ASM: ds_read_b64_tr_b8
// ASM: v_mfma_scale_f32_16x16x128_f8f6f4
