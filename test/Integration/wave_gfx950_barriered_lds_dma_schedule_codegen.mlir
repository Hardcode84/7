// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=gfx950 --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-16wave --m=4096 --n=4096 --k=8192 \
// RUN:   --variants=scheduled --skip-hw --enable-split-barriers --emit-asm=%t.s
// RUN: FileCheck %s --input-file=%t.s --check-prefix=F16
//
// F16-LABEL: .Lwmma_f16_matmul_tiled.loop_exit_0:
// F16: ds_add_rtn_u32
// F16: v_mfma_f32_16x16x32_f16
// F16: .Lwmma_f16_matmul_tiled.loop_head_2:
// F16: ds_read_b32
// F16: s_cbranch_scc1 .Lwmma_f16_matmul_tiled.loop_head_2
// F16: ds_read_b128
