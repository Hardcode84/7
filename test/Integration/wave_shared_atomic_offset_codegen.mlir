// RUN: sed 's/WAVE_WIDTH/64/g' %S/Inputs/shared_atomic_offset.mlir > %t.mlir
// RUN: wave-opt %t.mlir --wave-generate-index-exprs | FileCheck %s --check-prefix=INDEX
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// INDEX-LABEL: func.func @shared_atomic_offset
// INDEX: [[OFFSET:%.*]] = wave.index_expr
// INDEX: [[PTR:%.*]] = wave.ptr_add {{%.*}}, [[OFFSET]]
// INDEX: [[OLD:%.*]], [[ATOMIC:%.*]] = waveamd.global_atomic_add_acq_rel {{%.*}} to [[PTR]]
// INDEX-NOT: waveamd.global_atomic_add_acq_rel
// INDEX: wave.store [[OLD]]
// INDEX: return
// ASM-LABEL: shared_atomic_offset:
// ASM: global_atomic_add
// ASM-NOT: global_atomic_add
// ASM: buffer_store_dword
// ASM-NOT: buffer_store_dword
// ASM: s_endpgm
