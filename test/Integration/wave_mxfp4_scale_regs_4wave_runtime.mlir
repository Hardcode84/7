// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-mxfp4-256x256-4wave --m=512 --n=512 --k=512 --cta-swizzle-xcds=1 --cta-group-m=1 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s
//
// CHECK: bm=2 bn=2 wave_m_tiles=8 wave_n_tiles=8 wave_k_tiles=2 target_waves=1
// CHECK: input_type=mxfp4 output_type=f16 mxfp4_scale_path=regs
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: hw_output_check: passed
