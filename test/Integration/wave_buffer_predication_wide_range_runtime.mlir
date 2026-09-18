// REQUIRES: host-supports-amdgpu-gfx1250
// RUN: sed -e '/DMA-BEGIN/,/DMA-END/d' -e 's/@FINAL@/stored/g' -e 's/@W@/%wave_width/g' -e 's/@OUT@/%wave_bytes/g' -e 's/@RANGE@/4294967296/g' -e 's/@RT@/i64/g' %S/Inputs/buffer_predication_ranges.mlir \
// RUN:   | wave-opt - --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},waveamd-lower-buffer-predication,waveamd-dma-zero-fill,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels},convert-scf-to-cf,gpu-to-llvm{use-bare-pointers-for-kernels=true},convert-to-llvm,reconcile-unrealized-casts)' \
// RUN:   | mlir-runner --shared-libs=%mlir_rocm_runtime --shared-libs=%mlir_runner_utils --shared-libs=%wave_runtime --entry-point-result=void
