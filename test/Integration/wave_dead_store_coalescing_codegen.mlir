// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: dead_store_tokens_coalesce:
// ASM-NOT: buffer_store_dword {{.*}}
// ASM: buffer_store_dwordx2
// ASM-NOT: buffer_store_dword {{.*}}
// ASM: s_endpgm

// ASM-LABEL: live_store_token_stays:
// ASM-NOT: buffer_store_dwordx2
// ASM-COUNT-2: buffer_store_dword
// ASM-NOT: buffer_store_dwordx2
// ASM: s_barrier
// ASM: s_endpgm

// ASM-LABEL: different_store_dependencies_stay:
// ASM-NOT: buffer_store_dwordx2
// ASM-COUNT-2: buffer_store_dword
// ASM-NOT: buffer_store_dwordx2
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @dead_store_tokens_coalesce(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %ptr1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %root = wave.token : !wave.mem.token
  %first = wave.store %lane -> %ptr0 after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %lane -> %ptr1 after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @live_store_token_stays(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %ptr1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %root = wave.token : !wave.mem.token
  %first = wave.store %lane -> %ptr0 after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %lane -> %ptr1 after %root
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %barrier = wave.barrier %first : (!wave.mem.token) -> !wave.mem.token
  return
}

func.func @different_store_dependencies_stay(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %ptr1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %root0 = wave.token : !wave.mem.token
  %root1 = wave.token : !wave.mem.token
  %first = wave.store %lane -> %ptr0 after %root0
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %lane -> %ptr1 after %root1
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
