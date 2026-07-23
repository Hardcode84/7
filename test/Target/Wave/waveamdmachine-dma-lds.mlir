// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --split-input-file --waveamd-to-machine %s | wave-opt --split-input-file | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --split-input-file --waveamd-to-machine %s | wave-translate --split-input-file --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --split-input-file --waveamd-to-machine %s | wave-translate --split-input-file --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @global_dma_lds
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.global_load_lds_b32
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dword
func.func @global_dma_lds(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_b128
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_b128:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_b128(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_uniform_mul_dest
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_uniform_mul_dest:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_uniform_mul_dest(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %first = wave.read_first %wi : !wave.simd<i32, 64> -> i32
  %off = wave.index_expr <"512*floor(1/64*wi_first)"> ["wi_first"](%first)
      : (i32) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_uniform_dest_add
// SELECT: waveamdmachine.imm 1024
// SELECT: [[M0SRC:%[A-Za-z0-9_]+]] = waveamdmachine.s_mov_b32_value %{{[A-Za-z0-9_]+}}
// SELECT-NEXT: [[M0:%[A-Za-z0-9_]+]] = waveamdmachine.s_mov_m0 [[M0SRC]]
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_uniform_dest_add:
// ASM: s_mov_b32 [[M0SRC:s[0-9]+]], 0x400
// ASM-NEXT: s_mov_b32 m0, [[M0SRC]]
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_uniform_dest_add(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %first = wave.read_first %wi : !wave.simd<i32, 64> -> i32
  %off = wave.index_expr <"256 + 512*floor(1/64*wi_first)"> ["wi_first"](%first)
      : (i32) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_uniform_dest_sadd_m0
// SELECT: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: %[[SCALED:.*]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT: %[[C:.*]] = waveamdmachine.imm 1024
// SELECT: %[[M0:.*]], %{{.*}} = waveamdmachine.s_add_m0_i32 %[[SCALED]], %[[C]]
// SELECT-NOT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: %[[M0]]

// ASM-LABEL: global_dma_lds_uniform_dest_sadd_m0:
// ASM: s_lshl_b32 [[SCALED:s[0-9]+]], s{{[0-9]+}}, 2
// ASM: s_add_i32 m0, [[SCALED]], 0x400
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_uniform_dest_sadd_m0(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32)
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %u = wave.assume %u_raw as "u" [#wave.pred<"u >= 0">, #wave.pred<"u <= 255">] : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"u + 256"> ["u"](%u) : (i32) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_intconvert_range_m0
// SELECT-NOT: waveamdmachine.s_add_u64
// SELECT-NOT: waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_intconvert_range_m0:
// ASM-NOT: s_addc_u32
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_intconvert_range_m0(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 16384 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 255">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %first = wave.read_first %wi : !wave.simd<i32, 64> -> i32
  %derived = wave.index_expr <"1040*floor(1/64*w)"> ["w"](%first)
      : (i32) -> index
  %base = wave.cast intconvert %derived : index -> i32
  %off = wave.index_expr <"byte_base"> ["byte_base"](%base)
      : (i32) -> index
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index
      -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_wrapping_intconvert_wide_m0
// SELECT: waveamdmachine.s_add_u64
// SELECT: %[[CAST_M0:.*]]:2 = waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.s_mov_m0 %[[CAST_M0]]#0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_wrapping_intconvert_wide_m0:
// ASM: s_addc_u32
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_wrapping_intconvert_wide_m0(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 16384 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 127">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %first = wave.read_first %wi : !wave.simd<i32, 64> -> i32
  %derived = wave.index_expr <"2147483647 + floor(1/64*w)"> ["w"](%first)
      : (i32) -> index
  %base = wave.cast intconvert %derived : index -> i32
  %off = wave.index_expr <"byte_base"> ["byte_base"](%base)
      : (i32) -> index
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index
      -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_wide_uniform_dest_m0
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.s_lshr_b64
// SELECT: %[[M0SRC:.*]]:2 = waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.s_mov_m0 %[[M0SRC]]#0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_wide_uniform_dest_m0:
// ASM: s_lshr_b64
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_wide_uniform_dest_m0(
    %in: !wave.ptr<#wave.global, i32>, %x_raw: i64)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1099511627775">] : i64
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"floor(1/8*x)"> ["x"](%x) : (i64) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_i64_fit_dest_m0
// SELECT: %[[X:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: %[[FOUR:.*]] = waveamdmachine.s_mov_b64_imm 4
// SELECT: %[[SCALED:.*]], %{{.*}}, %{{.*}} = waveamdmachine.s_mul_u64 %[[FOUR]], %[[X]]
// SELECT: %[[LOW:.*]]:2 = waveamdmachine.tuple_to_elements %[[SCALED]]
// SELECT: waveamdmachine.s_mov_m0 %[[LOW]]#0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_i64_fit_dest_m0:
// ASM: s_mul_i32
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_i64_fit_dest_m0(
    %in: !wave.ptr<#wave.global, i32>, %x_raw: i64)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 127">] : i64
  %off = wave.index_expr <"x"> ["x"](%x) : (i64) -> index
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_uniform_dest_split_remainder_m0
// SELECT-DAG: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT-DAG: waveamdmachine.arg {index = 2 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.s_add_u64
// SELECT: %[[M0SRC:.*]]:2 = waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.s_mov_m0 %[[M0SRC]]#0
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_uniform_dest_split_remainder_m0:
// ASM: s_add_u32
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_uniform_dest_split_remainder_m0(
    %in: !wave.ptr<#wave.global, i32>, %a_raw: i64, %b_raw: i64)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %a = wave.assume %a_raw as "a" [#wave.pred<"a >= 0">, #wave.pred<"a <= 1073741823">] : i64
  %b = wave.assume %b_raw as "b" [#wave.pred<"b >= 0">, #wave.pred<"b <= 1073741823">] : i64
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"a + b"> ["a", "b"](%a, %b) : (i64, i64) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_wide_source_base_adjust
// SELECT: waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: %[[VOFF:.*]]:2 = waveamdmachine.tuple_to_elements
// SELECT: waveamdmachine.global_load_lds_b128 %[[VOFF]]#0,
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: global_dma_lds_wide_source_base_adjust:
// ASM: v_lshrrev_b64
// ASM: global_load_lds_dwordx4
func.func @global_dma_lds_wide_source_base_adjust(
    %in: !wave.ptr<#wave.global, i32>, %x_raw: i64)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1099511627775">] : i64
  %src_off = wave.index_expr <"floor(1/4294967296*x) + w"> ["w", "x"](%wi, %x)
      : (!wave.simd<i32, 64>, i64) -> !wave.simd<index, 64>
  %src = wave.ptr_add %in, %src_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_addr64_fallback
// SELECT-NOT: waveamdmachine.global_load_lds_b128
// SELECT-NOT: waveamdmachine.s_mov_m0
// SELECT-NOT: waveamdmachine.s_add_m0_i32
// SELECT: waveamdmachine.v_mbcnt_lo
// SELECT: waveamdmachine.v_mbcnt_hi
// SELECT: waveamdmachine.global_load_b32_addr64
// SELECT: waveamdmachine.global_load_b32_addr64
// SELECT: waveamdmachine.global_load_b32_addr64
// SELECT: waveamdmachine.global_load_b32_addr64
// SELECT: waveamdmachine.ds_store_tuple_b32
// SELECT-NOT: waveamdmachine.s_mov_m0
// SELECT-NOT: waveamdmachine.s_add_m0_i32
func.func @global_dma_lds_addr64_fallback(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"4294967296*w"> ["w"](%wi)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %in, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_dma_lds_source_const_offset
// SELECT: waveamdmachine.global_load_lds_b128
// SELECT-SAME: after %{{[A-Za-z0-9_]+}} :

// ASM-LABEL: global_dma_lds_source_const_offset:
// ASM: s_mov_b32 m0,
// ASM: global_load_lds_dwordx4
// ASM-NOT: offset:
func.func @global_dma_lds_source_const_offset(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src_off = wave.index_expr <"64 + wi"> ["wi"](%wi)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %in, %src_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.buffer_load_lds_b32
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: buffer_dma_lds:
// ASM: s_mov_b32 m0,
// ASM: buffer_load_dword {{.*}} lds
func.func @buffer_dma_lds(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %buffer, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_b128
// SELECT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.buffer_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: buffer_dma_lds_b128:
// ASM: s_mov_b32 m0,
// ASM: buffer_load_dwordx4 {{.*}} lds
func.func @buffer_dma_lds_b128(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %buffer, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_uniform_dest_sadd_m0
// SELECT: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// SELECT: %[[SCALED:.*]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT: %[[C:.*]] = waveamdmachine.imm 1024
// SELECT: %[[M0:.*]], %{{.*}} = waveamdmachine.s_add_m0_i32 %[[SCALED]], %[[C]]
// SELECT-NOT: waveamdmachine.s_mov_m0
// SELECT: waveamdmachine.buffer_load_lds_b128
// SELECT-SAME: %[[M0]]

// ASM-LABEL: buffer_dma_lds_uniform_dest_sadd_m0:
// ASM: s_lshl_b32 [[SCALED:s[0-9]+]], s{{[0-9]+}}, 2
// ASM: s_add_i32 m0, [[SCALED]], 0x400
// ASM: buffer_load_dwordx4 {{.*}} lds
func.func @buffer_dma_lds_uniform_dest_sadd_m0(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32)
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %src = wave.ptr_add %buffer, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %u = wave.assume %u_raw as "u" [#wave.pred<"u >= 0">, #wave.pred<"u <= 255">] : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %off = wave.index_expr <"u + 256"> ["u"](%u) : (i32) -> index
  %dst = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_bounded_source_soffset
// SELECT-DAG: %[[DESC:.*]] = waveamdmachine.make_buffer_rsrc
// SELECT-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// SELECT-DAG: %[[WI:.*]] = waveamdmachine.v_workitem_id_x
// SELECT-DAG: %[[SOFFSET:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT-DAG: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[WI]],
// SELECT: waveamdmachine.buffer_load_lds_b128 %[[VOFFSET]], %[[DESC]], %[[SOFFSET]],

// ASM-LABEL: buffer_dma_lds_bounded_source_soffset:
// ASM: buffer_load_dwordx4 {{.*}}, s{{[0-9]+}} offen lds
func.func @buffer_dma_lds_bounded_source_soffset(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"wi + 16*u"> ["wi", "u"](%wi, %u)
      : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_lane_terms_before_uniform
// SELECT-DAG: %[[DESC:.*]] = waveamdmachine.make_buffer_rsrc
// SELECT-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// SELECT-DAG: %[[USCALED:.*]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT-DAG: %[[X4:.*]] = waveamdmachine.v_lshlrev_b32
// SELECT-DAG: %[[Y4:.*]] = waveamdmachine.v_lshlrev_b32
// SELECT-DAG: %[[Z4:.*]] = waveamdmachine.v_lshlrev_b32
// SELECT-DAG: %[[XY:.*]] = waveamdmachine.v_add_u32 %[[X4]], %[[Y4]]
// SELECT-DAG: %[[XYZ:.*]] = waveamdmachine.v_add_u32 %[[XY]], %[[Z4]]
// SELECT: waveamdmachine.buffer_load_lds_b128 %[[XYZ]], %[[DESC]], %[[USCALED]],

// ASM-LABEL: buffer_dma_lds_lane_terms_before_uniform:
// ASM: buffer_load_dwordx4 {{.*}}, s{{[0-9]+}} offen lds
func.func @buffer_dma_lds_lane_terms_before_uniform(
    %in: !wave.ptr<#wave.global, i32>, %u_raw: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 8192 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %u = wave.assume %u_raw as "u" [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %x_raw = wave.lane_id : !wave.simd<i32, 64>
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %v1 = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %v2 = wave.splat %c2 : i32 -> !wave.simd<i32, 64>
  %y_raw = wave.binary addi %x, %v1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %y = wave.assume %y_raw as "y" [#wave.pred<"y >= 0">, #wave.pred<"y <= 64">] : !wave.simd<i32, 64>
  %z_raw = wave.binary addi %x, %v2
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %z = wave.assume %z_raw as "z" [#wave.pred<"z >= 0">, #wave.pred<"z <= 65">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"x + y + z + 16*u"> ["u", "x", "y", "z"](%u, %x, %y, %z)
      : (i32, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>)
      -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_source_const_soffset
// SELECT-DAG: %[[DESC:.*]] = waveamdmachine.make_buffer_rsrc
// SELECT-DAG: %[[WI:.*]] = waveamdmachine.v_workitem_id_x
// SELECT-DAG: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[WI]],
// SELECT-DAG: %[[SOIMM:.*]] = waveamdmachine.imm 2048
// SELECT: %[[SOFFSET:.*]] = waveamdmachine.s_mov_b32_value %[[SOIMM]]
// SELECT: waveamdmachine.buffer_load_lds_b128 %[[VOFFSET]], %[[DESC]], %[[SOFFSET]],

// ASM-LABEL: buffer_dma_lds_source_const_soffset:
// ASM: buffer_load_dwordx4 {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], s{{[0-9]+}} offen lds
func.func @buffer_dma_lds_source_const_soffset(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"512 + wi"> ["wi"](%wi)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_composed_source_assumption
// SELECT: waveamdmachine.v_mul_u64
// SELECT: waveamdmachine.buffer_load_lds_b128
// SELECT-SAME: !waveamdmachine.m0

// ASM-LABEL: buffer_dma_lds_composed_source_assumption:
// ASM: buffer_load_dwordx4 {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen lds
func.func @buffer_dma_lds_composed_source_assumption(
    %in: !wave.ptr<#wave.global, i8>, %u_raw: i64)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %u = wave.assume %u_raw as "u" [#wave.pred<"u >= 0">] : i64
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w" [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">] : !wave.simd<i32, 64>
  %off = wave.index_expr <"128 + 64*u + w">
      assuming [#wave.pred<"128 + 64*u + w >= 0 & -2147483647 + 128 + 64*u + w <= 0">]
      ["u", "w"](%u, %wi) : (i64, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %buffer, %off
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
