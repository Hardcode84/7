# gfx950 Matmul Profiles

## `gfx950-f16-256x256-16wave`

Recommended f16 GEMM calibration baseline for 4096x4096xK:

```text
bm=4
bn=4
wave_m_tiles=4
wave_n_tiles=4
wave_k_tiles=1
use_buffer=true
use_dma_lds=true
matrix_intrinsic=mfma_gfx950
input_type=f16
output_type=f16
cta_swizzle_xcds=8
cta_group_m=4
```

This is a 256x256 CTA with 16 waves and 32-wide MFMA K steps.

```bash
python tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
  --chip=gfx950 --kernel-profile=gfx950-f16-256x256-16wave \
  --m=4096 --n=4096 --k=4096 \
  --variants=scheduled --iters=500 --warmup=20 --repeats=3
```
