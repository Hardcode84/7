// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-wavemachine --waveamd-abi-lowering --waveamd-reg-alloc %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @buffer_store_kernel
// SELECT: wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
// SELECT: wavemachine.make_buffer_rsrc
// SELECT: wavemachine.buffer_store_b32

// PIPELINE-LABEL: func.func @buffer_store_kernel
// PIPELINE: wavemachine.s_load_b64
// PIPELINE: wavemachine.make_buffer_rsrc
// PIPELINE: wavemachine.buffer_store_b32
// PIPELINE-SAME: !wavemachine.reg<sgpr, 4,

// ASM-LABEL: buffer_store_kernel:
// ASM: s_load_b64
// ASM: s_mov_b32
// ASM: buffer_store_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_store_kernel(%out: !wave.ptr<i32, #wave.global>, %x: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %sum = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  return
}

// Single-dword `wave.load` through a buffer pointer: the selector lowers
// it to `wavemachine.buffer_load_b32`, and the AMDGPU printer emits a
// `buffer_load_dword ..., 0 offen` (no offset suffix for component 0).
// SELECT-LABEL: func.func @buffer_load_kernel
// SELECT: wavemachine.make_buffer_rsrc
// SELECT: wavemachine.buffer_load_b32

// PIPELINE-LABEL: func.func @buffer_load_kernel
// PIPELINE: wavemachine.buffer_load_b32
// PIPELINE-SAME: !wavemachine.reg<sgpr, 4,
// PIPELINE: wavemachine.global_store_b32

// ASM-LABEL: buffer_load_kernel:
// ASM: buffer_load_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen
// ASM-NOT: offset:
// ASM: s_waitcnt {{.*}}vmcnt
// ASM: global_store_b32
func.func @buffer_load_kernel(%in: !wave.ptr<i32, #wave.global>, %out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %iptrs = wave.ptr_add %buffer, %lane : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %v, %tok = wave.load %iptrs : (!wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %store_token = wave.store %v -> %optrs after %tok : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// Tuple `wave.load` (8 dwords) through a buffer pointer: the selector
// folds it into a single `wavemachine.buffer_load_tuple_b32`, which the
// AMDGPU printer expands into eight consecutive `buffer_load_dword`
// instructions with `offset:i*4` immediates.
// SELECT-LABEL: func.func @buffer_load_tuple_kernel
// SELECT: wavemachine.make_buffer_rsrc
// SELECT: wavemachine.buffer_load_tuple_b32

// ASM-LABEL: buffer_load_tuple_kernel:
// ASM: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen{{$}}
// ASM: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:16
// ASM: s_waitcnt {{.*}}vmcnt
func.func @buffer_load_tuple_kernel(%in: !wave.ptr<i32, #wave.global>, %out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %in, %range : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %iptrs = wave.ptr_add %buffer, %lane : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %v, %tok = wave.load %iptrs : (!wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %optrs, %lane_off : !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %store_token = wave.store %regs -> %tuple_ptr after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

}
