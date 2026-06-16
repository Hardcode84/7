// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-insert-hazard-waits --waveamd-resource-info --waveamd-metadata %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// A scalar wave.load through a per-lane address lowers to a single
// global_load_dword. The op carries both a VGPR result and a memory
// token; the token feeds the eventual store dependency edge.
// SELECT-LABEL: func.func @scalar_load_kernel
// SELECT: waveamdmachine.global_load_b32{{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)

// PIPELINE-LABEL: func.func @scalar_load_kernel
// PIPELINE: waveamdmachine.global_load_b32

// ASM-LABEL: scalar_load_kernel:
// ASM: global_load_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}
// ASM: s_endpgm
func.func @scalar_load_kernel(%in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %op = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v, %tok = wave.load %ip : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %st = wave.store %v -> %op after %tok : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// A tuple wave.load selects a tuple op; backend start decomposes it to
// wide chunks before asm.
// SELECT-LABEL: func.func @tuple_load_kernel
// SELECT: waveamdmachine.global_load_tuple_b32{{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token)

// PIPELINE-LABEL: func.func @tuple_load_kernel
// PIPELINE: waveamdmachine.global_load_tuple_b32{{.*}} -> (!waveamdmachine.reg<vgpr, 8,

// ASM-LABEL: tuple_load_kernel:
// ASM: global_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}{{$}}
// ASM: global_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM: s_endpgm
func.func @tuple_load_kernel(%in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %base = arith.constant 0 : i32
  %op = wave.ptr_add %out, %base : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %v, %tok = wave.load %ip : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.binary muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %op, %lane_off : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %st = wave.store %regs -> %tuple_ptr after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// fragment_pack is a no-op at the WaveAMDMachine level: the per-lane VGPR
// tuple is reused as-is, so the selector never emits a fresh
// waveamdmachine.* op for it.
// SELECT-LABEL: func.func @fragment_pack_is_noop
// SELECT-NOT: waveamdmachine.fragment_pack
// SELECT: waveamdmachine.s_endpgm
func.func @fragment_pack_is_noop(%in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %base = arith.constant 0 : i32
  %op = wave.ptr_add %out, %base : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %v, %tok = wave.load %ip : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.binary muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %op, %lane_off : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %st = wave.store %regs -> %tuple_ptr after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
