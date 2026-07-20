// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --rand-int --multi-wave-specialize \
// RUN:   | FileCheck %s --check-prefix=F4
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --seed=17 --multi-wave-specialize \
// RUN:   | FileCheck %s --check-prefix=F4R
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-8wave --m=1024 --n=512 --k=256 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --rand-int --multi-wave-specialize \
// RUN:   | FileCheck %s --check-prefix=F8
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave --m=1024 --n=512 --k=256 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --rand-int \
// RUN:   | FileCheck %s --check-prefix=F16
//
// F4: bm=2 bn=2 wave_m_tiles=8 wave_n_tiles=8 wave_k_tiles=2 target_waves=1
// F4-SAME: input_type=f16 output_type=f16
// F4: seed=0 input_mode=rand-int
// F4: cta_swizzle_xcds=8 cta_group_m=4
// F4: kernel_abi=matmul output_layout=column-major
// F4: output_check: passed mode=strict
// F4: variant: scheduled
// F4: hw_output_check: passed
// F4R: seed=17 input_mode=random
// F4R: output_check: passed mode=strict
// F4R: variant: scheduled
// F4R: hw_output_check: passed
// F8: bm=2 bn=4 wave_m_tiles=8 wave_n_tiles=4 wave_k_tiles=2 target_waves=2
// F8-SAME: input_type=f16 output_type=f16
// F8: seed=0 input_mode=rand-int
// F8: cta_swizzle_xcds=8 cta_group_m=4
// F8: kernel_abi=matmul output_layout=tile-packed
// F8: output_check: passed mode=strict
// F8: variant: scheduled
// F8: hw_output_check: passed
// F16: bm=4 bn=4 wave_m_tiles=4 wave_n_tiles=4 wave_k_tiles=1 target_waves=4
// F16-SAME: input_type=f16 output_type=f16
// F16: seed=0 input_mode=rand-int
// F16: cta_swizzle_xcds=8 cta_group_m=4
// F16: kernel_abi=matmul output_layout=tile-packed
// F16: output_check: passed mode=strict
// F16: variant: scheduled
// F16: hw_output_check: passed
