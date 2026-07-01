// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=256 --n=256 --k=512 --bm=4 --bn=4 --wave-m-tiles=4 --wave-n-tiles=4 --wave-k-tiles=1 --target-waves=4 --use-buffer --use-dma-lds --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 --cta-swizzle-xcds=1 --cta-group-m=1 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s
//
// CHECK: bm=4 bn=4 wave_m_tiles=4 wave_n_tiles=4 wave_k_tiles=1 target_waves=4
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: hw_output_check: passed
