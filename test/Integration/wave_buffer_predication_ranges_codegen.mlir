// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e '/DMA-BEGIN/,/DMA-END/d' -e 's/@FINAL@/stored/g' -e 's/@W@/32/g' -e 's/@RANGE@/4096/g' -e 's/@RT@/i64/g' | wave-opt --wave-set-target-attr=chip=gfx1250 --waveamd-lower-buffer-predication | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=FLAT < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e '/DMA-BEGIN/,/DMA-END/d' -e 's/@FINAL@/stored/g' -e 's/@W@/32/g' -e 's/@RANGE@/-2147483648/g' -e 's/@RT@/i32/g' | wave-opt --wave-set-target-attr=chip=gfx1250 --waveamd-lower-buffer-predication | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=FLAT < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e '/DMA-BEGIN/,/DMA-END/d' -e 's/@FINAL@/stored/g' -e 's/@W@/32/g' -e 's/@RANGE@/4294967295/g' -e 's/@RT@/i64/g' | wave-opt --wave-set-target-attr=chip=gfx1250 --waveamd-lower-buffer-predication | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=FLAT < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e '/DMA-BEGIN/,/DMA-END/d' -e 's/@FINAL@/stored/g' -e 's/@W@/32/g' -e 's/@RANGE@/4294967296/g' -e 's/@RT@/i64/g' | wave-opt --wave-set-target-attr=chip=gfx1250 --waveamd-lower-buffer-predication | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=EXEC < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e 's/@FINAL@/done/g' -e 's/@W@/64/g' -e 's/@RANGE@/4096/g' -e 's/@RT@/i64/g' | wave-opt --wave-set-target-attr=chip=gfx950 --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=DMA < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e 's/@FINAL@/done/g' -e 's/@W@/64/g' -e 's/@RANGE@/-2147483648/g' -e 's/@RT@/i32/g' | wave-opt --wave-set-target-attr=chip=gfx950 --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=DMA < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e 's/@FINAL@/done/g' -e 's/@W@/64/g' -e 's/@RANGE@/4294967295/g' -e 's/@RT@/i64/g' | wave-opt --wave-set-target-attr=chip=gfx950 --waveamd-lower-buffer-predication --waveamd-dma-zero-fill | wave-translate --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=DMA < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.s -o /dev/null
// RUN: sed -n '/^func.func @buffer_ranges/,/^}/p' %S/Inputs/buffer_predication_ranges.mlir | sed -e 's/@FINAL@/done/g' -e 's/@W@/64/g' -e 's/@RANGE@/-2147483648/g' -e 's/@RT@/i32/g' | wave-opt --wave-set-target-attr=chip=gfx950 --waveamd-lower-buffer-predication --waveamd-dma-zero-fill --wave-generate-index-exprs --waveamd-to-machine | FileCheck %s --check-prefix=DESCRIPTOR

// FLAT-LABEL: buffer_ranges:
// FLAT-NOT: s_and_saveexec
// FLAT: v_cndmask_b32
// FLAT: buffer_load_b32
// FLAT: buffer_store_b32
// FLAT: buffer_store_b32
// FLAT-NOT: s_and_saveexec
// FLAT: s_endpgm
// EXEC-LABEL: buffer_ranges:
// EXEC: s_and_saveexec_b32
// EXEC: buffer_load_b32
// EXEC: buffer_store_b32
// EXEC: s_and_saveexec_b32
// EXEC: buffer_store_b32
// EXEC: s_endpgm
// DMA-LABEL: buffer_ranges:
// DMA-NOT: s_and_saveexec
// DMA: buffer_load_dword
// DMA: buffer_store_dword
// DMA: buffer_store_dword
// DMA: buffer_load_dword {{.*}} lds
// DMA: ds_read_b32
// DMA: buffer_store_dword
// DMA-NOT: s_and_saveexec
// DMA: s_endpgm

// DESCRIPTOR-LABEL: func.func @buffer_ranges
// DESCRIPTOR: waveamdmachine.make_buffer_rsrc
// DESCRIPTOR: [[CHECKED:%.*]] = waveamdmachine.make_buffer_rsrc [[BASE:%.*]], [[RANGE:%.*]] :
// DESCRIPTOR-NEXT: [[STRIDED:%.*]] = waveamdmachine.make_buffer_rsrc [[BASE]], [[RANGE]] {const_add_tid_enable = true, const_stride = 4 : i64}
// DESCRIPTOR: waveamdmachine.buffer_store_b32 {{%.*}}, {{%.*}}, [[STRIDED]],
// DESCRIPTOR: [[MASKED:%.*]] = waveamdmachine.v_cndmask_b32_tuple
// DESCRIPTOR: waveamdmachine.buffer_store_b32 [[MASKED]], {{%.*}}, [[CHECKED]],
// DESCRIPTOR: waveamdmachine.buffer_store_b32 {{%.*}}, {{%.*}}, [[STRIDED]],
