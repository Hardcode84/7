// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --wave-coalesce-memory %s \
// RUN:   | FileCheck %s --check-prefix=IR

// IR-LABEL: func.func @dead_store_tokens_coalesce
// IR: [[PACK:%.*]] = wave.pack
// IR: wave.store [[PACK]]
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

// IR-LABEL: func.func @equivalent_empty_dependencies_coalesce
// IR: [[ROOT:%.*]] = wave.token
// IR: wave.token
// IR: [[EMPTY_PACK:%.*]] = wave.pack
// IR: wave.store [[EMPTY_PACK]] {{.*}} after [[ROOT]]
// ASM-LABEL: equivalent_empty_dependencies_coalesce:
// ASM-NOT: buffer_store_dword {{.*}}
// ASM: buffer_store_dwordx2
// ASM-NOT: buffer_store_dword {{.*}}
// ASM: s_endpgm

// IR-LABEL: func.func @distinct_load_dependencies_stay
// IR: %{{.*}}, [[DEP0:%.*]] = wave.load
// IR: %{{.*}}, [[DEP1:%.*]] = wave.load
// IR-NOT: wave.pack
// IR: wave.store {{.*}} after [[DEP0]]
// IR: wave.store {{.*}} after [[DEP1]]
// ASM-LABEL: distinct_load_dependencies_stay:
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
  %bounded_lane = wave.assume %lane as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%bounded_lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%bounded_lane)
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
  %bounded_lane = wave.assume %lane as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%bounded_lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%bounded_lane)
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

func.func @equivalent_empty_dependencies_coalesce(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_lane = wave.assume %lane as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%bounded_lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%bounded_lane)
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

func.func @distinct_load_dependencies_stay(
    %in0: !wave.ptr<#wave.global, i32>,
    %in1: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_lane = wave.assume %lane as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %off0 = wave.index_expr <"item"> ["item"](%bounded_lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %off1 = wave.index_expr <"item + 1"> ["item"](%bounded_lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %ptr1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %unused0, %dep0 = wave.load %in0
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %unused1, %dep1 = wave.load %in1
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %first = wave.store %lane -> %ptr0 after %dep0
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  %second = wave.store %lane -> %ptr1 after %dep1
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
