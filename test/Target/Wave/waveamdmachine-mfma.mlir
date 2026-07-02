// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @mfma_gfx950_f16xf32_kernel
// SELECT: waveamdmachine.mfma_f32_16x16x32_f16{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_gfx950_f16xf32_kernel
// PIPELINE: waveamdmachine.mfma_f32_16x16x32_f16{{.*}} -> !waveamdmachine.reg<vgpr, 4,

// ASM-LABEL: mfma_gfx950_f16xf32_kernel:
// ASM: v_mfma_f32_16x16x32_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], 0
func.func @mfma_gfx950_f16xf32_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma "mfma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 64, 4>,
        !waveamd.fragment<1, f16, 16, 16, 64, 4>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %mask = arith.constant 63 : i32
  %mask_simd = wave.splat %mask : i32 -> !wave.simd<i32, 64>
  %lane = wave.binary andi %wi, %mask_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %r = arith.constant 4 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_f16_32x32x16_kernel
// SELECT: waveamdmachine.mfma_f32_32x32x16_f16{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 16>

// PIPELINE-LABEL: func.func @mfma_gfx950_f16_32x32x16_kernel
// PIPELINE: waveamdmachine.mfma_f32_32x32x16_f16{{.*}} -> !waveamdmachine.reg<vgpr, 16,

// ASM-LABEL: mfma_gfx950_f16_32x32x16_kernel:
// ASM: v_mfma_f32_32x32x16_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], 0
func.func @mfma_gfx950_f16_32x32x16_kernel(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 32, 32, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 32, 32, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %result = waveamd.mma "mfma.f32.32x32x16.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 32, 32, 64, 4>,
        !waveamd.fragment<1, f16, 32, 32, 64, 4>,
        !waveamd.fragment<2, f32, 32, 32, 64, 16>
     -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %r = arith.constant 16 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %wi, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 32, 32, 64, 16>
      -> !wave.simd<vector<16xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<16xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_mxfp4_kernel
// SELECT: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_gfx950_mxfp4_kernel
// PIPELINE: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4{{.*}} -> !waveamdmachine.reg<vgpr, 4,

// ROUNDTRIP-LABEL: func.func @mfma_gfx950_mxfp4_kernel
// ROUNDTRIP: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" {{.*}} {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64}

// ASM-LABEL: mfma_gfx950_mxfp4_kernel:
// ASM: v_mfma_scale_f32_16x16x128_f8f6f4 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]], [[SA:v[0-9]+]], [[SB:v[0-9]+]] op_sel:[1,0,0] op_sel_hi:[0,1,0] cbsz:4 blgp:4
func.func @mfma_gfx950_mxfp4_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %scale_bits = arith.constant 2139062143 : i32
  %scale = wave.splat %scale_bits : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %scale, %acc {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64}
      : !waveamd.fragment<0, i8, 16, 16, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<1, i8, 16, 16, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %mask = arith.constant 63 : i32
  %mask_simd = wave.splat %mask : i32 -> !wave.simd<i32, 64>
  %lane = wave.binary andi %wi, %mask_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %r = arith.constant 4 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_mxfp4_transposed_scale_kernel
// SELECT: %[[TR:.*]], %[[TOK:.*]] = waveamdmachine.ds_read_tr_b64_b8
// SELECT-NEXT: %[[SPLIT:.*]]:2 = waveamdmachine.tuple_to_elements %[[TR]]
// SELECT-NEXT: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 {{.*}}, %[[SPLIT]]#0, %[[SPLIT]]#0 : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>

// ASM-LABEL: mfma_gfx950_mxfp4_transposed_scale_kernel:
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: v_mfma_scale_f32_16x16x128_f8f6f4 {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{v[0-9]+}} op_sel_hi:[0,0,0] cbsz:4 blgp:4
func.func @mfma_gfx950_mxfp4_transposed_scale_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, waveamdmachine.lds_size = 512 : i64} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %scale_ptr = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %scale, %tok = waveamd.transpose_load %scale_ptr
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %a, %scale, %b, %scale, %acc
      : !waveamd.fragment<0, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<1, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %four = arith.constant 4 : i32
  %four_simd = wave.splat %four : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %four_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr after %tok
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
        -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_bf16xf32_kernel
// SELECT: waveamdmachine.mfma_f32_16x16x32_bf16{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_gfx950_bf16xf32_kernel
// PIPELINE: waveamdmachine.mfma_f32_16x16x32_bf16{{.*}} -> !waveamdmachine.reg<vgpr, 4,

// ASM-LABEL: mfma_gfx950_bf16xf32_kernel:
// ASM: v_mfma_f32_16x16x32_bf16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], 0
func.func @mfma_gfx950_bf16xf32_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, bf16, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, bf16, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma "mfma.f32.16x16x32.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 16, 16, 64, 4>,
        !waveamd.fragment<1, bf16, 16, 16, 64, 4>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %mask = arith.constant 63 : i32
  %mask_simd = wave.splat %mask : i32 -> !wave.simd<i32, 64>
  %lane = wave.binary andi %wi, %mask_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %r = arith.constant 4 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_bf16_32x32x16_kernel
// SELECT: waveamdmachine.mfma_f32_32x32x16_bf16{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 16>

// PIPELINE-LABEL: func.func @mfma_gfx950_bf16_32x32x16_kernel
// PIPELINE: waveamdmachine.mfma_f32_32x32x16_bf16{{.*}} -> !waveamdmachine.reg<vgpr, 16,

// ASM-LABEL: mfma_gfx950_bf16_32x32x16_kernel:
// ASM: v_mfma_f32_32x32x16_bf16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], 0
func.func @mfma_gfx950_bf16_32x32x16_kernel(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %result = waveamd.mma "mfma.f32.32x32x16.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 32, 32, 64, 4>,
        !waveamd.fragment<1, bf16, 32, 32, 64, 4>,
        !waveamd.fragment<2, f32, 32, 32, 64, 16>
     -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %r = arith.constant 16 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %wi, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 32, 32, 64, 16>
      -> !wave.simd<vector<16xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<16xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// ASM-LABEL: gfx950_literal_mul_kernel:
// ASM: v_mov_b32_e32 [[IMM:v[0-9]+]], 0x100
// ASM: v_mul_lo_u32 [[MUL:v[0-9]+]], [[IMM]], {{[vs][0-9]+}}
func.func @gfx950_literal_mul_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %c256 = arith.constant 256 : i32
  %v256 = wave.splat %c256 : i32 -> !wave.simd<i32, 64>
  %value = wave.binary muli %v256, %wi
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %store_token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @mfma_gfx950_mxfp4_scale_byte_pack_kernel
// SELECT-NOT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.mfma_scale_f32_16x16x128_f4_f4{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
func.func @mfma_gfx950_mxfp4_scale_byte_pack_kernel(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero_i32 = arith.constant 0 : i32
  %z = wave.constant 0 : i8 -> !wave.simd<i8, 64>
  %a0 = wave.constant 1 : i8 -> !wave.simd<i8, 64>
  %a1 = wave.constant 2 : i8 -> !wave.simd<i8, 64>
  %a2 = wave.constant 3 : i8 -> !wave.simd<i8, 64>
  %a3 = wave.constant 4 : i8 -> !wave.simd<i8, 64>
  %b0 = wave.constant 5 : i8 -> !wave.simd<i8, 64>
  %b1 = wave.constant 6 : i8 -> !wave.simd<i8, 64>
  %b2 = wave.constant 7 : i8 -> !wave.simd<i8, 64>
  %b3 = wave.constant 8 : i8 -> !wave.simd<i8, 64>
  %scale_a = wave.pack %a0, %a1, %a2, %a3, %z, %z, %z, %z :
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<8xi8>, 64>
  %scale_b = wave.pack %b0, %b1, %b2, %b3, %z, %z, %z, %z :
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>
      -> !wave.simd<vector<8xi8>, 64>
  %a = waveamd.fragment_fill %zero_i32
      : i32 -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero_i32
      : i32 -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero_i32
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
      %a, %scale_a, %b, %scale_b, %acc
      : !waveamd.fragment<0, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<1, i8, 16, 16, 64, 4>,
        !wave.simd<vector<8xi8>, 64>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %four = arith.constant 4 : i32
  %four_simd = wave.splat %four : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %four_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

}
