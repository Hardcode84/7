// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=gfx950 --build-dir=%wave_obj_root \
// RUN:   --m=256 --n=256 --k=512 --bm=2 --bn=2 \
// RUN:   --wave-m-tiles=4 --wave-n-tiles=4 --wave-k-tiles=1 --target-waves=4 \
// RUN:   --use-buffer --use-dma-lds --matrix-intrinsic=mfma_gfx950 \
// RUN:   --input-type=mxfp4 --output-type=f16 --mxfp4-scale-path=regs \
// RUN:   --cta-swizzle-xcds=1 --cta-group-m=1 \
// RUN:   --variants=scheduled --iters=2 --warmup=1 --repeats=1 --skip-hw \
// RUN:   | FileCheck %s
//
// CHECK: bm=2 bn=2 wave_m_tiles=4 wave_n_tiles=4 wave_k_tiles=1 target_waves=4
// CHECK: input_type=mxfp4 output_type=f16 mxfp4_scale_path=regs
// CHECK: input_mode=random
// CHECK: variant: scheduled
// CHECK: sim_cycles
