// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx908 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx908 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx900 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx90a --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx942 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx950 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx1010 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/4/g" %s | wave-opt --wave-set-target-attr=chip=gfx1030 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/16/g" %s | wave-opt --wave-set-target-attr=chip=gfx950 --split-input-file --waveamd-to-machine -o /dev/null
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx900 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx90a --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/64/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx942 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1010 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1030 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/4/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1100 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-4
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1100 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/4/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1200 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-4
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1200 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/4/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1250 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-4
// RUN: sed -e "s/@W@/32/g" -e "s/@BYTES@/16/g" %s | not wave-opt --split-input-file --wave-set-target-attr=chip=gfx1250 --waveamd-to-machine 2>&1 | FileCheck %s --check-prefix=REJECT-16
// RUN: sed -e "s/@FINAL@/done/g" -e "s/@W@/32/g" -e "s/@OUT@/128/g" -e "s/@RANGE@/4096/g" -e "s/@RT@/i64/g" %S/Inputs/buffer_predication_ranges.mlir | not wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx1100},waveamd-lower-buffer-predication,waveamd-dma-zero-fill,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels})' 2>&1 | FileCheck %s --check-prefix=WITNESS
// RUN: sed -e "s/@FINAL@/done/g" -e "s/@W@/32/g" -e "s/@OUT@/128/g" -e "s/@RANGE@/4096/g" -e "s/@RT@/i32/g" %S/Inputs/buffer_predication_ranges.mlir | not wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx1100},waveamd-lower-buffer-predication,waveamd-dma-zero-fill,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=compile_kernels})' 2>&1 | FileCheck %s --check-prefix=WITNESS
// WITNESS: gfx1100 does not support 4-byte buffer-to-LDS DMA
// WITNESS-NOT: failed to assemble AMDGPU ISA
// REJECT-4-DAG: does not support 4-byte global-to-LDS DMA
// REJECT-4-DAG: does not support 4-byte buffer-to-LDS DMA
// REJECT-16-DAG: does not support 16-byte global-to-LDS DMA
// REJECT-16-DAG: does not support 16-byte buffer-to-LDS DMA

module {
func.func @global_dma(%in: !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %source = wave.ptr_add %in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#wave.global, i32>, @W@>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %loaded = waveamd.dma_load_lds %source -> %lds after %root {bytes = @BYTES@ : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, @W@>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return %loaded : !wave.mem.token
}
}

// -----

module {
func.func @buffer_dma(%in: !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %range = arith.constant 4096 : i32
  %base = waveamd.make_buffer %in, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %source = wave.ptr_add %base, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %loaded = waveamd.dma_load_lds %source -> %lds after %root {bytes = @BYTES@ : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return %loaded : !wave.mem.token
}
}
