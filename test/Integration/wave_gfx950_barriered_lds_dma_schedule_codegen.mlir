// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=gfx950 --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-16wave --m=4096 --n=4096 --k=8192 \
// RUN:   --variants=scheduled --skip-hw --emit-asm=%t.s
// RUN: FileCheck %s --input-file=%t.s --check-prefix=F16
//
// F16-LABEL: .Lwmma_f16_matmul_tiled.loop_head_0:
// F16: buffer_load_dwordx4 {{.*}} lds
// F16: v_mfma_f32_16x16x32_f16
// F16: buffer_load_dwordx4 {{.*}} lds
// F16: v_mfma_f32_16x16x32_f16
// F16-NOT: s_waitcnt vmcnt(0)
// F16: s_waitcnt vmcnt(2)
// F16-NEXT: s_barrier
