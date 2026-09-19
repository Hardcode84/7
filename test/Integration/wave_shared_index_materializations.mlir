// RUN: wave-opt %s --wave-generate-index-exprs --canonicalize --cse -o %t.once
// RUN: wave-opt %t.once --wave-generate-index-exprs --canonicalize --cse -o %t.twice
// RUN: diff %t.once %t.twice
// RUN: wave-opt %s --wave-generate-index-exprs | FileCheck %s --check-prefix=CAPTURE
// RUN: wave-opt %s --wave-generate-index-exprs --wave-materialize-memory-variants --canonicalize | FileCheck %s --check-prefix=MATERIALIZE
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null

// CAPTURE-LABEL: func.func @shared_index_materializations
// CAPTURE: [[FIRST:%.*]] = wave.store
// CAPTURE-NEXT: [[FIRST_ALT:%.*]] = wave.store {{.*}}
// CAPTURE-NEXT: [[FIRST_CHOICE:%.*]] = wave.materialization_variants [[FIRST]], [[FIRST_ALT]]
// CAPTURE-NEXT: [[SECOND:%.*]] = wave.store
// CAPTURE-NEXT: [[SECOND_ALT:%.*]] = wave.store {{.*}}
// CAPTURE-NEXT: [[SECOND_CHOICE:%.*]] = wave.materialization_variants [[SECOND]], [[SECOND_ALT]]
// CAPTURE-NEXT: return [[FIRST_CHOICE]], [[SECOND_CHOICE]]
// MATERIALIZE-LABEL: func.func @shared_index_materializations
// MATERIALIZE: wave.store
// MATERIALIZE-NEXT: wave.store {{.*}}
// MATERIALIZE-NEXT: {{%.*}} = wave.materialization_variants
// MATERIALIZE: wave.store
// MATERIALIZE-NEXT: wave.store {{.*}}
// MATERIALIZE-NEXT: {{%.*}} = wave.materialization_variants
// MATERIALIZE-NOT: wave.materialization_variants {{.*}}!wave.ptr
// ASM-LABEL: shared_index_materializations:
// ASM-COUNT-2: buffer_store_b32
// ASM-NOT: buffer_store_b32
// ASM: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @shared_index_materializations(
      %first: !wave.ptr<#wave.global, i32>,
      %second: !wave.ptr<#wave.global, i32>) -> (!wave.mem.token, !wave.mem.token)
      attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %x = wave.lane_id : !wave.simd<i32, 32>
    %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
    %offset = wave.binary addi %x, %one overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %a = wave.ptr_add %first, %offset
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %b = wave.ptr_add %second, %offset
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %ta = wave.store %x -> %a
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    %tb = wave.store %x -> %b
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
    return %ta, %tb : !wave.mem.token, !wave.mem.token
  }
}
