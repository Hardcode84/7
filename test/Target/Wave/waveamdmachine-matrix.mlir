// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-insert-hazard-waits --waveamd-resource-info --waveamd-metadata %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @matrix_kernel
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: %[[MMA:.+]] = waveamdmachine.wmma_i32_16x16x16_iu8{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: %[[LANE:.+]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[ELEM_STRIDE:.+]] = waveamdmachine.imm 8
// SELECT: %[[ELEM_OFF:.+]] = waveamdmachine.v_mul_lo_u32 %[[LANE]], %[[ELEM_STRIDE]]
// SELECT: %[[DWORD_SHIFT:.+]] = waveamdmachine.imm 2
// SELECT: %[[BYTE_OFF:.+]] = waveamdmachine.v_lshlrev_b32 %[[ELEM_OFF]], %[[DWORD_SHIFT]]
// SELECT: waveamdmachine.global_store_tuple_b32 %[[BYTE_OFF]], %[[MMA]]

// PIPELINE: module attributes {{{.*}}waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"{{.*}}}
// PIPELINE-LABEL: func.func @matrix_kernel
// PIPELINE-SAME: waveamdmachine.metadata
// PIPELINE-SAME: waveamdmachine.vgpr_count
// PIPELINE: waveamdmachine.wmma_i32_16x16x16_iu8{{.*}} -> !waveamdmachine.reg<vgpr, 8,
// PIPELINE: waveamdmachine.global_store_tuple_b32

// ASM-LABEL: matrix_kernel:
// ASM: v_mov_b32_e32 [[A0:v[0-9]+]], 0
// ASM: v_mov_b32_e32 [[B0:v[0-9]+]], 0
// ASM: v_mov_b32_e32 [[C0:v[0-9]+]], 7
// ASM: v_wmma_i32_16x16x16_iu8 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]]
// ASM: s_load_b64 [[OUT:s\[[0-9]+:[0-9]+\]]], s[0:1], 0x0
// ASM: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, [[OUT]]{{$}}
// ASM: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, [[OUT]] offset:16
// ASM: s_waitcnt_vscnt null, 0x0
// ASM: s_endpgm
func.func @matrix_kernel(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %seven = arith.constant 7 : i32
  %base = arith.constant 0 : i32
  %ptr = wave.ptr_add %out, %base : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #wave.global>
  %a = waveamd.fragment_fill %zero : i32 -> !waveamd.fragment<0, i8, 16, 16, 32, 4>
  %b = waveamd.fragment_fill %zero : i32 -> !waveamd.fragment<1, i8, 16, 16, 32, 4>
  %acc = waveamd.fragment_fill %seven : i32 -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.i32.16x16x16.iu8" %a, %b, %acc : !waveamd.fragment<0, i8, 16, 16, 32, 4>, !waveamd.fragment<1, i8, 16, 16, 32, 4>, !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !waveamd.fragment<2, i32, 16, 16, 32, 8>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %ptr, %lane_off : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %regs = waveamd.fragment_unpack %result : !waveamd.fragment<2, i32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %store_token = wave.store %regs -> %tuple_ptr : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @matrix_f16_kernel
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.v_mov_b32_tuple{{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
// SELECT: waveamdmachine.wmma_f32_16x16x16_f16{{.*}} : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>

// PIPELINE-LABEL: func.func @matrix_f16_kernel
// PIPELINE-SAME: waveamdmachine.metadata
// PIPELINE: waveamdmachine.wmma_f32_16x16x16_f16{{.*}} -> !waveamdmachine.reg<vgpr, 8,

// ASM-LABEL: matrix_f16_kernel:
// ASM: v_wmma_f32_16x16x16_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]]
// ASM: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}}{{$}}
// ASM: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM: s_endpgm
func.func @matrix_f16_kernel(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %seven_as_f32_bits = arith.constant 1088421888 : i32
  %base = arith.constant 0 : i32
  %ptr = wave.ptr_add %out, %base : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #wave.global>
  %a = waveamd.fragment_fill %zero : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 8>
  %b = waveamd.fragment_fill %zero : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %seven_as_f32_bits : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.f32.16x16x16.f16" %a, %b, %acc : !waveamd.fragment<0, f16, 16, 16, 32, 8>, !waveamd.fragment<1, f16, 16, 16, 32, 8>, !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %ptr, %lane_off : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %regs = waveamd.fragment_unpack %result : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %store_token = wave.store %regs -> %tuple_ptr : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

}
