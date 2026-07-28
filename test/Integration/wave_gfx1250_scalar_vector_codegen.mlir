// RUN: wave-opt %s --split-input-file \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --split-input-file --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: FileCheck %s --check-prefix=NOLEGACY < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @gfx1250_scalar_buffer(
// IR: waveamdmachine.s_load_b64
// IR: waveamdmachine.buffer_store_b32
// IR-LABEL: func.func @gfx1250_vector_global(
// IR: waveamdmachine.global_store_b32
// IR-LABEL: func.func @gfx1250_lds(
// IR-SAME: waveamdmachine.lds_size = 128 : i64
// IR: waveamdmachine.ds_store_b32
// IR: waveamdmachine.ds_load_b32
// IR-LABEL: func.func @gfx1250_scratch(
// IR-SAME: wave.regalloc.scratch.dwords
// IR-SAME: waveamdmachine.private_segment_fixed_size = 4 : i64
// IR-SAME: waveamdmachine.vgpr_spill_count = 1 : i64
// IR: waveamdmachine.scratch_store_b32
// IR: waveamdmachine.scratch_load_b32

// ASM-LABEL: gfx1250_scalar_buffer:
// ASM: s_load_b64
// ASM: s_wait_kmcnt 0x0
// ASM: s_lshl_b64 {{.*}}, 57
// ASM: s_lshr_b64 {{.*}}, 7
// ASM: buffer_store_b32
// ASM-LABEL: gfx1250_vector_global:
// ASM: global_store_b32
// ASM-LABEL: gfx1250_lds:
// ASM: ds_store_b32
// ASM: s_wait_dscnt 0x0
// ASM: s_barrier_signal
// ASM: s_barrier_wait
// ASM: ds_load_b32
// ASM: s_wait_dscnt 0x0
// ASM: .amdhsa_group_segment_fixed_size 128
// ASM-LABEL: gfx1250_scratch:
// ASM: scratch_store_b32
// ASM: s_wait_xcnt 0x0
// ASM: buffer_load_b32
// ASM: s_wait_storecnt 0x0
// ASM: s_wait_xcnt 0x0
// ASM: scratch_load_b32
// ASM: s_wait_loadcnt 0x0
// ASM: buffer_store_b32
// ASM: .amdhsa_private_segment_fixed_size 4
// ASM: vgpr_spill_count: 1
// ASM: wave.regalloc.scratch.dwords: 1

// NOLEGACY-NOT: s_waitcnt
// NOLEGACY-NOT: s_waitcnt_vscnt

// DIS-LABEL: <gfx1250_scalar_buffer>:
// DIS: s_load_b64
// DIS: s_wait_kmcnt 0x0
// DIS: buffer_store_b32
// DIS-LABEL: <gfx1250_vector_global>:
// DIS: global_store_b32
// DIS-LABEL: <gfx1250_lds>:
// DIS: ds_store_b32
// DIS: s_wait_dscnt 0x0
// DIS: ds_load_b32
// DIS-LABEL: <gfx1250_scratch>:
// DIS: scratch_store_b32
// DIS: scratch_load_b32

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_scalar_buffer(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                waveamdmachine.kernarg_preload_length = 0 : i64} {
  %range = arith.constant 1024 : i32
  %workgroup_raw = wave.workgroup_id 0
  %workgroup = wave.assume %workgroup_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %tile = wave.index_expr <"256*x"> ["x"](%workgroup) : (i32) -> index
  %base = wave.ptr_add %out, %tile
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %stored = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_vector_global(
    %out: !wave.ptr<#wave.global, i32>, %raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %x = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 4095">] : i32
  %offset =
      wave.index_expr <"1073741824 + floor(1/512*Mod(8*x, 1024)) + lid">
      ["lid", "x"](%lane, %x)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_lds(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %lds_ptr = wave.ptr_add %allocation, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %lds_ptr
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %ready = wave.barrier %stored : (!wave.mem.token) -> !wave.mem.token
  %value, %loaded = wave.load %lds_ptr after %ready
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %global_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %done = wave.store %value -> %global_ptr after %loaded
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_scratch(
    %in: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>,
    %raw: i32)
    attributes {wave.kernel,
                waveamdmachine.vgpr_count_max = 2 : i64} {
  %range = arith.constant 128 : i32
  %offset = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit_scalar = arith.constant 16 : i32
  %limit = wave.splat %limit_scalar : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %lane, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active = wave.index_expr <"x + lid"> ["x", "lid"](%offset, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %oob_scalar = arith.constant 1073741824 : index
  %oob = wave.index_expr <"floor(1/2*x)">
      assuming [#wave.pred<"x >= 0">] ["x"](%oob_scalar)
      : (index) -> index
  %oob_vector = wave.splat %oob : index -> !wave.simd<index, 32>
  %active_ptr = wave.ptr_add %buffer, %active
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %oob_ptr = wave.ptr_add %buffer, %oob_vector
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %selected = wave.select %mask, %active_ptr, %oob_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %value, %loaded = wave.load %selected
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %out_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %out_ptr after %loaded
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
