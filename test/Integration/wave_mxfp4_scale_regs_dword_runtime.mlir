// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --m=512 --n=512 --k=1024 --bm=2 --bn=2 --wave-m-tiles=8 --wave-n-tiles=8 --wave-k-tiles=2 --target-waves=1 --use-buffer --use-dma-lds --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 --mxfp4-scale-path=regs --cta-swizzle-xcds=1 --cta-group-m=1 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s
//
// CHECK: bm=2 bn=2 wave_m_tiles=8 wave_n_tiles=8 wave_k_tiles=2 target_waves=1
// CHECK: input_type=mxfp4 output_type=f16 mxfp4_scale_path=regs
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: hw_output_check: passed
