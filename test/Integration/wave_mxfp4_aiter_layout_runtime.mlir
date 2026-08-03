// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-mxfp4-aiter-256x256 --m=512 --n=512 --k=2048 --cta-group-m=2 --seed=17 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=LARGE-TILE
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-mxfp4-aiter-32x128 --m=256 --n=512 --k=512 --seed=29 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=MULTI-CTA
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-mxfp4-aiter-128x256 --m=128 --n=256 --k=1024 --cta-swizzle-xcds=1 --cta-group-m=1 --seed=41 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=WAVE-K4
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=192 --n=320 --k=512 --bm=2 --bn=2 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --target-waves=1 --use-buffer --use-dma-lds --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 --output-store-cache=cs --mxfp4-input-layout=aiter --cta-swizzle-xcds=1 --cta-group-m=1 --seed=53 --variants=scheduled --iters=2 --warmup=1 --repeats=1 \
// RUN:   | FileCheck %s --check-prefix=OWNER-SPLIT
//
// LARGE-TILE: input_type=mxfp4 output_type=f16 mxfp4_scale_path=dma mxfp4_input_layout=aiter
// LARGE-TILE: seed=17 input_mode=random
// LARGE-TILE: m=512 n=512 k=2048 bm=1 bn=4 wave_m_tiles=16 wave_n_tiles=4 wave_k_tiles=4
// LARGE-TILE: cta_swizzle_xcds=1 cta_group_m=2
// LARGE-TILE: input_check: passed mode=random a_codes=16 b_codes=16 a_scale_values=4 b_scale_values=4 reference=canonical upload=aiter-preshuffled
// LARGE-TILE: output_layout_check: passed kernel=tile-packed final=row-major conversion=device coordinates=bijective elements=262144
// LARGE-TILE: kernel_abi=matmul output_layout=tile-packed
// LARGE-TILE: output_contract: kernel=tile-packed final=row-major conversion=device
// LARGE-TILE: grid: 2,2,1 block: 256,1,1
// LARGE-TILE: timing_scope: gemm+device-output-conversion
// LARGE-TILE: kernel_only_per_launch_us:
// LARGE-TILE: output_check: passed mode=strict layout=row-major elements=262144
// LARGE-TILE: variant: scheduled
// LARGE-TILE: hw_output_check: passed
// MULTI-CTA: m=256 n=512 k=512 bm=1 bn=4 wave_m_tiles=2 wave_n_tiles=2 wave_k_tiles=2
// MULTI-CTA: input_type=mxfp4 output_type=f16 mxfp4_scale_path=dma mxfp4_input_layout=aiter
// MULTI-CTA: seed=29 input_mode=random
// MULTI-CTA: cta_swizzle_xcds=8 cta_group_m=4
// MULTI-CTA: input_check: passed mode=random a_codes=16 b_codes=16 a_scale_values=4 b_scale_values=4 reference=canonical upload=aiter-preshuffled
// MULTI-CTA: output_layout_check: passed kernel=tile-packed final=row-major conversion=device coordinates=bijective elements=131072
// MULTI-CTA: kernel_abi=matmul output_layout=tile-packed
// MULTI-CTA: output_contract: kernel=tile-packed final=row-major conversion=device
// MULTI-CTA: grid: 8,4,1 block: 256,1,1
// MULTI-CTA: timing_scope: gemm+device-output-conversion
// MULTI-CTA: kernel_only_per_launch_us:
// MULTI-CTA: output_check: passed mode=strict layout=row-major elements=131072
// MULTI-CTA: variant: scheduled
// MULTI-CTA: hw_output_check: passed
// WAVE-K4: m=128 n=256 k=1024 bm=1 bn=4 wave_m_tiles=8 wave_n_tiles=4 wave_k_tiles=4
// WAVE-K4: input_type=mxfp4 output_type=f16 mxfp4_scale_path=dma mxfp4_input_layout=aiter
// WAVE-K4: input_check: passed mode=random a_codes=16 b_codes=16 a_scale_values=4 b_scale_values=4 reference=canonical upload=aiter-preshuffled
// WAVE-K4: output_layout_check: passed kernel=tile-packed final=row-major conversion=device coordinates=bijective elements=32768
// WAVE-K4: output_contract: kernel=tile-packed final=row-major conversion=device
// WAVE-K4: grid: 1,1,1 block: 256,1,1
// WAVE-K4: timing_scope: gemm+device-output-conversion
// WAVE-K4: kernel_only_per_launch_us:
// WAVE-K4: output_check: passed mode=strict layout=row-major elements=32768
// WAVE-K4: variant: scheduled
// WAVE-K4: hw_output_check: passed
// OWNER-SPLIT: m=192 n=320 k=512 bm=2 bn=2 wave_m_tiles=2 wave_n_tiles=2 wave_k_tiles=2
// OWNER-SPLIT: input_type=mxfp4 output_type=f16 mxfp4_scale_path=dma mxfp4_input_layout=aiter
// OWNER-SPLIT: input_check: passed mode=random a_codes=16 b_codes=16 a_scale_values=4 b_scale_values=4 reference=canonical upload=aiter-preshuffled scale_blocks=position-distinct scale_axes=distinct
// OWNER-SPLIT: output_layout_check: passed kernel=tile-packed final=row-major conversion=device coordinates=bijective elements=61440
// OWNER-SPLIT: output_contract: kernel=tile-packed final=row-major conversion=device
// OWNER-SPLIT: grid: 3,5,1 block: 256,1,1
// OWNER-SPLIT: output_check: passed mode=strict layout=row-major elements=61440
// OWNER-SPLIT: variant: scheduled
// OWNER-SPLIT: hw_output_check: passed
