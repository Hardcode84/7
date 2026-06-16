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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_bounded_source_soffset
// SELECT-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// SELECT-DAG: %[[WI:.*]] = waveamdmachine.v_workitem_id_x
// SELECT-DAG: %[[SOFFSET:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[WI]],
// SELECT: %[[ADDR:.*]] = waveamdmachine.v_add_u32 %[[SOFFSET]], %[[VOFFSET]]
// SELECT: waveamdmachine.buffer_load_lds_b128 %[[ADDR]], {{.*}}, %{{.*}},

// ASM-LABEL: buffer_dma_lds_bounded_source_soffset:
// ASM: buffer_load_dwordx4 {{.*}}, 0 offen lds
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_dma_lds_source_const_soffset
// SELECT-DAG: %[[WI:.*]] = waveamdmachine.v_workitem_id_x
// SELECT-DAG: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[WI]],
// SELECT-DAG: %[[SOIMM:.*]] = waveamdmachine.imm 2048
// SELECT: %[[ADDR:.*]] = waveamdmachine.v_add_u32 %[[SOIMM]], %[[VOFFSET]]
// SELECT: waveamdmachine.buffer_load_lds_b128 %[[ADDR]], {{.*}}, %{{.*}},

// ASM-LABEL: buffer_dma_lds_source_const_soffset:
// ASM: buffer_load_dwordx4 {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen lds
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
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
